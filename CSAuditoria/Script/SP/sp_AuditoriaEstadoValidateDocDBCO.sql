-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocDBCO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocDBCO]

go

create procedure sp_AuditoriaEstadoValidateDocDBCO (

  @@dbco_id     int,
  @@aud_id       int

)
as

begin

  set nocount on

end
GO