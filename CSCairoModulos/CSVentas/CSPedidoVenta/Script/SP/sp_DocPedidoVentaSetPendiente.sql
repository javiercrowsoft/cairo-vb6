if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSetPendiente]

/*

  exec  sp_DocPedidoVentaSetPendiente 38

*/

go
create procedure sp_DocPedidoVentaSetPendiente (
  @@pv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @pv_pendiente decimal(18,6)

  begin transaction

  -- Actualizo la deuda de la Pedido
  exec sp_DocPedidoVentaSetItemPendiente @@pv_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @pv_pendiente = sum(pvi_pendiente * (pvi_importe / pvi_cantidad)) from PedidoVentaItem where pv_id = @@pv_id
  set @pv_pendiente = IsNull(@pv_pendiente,0)

  update PedidoVenta set pv_pendiente = round(@pv_pendiente,2) where pv_id = @@pv_id
  if @@error <> 0 goto ControlError

  -- Actualizo la tabla PedidoVentaItemStock
  exec sp_DocPedidoVentaSetItemStock @@pv_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPedidoVentaSetPendiente.', 16, 1)
  rollback transaction  

end 

go