if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PresupuestosEnvio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PresupuestosEnvio]
go

/*
select * from PresupuestoEnvio

sp_docPresupuestoEnvioget 47

sp_lsdoc_PresupuestosEnvio

  7,
	'20030101',
	'20050101',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0'

*/

create procedure sp_lsdoc_PresupuestosEnvio (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id  varchar(255),
@@est_id	varchar(255),
@@ccos_id	varchar(255),
@@suc_id	varchar(255),
@@ven_id	varchar(255),
@@doc_id	varchar(255),
@@cpg_id	varchar(255),
@@emp_id	varchar(255)/*
@@TABLA_ID-10 varchar(255),
@@TABLA_ID-11 varchar(255),
@@TABLA_ID-12 varchar(255),
@@TABLA_ID-13 varchar(255),
@@TABLA_ID-14 varchar(255),
@@TABLA_ID-15 varchar(255)*/

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @ven_id int
declare @doc_id int
declare @cpg_id int
declare @emp_id int
/*declare @TABLA_ID-10 int
declare @TABLA_ID-11 int
declare @TABLA_ID-12 int
declare @TABLA_ID-13 int
declare @TABLA_ID-14 int
declare @TABLA_ID-15 int */

declare @ram_id_Cliente int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Vendedor int
declare @ram_id_Documento int
declare @ram_id_CondicionPago int 
declare @ram_id_Empresa int /* 
declare @RAM_ID_TABLA-10 int
declare @RAM_ID_TABLA-11 int
declare @RAM_ID_TABLA-12 int
declare @RAM_ID_TABLA-13 int
declare @RAM_ID_TABLA-14 int
declare @RAM_ID_TABLA-15 int */

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_Vendedor out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out /*
exec sp_ArbConvertId @@TABLA_ID-10, @TABLA_ID-10 out, @RAM_ID_TABLA-10 out
exec sp_ArbConvertId @@TABLA_ID-11, @TABLA_ID-11 out, @RAM_ID_TABLA-11 out
exec sp_ArbConvertId @@TABLA_ID-12, @TABLA_ID-12 out, @RAM_ID_TABLA-12 out
exec sp_ArbConvertId @@TABLA_ID-13, @TABLA_ID-13 out, @RAM_ID_TABLA-13 out
exec sp_ArbConvertId @@TABLA_ID-14, @TABLA_ID-14 out, @RAM_ID_TABLA-14 out
exec sp_ArbConvertId @@TABLA_ID-15, @TABLA_ID-15 out, @RAM_ID_TABLA-15 out */

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
	end else 
		set @ram_id_Cliente = 0
end

if @ram_id_CentroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
	end else 
		set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
	end else 
		set @ram_id_Estado = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Vendedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Vendedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Vendedor, @clienteID 
	end else 
		set @ram_id_Vendedor = 0
end

if @ram_id_Documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
	end else 
		set @ram_id_Documento = 0
end

if @ram_id_CondicionPago <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CondicionPago, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CondicionPago, @clienteID 
	end else 
		set @ram_id_CondicionPago = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

/*
if @RAM_ID_TABLA-10 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-10, @clienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-10, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-10, @clienteID 
	end else 
		set @RAM_ID_TABLA-10 = 0
end

if @RAM_ID_TABLA-11 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-11, @clienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-11, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-11, @clienteID 
	end else 
		set @RAM_ID_TABLA-11 = 0
end

if @RAM_ID_TABLA-12 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-12, @clienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-12, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-12, @clienteID 
	end else 
		set @RAM_ID_TABLA-12 = 0
end

if @RAM_ID_TABLA-13 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-13, @clienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-13, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-13, @clienteID 
	end else 
		set @RAM_ID_TABLA-13 = 0
end

if @RAM_ID_TABLA-14 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-14, @clienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-14, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-14, @clienteID 
	end else 
		set @RAM_ID_TABLA-14 = 0
end

if @RAM_ID_TABLA-15 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-15, @clienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-15, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-15, @clienteID 
	end else 
		set @RAM_ID_TABLA-15 = 0
end
 */
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns PresupuestoEnvio


select 
			pree_id,
			''									  	as [TypeTask],
			pree_numero             as [Número],
			pree_nrodoc						  as [Comprobante],
	    cli_nombre            	as [Cliente],
      doc_nombre					  	as [Documento],
	    est_nombre					  	as [Estado],
			pree_fecha						  as [Fecha],
			pree_fechaentrega				as [Fecha de entrega],
			pree_neto								as [Neto],
			pree_ivari							as [IVA RI],
			pree_ivarni							as [IVA RNI],
			pree_subtotal						as [Subtotal],
			pree_total							as [Total],
			pree_pendiente					as [Pendiente],
			case pree_firmado
				when 0 then 'No'
				else        'Si'
			end											as [Firmado],
			
			pree_descuento1					as [% Desc. 1],
			pree_descuento2					as [% Desc. 2],
			pree_importedesc1				as [Desc. 1],
			pree_importedesc2				as [Desc. 2],

	    cpg_nombre					as [Condicion de Pago],
	    ccos_nombre					as [Centro de costo],
      suc_nombre					as [Sucursal],
			emp_nombre          as [Empresa],

			PresupuestoEnvio.Creado,
			PresupuestoEnvio.Modificado,
			us_nombre             as [Modifico],
			pree_descrip					as [Observaciones]
from 
			PresupuestoEnvio  inner join documento     			on PresupuestoEnvio.doc_id   = documento.doc_id
												inner join empresa            on documento.emp_id          = empresa.emp_id
                  			inner join condicionpago      on PresupuestoEnvio.cpg_id   = condicionpago.cpg_id
												inner join estado             on PresupuestoEnvio.est_id   = estado.est_id
												inner join sucursal           on PresupuestoEnvio.suc_id   = sucursal.suc_id
                  			inner join cliente            on PresupuestoEnvio.cli_id   = cliente.cli_id
                  			inner join usuario            on PresupuestoEnvio.modifico = usuario.us_id
                  			left join vendedor            on PresupuestoEnvio.ven_id   = vendedor.ven_id
                  			left join centrocosto         on PresupuestoEnvio.ccos_id  = centrocosto.ccos_id
where 

				  @@Fini <= pree_fecha
			and	@@Ffin >= pree_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Cliente.cli_id = @cli_id or @cli_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CondicionPago.cpg_id = @cpg_id or @cpg_id=0) 
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (Vendedor.ven_id = @ven_id or @ven_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)
/*
and   (TABLA_DEL_LISTADO-10.TABLA_ID-10 = @TABLA_ID-10 or @TABLA_ID-10=0)
and   (TABLA_DEL_LISTADO-11.TABLA_ID-11 = @TABLA_ID-11 or @TABLA_ID-11=0)
and   (TABLA_DEL_LISTADO-12.TABLA_ID-12 = @TABLA_ID-12 or @TABLA_ID-12=0)
and   (TABLA_DEL_LISTADO-13.TABLA_ID-13 = @TABLA_ID-13 or @TABLA_ID-13=0)
and   (TABLA_DEL_LISTADO-14.TABLA_ID-14 = @TABLA_ID-14 or @TABLA_ID-14=0)
and   (TABLA_DEL_LISTADO-15.TABLA_ID-15 = @TABLA_ID-15 or @TABLA_ID-15=0) 
*/
-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Cliente.cli_id
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
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = CentroCosto.ccos_id
							   ) 
           )
        or 
					 (@ram_id_CentroCosto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Estado.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Sucursal.suc_id
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
                  and  tbl_id = 15 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Vendedor.ven_id
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
                  and  tbl_id = 4001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Documento.doc_id
							   ) 
           )
        or 
					 (@ram_id_Documento = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = CondicionPago.cpg_id
							   ) 
           )
        or 
					 (@ram_id_CondicionPago = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )
/*
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA-10 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-10.TABLA_ID-10
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-10 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA-11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-11.TABLA_ID-11
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-11 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA-12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-12.TABLA_ID-12
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-12 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA-13 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-13.TABLA_ID-13
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-13 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA-14 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-14.TABLA_ID-14
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-14 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA-15 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-15.TABLA_ID-15
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-15 = 0)
			 ) */
	order by pree_fecha
go