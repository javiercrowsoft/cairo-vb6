if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSetCredito]

/*

 sp_DocFacturaVentaSetCredito 61

*/

go
create procedure sp_DocFacturaVentaSetCredito (
  @@fv_id      int,
  @@borrar     tinyint = 0
)
as

begin

  exec sp_DocFacturaVentaSetCreditoCairo @@fv_id, @@borrar

end