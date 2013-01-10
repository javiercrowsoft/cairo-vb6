-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocOC]

go

create procedure sp_AuditoriaCreditoValidateDocOC (

  @@oc_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @oc_nrodoc         varchar(50) 
  declare @oc_numero         varchar(50) 
  declare @est_id           int
  declare @oc_pendiente      decimal(18,6)
  declare @oc_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @prov_id          int
  declare @doct_OrdenCpra    int
  declare @emp_id            int

  set @doct_OrdenCpra = 35

  select 
            @doct_id        = doct_id,
            @oc_nrodoc    = oc_nrodoc,
            @oc_numero    = convert(varchar,oc_numero),
            @est_id        = est_id,
            @oc_pendiente  = oc_pendiente,
            @oc_total      = oc_total,
            @prov_id      = prov_id,
            @emp_id        = emp_id

  from OrdenCompra where oc_id = @@oc_id


  if exists(select prov_id 
            from ProveedorCacheCredito 
             where prov_id <> @prov_id 
               and doct_id = @doct_OrdenCpra 
               and id      = @@oc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta orden de compra esta afectando el cache de credito de otro proveedor '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(oci_pendientefac * (oci_importe / oci_cantidad)) from OrdenCompraItem where oc_id = @@oc_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 36 /*cancelacion*/ set @pendiente = -@pendiente

  if @pendiente <> 0 begin

    if not exists(select id from ProveedorCacheCredito 
                  where prov_id = @prov_id 
                    and doct_id = @doct_OrdenCpra 
                    and id      = @@oc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta orden de compra tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

    end else begin

      select @cache = sum(provcc_importe) 
      from ProveedorCacheCredito 
      where prov_id = @prov_id
        and doct_id  = @doct_OrdenCpra
        and id      = @@oc_id
        and emp_id  = @emp_id

        set @cache = IsNull(@cache,0)

        if @pendiente <> @cache begin
  
        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'Esta orden de compra tiene un pendiente distinto al que figura en el cache de credito '
                                   + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                   3,
                                   4,
                                   @doct_id,
                                   @@oc_id
                                  )

      end

    end

  end else begin

    if exists(select id from ProveedorCacheCredito 
              where prov_id = @prov_id 
                and doct_id = @doct_OrdenCpra 
                and id      = @@oc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta orden de compra no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

    end

  end

ControlError:

end
GO