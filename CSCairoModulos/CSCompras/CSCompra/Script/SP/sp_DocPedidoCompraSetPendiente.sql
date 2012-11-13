if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraSetPendiente]

/*

	exec	sp_DocPedidoCompraSetPendiente 38

*/

go
create procedure sp_DocPedidoCompraSetPendiente (
	@@pc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @pc_pendiente decimal(18,6)

	begin transaction

	exec sp_DocPedidoCompraSetItemPendiente @@pc_id, @@bSuccess out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	select @pc_pendiente = sum(pci_pendiente * (pci_importe / pci_cantidad)) from PedidoCompraItem where pc_id = @@pc_id
	set @pc_pendiente = IsNull(@pc_pendiente,0)

	update PedidoCompra set pc_pendiente = round(@pc_pendiente,2) where pc_id = @@pc_id
	if @@error <> 0 goto ControlError

	commit transaction

	set @@bSuccess = 1

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el pendiente del pedido de compra. sp_DocPedidoCompraSetPendiente.', 16, 1)
	rollback transaction	

end 

go