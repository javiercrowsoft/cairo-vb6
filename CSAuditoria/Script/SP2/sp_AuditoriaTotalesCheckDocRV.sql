-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocRV]

go

create procedure sp_AuditoriaTotalesCheckDocRV (

	@@rv_id     	int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	exec sp_AuditoriaTotalesCheckDocRVCliente @@rv_id,
																						@@bSuccess out,
																						@@bErrorMsg out

end
GO