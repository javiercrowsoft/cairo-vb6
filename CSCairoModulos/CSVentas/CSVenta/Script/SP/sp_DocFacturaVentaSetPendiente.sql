if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSetPendiente]

/*

  exec  sp_DocFacturaVentaSetPendiente 38

*/

go
create procedure sp_DocFacturaVentaSetPendiente (
  @@fv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @fv_pendiente decimal(18,6)

  begin transaction

  select @fv_pendiente = sum(fvd_pendiente) from FacturaVentaDeuda where fv_id = @@fv_id
  set @fv_pendiente = IsNull(@fv_pendiente,0)

  update FacturaVenta set fv_pendiente = round(@fv_pendiente,2) where fv_id = @@fv_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la factura de venta. sp_DocFacturaVentaSetPendiente.', 16, 1)
  rollback transaction  

end 

go