-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocFV]

go

create procedure sp_AuditoriaCreditoValidateDocFV (

  @@fv_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @fv_nrodoc         varchar(50) 
  declare @fv_numero         varchar(50) 
  declare @est_id           int
  declare @fv_pendiente      decimal(18,6)
  declare @fv_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @cli_id           int
  declare @doct_facturaVta  int
  declare @emp_id            int

  set @doct_facturaVta = 1

  select 
            @doct_id        = doct_id,
            @fv_nrodoc    = fv_nrodoc,
            @fv_numero    = convert(varchar,fv_numero),
            @est_id        = est_id,
            @fv_pendiente  = fv_pendiente,
            @fv_total      = fv_total,
            @cli_id       = cli_id,
            @emp_id        = emp_id

  from FacturaVenta where fv_id = @@fv_id


  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_facturaVta 
               and id      = @@fv_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura esta afectando el cache de credito de otro cliente '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(fvd_pendiente) from FacturaVentaDeuda where fv_id = @@fv_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 7 /*nota de credito*/ set @pendiente = -@pendiente

  if @pendiente <> 0 begin

    if not exists(select id from ClienteCacheCredito 
                  where cli_id  = @cli_id 
                    and doct_id = @doct_facturaVta 
                    and id      = @@fv_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

    end else begin

      select @cache = sum(clicc_importe) 
      from ClienteCacheCredito 
      where cli_id   = @cli_id
        and doct_id  = @doct_facturaVta
        and id      = @@fv_id
        and emp_id  = @emp_id

        set @cache = IsNull(@cache,0)

        if @pendiente <> @cache begin
  
        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'Esta factura tiene un pendiente distinto al que figura en el cache de credito '
                                   + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                   3,
                                   4,
                                   @doct_id,
                                   @@fv_id
                                  )

      end

    end

  end else begin

    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_facturaVta 
                and id      = @@fv_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

    end

  end

ControlError:

end
GO