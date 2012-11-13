if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedoresFixCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedoresFixCredito]

/*

 sp_proveedoresFixCredito

*/

go
create procedure sp_proveedoresFixCredito 

as

begin

	declare @prov_id int

	declare c_proveedor insensitive cursor for select prov_id from proveedor

	open c_proveedor

	fetch next from c_proveedor into @prov_id	
	while @@fetch_status=0
	begin

		exec sp_ProveedorFixCredito @prov_id

		fetch next from c_proveedor into @prov_id
	end

	close c_proveedor
	deallocate c_proveedor

end
go