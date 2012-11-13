if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListSetCredito]

/*

 sp_DocPackingListSetCredito 12

*/

go
create procedure sp_DocPackingListSetCredito (
	@@pklst_id      int,
  @@borrar     		tinyint = 0
)
as

begin

	exec sp_DocPackingListSetCreditoCairo @@pklst_id, @@borrar

end
go