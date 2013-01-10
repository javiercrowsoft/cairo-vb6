if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaSetPendiente]

/*

  exec  sp_DocManifiestoCargaSetPendiente 38

*/

go
create procedure sp_DocManifiestoCargaSetPendiente (
  @@mfc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @mfc_pendiente decimal(18,6)

  begin transaction

  -- Actualizo la deuda del manifiesto
  exec sp_DocManifiestoCargaSetItemPendiente @@mfc_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @mfc_pendiente = sum(mfci_pendiente) from ManifiestoCargaItem where mfc_id = @@mfc_id
  set @mfc_pendiente = IsNull(@mfc_pendiente,0)

  update ManifiestoCarga set mfc_pendiente = round(@mfc_pendiente,2) where mfc_id = @@mfc_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del manifiesto de carga. sp_DocManifiestoCargaSetPendiente.', 16, 1)
  rollback transaction  

end 
go