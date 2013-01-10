if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoFormulaKitDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoFormulaKitDelete]

go

/*

select max(fv_id) from facturaventa

exec sp_ProductoFormulaKitDelete 95,3

*/
create procedure sp_ProductoFormulaKitDelete(
  @@prfk_id    int
) 
as
begin

  set nocount on

  begin transaction

  delete ProductoKitItemA where prk_id in (select prk_id from ProductoKit where prfk_id = @@prfk_id)
  if @@error <> 0 goto ControlError

  delete ProductoKit where prfk_id = @@prfk_id
  if @@error <> 0 goto ControlError

  delete ProductoFormulaKit where prfk_id = @@prfk_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la formula de kit. sp_productoFormulaKitDelete.', 16, 1)
  rollback transaction  

end
go