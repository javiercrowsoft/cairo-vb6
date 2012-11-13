if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_BancosConciliacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_BancosConciliacion]
go

/*

*/

create procedure sp_lsdoc_BancosConciliacion (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cue_id  varchar(255),
@@bco_id	varchar(255),
@@emp_id	varchar(255)

)as 
begin

	set nocount on

	/*- ///////////////////////////////////////////////////////////////////////
	
	INICIO PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	declare @cue_id int
	declare @bco_id int
	declare @emp_id int
	
	declare @ram_id_Cuenta int
	declare @ram_id_Banco int
	declare @ram_id_Empresa int
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_Cuenta out
	exec sp_ArbConvertId @@bco_id, @bco_id out, @ram_id_Banco out
	exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out
	
	exec sp_GetRptId @clienteID out
	
	if @ram_id_Cuenta <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Cuenta, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Cuenta, @clienteID 
		end else 
			set @ram_id_Cuenta = 0
	end
	
	if @ram_id_Banco <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Banco, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Banco, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Banco, @clienteID 
		end else 
			set @ram_id_Banco = 0
	end
	
	if @ram_id_empresa <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
		end else 
			set @ram_id_empresa = 0
	end
	
	/*- ///////////////////////////////////////////////////////////////////////
	
	FIN PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	select 
				bcoc_id,
				''									  	as [TypeTask],
				bcoc_numero             as [Número],
				emp_nombre            	as [Empresa],
		    cue_nombre            	as [Cuenta],
		    bco_nombre					  	as [Banco],
				bcoc_fecha						  as [Fecha],
	
				bcoc_fechadesde	  		  as [Desde],
				bcoc_fechahasta 			  as [Hasta],
	
				bcoc_saldoBco						as [Saldo],
	
				bcoc.Creado,
				bcoc.Modificado,
				us_nombre             as [Modifico],
				bcoc_descrip				  as [Observaciones]
	from 
				BancoConciliacion bcoc
	                   inner join cuenta 		cue   on bcoc.cue_id   	= cue.cue_id
										 inner join banco     bco   on cue.bco_id   	= bco.bco_id
	                   inner join usuario   us    on bcoc.modifico 	= us.us_id
										 left  join empresa   emp   on cue.emp_id  		= emp.emp_id
	where 
	
					  @@Fini <= bcoc_fecha
				and	@@Ffin >= bcoc_fecha 		
	
	/* -///////////////////////////////////////////////////////////////////////
	
	INICIO SEGUNDA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	and   (bcoc.cue_id = @cue_id or @cue_id=0)
	and   (cue.bco_id  = @bco_id or @bco_id=0)
	and   (emp.emp_id  = @emp_id or @emp_id=0)
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 17
	                  and  rptarb_hojaid = bcoc.cue_id
								   ) 
	           )
	        or 
						 (@ram_id_Cuenta = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 13
	                  and  rptarb_hojaid = cue.bco_id
								   ) 
	           )
	        or 
						 (@ram_id_Banco = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1018 
	                  and  rptarb_hojaid = cue.emp_id
								   ) 
	           )
	        or 
						 (@ram_id_empresa = 0)
				 )
	
		order by bcoc_fecha, bcoc_numero

end

go