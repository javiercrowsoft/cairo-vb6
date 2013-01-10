if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSetCredito]

/*

 sp_DocRemitoVentaSetCredito 12

*/

go
create procedure sp_DocRemitoVentaSetCredito (
  @@rv_id      int,
  @@borrar     tinyint = 0
)
as

begin

  exec sp_DocRemitoVentaSetCreditoCairo @@rv_id, @@borrar

end
go