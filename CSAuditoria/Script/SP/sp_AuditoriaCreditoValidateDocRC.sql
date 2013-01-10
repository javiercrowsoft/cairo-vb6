-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocRC]

go

create procedure sp_AuditoriaCreditoValidateDocRC (

  @@rc_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @rc_nrodoc         varchar(50) 
  declare @rc_numero         varchar(50) 
  declare @est_id           int
  declare @rc_pendiente      decimal(18,6)
  declare @rc_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @prov_id          int
  declare @doct_RemitoCpra  int
  declare @emp_id            int

  set @doct_RemitoCpra = 4

  select 
            @doct_id        = rc.doct_id,
            @rc_nrodoc    = rc_nrodoc,
            @rc_numero    = convert(varchar,rc_numero),
            @est_id        = est_id,
            @rc_pendiente  = rc_pendiente,
            @rc_total      = rc_total,
            @prov_id      = prov_id,
            @emp_id        = emp_id

  from RemitoCompra rc Inner join Documento doc on rc.doc_id = doc.doc_id 
  where rc_id = @@rc_id


  if exists(select prov_id 
            from ProveedorCacheCredito 
             where prov_id <> @prov_id 
               and doct_id = @doct_RemitoCpra 
               and id      = @@rc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este remito esta afectando el cache de credito de otro proveedor '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rc_id
                                )

  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(rci_pendientefac * (rci_importe / rci_cantidad)) from RemitoCompraItem where rc_id = @@rc_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 25 /*devolucion*/ set @pendiente = -@pendiente

  if @pendiente <> 0 begin

    if not exists(select id from ProveedorCacheCredito 
                  where prov_id = @prov_id 
                    and doct_id = @doct_RemitoCpra 
                    and id      = @@rc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este remito tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rc_id
                                )
    end else begin

      select @cache = sum(provcc_importe) 
      from ProveedorCacheCredito 
      where prov_id = @prov_id
        and doct_id  = @doct_RemitoCpra
        and id      = @@rc_id
        and emp_id  = @emp_id

      set @cache = IsNull(@cache,0)

      if @pendiente <> @cache begin
  
        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'Este remito tiene un pendiente distinto al que figura en el cache de credito '
                                   + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
                                   3,
                                   4,
                                   @doct_id,
                                   @@rc_id
                                  )
      end

    end

  end else begin

    if exists(select id from ProveedorCacheCredito 
              where prov_id = @prov_id 
                and doct_id = @doct_RemitoCpra 
                and id      = @@rc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este remito no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rc_id
                                )

    end

  end

ControlError:

end
GO