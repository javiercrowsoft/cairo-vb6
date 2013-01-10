if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorFixCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorFixCredito]

/*

 sp_proveedorFixCredito 12

*/

go
create procedure sp_proveedorFixCredito (
  @@prov_id      int
)
as

begin

  declare @emp_id int

  declare c_empresa insensitive cursor for select emp_id from empresa

  open c_empresa

  fetch next from c_empresa into @emp_id  
  while @@fetch_status=0
  begin

    exec sp_proveedorUpdateCredito             @@prov_id, @emp_id
    exec sp_proveedorUpdateOrdenCompraCredito @@prov_id, @emp_id
    exec sp_proveedorUpdateRemitoCredito       @@prov_id, @emp_id

    fetch next from c_empresa into @emp_id
  end

  close c_empresa
  deallocate c_empresa



  update proveedor 
      set prov_deudatotal =   prov_deudaorden 
                          +  prov_deudaremito 
                          +  prov_deudactacte
                          +  prov_deudadoc
  where prov_id = @@prov_id

end
go