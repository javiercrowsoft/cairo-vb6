if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_retencionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_retencionDelete]

/*

*/

go
create procedure sp_retencionDelete (
  @@ret_id         int
)
as

begin

  set nocount on

  begin transaction

  delete RetencionItem where ret_id = @@ret_id
  if @@error <> 0 goto ControlError

  delete Retencion where ret_id = @@ret_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la retencion. sp_retencionDelete.', 16, 1)
  rollback transaction  

end
go