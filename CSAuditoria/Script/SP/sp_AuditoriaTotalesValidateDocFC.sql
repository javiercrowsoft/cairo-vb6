-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocFC]

go

create procedure sp_AuditoriaTotalesValidateDocFC (

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
  declare @fc_otros         decimal(18,6)
  declare @fc_percepciones  decimal(18,6)
  declare @fc_neto          decimal(18,6)
  declare @fc_ivari         decimal(18,6)
  declare @fc_importedesc1  decimal(18,6)
  declare @fc_importedesc2  decimal(18,6)
  declare @fc_desc1          decimal(18,6)
  declare @fc_desc2          decimal(18,6)

  select 
            @doct_id        = doct_id,
            @fc_nrodoc    = fc_nrodoc,
            @fc_numero    = convert(varchar,fc_numero),
            @est_id        = est_id,
            @fc_pendiente  = fc_pendiente,
            @fc_total      = fc_total,
            @fc_neto      = fc_neto,
            @fc_ivari      = fc_ivari,

            @fc_otros          = fc_totalotros,
            @fc_percepciones  = fc_totalpercepciones,

            @fc_desc1          = fc_descuento1,
            @fc_desc2          = fc_descuento2,

            @fc_importedesc1  = fc_importedesc1,
            @fc_importedesc2  = fc_importedesc2

  from FacturaCompra where fc_id = @@fc_id

  if exists(select fc_id 
            from FacturaCompraItem
             where round(fci_neto,2) <> round(fci_precio * fci_cantidad,2)
              and fc_id = @@fc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura posee items cuyo neto no coincide con el precio por la cantidad '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  if exists(select fc_id 
            from FacturaCompraItem
             where round(fci_neto * (fci_ivariporc / 100),2) <> round(fci_ivari,2)
              and fc_id = @@fc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura posee items cuyo iva no coincide con el neto por el porcentaje de la tasa '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  declare @fci_neto decimal(18,6)

  select @fci_neto = sum(fci_neto)
  from FacturaCompraItem
  where fc_id = @@fc_id
  group by fc_id

  set @fci_neto = IsNull(@fci_neto,0) - (@fci_neto * @fc_desc1/100) 
  set @fci_neto = IsNull(@fci_neto,0) - (@fci_neto * @fc_desc2/100)

  if round(@fci_neto,2) <> round(@fc_neto,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El neto de esta factura no coincide con la suma de los netos de sus items '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  declare @importe         decimal(18,6)
  declare @otros           decimal(18,6)
  declare @percepciones    decimal(18,6)

  select @importe       = sum(fci_importe) from FacturaCompraItem where fc_id = @@fc_id group by fc_id
  select @otros         = sum(fcot_debe-fcot_haber) from FacturaCompraOtro where fc_id = @@fc_id group by fc_id
  select @percepciones   = sum(fcperc_importe) from FacturaCompraPercepcion where fc_id = @@fc_id group by fc_id

  set @importe       = isnull(@importe,0)
  set @otros         = isnull(@otros,0)
  set @percepciones = isnull(@percepciones,0)

  declare @fc_descivari decimal(18,6)
  declare @fci_ivari     decimal(18,6)

  select @fci_ivari = sum(fci_ivari)
            from FacturaCompraItem
            where fc_id = @@fc_id
            group by fc_id

  set @fci_ivari     = isnull(@fci_ivari,0)
  set @fc_descivari = (@fci_ivari * @fc_desc1/100) 
  set @fc_descivari = @fc_descivari + ((@fci_ivari - @fc_descivari) * @fc_desc2/100)
  set @fc_total     = @fc_total + @fc_importedesc1 + @fc_importedesc2 + @fc_descivari

  if round(@importe + @otros + @percepciones,2) <> round(@fc_total,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de esta factura no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  select @fci_ivari = sum(fci_ivari)
            from FacturaCompraItem
            where fc_id = @@fc_id
            group by fc_id

  set @fci_ivari = isnull(@fci_ivari,0)
  set @fci_ivari = @fci_ivari - (@fci_ivari * @fc_desc1/100) 
  set @fci_ivari = @fci_ivari - (@fci_ivari * @fc_desc2/100)

  if round(@fci_ivari,2) <> round(@fc_ivari,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El IVA de esta factura no coincide con la suma de los IVA de sus items '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  if round(@otros,2) <> round(@fc_otros,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de otros de esta factura no coincide con la suma de los totales de sus items de tipo otro '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

  if round(@percepciones,2) <> round(@fc_percepciones,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de percepcioens de esta factura no coincide con la suma de los totales de sus items de tipo percepcion '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fc_id
                                )

  end

ControlError:

end
GO