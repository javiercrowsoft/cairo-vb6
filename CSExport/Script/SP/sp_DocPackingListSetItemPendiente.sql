if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListSetItemPendiente]

/*

  exec  sp_DocPackingListSetItemPendiente 38

*/

go
create procedure sp_DocPackingListSetItemPendiente (
  @@pklst_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @est_id     int
  select @est_id = est_id from PackingList where pklst_id = @@pklst_id

  begin transaction

  if @est_id <> 7 begin

    declare @pklsti_id int
    declare @pklsti_cancelado decimal(18,6)
    declare c_rviitems insensitive cursor for select pklsti_id from PackingListItem where pklst_id = @@pklst_id
  
    open c_rviitems
    fetch next from c_rviitems into @pklsti_id
    while @@fetch_status = 0 begin
  
      set @pklsti_cancelado=0
  
      select @pklsti_cancelado = sum(pvpklst_cantidad) from PedidoPackingList where pklsti_id = @pklsti_id
      set @pklsti_cancelado = IsNull(@pklsti_cancelado,0)
  
      select @pklsti_cancelado = @pklsti_cancelado + IsNull(sum(mfcpklst_cantidad),0) from ManifiestoPackingList where pklsti_id = @pklsti_id
      set @pklsti_cancelado = IsNull(@pklsti_cancelado,0)
  
      update PackingListItem set pklsti_pendiente = pklsti_cantidad - @pklsti_cancelado where pklsti_id = @pklsti_id
  
      set @pklsti_cancelado=0
  
      select @pklsti_cancelado = sum(pklstfv_cantidad) from PackingListFacturaVenta where pklsti_id = @pklsti_id
      set @pklsti_cancelado = IsNull(@pklsti_cancelado,0)
  
      update PackingListItem set pklsti_pendientefac = pklsti_cantidad - @pklsti_cancelado where pklsti_id = @pklsti_id
  
      fetch next from c_rviitems into @pklsti_id
    end
    close c_rviitems
    deallocate c_rviitems

  end else begin

    update PackingListItem set   pklsti_pendientefac = 0,
                                pklsti_pendiente    = 0
    where pklst_id = @@pklst_id

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del packing list. sp_DocPackingListSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go