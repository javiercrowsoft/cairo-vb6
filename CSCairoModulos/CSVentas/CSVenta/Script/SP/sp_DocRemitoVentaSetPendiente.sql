if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSetPendiente]

/*

  exec  sp_DocRemitoVentaSetPendiente 38

*/

go
create procedure sp_DocRemitoVentaSetPendiente (
  @@rv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @rv_pendiente decimal(18,6)

  begin transaction

  exec sp_DocRemitoVentaSetItemPendiente @@rv_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  select @rv_pendiente = sum(rvi_pendientefac * (rvi_importe / rvi_cantidad)) from RemitoVentaItem where rv_id = @@rv_id
  set @rv_pendiente = IsNull(@rv_pendiente,0)

  update RemitoVenta set rv_pendiente = round(@rv_pendiente,2) where rv_id = @@rv_id
  if @@error <> 0 goto ControlError

  --//////////////////////////////////////////////////////////////
  --
  -- Particularidades del cliente
  --
  declare @MsgError  varchar(5000) set @MsgError = ''

  exec sp_DocRemitoVentaSetPendienteCliente @@rv_id,
                                            @@bSuccess  out,
                                            @MsgError out

  -- Si el documento no es valido
  if IsNull(@@bSuccess,0) = 0 goto ControlError  


  --//////////////////////////////////////////////////////////////
  --
  -- Fin de la transaccion
  --
  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del remito de venta. sp_DocRemitoVentaSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)
  rollback transaction  

end 

go