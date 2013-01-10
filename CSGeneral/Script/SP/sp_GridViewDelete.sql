if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewDelete]

/*

*/

go
create procedure sp_GridViewDelete (
  @@grdv_id     int
)
as

begin

  set nocount on

  begin transaction
       
  exec sp_GridViewDeleteItems @@grdv_id

  delete GridView where grdv_id = @@grdv_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la vista. sp_GridViewDelete.', 16, 1)
  rollback transaction  

end
go