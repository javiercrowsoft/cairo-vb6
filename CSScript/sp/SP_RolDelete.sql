if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_RolDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_RolDelete]

go

/*

  04/09/00
  Proposito: Borrar un usuario

*/

create procedure SP_RolDelete(
  @@rol_id int
)
as 

begin transaction

Delete UsuarioRol where rol_id = @@rol_id
  if @@error <> 0 goto error 

Delete Permiso where rol_id = @@rol_id
  if @@error <> 0 goto error 

Delete Rol where rol_id = @@rol_id
  if @@error <> 0 goto error 

commit transaction
return

error:
raiserror ('Error al intentar borrar el rol', 16, -1)
rollback transaction
