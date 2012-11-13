if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraSetPendiente]

/*

	exec	sp_DocRemitoCompraSetPendiente 38
sp_col RemitoCompra
*/

go
create procedure sp_DocRemitoCompraSetPendiente (
	@@rc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @rc_pendiente decimal(18,6)

	begin transaction

	exec sp_DocRemitoCompraSetItemPendiente @@rc_id, @@bSuccess out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	select @rc_pendiente = sum(rci_pendientefac * (rci_importe / rci_cantidadaremitir)) from RemitoCompraItem where rc_id = @@rc_id
	set @rc_pendiente = IsNull(@rc_pendiente,0)

	update RemitoCompra set rc_pendiente = round(@rc_pendiente,2) where rc_id = @@rc_id
	if @@error <> 0 goto ControlError

	commit transaction

	set @@bSuccess = 1

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el pendiente del remito de compra. sp_DocRemitoCompraSetPendiente.', 16, 1)
	rollback transaction	

end 

go