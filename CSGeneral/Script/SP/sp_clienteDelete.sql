if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteDelete]

/*

sp_tables '%cliente%'

 select * from cliente
 select * from documento

 sp_clienteDelete 6

*/

go
create procedure sp_clienteDelete (
	@@cli_id 				int,
	@@delContacto		tinyint = 0
)
as

begin

	set nocount on

	begin transaction

	if @@delContacto <> 0 begin

		delete Contacto where cli_id = @@cli_id
		if @@error <> 0 goto ControlError

	end else begin

		update Contacto set cli_id = null where cli_id = @@cli_id
		if @@error <> 0 goto ControlError

	end

	delete ClienteCacheCredito where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete ClientePercepcion where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete EmpresaCliente where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete ClienteCuentaGrupo where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete ClienteSucursal where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete ListaDescuentoCliente where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete ListaPrecioCliente where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete EmpresaClienteDeuda where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	delete Cliente where cli_id = @@cli_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el cliente. sp_clienteDelete.', 16, 1)
	rollback transaction	

end
go