-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockCheckDocRS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockCheckDocRS]

go

create procedure sp_AuditoriaStockCheckDocRS (

	@@rs_id       int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @st_id1 int
	declare @st_id2 int

	select @st_id1 = st_id1, @st_id2 = st_id2 from RecuentoStock where rs_id = @@rs_id

	exec sp_AuditoriaStockCheckDocRS2 @@rs_id, @st_id1, @@bSuccess out , @@bErrorMsg out,0
	if @@bSuccess = 0 return

	exec sp_AuditoriaStockCheckDocRS2 @@rs_id, @st_id2, @@bSuccess out , @@bErrorMsg out,1
end
go