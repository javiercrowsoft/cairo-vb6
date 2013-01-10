-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocRV]

go

create procedure sp_AuditoriaTotalesValidateDocRV (

  @@rv_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @rv_nrodoc         varchar(50) 
  declare @rv_numero         varchar(50) 
  declare @est_id           int
  declare @rv_pendiente      decimal(18,6)
  declare @rv_total          decimal(18,6)
  declare @rv_neto          decimal(18,6)
  declare @rv_ivari         decimal(18,6)
  declare @rv_importedesc1  decimal(18,6)
  declare @rv_importedesc2  decimal(18,6)
  declare @rv_desc1          decimal(18,6)
  declare @rv_desc2          decimal(18,6)

  select 
            @doct_id            = doct_id,
            @rv_nrodoc        = rv_nrodoc,
            @rv_numero        = convert(varchar,rv_numero),
            @est_id            = est_id,
            @rv_pendiente      = rv_pendiente,
            @rv_total          = rv_total,
            @rv_neto          = rv_neto,
            @rv_ivari          = rv_ivari,

            @rv_desc1          = rv_descuento1,
            @rv_desc2          = rv_descuento2,

            @rv_importedesc1  = rv_importedesc1,
            @rv_importedesc2  = rv_importedesc2

  from RemitoVenta where rv_id = @@rv_id

  if exists(select rv_id 
            from RemitoVentaItem
             where round(rvi_neto,2) <> round(rvi_precio * rvi_cantidad,2)
              and rv_id = @@rv_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este remito posee items cuyo neto no coincide con el precio por la cantidad '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rv_id
                                )

  end

  if exists(select rv_id 
            from RemitoVentaItem
             where round(rvi_neto * (rvi_ivariporc / 100),2) <> round(rvi_ivari,2)
              and rv_id = @@rv_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este remito posee items cuyo iva no coincide con el neto por el porcentaje de la tasa '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rv_id
                                )

  end

  declare @rvi_neto decimal(18,6)

  select @rvi_neto = sum(rvi_neto)
  from RemitoVentaItem
  where rv_id = @@rv_id
  group by rv_id

  set @rvi_neto = IsNull(@rvi_neto,0) - (@rvi_neto * @rv_desc1/100) 
  set @rvi_neto = IsNull(@rvi_neto,0) - (@rvi_neto * @rv_desc2/100)

  if  round(@rvi_neto,2) <> round(@rv_neto,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El neto de este remito no coincide con la suma de los netos de sus items '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rv_id
                                )

  end

  declare @rv_descivari decimal(18,6)
  declare @rvi_ivari     decimal(18,6)
  declare @importe      decimal(18,6)

  select @rvi_ivari = sum(rvi_ivari)
            from RemitoVentaItem
            where rv_id = @@rv_id
            group by rv_id

  set @rvi_ivari = isnull(@rvi_ivari,0)
  set @rv_descivari = (@rvi_ivari * @rv_desc1/100) 
  set @rv_descivari = @rv_descivari + ((@rvi_ivari - @rv_descivari) * @rv_desc2/100)
  set @rv_total     = @rv_total + @rv_importedesc1 + @rv_importedesc2 + @rv_descivari

  select @importe = sum(rvi_importe)
            from RemitoVentaItem
            where rv_id = @@rv_id

  set @importe = isnull(@importe,0)

  if round(@importe,2) <> round(@rv_total,2)  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de este remito no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rv_id
                                )

  end

  select @rvi_ivari = sum(rvi_ivari)
            from RemitoVentaItem
            where rv_id = @@rv_id
            group by rv_id

  set @rvi_ivari = isnull(@rvi_ivari,0)
  set @rvi_ivari = @rvi_ivari - (@rvi_ivari * @rv_desc1/100) 
  set @rvi_ivari = @rvi_ivari - (@rvi_ivari * @rv_desc2/100)

  if round(@rvi_ivari,2) <> round(@rv_ivari,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El IVA de este remito no coincide con la suma de los IVA de sus items '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@rv_id
                                )

  end


ControlError:

end
GO