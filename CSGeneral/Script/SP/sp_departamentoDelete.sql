if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_departamentoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_departamentoDelete]

/*


 select * from departamento

 sp_departamentoDelete 59

*/

go
create procedure sp_departamentoDelete (
	@@dpto_id 		int
)
as

begin

	set nocount on

	begin transaction

	declare @pre_id_vernoticias           int
	declare @pre_id_editarnoticias        int
	declare @pre_id_vertareas             int
	declare @pre_id_asignartareas         int
	declare @pre_id_verdocumentos         int
	declare @pre_id_agregardocumentos     int
	declare @pre_id_borrardocumentos      int
	declare @pre_id_editardocumentos      int

	select @pre_id_vernoticias       = pre_id_vernoticias		    from Departamento where dpto_id = @@dpto_id
	select @pre_id_editarnoticias    = pre_id_editarnoticias    from Departamento where dpto_id = @@dpto_id
	select @pre_id_vertareas         = pre_id_vertareas 		    from Departamento where dpto_id = @@dpto_id
	select @pre_id_asignartareas     = pre_id_asignartareas     from Departamento where dpto_id = @@dpto_id
	select @pre_id_verdocumentos     = pre_id_verdocumentos     from Departamento where dpto_id = @@dpto_id
	select @pre_id_agregardocumentos = pre_id_agregardocumentos from Departamento where dpto_id = @@dpto_id
	select @pre_id_borrardocumentos  = pre_id_borrardocumentos  from Departamento where dpto_id = @@dpto_id
	select @pre_id_editardocumentos  = pre_id_editardocumentos  from Departamento where dpto_id = @@dpto_id

  delete Permiso where pre_id =	@pre_id_vernoticias           
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_editarnoticias        
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_vertareas             
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_asignartareas         
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_verdocumentos         
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_agregardocumentos     
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_borrardocumentos      
	if @@error <> 0 goto ControlError
  delete Permiso where pre_id =	@pre_id_editardocumentos      
	if @@error <> 0 goto ControlError

	delete UsuarioDepartamento where dpto_id = @@dpto_id
	if @@error <> 0 goto ControlError

	delete Departamento where dpto_id = @@dpto_id
	if @@error <> 0 goto ControlError

  delete Prestacion where pre_id =	@pre_id_vernoticias           
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_editarnoticias        
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_vertareas             
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_asignartareas         
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_verdocumentos         
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_agregardocumentos     
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_borrardocumentos      
	if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =	@pre_id_editardocumentos      
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el departamento. sp_departamentoDelete.', 16, 1)
	rollback transaction	

end
go