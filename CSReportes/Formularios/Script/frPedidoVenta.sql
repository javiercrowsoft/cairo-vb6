/*

select * from PedidoVenta
frPedidoVenta 2

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frPedidoVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frPedidoVenta]

go
create procedure frPedidoVenta (

  @@pv_id      int

)as 

begin

  select pv_fechaentrega as [Fecha entrega], 
         pv_numero,
         pv_nrodoc,
         doc_nombre, 
         ccos_nombre, 
         cli_nombre as Cliente, 
         cpg_nombre as [Condicion de pago], 
         cli_cuit,
         pvi_neto as [Importe neto],
         pvi_cantidad as [Cantidad],
         pvi_ivari    as [IvaRI],
         pvi_precio   as [Precio],
         pvi_importe  as [Importe],
         pr_descripventa   as [Descrip. Producto],
         pv_descrip as Descripcion,
         cli_tel as Telefono,

      case cli_catfiscal
        when 1 then 'Inscripto'
        when 2 then 'Exento'
        when 3 then 'No inscripto'
        when 4 then 'Consumidor Final'
        when 5 then 'Extranjero'
        when 6 then 'Mono Tributo'
        when 7 then 'Extranjero Iva'
        when 8 then 'No responsable'
        when 9 then 'No Responsable exento'
        when 10 then 'No categorizado'
        when 11 then 'Inscripto M'
        else 'Sin categorizar'
      end as cat_fisctal,

      cli_calle + ' ' +
      cli_callenumero + ' ' +
      cli_piso + ' ' +
      cli_depto + ' (' +
      cli_codpostal + ')' as direccion,
      cli_localidad,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      pr_nombreventa as Producto,
      emp_nombre,
      clis_nombre,
      mon_nombre,
      mon_signo
      

  from PedidoVenta inner join PedidoVentaItem   on PedidoVenta.pv_id          = PedidoVentaItem.pv_id
                   inner join Documento         on PedidoVenta.doc_id        = Documento.doc_id
                   inner join Moneda            on Documento.mon_id          = Moneda.mon_id        
                   inner join Cliente           on PedidoVenta.cli_id        = Cliente.cli_id
                   inner join CondicionPago     on PedidoVenta.cpg_id        = CondicionPago.cpg_id
                   inner join Producto          on PedidoVentaItem.pr_id     = Producto.pr_id
                   inner join Empresa           on Documento.emp_id          = Empresa.emp_id
                   left join  Legajo            on PedidoVenta.lgj_id        = Legajo.lgj_id
                   left join  CentroCosto       on PedidoVentaItem.ccos_id   = CentroCosto.ccos_id
                   left join  ClienteSucursal   on PedidoVenta.clis_id       = ClienteSucursal.clis_id

  where PedidoVenta.pv_id = @@pv_id
  order by pvi_orden
end
go

