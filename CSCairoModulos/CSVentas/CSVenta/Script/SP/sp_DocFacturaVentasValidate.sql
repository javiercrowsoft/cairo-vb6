if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentasValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentasValidate]

/*

	exec	sp_DocFacturaVentasValidate

*/

go
create procedure sp_DocFacturaVentasValidate 
as

begin

	exec sp_DocFacturaVentasSetPendiente 
	exec sp_DocFacturaVentasSetEstado
end 

go