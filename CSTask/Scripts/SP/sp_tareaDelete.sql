if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tareaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tareaDelete]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(tar_id) from tarea

-- sp_tareaDelete 131

create procedure sp_tareaDelete (
	@@tar_id	int
)
as

begin

	set nocount on

	begin transaction

	declare @tar_id 		int
	declare @prns_id 		int

	select prns_id = prns_id 
	from Tarea 
	where tar_id = @@tar_id

	select @tar_id = max(tar_id)
	from Tarea t
  where t.tar_id <> @@tar_id
		and t.prns_id = @prns_id

	update ProductoNumeroSerie set tar_id = @tar_id
  where prns_id = @prns_id
	if @@error <> 0 goto ControlError

	delete Tarea where tar_id = @@tar_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la tarea. sp_tareaDelete.', 16, 1)
	rollback transaction	

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



