if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListSetPendiente]

/*

  exec  sp_DocPackingListSetPendiente 38
sp_col packinglistitem
*/

go
create procedure sp_DocPackingListSetPendiente (
  @@pklst_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @pklst_pendiente decimal(18,6)

  begin transaction

  -- Actualizo la deuda de la Pedido
  exec sp_DocPackingListSetItemPendiente @@pklst_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @pklst_pendiente = sum(pklsti_pendientefac * (pklsti_importe / pklsti_cantidad)) from PackingListItem where pklst_id = @@pklst_id
  set @pklst_pendiente = IsNull(@pklst_pendiente,0)

  update PackingList set pklst_pendiente = round(@pklst_pendiente,2) where pklst_id = @@pklst_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del packing list. sp_DocPackingListSetPendiente.', 16, 1)
  rollback transaction  

end 

go