if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_listaPrecioDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_listaPrecioDelete]

/*

sp_tables '%cliente%'

 select * from cliente
 select * from documento

 sp_listaPrecioDelete 6

*/

go
create procedure sp_listaPrecioDelete (
	@@lp_id 		int
)
as

begin

	set nocount on

	begin transaction

	Update cliente set lp_id = null where lp_id = @@lp_id
	Update proveedor set lp_id = null where lp_id = @@lp_id

	delete ListaPrecioItem where lp_id = @@lp_id
	if @@error <> 0 goto ControlError

	delete ListaPrecioProveedor where lp_id = @@lp_id
	if @@error <> 0 goto ControlError

	delete ListaPrecioCliente where lp_id = @@lp_id
	if @@error <> 0 goto ControlError

	delete ListaPrecioLista where lp_id = @@lp_id
	if @@error <> 0 goto ControlError

	delete ListaPrecio where lp_id = @@lp_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la lista de precio. sp_listaPrecioDelete.', 16, 1)
	rollback transaction	

end
go