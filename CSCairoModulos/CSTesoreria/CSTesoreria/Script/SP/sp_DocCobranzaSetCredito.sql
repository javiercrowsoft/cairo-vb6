if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaSetCredito]

/*

 sp_DocCobranzaSetCredito 12

*/

go
create procedure sp_DocCobranzaSetCredito (
  @@cobz_id     int,
  @@borrar     tinyint = 0
)
as

begin

  exec sp_DocCobranzaSetCreditoCairo @@cobz_id, @@borrar
end