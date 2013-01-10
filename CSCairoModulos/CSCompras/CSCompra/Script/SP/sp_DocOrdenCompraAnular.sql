if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraAnular]

go

create procedure sp_DocOrdenCompraAnular (
  @@us_id       int,
  @@oc_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@oc_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  if exists(select oc_id from OrdenFacturaCompra oc inner join OrdenCompraitem oci on oc.oci_id = oci.oci_id where oc_id = @@oc_id) begin
    goto VinculadaFactura
  end

  if exists(select oc_id from OrdenRemitoCompra o inner join OrdenCompraItem oci on o.oci_id = oci.oci_id where oc_id = @@oc_id) begin
    goto VinculadaRemito
  end

  if exists(select oc_id from PedidoOrdenCompra o inner join OrdenCompraItem oci on o.oci_id = oci.oci_id where oc_id = @@oc_id) begin
    goto VinculadaPedido
  end

  if exists(select oci_id_orden from OrdenDevolucionCompra p inner join Ordencompraitem oci on p.oci_id_orden = oci.oci_id or p.oci_id_devolucion = oci.oci_id where oc_id = @@oc_id) begin
    goto VinculadaDevolucion
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update OrdenCompra set est_id = @estado_anulado, oc_pendiente = 0
    where oc_id = @@oc_id
    set @est_id = @estado_anulado

    exec sp_DocOrdenCompraSetCredito @@oc_id,1
    if @@error <> 0 goto ControlError

  end else begin

    update OrdenCompra set est_id = @estado_pendiente, oc_pendiente = oc_total
    where oc_id = @@oc_id

    exec sp_DocOrdenCompraSetEstado @@oc_id,0,@est_id out

    exec sp_DocOrdenCompraSetCredito @@oc_id
    if @@error <> 0 goto ControlError

  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bSuccess tinyint
  declare @MsgError  varchar(5000) set @MsgError = ''

  exec sp_AuditoriaAnularCheckDocOC    @@oc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  update OrdenCompra set modificado = getdate(), modifico = @@us_id where oc_id = @@oc_id

  if @@anular <> 0 exec sp_HistoriaUpdate 17004, @@oc_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 17004, @@oc_id, @@us_id, 8

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  if @bInternalTransaction <> 0 
    commit transaction

  if @@Select <> 0 begin
    select est_id, est_nombre from Estado where est_id = @est_id
  end

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el estado de la orden de compra. sp_DocOrdenCompraAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

VinculadaFactura:
  raiserror ('@@ERROR_SP:El documento esta vinculado a una factura de compra.', 16, 1)
  Goto fin

VinculadaRemito:
  raiserror ('@@ERROR_SP:El documento esta vinculado a un remito de compra.', 16, 1)
  Goto fin

VinculadaPedido:
  raiserror ('@@ERROR_SP:El documento esta vinculado a un pedido de compra.', 16, 1)
  Goto fin

VinculadaDevolucion:
  raiserror ('@@ERROR_SP:El documento esta vinculado a una cancelación de orden de compra.', 16, 1)
  Goto fin

fin:

end