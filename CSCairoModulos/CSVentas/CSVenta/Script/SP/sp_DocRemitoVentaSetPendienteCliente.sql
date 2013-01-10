if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSetPendienteCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSetPendienteCliente]

go

create procedure sp_DocRemitoVentaSetPendienteCliente (
  @@rv_id       int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  set @@bSuccess = 1

end
GO