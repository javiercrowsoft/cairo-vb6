if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tipoOperacionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tipoOperacionDelete]

/*

sp_tables '%TipoOperacion%'

 select * from TipoOperacion
 select * from documento

 sp_tipoOperacionDelete 6

*/

go
create procedure sp_tipoOperacionDelete (
	@@to_id 		int
)
as

begin

	set nocount on

	begin transaction

	delete TipoOperacionCuentaGrupo where to_id = @@to_id
	if @@error <> 0 goto ControlError

	delete TipoOperacion where to_id = @@to_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el tipo de operación. sp_tipoOperacionDelete.', 16, 1)
	rollback transaction	

end
go