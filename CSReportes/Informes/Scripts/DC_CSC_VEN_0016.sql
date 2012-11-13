/*---------------------------------------------------------------------
Nombre: Facturas a Cobrar por Fecha
---------------------------------------------------------------------*/
/*

Para testear:

DC_CSC_VEN_0016 
										1,
										'20050101',
										'20050331',
										'0',
										'0',
										'0',
										'0',
										'0',
										'0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0016]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0016]

go
create procedure DC_CSC_VEN_0016 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cli_id  				varchar(255),
	@@ven_id          varchar(255),
	@@suc_id  				varchar(255),
	@@cico_id					varchar(255),
	@@cue_id					varchar(255), 
	@@emp_id  				varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id 	int
declare @ven_id 	int
declare @suc_id 	int
declare @cico_id  int
declare @cue_id 	int
declare @emp_id 	int 

declare @ram_id_Cliente 					int
declare @ram_id_Vendedor 					int
declare @ram_id_Sucursal 					int
declare @ram_id_circuitoContable 	int
declare @ram_id_Cuenta 						int
declare @ram_id_Empresa   				int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_Vendedor out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitoContable out
exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_Cuenta out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
	end else 
		set @ram_id_Cliente = 0
end

if @ram_id_Vendedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Vendedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Vendedor, @clienteID 
	end else 
		set @ram_id_Vendedor = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cuenta, @clienteID 
	end else 
		set @ram_id_Cuenta = 0
end

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cta_deudor tinyint set @cta_deudor = 1

create table #tbl_DC_CSC_VEN_0016 (

				emp_id              int,
				fv_fecha            datetime,

				fv_neto       			decimal(18,6),
				fv_desc 						decimal(18,6),
        fv_subtotal   			decimal(18,6),
				fv_iva 			 				decimal(18,6),
				fv_total      			decimal(18,6),
				fv_pendiente  			decimal(18,6)
)

insert into #tbl_DC_CSC_VEN_0016

select 

				fv.emp_id,
				fv_fecha																	as [Fecha],

				case fv.doct_id
					when 7 		then -sum(fv_neto)
					else            sum(fv_neto)
				end				        		 										as [Neto],
				case fv.doct_id
					when 7 		then -sum(  fv_importedesc1 
                              + fv_importedesc2)	  
					else						sum(  fv_importedesc1 
                              + fv_importedesc2)	  
				end																				as [Descuento],
				case fv.doct_id
					when 7 		then -sum(fv_subtotal)
					else            sum(fv_subtotal)
				end   		 																as [Sub Total],
				case fv.doct_id
					when 7 		then -sum(	fv_ivari 
															+ fv_ivarni)
					else            sum(	fv_ivari 
															+ fv_ivarni)
				end 			 			 													as [Iva],
				case fv.doct_id
					when 7 		then -sum(fv_total)
					else            sum(fv_total)
				end      		 															as [Total],
				case fv.doct_id
					when 7 		then -sum(fv_pendiente)
					else            sum(fv_pendiente)
				end  		 																	as [Pendiente]

from 

	FacturaVenta fv inner join AsientoItem 	ai  	on fv.as_id   = ai.as_id and asi_tipo = @cta_deudor
								  inner join Cliente 			cli		on fv.cli_id	= cli.cli_id
									inner join Documento    doc   on fv.doc_id  = doc.doc_id

where 

				  fv_fecha >= @@Fini
			and	fv_fecha <= @@Ffin

			and fv.est_id <> 7

			and (
						exists(select * from EmpresaUsuario where emp_id = fv.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (fv.cli_id 		= @cli_id 	or @cli_id	=0)
and   (		IsNull(fv.ven_id,0) 	= @ven_id
			 or	IsNull(cli.ven_id,0) 	= @ven_id
			 or @ven_id	=0
			)
and   (fv.suc_id 		= @suc_id 	or @suc_id	=0)
and   (doc.cico_id  = @cico_id 	or @cico_id	=0)
and   (ai.cue_id 		= @cue_id 	or @cue_id	=0)
and   (fv.emp_id 		= @emp_id 	or @emp_id	=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = fv.cli_id
							   ) 
           )
        or 
					 (@ram_id_Cliente = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 15 
                  and  (		rptarb_hojaid = isnull(fv.ven_id,0)
												or	rptarb_hojaid = isnull(cli.ven_id,0)
												)
							   ) 
           )
        or 
					 (@ram_id_Vendedor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = fv.suc_id
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
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = doc.cico_id
							   ) 
           )
        or 
					 (@ram_id_circuitoContable = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = ai.cue_id
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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = fv.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )

group by 
				fv.emp_id,
				fv_fecha,
				fv.doct_id

declare @FiniYear 		datetime
declare @FiniMonth		datetime

set @FiniYear  = dateadd(yy,-1,@@Ffin)
set @FiniMonth = dateadd(m,-1,@@Ffin)

-------------------------------------------------------------------------------------------------------------------------
-- mensual
-------------------------------------------------------------------------------------------------------------------------
select 
				1										as grupo,
				emp_nombre          as Empresa,
				substring(convert(varchar,fv_fecha,111),1,7)	as [Fecha],

				sum(fv_neto)       	as [Neto],
				sum(fv_desc) 				as [Descuento],
        sum(fv_subtotal)   	as [Sub Total],
				sum(fv_iva) 			 	as [Iva],
				sum(fv_total)      	as [Total],
				sum(fv_pendiente)  	as [Pendiente]

from #tbl_DC_CSC_VEN_0016 t inner join Empresa e on t.emp_id = e.emp_id

where fv_fecha between @FiniYear and @@Ffin

group by 
				emp_nombre,
				substring(convert(varchar,fv_fecha,111),1,7)

union all

-------------------------------------------------------------------------------------------------------------------------
-- ultimo mes
-------------------------------------------------------------------------------------------------------------------------
select 
				2										as grupo,
				emp_nombre          as Empresa,
				convert(varchar,fv_fecha,111) as [Fecha],

				fv_neto       	as [Neto],
				fv_desc 				as [Descuento],
        fv_subtotal   	as [Sub Total],
				fv_iva 				 	as [Iva],
				fv_total      	as [Total],
				fv_pendiente  	as [Pendiente]

from #tbl_DC_CSC_VEN_0016 t inner join Empresa e on t.emp_id = e.emp_id

where fv_fecha between @FiniMonth and @@Ffin

union all

-------------------------------------------------------------------------------------------------------------------------
-- anual
-------------------------------------------------------------------------------------------------------------------------
select 
				3										as grupo,
				emp_nombre          as Empresa,
				substring(convert(varchar,fv_fecha,111),1,4)  as [Fecha],

				sum(fv_neto)       	as [Neto],
				sum(fv_desc) 				as [Descuento],
        sum(fv_subtotal)   	as [Sub Total],
				sum(fv_iva) 			 	as [Iva],
				sum(fv_total)      	as [Total],
				sum(fv_pendiente)  	as [Pendiente]

from #tbl_DC_CSC_VEN_0016 t inner join Empresa e on t.emp_id = e.emp_id

group by 
				emp_nombre,
				substring(convert(varchar,fv_fecha,111),1,4)

order by 1,2,3


end
go
