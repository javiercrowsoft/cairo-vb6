if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSaveCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSaveCliente]

go

create procedure sp_DocRemitoVentaSaveCliente (
  @rv_id         int,
  @@rvTMP_ID    int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  set @@bSuccess = 1

end
GO