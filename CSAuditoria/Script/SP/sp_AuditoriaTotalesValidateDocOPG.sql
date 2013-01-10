-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocOPG]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocOPG]

go

create procedure sp_AuditoriaTotalesValidateDocOPG (

  @@opg_id    int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id             int
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

            @opg_otros        = opg_otros

  from OrdenPago where opg_id = @@opg_id

  declare @importe         decimal(18,6)

  select @importe = sum(case opgi_otrotipo 
                          when 2 then - opgi_importe 
                          else           opgi_importe 
                        end) from OrdenPagoItem 
  where opg_id     = @@opg_id 
    and opgi_tipo  <> 5 -- Cuenta corriente
  group by opg_id

  set @importe = isnull(@importe,0)

  if round(@importe,2) <> round(@opg_total,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de esta orden de pago no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @opg_nrodoc + ' nro.: '+ @opg_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@opg_id
                                )

  end

  set @importe = 0

  select @importe = sum(case opgi_otrotipo 
                          when 2 then - opgi_importe 
                          else           opgi_importe 
                        end) from OrdenPagoItem 
  where opg_id     = @@opg_id 
    and opgi_tipo  = 4 -- Otros
  group by opg_id

  set @importe = isnull(@importe,0)

  if round(@importe,2) <> round(@opg_otros,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de otros de esta orden de pago no coincide con la suma de los totales de sus items de tipo otros '
                                 + '(comp.:' + @opg_nrodoc + ' nro.: '+ @opg_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@opg_id
                                )

  end

ControlError:

end
GO