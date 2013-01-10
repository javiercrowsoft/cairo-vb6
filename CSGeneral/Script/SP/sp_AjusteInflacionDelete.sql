if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AjusteInflacionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AjusteInflacionDelete]

/*

sp_tables '%cliente%'

 select * from cliente
 select * from documento

 sp_AjusteInflacionDelete 6

*/

go
create procedure sp_AjusteInflacionDelete (
  @@aje_id         int
)
as

begin

  set nocount on

  begin transaction

  delete AjusteInflacionItem where aje_id = @@aje_id
  if @@error <> 0 goto ControlError

  delete AjusteInflacion where aje_id = @@aje_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el esquema de ajuste por inflación. sp_AjusteInflacionDelete.', 16, 1)
  rollback transaction  

end
go