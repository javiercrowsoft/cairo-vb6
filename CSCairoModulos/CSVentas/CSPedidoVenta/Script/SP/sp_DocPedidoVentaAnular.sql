if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaAnular]

go
create procedure sp_DocPedidoVentaAnular (
  @@us_id       int,
  @@pv_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@pv_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    delete PedidoVentaItemStock where pv_id = @@pv_id

    update PedidoVenta set est_id = @estado_anulado, pv_pendiente = 0
    where pv_id = @@pv_id
    set @est_id = @estado_anulado

    exec sp_DocPedidoVentaSetCredito @@pv_id,1
    if @@error <> 0 goto ControlError

  end else begin

    update PedidoVenta set est_id = @estado_pendiente, pv_pendiente = pv_total
    where pv_id = @@pv_id

    -- Actualizo la tabla PedidoVentaItemStock
    exec sp_DocPedidoVentaSetItemStock @@pv_id, 0

    exec sp_DocPedidoVentaSetEstado @@pv_id,0,@est_id out

    exec sp_DocPedidoVentaSetCredito @@pv_id
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

  exec sp_AuditoriaAnularCheckDocPV    @@pv_id,
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

  update PedidoVenta set modificado = getdate(), modifico = @@us_id where pv_id = @@pv_id

  if @@anular <> 0 exec sp_HistoriaUpdate 16003, @@pv_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 16003, @@pv_id, @@us_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del pedido de venta. sp_DocPedidoVentaAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

end