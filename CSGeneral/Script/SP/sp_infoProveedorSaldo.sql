if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorSaldo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorSaldo]

/*

sp_infoProveedorSaldo '',114,1

*/

go
create procedure sp_infoProveedorSaldo (
	@@us_id        int,
	@@emp_id       int,
	@@prov_id      int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	exec sp_infoProveedorSaldo2 	@@us_id,
																@@emp_id,
																@@prov_id,
																@@info_aux

end
go