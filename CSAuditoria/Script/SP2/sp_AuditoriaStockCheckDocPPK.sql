-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockCheckDocPPK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockCheckDocPPK]

go

create procedure sp_AuditoriaStockCheckDocPPK (

  @@ppk_id      int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out, 
  @@bDesarme    tinyint
)
as

begin

  set nocount on

  declare @st_id1 int
  declare @st_id2 int

  select @st_id1 = st_id1, @st_id2 = st_id2 from ParteProdKit where ppk_id = @@ppk_id

-- VALIDAR

  if @@bDesarme = 0 begin

     exec sp_AuditoriaStockCheckDocPPK2 @@ppk_id, @st_id1, @@bSuccess out , @@bErrorMsg out, 0

  end else begin

    --exec sp_AuditoriaStockCheckDocPPK2 @@ppk_id, @st_id2, @@bSuccess out , @@bErrorMsg out, 1
    set @@bSuccess = 1

  end

end
go