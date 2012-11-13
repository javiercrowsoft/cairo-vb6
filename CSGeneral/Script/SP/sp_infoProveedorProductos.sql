if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorProductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorProductos]

/*

sp_infoProveedorProductos 1,1,34

*/

go
create procedure sp_infoProveedorProductos (
	@@us_id         int,
	@@emp_id        int,
	@@prov_id        int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	exec sp_infoProveedorProductos2 @@us_id,
																@@emp_id,
																@@prov_id,
																@@info_aux

end
go