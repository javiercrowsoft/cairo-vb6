/*


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_FacturasVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_FacturasVenta]
go

/*

*/

create procedure sp_lsdoc_FacturasVenta (

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
@@emp_id	varchar(255)
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

declare @ram_id_Cliente int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Vendedor int
declare @ram_id_Documento int
declare @ram_id_CondicionPago int 
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_Vendedor out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
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
-- sp_columns Facturaventa


select 
			fv_id,
			''									  as [TypeTask],
			fv_numero             as [Número],
			fv_nrodoc						  as [Comprobante],
	    cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			fv_fecha						  as [Fecha],
			fv_fechaentrega				as [Fecha de entrega],
			fv_neto								as [Neto],
			fv_ivari							as [IVA RI],
			fv_ivarni							as [IVA RNI],
			fv_subtotal						as [Subtotal],
			fv_total							as [Total],
			fv_pendiente					as [Pendiente],
			case fv_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			case impreso
				when 0 then 'No'
				else        'Si'
			end										as [Impreso],
			case emailenviado
				when 0 then 'No'
				else        'Si'
			end										as [Email],
			
			fv_descuento1					as [% Desc. 1],
			fv_descuento2					as [% Desc. 2],
			fv_importedesc1				as [Desc. 1],
			fv_importedesc2				as [Desc. 2],

	    lp_nombre						as [Lista de Precios],
	    ld_nombre						as [Lista de descuentos],
	    cpg_nombre					as [Condicion de Pago],
	    ccos_nombre					as [Centro de costo],
      suc_nombre					as [Sucursal],
			emp_nombre          as [Empresa],

			FacturaVenta.Creado,
			FacturaVenta.Modificado,
			us_nombre             as [Modifico],
			case when fv_cae = '' and doc_esfacturaelectronica <> 0 then 'Pendiente' else fv_cae end 
														as [CAE],
			fv_cae_nrodoc					as [CAE Comprobante],
			fv_cae_vto            as [CAE Vto],
			fv_descrip						as [Observaciones]
from 
			Facturaventa inner join documento     on Facturaventa.doc_id   = documento.doc_id
									 inner join empresa       on documento.emp_id      = empresa.emp_id     
                   inner join condicionpago on Facturaventa.cpg_id   = condicionpago.cpg_id
									 inner join estado        on Facturaventa.est_id   = estado.est_id
									 inner join sucursal      on Facturaventa.suc_id   = sucursal.suc_id
                   inner join cliente       on Facturaventa.cli_id   = cliente.cli_id
                   inner join usuario       on Facturaventa.modifico = usuario.us_id
                   left join vendedor       on Facturaventa.ven_id   = vendedor.ven_id
                   left join centrocosto    on Facturaventa.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on Facturaventa.lp_id    = listaprecio.lp_id
  								 left join listadescuento on Facturaventa.ld_id    = listadescuento.ld_id
where 

				  @@Fini <= fv_fecha
			and	@@Ffin >= fv_fecha 		

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
					 (@ram_id_Empresa = 0)
			 )

	order by fv_fecha, Comprobante
go