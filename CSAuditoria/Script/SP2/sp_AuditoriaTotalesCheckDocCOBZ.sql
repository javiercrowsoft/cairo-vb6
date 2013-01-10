-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocCOBZ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocCOBZ]

go

create procedure sp_AuditoriaTotalesCheckDocCOBZ (
  @@cobz_id      int,
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

  declare @doct_id            int
  declare @cobz_nrodoc         varchar(50) 
  declare @cobz_numero         varchar(50) 
  declare @cobz_total          decimal(18,6)
  declare @cobz_otros         decimal(18,6)

  select 
            @doct_id          = doct_id,
            @cobz_nrodoc    = cobz_nrodoc,
            @cobz_numero    = convert(varchar,cobz_numero),
            @cobz_total      = cobz_total,

            @cobz_otros      = cobz_otros

  from Cobranza where cobz_id = @@cobz_id

  declare @importe         decimal(18,6)

  select @importe = sum(case cobzi_otrotipo 
                          when 2 then - cobzi_importe 
                          else           cobzi_importe 
                        end) from CobranzaItem 
  where cobz_id     = @@cobz_id 
    and cobzi_tipo  <> 5 -- Cuenta corriente
  group by cobz_id

  set @importe = isnull(@importe,0)

  if abs(round(@importe,2) - round(@cobz_total,2))>0.01 begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'El total de esta cobranza no coincide con la suma de los totales de sus items' + char(10)

  end

  set @importe = 0

  select @importe = sum(case cobzi_otrotipo 
                          when 2 then - cobzi_importe 
                          else           cobzi_importe 
                        end) from CobranzaItem 
  where cobz_id     = @@cobz_id 
    and cobzi_tipo  = 4 -- Otros
  group by cobz_id

  set @importe = isnull(@importe,0)

  if abs(round(@importe,2) - round(@cobz_otros,2))>0.01 begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'El total de otros de esta cobranza no coincide con la suma de los totales de sus items de tipo otros' + char(10)

  end

  if not exists(select cobz_id from CobranzaItem where cobz_id = @@cobz_id) begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'Esta cobranza no contiene items. Todas las cobranzas deben tener almenos dos items uno de cuenta corriente y otro de un medio de pago.' + char(10)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO