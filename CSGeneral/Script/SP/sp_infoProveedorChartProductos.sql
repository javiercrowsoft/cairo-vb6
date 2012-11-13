if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorChartProductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorChartProductos]

/*

sp_infoProveedorChartProductos 1,1,34

*/

go
create procedure sp_infoProveedorChartProductos (
	@@us_id        int,
	@@emp_id       int,
	@@prov_id      int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	exec sp_infoProveedorChartProductos2 @@us_id,
																			 @@emp_id,
																		   @@prov_id,
																		   @@info_aux

end
go