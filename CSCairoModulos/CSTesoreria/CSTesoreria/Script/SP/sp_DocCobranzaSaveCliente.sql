if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaSaveCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaSaveCliente]

go

create procedure sp_DocCobranzaSaveCliente (
	@@cobz_id     int,
	@@cobzTMP_ID	int,
  @@bSuccess    tinyint out,
	@@ErrorMsg    varchar(5000) out
)
as

begin

  set nocount on

	set @@bSuccess = 1

end
GO