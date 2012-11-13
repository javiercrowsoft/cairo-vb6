if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CatalogoWebCategoriaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CatalogoWebCategoriaDelete]

/*

 sp_CatalogoWebCategoriaDelete 6

*/

go
create procedure sp_CatalogoWebCategoriaDelete (
	@@catwc_id int
)
as

begin

	set nocount on

	begin transaction

	delete CatalogoWebCategoriaItem where catwc_id = @@catwc_id
	if @@error <> 0 goto ControlError

	delete CatalogoWebCategoria where catwc_id = @@catwc_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la categoria del catalogo web. sp_CatalogoWebCategoriaDelete.', 16, 1)
	rollback transaction	

end
go