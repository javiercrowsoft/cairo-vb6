-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocFC]

go

create procedure sp_AuditoriaCreditoValidateDocFC (

  @@fc_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @fc_nrodoc         varchar(50) 
  declare @fc_numero         varchar(50) 
  declare @est_id           int
  declare @fc_pendiente      decimal(18,6)
  declare @fc_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @prov_id          int
  declare @doct_facturaCpra  int
  declare @emp_id            int

  set @doct_facturaCpra = 2

  select 
            @doct_id        = fc.doct_id,
            @fc_nrodoc    = fc_nrodoc,
            @fc_numero    = convert(varchar,fc_numero),
            @est_id        = est_id,
            @fc_pendiente  = fc_pendiente,
            @fc_total      = fc_total,
            @prov_id      = prov_id,
            @emp_id        = emp_id

  from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id 
  where fc_id = @@fc_id


  if exists(select prov_id 
            from ProveedorCacheCredito 
             where prov_id <> @prov_id 
               and doct_id = @doct_facturaCpra 
               and id      = @@fc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura esta afectando el cache de credito de otro Proveedor '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(fcd_pendiente) from FacturaCompraDeuda where fc_id = @@fc_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 8 /*nota de credito*/ set @pendiente = -@pendiente

  if @pendiente <> 0 begin

    if not exists(select id from ProveedorCacheCredito 
                  where prov_id = @prov_id 
                    and doct_id = @doct_facturaCpra 
                    and id      = @@fc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

    end else begin

      select @cache = sum(provcc_importe) 
      from ProveedorCacheCredito 
      where prov_id = @prov_id
        and doct_id  = @doct_facturaCpra
        and id      = @@fc_id
        and emp_id  = @emp_id

        set @cache = IsNull(@cache,0)

        if @pendiente <> @cache begin
  
        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'Esta factura tiene un pendiente distinto al que figura en el cache de credito '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   4,
                                   @doct_id,
                                   @@fc_id
                                  )

      end

    end

  end else begin

    if exists(select id from ProveedorCacheCredito 
              where prov_id = @prov_id 
                and doct_id = @doct_facturaCpra 
                and id      = @@fc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )
    end

  end

ControlError:

end
GO