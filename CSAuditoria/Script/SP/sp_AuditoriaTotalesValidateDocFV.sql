-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocFV]

go

create procedure sp_AuditoriaTotalesValidateDocFV (

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
  declare @fv_neto          decimal(18,6)
  declare @fv_ivari         decimal(18,6)
  declare @fv_importedesc1  decimal(18,6)
  declare @fv_importedesc2  decimal(18,6)
  declare @fv_desc1          decimal(18,6)
  declare @fv_desc2          decimal(18,6)

  select 
            @doct_id            = doct_id,
            @fv_nrodoc        = fv_nrodoc,
            @fv_numero        = convert(varchar,fv_numero),
            @est_id            = est_id,
            @fv_pendiente      = fv_pendiente,
            @fv_total          = fv_total,
            @fv_neto          = fv_neto,
            @fv_ivari          = fv_ivari,

            @fv_desc1          = fv_descuento1,
            @fv_desc2          = fv_descuento2,

            @fv_importedesc1  = fv_importedesc1,
            @fv_importedesc2  = fv_importedesc2

  from FacturaVenta where fv_id = @@fv_id

  if exists(select fv_id 
            from FacturaVentaItem
             where round(fvi_neto,2) <> round(fvi_precio * fvi_cantidad,2)
              and fv_id = @@fv_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura posee items cuyo neto no coincide con el precio por la cantidad '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

  end

  if exists(select fv_id 
            from FacturaVentaItem
             where round(fvi_neto * (fvi_ivariporc / 100),2) <> round(fvi_ivari,2)
              and fv_id = @@fv_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta factura posee items cuyo iva no coincide con el neto por el porcentaje de la tasa '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

  end

  declare @fvi_neto decimal(18,6)

  select @fvi_neto = sum(fvi_neto)
  from FacturaVentaItem
  where fv_id = @@fv_id
  group by fv_id

  set @fvi_neto = IsNull(@fvi_neto,0) - (@fvi_neto * @fv_desc1/100) 
  set @fvi_neto = IsNull(@fvi_neto,0) - (@fvi_neto * @fv_desc2/100)

  if  round(@fvi_neto,2) <> round(@fv_neto,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El neto de esta factura no coincide con la suma de los netos de sus items '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

  end

  declare @fv_descivari decimal(18,6)
  declare @fvi_ivari     decimal(18,6)
  declare @importe      decimal(18,6)

  select @fvi_ivari = sum(fvi_ivari)
            from FacturaVentaItem
            where fv_id = @@fv_id
            group by fv_id

  set @fvi_ivari     = isnull(@fvi_ivari,0)
  set @fv_descivari = (@fvi_ivari * @fv_desc1/100) 
  set @fv_descivari = @fv_descivari + ((@fvi_ivari - @fv_descivari) * @fv_desc2/100)
  set @fv_total     = @fv_total + @fv_importedesc1 + @fv_importedesc2 + @fv_descivari

  select @importe = sum(fvi_importe)
            from FacturaVentaItem
            where fv_id = @@fv_id

  set @importe = isnull(@importe,0)

  if round(@importe,2) <> round(@fv_total,2)  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de esta factura no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

  end

  select @fvi_ivari = sum(fvi_ivari)
            from FacturaVentaItem
            where fv_id = @@fv_id
            group by fv_id

  set @fvi_ivari = isnull(@fvi_ivari,0)
  set @fvi_ivari = @fvi_ivari - (@fvi_ivari * @fv_desc1/100) 
  set @fvi_ivari = @fvi_ivari - (@fvi_ivari * @fv_desc2/100)

  if round(@fvi_ivari,2) <> round(@fv_ivari,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El IVA de esta factura no coincide con la suma de los IVA de sus items '
                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@fv_id
                                )

  end


ControlError:

end
GO