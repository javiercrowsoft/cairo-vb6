-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocRVCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocRVCliente]

go

create procedure sp_AuditoriaTotalesCheckDocRVCliente (

  @@rv_id       int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  exec sp_AuditoriaTotalesCheckDocRV2  @@rv_id,
                                      @@bSuccess out,
                                      @@bErrorMsg out
end
GO