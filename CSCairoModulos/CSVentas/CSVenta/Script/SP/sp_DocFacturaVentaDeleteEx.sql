if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaDeleteEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaDeleteEx]

go
/*

 sp_DocFacturaVentaDeleteEx 93

*/

create procedure sp_DocFacturaVentaDeleteEx (
	@@fv_id int
)
as

begin

	return
end