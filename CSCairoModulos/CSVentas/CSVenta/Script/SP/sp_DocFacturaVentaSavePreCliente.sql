if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSavePreCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSavePreCliente]

/*

 sp_DocFacturaVentaSavePreCliente 124

*/

go
create procedure sp_DocFacturaVentaSavePreCliente (
	@@fvTMP_id		int,
  @@bSuccess    tinyint = 0 out,
	@@bErrorMsg   varchar(5000) = '' out
)
as

begin

  set nocount on

	set @@bSuccess = 1

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

