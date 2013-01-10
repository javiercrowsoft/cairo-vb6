-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocOC]

go

create procedure sp_AuditoriaTotalesValidateDocOC (

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
  declare @oc_neto          decimal(18,6)
  declare @oc_ivari         decimal(18,6)
  declare @oc_importedesc1  decimal(18,6)
  declare @oc_importedesc2  decimal(18,6)
  declare @oc_desc1          decimal(18,6)
  declare @oc_desc2          decimal(18,6)

  select 
            @doct_id        = doct_id,
            @oc_nrodoc    = oc_nrodoc,
            @oc_numero    = convert(varchar,oc_numero),
            @est_id        = est_id,
            @oc_pendiente  = oc_pendiente,
            @oc_total      = oc_total,
            @oc_neto      = oc_neto,
            @oc_ivari      = oc_ivari,

            @oc_desc1          = oc_descuento1,
            @oc_desc2          = oc_descuento2,

            @oc_importedesc1  = oc_importedesc1,
            @oc_importedesc2  = oc_importedesc2

  from OrdenCompra where oc_id = @@oc_id

  if exists(select oc_id 
            from OrdenCompraItem
             where round(oci_neto,2) <> round(oci_precio * oci_cantidad,2)
              and oc_id = @@oc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta orden posee items cuyo neto no coincide con el precio por la cantidad '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

  end

  if exists(select oc_id 
            from OrdenCompraItem
             where round(oci_neto * (oci_ivariporc / 100),2) <> round(oci_ivari,2)
              and oc_id = @@oc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Esta orden posee items cuyo iva no coincide con el neto por el porcentaje de la tasa '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

  end

  declare @oci_neto decimal(18,6)

  select @oci_neto = sum(oci_neto)
  from OrdenCompraItem
  where oc_id = @@oc_id
  group by oc_id

  set @oci_neto = IsNull(@oci_neto,0) - (@oci_neto * @oc_desc1/100) 
  set @oci_neto = IsNull(@oci_neto,0) - (@oci_neto * @oc_desc2/100)

  if round(@oci_neto,2) <> round(@oc_neto,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El neto de esta orden no coincide con la suma de los netos de sus items '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

  end

  declare @importe         decimal(18,6)

  select @importe = sum(oci_importe) from OrdenCompraItem where oc_id = @@oc_id group by oc_id

  set @importe = isnull(@importe,0)

  declare @oc_descivari decimal(18,6)
  declare @oci_ivari     decimal(18,6)

  select @oci_ivari = sum(oci_ivari)
            from OrdenCompraItem
            where oc_id = @@oc_id
            group by oc_id

  set @oci_ivari     = isnull(@oci_ivari,0)
  set @oc_descivari = (@oci_ivari * @oc_desc1/100) 
  set @oc_descivari = @oc_descivari + ((@oci_ivari - @oc_descivari) * @oc_desc2/100)
  set @oc_total     = @oc_total + @oc_importedesc1 + @oc_importedesc2 + @oc_descivari

  if round(@importe,2) <> round(@oc_total,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de esta orden no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

  end

  select @oci_ivari = sum(oci_ivari)
            from OrdenCompraItem
            where oc_id = @@oc_id
            group by oc_id

  set @oci_ivari = isnull(@oci_ivari,0)
  set @oci_ivari = @oci_ivari - (@oci_ivari * @oc_desc1/100) 
  set @oci_ivari = @oci_ivari - (@oci_ivari * @oc_desc2/100)

  if round(@oci_ivari,2) <> round(@oc_ivari,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El IVA de esta orden no coincide con la suma de los IVA de sus items '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@oc_id
                                )

  end

ControlError:

end
GO