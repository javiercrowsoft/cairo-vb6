
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_RemitoVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_RemitoVenta]

go
create procedure sp_lsdoc_RemitoVenta (

	@@rv_id int

)as 
begin

	set nocount on

	exec sp_lsdoc_RemitoVentaCliente @@rv_id

end
go