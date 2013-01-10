if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AgendaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AgendaDelete]

/*


 select * from Agenda

 sp_AgendaDelete 59

*/

go
create procedure sp_AgendaDelete (
  @@agn_id     int
)
as

begin

  set nocount on

  begin transaction

  declare @pre_id_agregar       int
  declare @pre_id_editar        int
  declare @pre_id_borrar        int
  declare @pre_id_listar        int
  declare @pre_id_propietario   int

  select @pre_id_agregar     = pre_id_agregar      from Agenda where agn_id = @@agn_id
  select @pre_id_editar      = pre_id_editar      from Agenda where agn_id = @@agn_id
  select @pre_id_borrar      = pre_id_borrar       from Agenda where agn_id = @@agn_id
  select @pre_id_listar      = pre_id_listar      from Agenda where agn_id = @@agn_id
  select @pre_id_propietario = pre_id_propietario from Agenda where agn_id = @@agn_id
  

  delete Permiso where pre_id =  @pre_id_agregar           
  if @@error <> 0 goto ControlError
  delete Permiso where pre_id =  @pre_id_editar        
  if @@error <> 0 goto ControlError
  delete Permiso where pre_id =  @pre_id_borrar             
  if @@error <> 0 goto ControlError
  delete Permiso where pre_id =  @pre_id_listar         
  if @@error <> 0 goto ControlError
  delete Permiso where pre_id =  @pre_id_propietario         
  if @@error <> 0 goto ControlError

  delete Agenda where agn_id = @@agn_id
  if @@error <> 0 goto ControlError

  delete Prestacion where pre_id =  @pre_id_agregar           
  if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =  @pre_id_editar        
  if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =  @pre_id_borrar             
  if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =  @pre_id_listar         
  if @@error <> 0 goto ControlError
  delete Prestacion where pre_id =  @pre_id_propietario         
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la agenda. sp_AgendaDelete.', 16, 1)
  rollback transaction  

end
go