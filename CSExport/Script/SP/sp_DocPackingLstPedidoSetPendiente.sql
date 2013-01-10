if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingLstPedidoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingLstPedidoSetPendiente]

/*

 sp_DocPackingLstPedidoSetPendiente 91

*/

GO
create procedure sp_DocPackingLstPedidoSetPendiente (
  @@pklst_id       int,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de los pedidos
  --
  declare @pv_id int

  declare c_pedidoPendiente insensitive cursor for 
    select distinct pv_id 
    from PedidoPackingList pvpklst inner join PackingListItem pklsti on pvpklst.pklsti_id = pklsti.pklsti_id
                                   inner join PedidoVentaItem pvi    on pvpklst.pvi_id    = pvi.pvi_id
    where pklst_id = @@pklst_id
  union
    select pv_id from #PedidoVentaPacking
  
  open c_pedidoPendiente
  fetch next from c_pedidoPendiente into @pv_id
  while @@fetch_status = 0 begin
    -- Actualizo la deuda del pedido
    exec sp_DocPedidoVentaSetPendiente @pv_id, @@bSuccess out

    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    -- Estado
    exec sp_DocPedidoVentaSetCredito @pv_id
    exec sp_DocPedidoVentaSetEstado @pv_id

    fetch next from c_pedidoPendiente into @pv_id
  end
  close c_pedidoPendiente
  deallocate c_pedidoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPackingLstPedidoSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

end

GO