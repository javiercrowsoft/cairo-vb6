if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tareaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tareaSave]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(tar_id) from tarea

-- sp_tareaSave 131

create procedure sp_tareaSave (
  @@tar_id  int
)
as

begin

  set nocount on

  declare @prns_id int
  declare @tar_id  int

  select @prns_id = prns_id from Tarea where tar_id = @@tar_id

  select @tar_id = max(tar_id) from Tarea where prns_id = @prns_id and tar_fechaini < getdate()

  -- Solo si son la misma tarea
  --
  if @@tar_id = @tar_id begin

    update productonumeroserie set tar_id = @tar_id where prns_id = @prns_id
    if @@error <> 0 goto ControlError

  end

  return
ControlError:

  raiserror ('Ha ocurrido un error al guardar la tarea. sp_tareaSave.', 16, 1)
  rollback transaction  

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



