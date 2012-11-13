if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_catalogoWebDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_catalogoWebDelete]

/*

sp_tables '%cliente%'

 select * from cliente
 select * from documento

 sp_catalogoWebDelete 6

*/

go
create procedure sp_catalogoWebDelete (
	@@catw_id int
)
as

begin

	set nocount on

	begin transaction

	delete CatalogoWebItem where catw_id = @@catw_id
	if @@error <> 0 goto ControlError

	delete CatalogoWeb where catw_id = @@catw_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el catalogo web. sp_catalogoWebDelete.', 16, 1)
	rollback transaction	

end
go