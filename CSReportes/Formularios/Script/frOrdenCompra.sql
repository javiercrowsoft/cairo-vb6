if exists (select * from sysobjects where id = object_id(N'[dbo].[frOrdenCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frOrdenCompra]

go
create procedure frOrdenCompra (

  @@oc_id      int

)as 

begin
  
  select
    oc_nrodoc              as Comprobante,
    oc_descrip            as Observaciones,
    oc_fecha              as Fecha,
    oc_fechaEntrega        as Entrega,
    oc_neto                as Neto,
    oc_ivari              as [IVA Resp. Insc],
    oc_ivarni              as [IVA RNI],
    oc_total              as Total,
    oc_Subtotal            as Subtotal,
    oc_pendiente          as Pendiente,
    oc_descuento1          as Descuento,
    oc_descuento2          as [Descuento2],

    oci_cantidad          as Cantidad,
    oci_cantidadaremitir  as [Cant. a remitir],  
    oci_precio            as Precio,
    oci_ivari              as [IvaRi Art.],
    oci_ivarni            as [IvaRNi Art.],
    oci_importe            as Importe,
    pr_nombrecompra        as Articulo,
    su.suc_nombre          as Sucursal,  
    p.prov_nombre          as Proveedor,
    p.prov_codigo          as Codigo,
    p.prov_cuit            as CUIT,
    p.prov_ingresosbrutos  as [Ing. Brutos],
    p.prov_chequeorden    as [Orden Cheque],
    p.prov_tel            as Telefono,      
    p.prov_calle          as Calle,
    p.prov_callenumero    as Nro,
    p.prov_localidad      as Localidad,

    cp.cpg_nombre          as [Cond. Pago],
    cc.ccos_nombre        as [Centro de Costo],

    case 
      when lgj_titulo <> '' then lgj_titulo 
      else lgj_codigo 
    end                    as lgj_codigo,

    '(' + pr_codigoexterno + ') ' 
    + pr_nombreCompra     as producto

  
  from OrdenCompra OC inner join Proveedor        P     on oc.prov_id = p.prov_id
                      inner join OrdenCompraItem oci   on oc.oc_id   = oci.oc_id
                      inner join Producto        Pr     on oci.pr_id  = pr.pr_id
                      inner join CondicionPago cp      on oc.cpg_id  = cp.cpg_id
                      inner join sucursal      su      on oc.suc_id  = su.suc_id
                      left join  Legajo                on oc.lgj_id  = Legajo.lgj_id
                      left join CentroCosto   cc       on oc.ccos_id = cc.ccos_id

  where oc.oc_id=@@oc_id

end
go
