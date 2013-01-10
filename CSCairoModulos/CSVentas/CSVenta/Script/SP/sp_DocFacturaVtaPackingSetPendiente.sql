if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVtaPackingSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVtaPackingSetPendiente]

/*

 sp_DocFacturaVtaPackingSetPendiente 124

*/

GO
create procedure sp_DocFacturaVtaPackingSetPendiente (
  @@fv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de los remitos
  --
  declare @pklst_id int

  declare c_packingPendiente insensitive cursor for 
    select distinct pklst_id 
    from PackingListFacturaVenta pklstfv inner join FacturaVentaItem fvi on pklstfv.fvi_id = fvi.fvi_id
                                         inner join PackingListItem pklsti on pklstfv.pklsti_id = pklsti.pklsti_id
    where fv_id = @@fv_id
  union
    select pklst_id from #PackingListFac
  
  open c_packingPendiente
  fetch next from c_packingPendiente into @pklst_id
  while @@fetch_status = 0 begin
    -- Actualizo la deuda de la factura
    exec sp_DocPackingListSetPendiente @pklst_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    -- Estado
    exec sp_DocPackingListSetCredito @pklst_id
    if @@error <> 0 goto ControlError

    exec sp_DocPackingListSetEstado @pklst_id
    if @@error <> 0 goto ControlError

-- TODO: VALIDACION

    fetch next from c_packingPendiente into @pklst_id
  end
  close c_packingPendiente
  deallocate c_packingPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del remito de venta. sp_DocFacturaVtaPackingSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO