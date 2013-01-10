-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocMFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocMFC]

go

create procedure sp_AuditoriaCreditoValidateDocMFC (

  @@mfc_id    int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @mfc_nrodoc       varchar(50) 
  declare @mfc_numero       varchar(50) 
  declare @est_id           int
  declare @mfc_pendiente    decimal(18,6)
  declare @mfc_total        decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @cli_id           int
  declare @doct_Manifiesto  int
  declare @emp_id            int

  set @doct_Manifiesto = 20

  select 
            @doct_id          = mfc.doct_id,
            @mfc_nrodoc      = mfc_nrodoc,
            @mfc_numero      = convert(varchar,mfc_numero),
            @est_id          = est_id,
            @mfc_pendiente  = mfc_pendiente,
            @mfc_total      = mfc_total,
            @cli_id         = cli_id,
            @emp_id          = emp_id

  from ManifiestoCarga mfc inner join Documento doc on mfc.doc_id = doc.doc_id
  where mfc_id = @@mfc_id


  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_Manifiesto 
               and id      = @@mfc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este manifiesto de carga esta afectando el cache de credito de otro cliente '
                                 + '(comp.:' + @mfc_nrodoc + ' nro.: '+ @mfc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@mfc_id
                                )

  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(mfci_pendiente * (mfci_importe / mfci_cantidad)) from ManifiestoCargaItem where mfc_id = @@mfc_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 41 /*devolucion*/ set @pendiente = -@pendiente

  if @pendiente <> 0 begin

    if not exists(select id from ClienteCacheCredito 
                  where cli_id  = @cli_id 
                    and doct_id = @doct_Manifiesto 
                    and id      = @@mfc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este manifiesto de carga tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @mfc_nrodoc + ' nro.: '+ @mfc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@mfc_id
                                )

    end else begin

      select @cache = sum(clicc_importe) 
      from ClienteCacheCredito 
      where cli_id   = @cli_id
        and doct_id  = @doct_Manifiesto
        and id      = @@mfc_id
        and emp_id  = @emp_id

        set @cache = IsNull(@cache,0)

        if @pendiente <> @cache begin
  
        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'Este manifiesto de carga tiene un pendiente distinto al que figura en el cache de credito '
                                   + '(comp.:' + @mfc_nrodoc + ' nro.: '+ @mfc_numero + ')',
                                   3,
                                   4,
                                   @doct_id,
                                   @@mfc_id
                                  )

      end

    end

  end else begin

    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_Manifiesto 
                and id      = @@mfc_id) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este manifiesto de carga no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @mfc_nrodoc + ' nro.: '+ @mfc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@mfc_id
                                )

    end

  end

ControlError:

end
GO