-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocPV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocPV]

go

create procedure sp_AuditoriaCreditoValidateDocPV (

  @@pv_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @pv_nrodoc         varchar(50) 
  declare @pv_numero         varchar(50) 
  declare @est_id           int
  declare @pv_pendiente      decimal(18,6)
  declare @pv_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @cli_id           int
  declare @doct_PedidoVta    int
  declare @emp_id            int

  set @doct_PedidoVta = 5

  select 
            @doct_id        = doct_id,
            @pv_nrodoc    = pv_nrodoc,
            @pv_numero    = convert(varchar,pv_numero),
            @est_id        = est_id,
            @pv_pendiente  = pv_pendiente,
            @pv_total      = pv_total,
            @cli_id       = cli_id,
            @emp_id        = emp_id

  from PedidoVenta where pv_id = @@pv_id


  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_PedidoVta 
               and id      = @@pv_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este pedido esta afectando el cache de credito de otro cliente '
                                 + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pv_id
                                )

  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(pvi_pendiente * (pvi_importe / pvi_cantidad)) from PedidoVentaItem where pv_id = @@pv_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 22 /*devolucion*/ set @pendiente = -@pendiente

  if @pendiente <> 0 begin

    if not exists(select id from ClienteCacheCredito 
                  where cli_id  = @cli_id 
                    and doct_id = @doct_PedidoVta 
                    and id      = @@pv_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este pedido tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pv_id
                                )

    end else begin

      select @cache = sum(clicc_importe) 
      from ClienteCacheCredito 
      where cli_id   = @cli_id
        and doct_id  = @doct_PedidoVta
        and id      = @@pv_id
        and emp_id  = @emp_id

        set @cache = IsNull(@cache,0)

        if @pendiente <> @cache begin
  
        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'Este pedido tiene un pendiente distinto al que figura en el cache de credito '
                                   + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
                                   3,
                                   4,
                                   @doct_id,
                                   @@pv_id
                                  )

      end

    end

  end else begin

    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_PedidoVta 
                and id      = @@pv_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este pedido no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pv_id
                                )

    end

  end

ControlError:

end
GO