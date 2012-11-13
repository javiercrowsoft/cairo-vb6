if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ExpoGrupoPrecioDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ExpoGrupoPrecioDelete]

/*

sp_tables '%cliente%'

 select * from cliente
 select * from documento

 sp_ExpoGrupoPrecioDelete 6

*/

go
create procedure sp_ExpoGrupoPrecioDelete (
	@@egp_id 		int
)
as

begin

	set nocount on

	begin transaction

	delete ExpoGrupoPrecioIdioma where egp_id = @@egp_id
	if @@error <> 0 goto ControlError

	delete ExpoGrupoPrecioPosAran where egp_id = @@egp_id
	if @@error <> 0 goto ControlError

	update producto set egp_id = null where egp_id = @@egp_id
	if @@error <> 0 goto ControlError

	delete ExpoGrupoPrecio where egp_id = @@egp_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el grupo de precios de exportación. sp_ExpoGrupoPrecioDelete.', 16, 1)
	rollback transaction	

end
go