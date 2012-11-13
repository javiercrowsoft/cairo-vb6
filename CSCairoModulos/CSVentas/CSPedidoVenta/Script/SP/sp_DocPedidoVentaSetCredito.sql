if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSetCredito]

/*

 sp_DocPedidoVentaSetCredito 8

*/

go
create procedure sp_DocPedidoVentaSetCredito (
	@@pv_id      int,
  @@borrar     tinyint = 0
)
as

begin

	exec sp_DocPedidoVentaSetCreditoCairo @@pv_id, @@borrar

end
go