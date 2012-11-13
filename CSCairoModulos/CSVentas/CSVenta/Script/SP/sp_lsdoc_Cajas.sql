/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Cajas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Cajas]


/*

sp_lsdoc_Cajas 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_lsdoc_Cajas (
  @@us_id    int,

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@mcj_nrodoc			varchar(255),
	@@cj_id						varchar(255),
	@@suc_id					varchar(255),
	@@us_id_Cajero    varchar(255),
	@@emp_id					varchar(255)

)as 

begin

	set nocount on
	
/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cj_id int
declare @suc_id int
declare @us_id_Cajero int
declare @emp_id int

declare @ram_id_Caja int
declare @ram_id_Sucursal int
declare @ram_id_Cajero int
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cj_id, 				@cj_id out, 				@ram_id_Caja out
exec sp_ArbConvertId @@suc_id, 				@suc_id out, 				@ram_id_Sucursal out
exec sp_ArbConvertId @@us_id_Cajero,  @us_id_Cajero out, 	@ram_id_Cajero out
exec sp_ArbConvertId @@emp_id, 				@emp_id out, 				@ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Caja <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_Caja, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Caja, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Caja, @clienteID 
	end else 
		set @ram_id_Caja = 0
end

if @ram_id_Sucursal <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Cajero <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_Cajero, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cajero, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cajero, @clienteID 
	end else 
		set @ram_id_Cajero = 0
end

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end

if isnumeric (@@mcj_nrodoc)<> 0 set @@mcj_nrodoc = right('00000000'+@@mcj_nrodoc,8)

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

	mcj_id,
	''                as TypeTask,
	mcj_fecha				  as Fecha,
	convert(varchar,mcj_hora,108)      
										as Hora,
  mcj_numero				as Numero,
  mcj_nrodoc				as Comprobante,
	suc_nombre				as Sucursal,
	cj_nombre      		as Caja,
	usc.us_nombre     as Cajero,

	case mcj_tipo when 1 then 'Apertura' when 2 then 'Cierre' end as [Operación],

	emp_nombre        as Empresa,

	mcj.creado        as Creado,
	mcj.modificado    as Modificado,
	us.us_nombre			as Modifico,
	mcj_descrip				as [Descripción]

from 

		MovimientoCaja mcj	inner join Usuario us    	on mcj.modifico 		= us.us_id
												left  join Caja cj    		on mcj.cj_id  			= cj.cj_id
												left  join empresa        on cj.emp_id        = empresa.emp_id     
												left  join Sucursal suc   on cj.suc_id   			= suc.suc_id
												left  join Usuario usc    on mcj.us_id_cajero = usc.us_id
where 
				  @@Fini <= mcj_fecha
			and	@@Ffin >= mcj_fecha 		
			and (mcj.mcj_nrodoc = @@mcj_nrodoc or @@mcj_nrodoc = '')

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (mcj.cj_id 				= @cj_id 				or @cj_id = 0)
and   (cj.suc_id 				= @suc_id 			or @suc_id = 0)
and   (mcj.us_id_cajero = @us_id_cajero or @us_id_cajero = 0)
and   (cj.emp_id 			  = @emp_id 			or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1033
                  and  rptarb_hojaid = mcj.cj_id
							   ) 
           )
        or 
					 (@ram_id_Caja = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007
                  and  rptarb_hojaid = cj.suc_id
							   ) 
           )
        or 
					 (@ram_id_Sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3
                  and  rptarb_hojaid = mcj.us_id_cajero
							   ) 
           )
        or 
					 (@ram_id_Cajero = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = cj.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )

	order by mcj_fecha, mcj_nrodoc

end
go