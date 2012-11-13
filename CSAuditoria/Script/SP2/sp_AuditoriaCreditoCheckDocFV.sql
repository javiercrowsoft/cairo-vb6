-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocFV]

go

create procedure sp_AuditoriaCreditoCheckDocFV (

	@@fv_id     	int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

	exec sp_AuditoriaCreditoCheckDocFVCliente @@fv_id, @@bSuccess out, @@bErrorMsg out

end
GO