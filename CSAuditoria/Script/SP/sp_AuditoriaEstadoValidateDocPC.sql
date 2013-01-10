-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocPC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocPC]

go

create procedure sp_AuditoriaEstadoValidateDocPC (

  @@pc_id       int,
  @@aud_id       int

)
as

begin

  set nocount on

  declare @audi_id       int
  declare @doct_id      int
  declare @pc_nrodoc     varchar(50) 
  declare @pc_numero     varchar(50) 
  declare @est_id       int

  select 
            @doct_id     = doct_id,
            @pc_nrodoc  = pc_nrodoc,
            @pc_numero  = convert(varchar,pc_numero),
            @est_id     = est_id

  from PedidoCompra where pc_id = @@pc_id

  if exists(select * from PedidoCompraItem pci
            where (pci_pendiente +  (    IsNull(
                                          (select sum(pcoc_cantidad) from PedidoOrdenCompra 
                                           where pci_id = pci.pci_id),0)
                                      +  IsNull(
                                          (select sum(pcdc_cantidad) from PedidoDevolucionCompra 
                                           where 
                                                 (pci_id_pedido      = pci.pci_id and @doct_id = 6)
                                              or (pci_id_devolucion  = pci.pci_id and @doct_id = 23)
                                          ),0)
                                      + IsNull(
                                          (select sum(pccot_cantidad) from PedidoCotizacionCompra 
                                           where pci_id = pci.pci_id),0)
                                    ) 
                  ) <> pci_cantidadaremitir

              and pc_id = @@pc_id
            )
  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este pedido no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                 3,
                                 3,
                                 @doct_id,
                                 @@pc_id
                                )
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @pc_pendiente  decimal(18,6)

    select 
            @pc_pendiente    = sum(pci_pendiente)

    from PedidoCompraItem where pc_id = @@pc_id

    if @pc_pendiente = 0 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El pedido no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
                                   + '(comp.:' + @pc_nrodoc + ' nro.: '+ @pc_numero + ')',
                                   3,
                                   3,
                                   @doct_id,
                                   @@pc_id
                                  )
    end

  end

ControlError:

end
GO