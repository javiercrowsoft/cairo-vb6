if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentasValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentasValidate]

/*

	exec	sp_DocRemitoVentasValidate

*/

go
create procedure sp_DocRemitoVentasValidate 
as

begin

	exec sp_DocRemitoVentasSetPendiente 
	exec sp_DocRemitoVentasSetEstado
end 

go