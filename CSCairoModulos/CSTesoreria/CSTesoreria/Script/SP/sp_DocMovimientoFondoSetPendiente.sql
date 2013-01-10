if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoSetPendiente]

/*

  exec  sp_DocMovimientoFondoSetPendiente 38

*/

go
create procedure sp_DocMovimientoFondoSetPendiente (
  @@mf_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @mf_pendiente decimal(18,6)

  begin transaction

  select @mf_pendiente = sum(mfd_pendiente) from MovimientoFondoDeuda where mf_id = @@mf_id
  set @mf_pendiente = IsNull(@mf_pendiente,0)

  update MovimientoFondo set mf_pendiente = round(@mf_pendiente,2) where mf_id = @@mf_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del movimiento de fondos. sp_DocMovimientoFondoSetPendiente.', 16, 1)
  rollback transaction  

end 

go