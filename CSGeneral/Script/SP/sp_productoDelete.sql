if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_productoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoDelete]

/*

 sp_productoDelete 6

*/

go
create procedure sp_productoDelete (
  @@pr_id     int
)
as

begin

  set nocount on

  begin transaction

  delete ProductoCliente where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ProductoProveedor where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ProductoKitItemA where prk_id in (select prk_id from ProductoKit 
                                           where prfk_id in (select prfk_id 
                                                             from ProductoFormulaKit 
                                                             where pr_id = @@pr_id)
                                          )
  if @@error <> 0 goto ControlError

  delete ProductoKit where prfk_id in (select prfk_id from ProductoFormulaKit where pr_id = @@pr_id)
  if @@error <> 0 goto ControlError

  delete ProductoFormulaKit where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ProductoDepositoFisico where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ProductoDepositoLogico where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ProductoTag where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ListaPrecioItem where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete ListaDescuentoItem where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete StockCache where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  delete Producto where pr_id = @@pr_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el producto. sp_productoDelete.', 16, 1)
  rollback transaction  

end
go