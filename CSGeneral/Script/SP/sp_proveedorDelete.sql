if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorDelete]

/*

sp_tables '%proveedor%'

 select * from Proveedor
 select * from documento

 sp_proveedorDelete 6

*/

go
create procedure sp_proveedorDelete (
  @@prov_id     int
)
as

begin

  set nocount on

  begin transaction

  delete ProductoProveedor where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete EmpresaProveedor where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete ProveedorRetencion where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete ProveedorCuentaGrupo where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete ListaDescuentoProveedor where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete ListaPrecioProveedor where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete ProveedorCacheCredito where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete ProveedorCAI where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete EmpresaProveedorDeuda where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  delete Proveedor where prov_id = @@prov_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el proveedor. sp_proveedorDelete.', 16, 1)
  rollback transaction  

end
go