if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListDelete]

go

create procedure sp_PickingListDelete (
  @@pkl_id int
)
as

begin

  set nocount on

  begin transaction

  delete PickingListPedidoItem where pkl_id = @@pkl_id
  if @@error <> 0 goto ControlError

  delete PickingListPedido where pkl_id = @@pkl_id
  if @@error <> 0 goto ControlError

  delete PickingList where pkl_id = @@pkl_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la lista de despacho. sp_PickingListDelete.', 16, 1)
  rollback transaction  


end

go