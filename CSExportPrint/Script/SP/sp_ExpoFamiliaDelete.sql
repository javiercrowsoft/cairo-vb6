if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ExpoFamiliaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ExpoFamiliaDelete]

/*

sp_tables '%cliente%'

 select * from cliente
 select * from documento

 sp_ExpoFamiliaDelete 6

*/

go
create procedure sp_ExpoFamiliaDelete (
	@@efm_id 		int
)
as

begin

	set nocount on

	begin transaction

	update producto set efm_id = null where efm_id = @@efm_id
	if @@error <> 0 goto ControlError

	delete ExpoFamilia where efm_id = @@efm_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la familia de exportación. sp_ExpoFamiliaDelete.', 16, 1)
	rollback transaction	

end
go