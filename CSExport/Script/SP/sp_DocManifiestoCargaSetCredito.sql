if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaSetCredito]

/*

 sp_DocManifiestoCargaSetCredito 12

*/

go
create procedure sp_DocManifiestoCargaSetCredito (
  @@mfc_id     int,
  @@borrar     tinyint = 0
)
as

begin

  exec sp_DocManifiestoCargaSetCreditoCairo @@mfc_id, @@borrar

end
go