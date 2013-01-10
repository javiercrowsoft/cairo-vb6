if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCpraRemitoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCpraRemitoSetPendiente]

/*

 sp_DocOrdenCpraRemitoSetPendiente 124

*/

GO
create procedure sp_DocOrdenCpraRemitoSetPendiente (
  @@oc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de los Remitos
  --
  declare @rc_id int

  declare c_RemitoPendiente insensitive cursor for 
    select distinct rc_id 
    from OrdenRemitoCompra ocrc   inner join OrdenCompraItem oci   on ocrc.oci_id = oci.oci_id
                                  inner join RemitoCompraItem rci on ocrc.rci_id = rci.rci_id
    where oc_id = @@oc_id
  union
    select rc_id from #OrdenCompraRemito
  
  open c_RemitoPendiente
  fetch next from c_RemitoPendiente into @rc_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la orden
    exec sp_DocRemitoCompraSetItemPendiente @rc_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --
      
      -- ESTADO
        exec sp_AuditoriaEstadoCheckDocRC    @rc_id,
                                            @@bSuccess  out,
                                            @MsgError out
      
        -- Si el documento no es valido
        if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_RemitoPendiente into @rc_id
  end
  close c_RemitoPendiente
  deallocate c_RemitoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente de la orden de compra. sp_DocOrdenCpraRemitoSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO