if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaAnularCheckDocPEMB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaAnularCheckDocPEMB]

go

create procedure sp_AuditoriaAnularCheckDocPEMB (
  @@pemb_id     int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  declare @bError tinyint

  set @bError     = 0
  set @@bSuccess   = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end