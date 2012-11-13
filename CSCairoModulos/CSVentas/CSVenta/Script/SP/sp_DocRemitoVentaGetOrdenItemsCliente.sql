if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetOrdenItemsCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetOrdenItemsCliente]

go

/*

sp_DocRemitoVentaGetOrdenItemsCliente '11'

*/

create procedure sp_DocRemitoVentaGetOrdenItemsCliente (
	@@strIds varchar(5000)
)
as

begin

  set nocount on

	exec sp_DocRemitoVentaGetOrdenItemsCairo @@strIds

end
go