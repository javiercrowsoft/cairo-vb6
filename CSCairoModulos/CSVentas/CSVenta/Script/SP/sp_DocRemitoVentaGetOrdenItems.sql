if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetOrdenItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetOrdenItems]

go

/*

sp_DocRemitoVentaGetOrdenItems '11'

*/

create procedure sp_DocRemitoVentaGetOrdenItems (
  @@strIds varchar(5000)
)
as

begin

  exec sp_DocRemitoVentaGetOrdenItemsCliente @@strIds

end
go