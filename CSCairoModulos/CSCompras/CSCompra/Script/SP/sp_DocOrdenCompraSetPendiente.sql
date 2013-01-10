if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraSetPendiente]

/*

  exec  sp_DocOrdenCompraSetPendiente 10

*/

go
create procedure sp_DocOrdenCompraSetPendiente (
  @@oc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @oc_pendiente decimal(18,6)

  begin transaction

  exec sp_DocOrdenCompraSetItemPendiente @@oc_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @oc_pendiente = sum(oci_pendientefac * (oci_importe / oci_cantidad)) from OrdenCompraItem where oc_id = @@oc_id
  set @oc_pendiente = IsNull(@oc_pendiente,0)

  update OrdenCompra set oc_pendiente = round(@oc_pendiente,2) where oc_id = @@oc_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del Orden de compra. sp_DocOrdenCompraSetPendiente.', 16, 1)
  rollback transaction  

end 

go