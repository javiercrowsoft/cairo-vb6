/*---------------------------------------------------------------------
Nombre: Detalle de Imputacion Contable de Ventas
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0185]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0185]

go

/*  

DC_CSC_CON_0185 1, 
								'20060901',
								'20060930',
								'0', 
								'1',
								'0',
								'0',
								'5'

*/

create procedure DC_CSC_CON_0185 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,
	@@cue_id          varchar(255),
  @@cico_id         varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@emp_id	 				varchar(255)
)as 

begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id       int
declare @mon_id   		int
declare @emp_id   		int
declare @cico_id 			int
declare @doc_id				int

declare @ram_id_cuenta           int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int


declare @clienteID 			int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@mon_id,  		 @mon_id  out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
exec sp_ArbConvertId @@cue_id,  		 @cue_id  out, 				@ram_id_cuenta out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id, 		   @doc_id  out, 				@ram_id_Documento out

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


--//////////////////////////////////////////////////////////////////////////////////////////
--
-- Select de Retorno
--
--//////////////////////////////////////////////////////////////////////////////////////////


		select 	fv_id 														as comp_id,
						fv.doct_id 												as doct_id,
						doc_nombre                        as Documento,
						as_doc_cliente										as Factura, 
						as_fecha													as Fecha,
						as_nrodoc													as Asiento,
						cue_nombre												as Cuenta, 
						asi_debe													as Debe, 
						asi_haber													as Haber

		from asiento ast inner join asientoitem asi on ast.as_id  = asi.as_id
		                 inner join cuenta cue      on asi.cue_id = cue.cue_id
										 inner join documento doc   on ast.doc_id_cliente = doc.doc_id
										 inner join facturaventa fv on ast.id_cliente = fv.fv_id

		where doct_id_cliente in (1,7,9) 
			and as_fecha between @@Fini and @@Ffin
		
		-- Validar usuario - empresa
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (asi.cue_id 	= @cue_id 	or @cue_id	=0)
		and   (asi.mon_id 	= @mon_id 	or @mon_id	=0)
		and   (doc.emp_id   = @emp_id 	or @emp_id	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id=0)
		
		and   (			ast.doc_id = @doc_id 	
						or 	ast.doc_id_cliente = @doc_id 
						or 	@doc_id	=0
					)
		
		-- Arboles
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 17 
		                  and  rptarb_hojaid = asi.cue_id
									   ) 
		           )
		        or 
							 (@ram_id_cuenta = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 12 
		                  and  rptarb_hojaid = asi.mon_id
									   ) 
		           )
		        or 
							 (@ram_id_moneda = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_empresa = 0)
					 )
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1016 
		                  and  rptarb_hojaid = doc.cico_id
									   ) 
		           )
		        or 
							 (@ram_id_circuitocontable = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 4001
		                  and  rptarb_hojaid = ast.doc_id_cliente
									   ) 
		           )
		        or 
							 (@ram_id_documento = 0)
					 )

	order by as_fecha, fv_id, asi_orden

end

GO