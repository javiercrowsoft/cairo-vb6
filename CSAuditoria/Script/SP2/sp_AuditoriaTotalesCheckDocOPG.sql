-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocOPG]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocOPG]

go

create procedure sp_AuditoriaTotalesCheckDocOPG (
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

  declare @doct_id            int
  declare @opg_nrodoc         varchar(50) 
  declare @opg_numero         varchar(50) 
  declare @opg_total          decimal(18,6)
  declare @opg_otros           decimal(18,6)

  select 
            @doct_id          = doct_id,
            @opg_nrodoc      = opg_nrodoc,
            @opg_numero      = convert(varchar,opg_numero),
            @opg_total      = opg_total,

            @opg_otros      = opg_otros

  from OrdenPago where opg_id = @@opg_id

  declare @importe         decimal(18,6)

  select @importe = sum(case opgi_otrotipo 
                          when 1 then - opgi_importe 
                          else           opgi_importe 
                        end) from OrdenPagoItem 
  where opg_id     = @@opg_id 
    and opgi_tipo  <> 5 -- Cuenta corriente
  group by opg_id

  set @importe = isnull(@importe,0)

  if abs(round(@importe,2) - round(@opg_total,2))>0.01 begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'El total de esta orden de pago no coincide con la suma de los totales de sus items' + char(10)

  end

  set @importe = 0

  select @importe = sum(case opgi_otrotipo 
                          when 1 then - opgi_importe 
                          else           opgi_importe 
                        end) from OrdenPagoItem 
  where opg_id     = @@opg_id 
    and opgi_tipo  = 4 -- Otros
  group by opg_id

  set @importe = isnull(@importe,0)

  if abs(round(@importe,2) - round(@opg_otros,2))>0.01 begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'El total de otros de esta orden de pago no coincide con la suma de los totales de sus items de tipo otros' + char(10)
                                    + 'Dif: ' + convert(varchar(50),round(@importe,2) - round(@opg_otros,2),1) + char(10)
                                    + 'Total: ' +  convert(varchar(50),round(@opg_otros,2),1) + char(10)
                                    + 'Deuda: ' +  convert(varchar(50),round(@importe,2),1) + char(10)

  end

  if not exists(select opg_id from OrdenPagoItem where opg_id = @@opg_id) begin

    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg + 'Esta orden de pago no contiene items. Todas las ordens de pago deben tener almenos dos items uno de cuenta corriente y otro de un medio de pago.' + char(10)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO