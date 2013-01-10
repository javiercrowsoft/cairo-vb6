-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocPC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocPC]

go

create procedure sp_AuditoriaTotalesValidateDocPC (

  @@pc_id     int,
  @@aud_id     int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @pc_nrodoc         varchar(50) 
  declare @pc_numero         varchar(50) 
  declare @est_id           int
  declare @pc_pendiente      decimal(18,6)
  declare @pc_total          decimal(18,6)
  declare @pc_neto          decimal(18,6)
  declare @pc_ivari         decimal(18,6)

  select 
            @doct_id        = doct_id,
            @pc_nrodoc    = pc_nrodoc,
            @pc_numero    = convert(varchar,pc_numero),
            @est_id        = est_id,
            @pc_pendiente  = pc_pendiente,
            @pc_total      = pc_total,
            @pc_neto      = pc_neto,
            @pc_ivari      = pc_ivari

  from PedidoCompra where pc_id = @@pc_id

  if exists(select pc_id 
            from PedidoCompraItem
             where round(pci_neto,2) <> round(pci_precio * pci_cantidad,2)
              and pc_id = @@pc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este pedido posee items cuyo neto no coincide con el precio por la cantidad '
                                 + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pc_id
                                )

  end

  if exists(select pc_id 
            from PedidoCompraItem
             where round(pci_neto * (pci_ivariporc / 100),2) <> round(pci_ivari,2)
              and pc_id = @@pc_id
            ) begin


      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este pedido posee items cuyo iva no coincide con el neto por el porcentaje de la tasa '
                                 + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pc_id
                                )

  end

  declare @pci_neto decimal(18,6)

  select @pci_neto = sum(pci_neto)
  from PedidoCompraItem
  where pc_id = @@pc_id
  group by pc_id

  set @pci_neto = IsNull(@pci_neto,0)

  if round(@pci_neto,2) <> round(@pc_neto,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El neto de este pedido no coincide con la suma de los netos de sus items '
                                 + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pc_id
                                )

  end

  declare @importe         decimal(18,6)

  select @importe = sum(pci_importe) from PedidoCompraItem where pc_id = @@pc_id group by pc_id

  set @importe = isnull(@importe,0)

  if round(@importe,2) <> round(@pc_total,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El total de este pedido no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pc_id
                                )

  end

  declare @pci_ivari     decimal(18,6)

  select @pci_ivari = sum(pci_ivari)
            from PedidoCompraItem
            where pc_id = @@pc_id
            group by pc_id

  set @pci_ivari = isnull(@pci_ivari,0)

  if round(@pci_ivari,2) <> round(@pc_ivari,2) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El IVA de este pedido no coincide con la suma de los IVA de sus items '
                                 + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                 3,
                                 4,
                                 @doct_id,
                                 @@pc_id
                                )

  end

ControlError:

end
GO