if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_BancoConciliacionDelete ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_BancoConciliacionDelete ]

go

/*

*/
create procedure sp_BancoConciliacionDelete  (
	@@bcoc_id    int
)
as

begin

	set nocount on

	begin transaction

	delete BancoConciliacionItem where bcoc_id = @@bcoc_id
	if @@error <> 0 goto ControlError

	delete BancoConciliacionItem where bcoc_id = @@bcoc_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la conciliacion bancaria. sp_BancoConciliacionDelete.', 16, 1)
	rollback transaction	

end				