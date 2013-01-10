if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraSetPendiente]

/*

  exec  sp_DocFacturaCompraSetPendiente 38

*/

go
create procedure sp_DocFacturaCompraSetPendiente (
  @@fc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @fc_pendiente decimal(18,6)

  begin transaction

  select @fc_pendiente = sum(fcd_pendiente) from FacturaCompraDeuda where fc_id = @@fc_id
  set @fc_pendiente = IsNull(@fc_pendiente,0)

  update FacturaCompra set fc_pendiente = round(@fc_pendiente,2) where fc_id = @@fc_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la factura de Compra. sp_DocFacturaCompraSetPendiente.', 16, 1)
  rollback transaction  

end 

go