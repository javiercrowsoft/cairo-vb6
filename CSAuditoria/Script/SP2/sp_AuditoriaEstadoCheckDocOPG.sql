-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocOPG]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocOPG]

go

create procedure sp_AuditoriaEstadoCheckDocOPG (
  @@opg_id      int,
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
  declare @opg_nrodoc       varchar(50) 
  declare @opg_numero       varchar(50) 
  declare @est_id           int
  declare @opg_pendiente    decimal(18,6)
  declare @opg_total        decimal(18,6)
  declare @aplicado         decimal(18,6)

  select 
            @doct_id          = doct_id,
            @opg_nrodoc      = opg_nrodoc,
            @opg_numero      = convert(varchar,opg_numero),
            @est_id          = est_id,
            @opg_pendiente  = opg_pendiente,
            @opg_total      = opg_total

  from OrdenPago where opg_id = @@opg_id

  select @aplicado = (IsNull(
                          (select sum(fcopg_importe) from FacturaCompraOrdenPago 
                           where opg_id = @@opg_id),0)
                      )

  if abs(round(@opg_total,2) - round(@opg_pendiente + @aplicado,2)) > 0.01 begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'El pendiente de la orden de pago no coincide con la suma de sus aplicaciones' + char(10)

  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    if round(@opg_pendiente,2) = 0 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'La orden de pago no tiene pendiente y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)

    end

  end

  if exists(select 1 from OrdenPagoItem where cue_id in (select cue_id from retenciontipo) and ret_id is null and opg_id = @@opg_id and opgi_tipo = 4) begin
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Debe indicar la retencion para los items de tipo otro de cuentas de retenciones' + char(10)
  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO