if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingLstDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingLstDevolucionSetPendiente]

/*

  select * from documentotipo

 sp_DocPackingLstDevolucionSetPendiente 124

*/

GO
create procedure sp_DocPackingLstDevolucionSetPendiente (
  @@pklst_id     int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las Facturas
  --
  declare @pklst_id int
  declare @doct_id int

  select @doct_id = doct_id from PackingList where pklst_id = @@pklst_id

  if @doct_id = 21 begin

    declare c_RemitoPendiente insensitive cursor for 
      select distinct pklsti.pklst_id 
      from PackingListDevolucion pklstdv   inner join PackingListItem pklsti    on pklstdv.pklsti_id_devolucion = pklsti.pklsti_id
                                          inner join PackingListItem pklstir   on pklstdv.pklsti_id_pklst = pklstir.pklsti_id
      where pklstir.pklst_id = @@pklst_id
    union
      select pklst_id from #PackingListDevolucion

  end else begin

    declare c_RemitoPendiente insensitive cursor for 
      select distinct pklsti.pklst_id 
      from PackingListDevolucion pklstdv   inner join PackingListItem pklsti    on pklstdv.pklsti_id_pklst = pklsti.pklsti_id
                                          inner join PackingListItem pklstid   on pklstdv.pklsti_id_devolucion = pklstid.pklsti_id
      where pklstid.pklst_id = @@pklst_id
    union
      select pklst_id from #PackingListDevolucion
  end
                      
  open c_RemitoPendiente
  fetch next from c_RemitoPendiente into @pklst_id
  while @@fetch_status = 0 begin
    -- Actualizo la deuda de la Remito
    exec sp_DocPackingListSetPendiente @pklst_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    exec sp_DocPackingListSetCredito @pklst_id

    -- Estado
    exec sp_DocPackingListSetEstado @pklst_id

    fetch next from c_RemitoPendiente into @pklst_id
  end
  close c_RemitoPendiente
  deallocate c_RemitoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del packing list. sp_DocPackingLstDevolucionSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

end

GO