if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_UsDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_UsDelete]

go

/*

	04/09/00
	Proposito: Borrar un usuario

  SP_UsDelete 790

*/

create procedure SP_UsDelete(
	@@us_id int
)
as 

begin transaction

Delete UsuarioRol where us_id = @@us_id
	if @@error <> 0 goto error 

Delete Permiso where us_id = @@us_id
	if @@error <> 0 goto error 

Delete UsuarioEmpresa where us_id = @@us_id
	if @@error <> 0 goto error 

Delete UsuarioDepositoLogico where us_id = @@us_id
	if @@error <> 0 goto error 

Delete EmpresaUsuario where us_id = @@us_id
	if @@error <> 0 goto error 

Update Cliente set us_id = null where us_id = @@us_id
	if @@error <> 0 goto error 

Update Proveedor set us_id = null where us_id = @@us_id
	if @@error <> 0 goto error 

Delete Usuario where us_id = @@us_id
	if @@error <> 0 goto error 

commit transaction
return

error:
raiserror ('Error al intentar borrar el usuario', 16, -1)
rollback transaction
