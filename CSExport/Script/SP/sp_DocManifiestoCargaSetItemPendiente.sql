if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaSetItemPendiente]

/*

  exec  sp_DocManifiestoCargaSetItemPendiente 38

*/

go
create procedure sp_DocManifiestoCargaSetItemPendiente (
  @@mfc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @est_id     int
  select @est_id = est_id from ManifiestoCarga where mfc_id = @@mfc_id

  begin transaction

  if @est_id <> 7 begin

    declare @mfci_id int
    declare @mfci_cancelado decimal(18,6)
    declare c_pklstiItems insensitive cursor for select mfci_id from ManifiestoCargaItem where mfc_id = @@mfc_id
  
    open c_pklstiItems
    fetch next from c_pklstiItems into @mfci_id
    while @@fetch_status = 0 begin
  
      set @mfci_cancelado=0
  
      select @mfci_cancelado = sum(mfcpklst_cantidad) from ManifiestoPackingList where mfci_id = @mfci_id
      set @mfci_cancelado = IsNull(@mfci_cancelado,0)
  
      update ManifiestoCargaItem set mfci_pendiente = mfci_cantidad - @mfci_cancelado where mfci_id = @mfci_id
  
      fetch next from c_pklstiItems into @mfci_id
    end
    close c_pklstiItems
    deallocate c_pklstiItems

  end else begin

    update ManifiestoCargaItem set mfci_pendiente = 0 where mfc_id = @@mfc_id

  end
  
  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del manifiesto de carga. sp_DocManifiestoCargaSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go