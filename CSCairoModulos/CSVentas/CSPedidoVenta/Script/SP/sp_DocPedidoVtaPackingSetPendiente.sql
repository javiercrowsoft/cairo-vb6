if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVtaPackingSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVtaPackingSetPendiente]

/*

 sp_DocPedidoVtaPackingSetPendiente 124

*/

GO
create procedure sp_DocPedidoVtaPackingSetPendiente (
  @@pv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de los Packings
  --
  declare @pklst_id int

  declare c_PackingPendiente insensitive cursor for 
    select distinct pklst_id 
    from PedidoPackingList pvpklst   inner join PedidoVentaItem pvi      on pvpklst.pvi_id = pvi.pvi_id
                                    inner join PackingListItem pklsti  on pvpklst.pklsti_id = pklsti.pklsti_id
    where pv_id = @@pv_id
  union
    select pklst_id from #PedidoPackingList
  
  open c_PackingPendiente
  fetch next from c_PackingPendiente into @pklst_id
  while @@fetch_status = 0 begin
    -- Actualizo la deuda de la Pedido
    exec sp_DocPackingListSetItemPendiente @pklst_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

-- TODO: VALIDACION

    fetch next from c_PackingPendiente into @pklst_id
  end
  close c_PackingPendiente
  deallocate c_PackingPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPedidoVtaPackingSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

end

GO