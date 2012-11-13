if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaDeleteCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaDeleteCliente]

go

create procedure sp_DocRemitoVentaDeleteCliente (
	@@rv_id     	int,
	@@us_id				int,
  @@bSuccess    tinyint out,
	@@ErrorMsg    varchar(5000) out
)
as

begin

  set nocount on

	set @@bSuccess = 1

end
GO