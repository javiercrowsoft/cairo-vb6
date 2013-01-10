if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoSetPendiente]

/*

  exec  sp_DocOrdenPagoSetPendiente 38

*/

go
create procedure sp_DocOrdenPagoSetPendiente (
  @@opg_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @aplicado decimal(18,6)

  begin transaction

  select @aplicado = sum(fcopg_importe) from FacturaCompraOrdenPago where opg_id = @@opg_id
  set @aplicado = Round(IsNull(@aplicado,0),2)

  update OrdenPago set opg_pendiente = round(opg_total - @aplicado,2) where opg_id = @@opg_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la Orden de Pago. sp_DocOrdenPagoSetPendiente.', 16, 1)
  rollback transaction  

end 

go