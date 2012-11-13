if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaAnularCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaAnularCliente]

go

create procedure sp_DocRemitoVentaAnularCliente (
	@@rv_id     	int,
	@@us_id				int,
	@@anular			tinyint,
  @@bSuccess    tinyint out,
	@@ErrorMsg    varchar(5000) out
)
as

begin

  set nocount on

	set @@bSuccess = 1

end
GO