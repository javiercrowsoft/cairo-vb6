if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CursoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CursoDelete]

go

-- sp_CursoDelete 1

create procedure sp_CursoDelete (
  @@cur_id int
)
as

begin

  set nocount on

  begin tran

  delete CursoItemCalificacion 
  where curi_id in (select curi_id from CursoItem where cur_id = @@cur_id)
  if @@error <> 0 goto ControlError

  delete CursoItemAsistencia
  where curi_id in (select curi_id from CursoItem where cur_id = @@cur_id)
  if @@error <> 0 goto ControlError

  delete CursoClase where cur_id = @@cur_id
  if @@error <> 0 goto ControlError

  delete CursoExamen where cur_id = @@cur_id
  if @@error <> 0 goto ControlError

  delete CursoItem where cur_id = @@cur_id
  if @@error <> 0 goto ControlError

  delete Curso where cur_id = @@cur_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el curso. sp_CursoDelete.', 16, 1)
  rollback transaction  

  return  

end

go