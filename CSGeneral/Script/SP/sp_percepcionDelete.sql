if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_percepcionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_percepcionDelete]

/*

*/

go
create procedure sp_percepcionDelete (
  @@perc_id         int
)
as

begin

  set nocount on

  begin transaction

  delete PercepcionItem where perc_id = @@perc_id
  if @@error <> 0 goto ControlError

  delete PercepcionProvincia where perc_id = @@perc_id
  if @@error <> 0 goto ControlError

  delete Percepcion where perc_id = @@perc_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la percepcion. sp_percepcionDelete.', 16, 1)
  rollback transaction  

end
go