if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSetPendiente]

/*

  exec  sp_DocOrdenServicioSetPendiente 38
sp_col OrdenServicio
*/

go
create procedure sp_DocOrdenServicioSetPendiente (
  @@os_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @os_pendiente decimal(18,6)

  begin transaction

  exec sp_DocOrdenServicioSetItemPendiente @@os_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @os_pendiente = sum(osi_pendiente * (osi_importe / osi_cantidadaremitir)) from OrdenServicioItem where os_id = @@os_id
  set @os_pendiente = IsNull(@os_pendiente,0)

  update OrdenServicio set os_pendiente = round(@os_pendiente,2) where os_id = @@os_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la orden de servicio. sp_DocOrdenServicioSetPendiente.', 16, 1)
  rollback transaction  

end 

go