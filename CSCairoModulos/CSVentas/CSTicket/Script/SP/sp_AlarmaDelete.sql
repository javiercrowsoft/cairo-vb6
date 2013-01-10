if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AlarmaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AlarmaDelete]

/*


 select * from Agenda

 sp_AlarmaDelete 59

*/

go
create procedure sp_AlarmaDelete (
  @@al_id     int
)
as

begin

  set nocount on

  begin transaction

  delete AlarmaDiaSemana where al_id = @@al_id
  if @@error<>0 goto ControlError

  delete AlarmaDiaMes where al_id = @@al_id
  if @@error<>0 goto ControlError

  delete AlarmaFecha where al_id = @@al_id
  if @@error<>0 goto ControlError

  delete AlarmaItem where al_id = @@al_id
  if @@error<>0 goto ControlError

  delete Alarma where al_id = @@al_id
  if @@error<>0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la alarma. sp_AlarmaDelete.', 16, 1)
  rollback transaction  

end
go