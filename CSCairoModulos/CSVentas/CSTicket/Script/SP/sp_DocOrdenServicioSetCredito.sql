if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSetCredito]

/*

 sp_DocOrdenServicioSetCredito 12

*/

go
create procedure sp_DocOrdenServicioSetCredito (
  @@os_id      int,
  @@borrar     tinyint = 0
)
as

begin

  exec sp_DocOrdenServicioSetCreditoCairo @@os_id, @@borrar

end