-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocCOBZ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocCOBZ]

go

create procedure sp_AuditoriaEstadoCheckDocCOBZ (
  @@cobz_id     int,
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

  declare @doct_id          int
  declare @cobz_nrodoc       varchar(50) 
  declare @cobz_numero       varchar(50) 
  declare @est_id           int
  declare @cobz_pendiente    decimal(18,6)
  declare @cobz_total        decimal(18,6)
  declare @aplicado         decimal(18,6)

  select 
            @doct_id          = doct_id,
            @cobz_nrodoc    = cobz_nrodoc,
            @cobz_numero    = convert(varchar,cobz_numero),
            @est_id          = est_id,
            @cobz_pendiente  = cobz_pendiente,
            @cobz_total      = cobz_total

  from Cobranza where cobz_id = @@cobz_id

  select @aplicado = (IsNull(
                          (select sum(fvcobz_importe) from FacturaVentaCobranza 
                           where cobz_id = @@cobz_id),0)
                      )

  if abs(round(@cobz_total,2) - round(@cobz_pendiente + @aplicado,2)) > 0.01  begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'El pendiente de la cobranza no coincide con la suma de sus aplicaciones' + char(10)

  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    if round(@cobz_pendiente,2) = 0 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'La cobranza no tiene pendiente y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)

    end

  end

  if exists(select 1 from CobranzaItem where cue_id in (select cue_id from retenciontipo) and ret_id is null and cobz_id = @@cobz_id and cobzi_tipo = 4) begin
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Debe indicar la retencion para los items de tipo otro de cuentas de retenciones' + char(10)
  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

ControlError:

end
GO