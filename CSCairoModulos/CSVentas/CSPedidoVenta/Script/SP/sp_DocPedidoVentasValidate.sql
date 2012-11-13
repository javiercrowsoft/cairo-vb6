if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentasValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentasValidate]

/*

	exec	sp_DocPedidoVentasValidate

*/

go
create procedure sp_DocPedidoVentasValidate 
as

begin

	exec sp_DocPedidoVentasSetPendiente 
	exec sp_DocPedidoVentasSetEstado
end 

go