if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaSetPendiente]

/*

  exec  sp_DocPresupuestoVentaSetPendiente 38

*/

go
create procedure sp_DocPresupuestoVentaSetPendiente (
  @@prv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @prv_pendiente decimal(18,6)

  begin transaction

  -- Actualizo la deuda de la Presupuesto
  exec sp_DocPresupuestoVentaSetItemPendiente @@prv_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @prv_pendiente = sum(prvi_pendiente * (prvi_importe / prvi_cantidad)) from PresupuestoVentaItem where prv_id = @@prv_id
  set @prv_pendiente = IsNull(@prv_pendiente,0)

  update PresupuestoVenta set prv_pendiente = round(@prv_pendiente,2) where prv_id = @@prv_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del presupuesto de venta. sp_DocPresupuestoVentaSetPendiente.', 16, 1)
  rollback transaction  

end 

go