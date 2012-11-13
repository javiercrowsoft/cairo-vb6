if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveCliente]

go

create procedure sp_DocFacturaVentaSaveCliente (
	@fv_id     		int,
	@@fvTMP_ID		int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	set @@bSuccess = 1

end
GO