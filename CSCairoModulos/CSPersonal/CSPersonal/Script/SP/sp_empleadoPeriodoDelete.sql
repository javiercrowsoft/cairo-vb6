if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_empleadoPeriodoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_empleadoPeriodoDelete]

go

-- sp_empleadoPeriodoDelete 1

create procedure sp_empleadoPeriodoDelete (
  @@empe_id int
)
as

begin

  set nocount on

  begin tran

  delete EmpleadoHoras where empe_id = @@empe_id
  if @@error <> 0 goto ControlError

  delete EmpleadoPeriodo where empe_id = @@empe_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el periodo de asistencia. sp_empleadoPeriodoDelete.', 16, 1)
  rollback transaction  

  return  

end

go