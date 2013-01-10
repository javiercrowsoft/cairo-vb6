if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_permisoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_permisoDelete]

go

/*

  04/09/00
  Proposito: Borrar un usuario

*/

create procedure sp_permisoDelete(
  @@per_id int
)
as 

begin transaction

Delete Permiso where per_id_padre = @@per_id
  if @@error <> 0 goto error 

Delete Permiso where per_id = @@per_id
  if @@error <> 0 goto error 

commit transaction
return

error:
raiserror ('Error al intentar borrar el permiso', 16, -1)
rollback transaction
