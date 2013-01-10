if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraSetItemPendiente]

/*

  select * from documentotipo

  exec  sp_DocPedidoCompraSetItemPendiente 23

*/

go
create procedure sp_DocPedidoCompraSetItemPendiente (
  @@pc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @pci_id     int
  declare @doct_id     int
  declare @est_id     int

  select @doct_id = doct_id, @est_id = est_id 
  from PedidoCompra where pc_id = @@pc_id

  begin transaction

  if @est_id <> 7 begin

    declare @aplicadoOrden         decimal(18,6)
    declare @aplicadoCotizacion   decimal(18,6)
    declare @aplicadoPedido       decimal(18,6)
    
    declare c_pciPendiente insensitive cursor for 
  
          select pci_id
          from 
                PedidoCompraItem 
  
          where pc_id = @@pc_id
  
    open c_pciPendiente 
    
    fetch next from c_pciPendiente into @pci_id
    while @@fetch_status = 0 
    begin
  
      if @doct_id = 6 begin
  
        select @aplicadoCotizacion = isnull(sum(pccot_cantidad),0)
        from 
              PedidoCotizacionCompra
        where pci_id = @pci_id
    
        select @aplicadoOrden = isnull(sum(pcoc_cantidad),0)
        from 
              PedidoOrdenCompra
        where pci_id = @pci_id
  
        select @aplicadoPedido = @aplicadoPedido + isnull(sum(pcdc_cantidad),0)
        from 
              PedidoDevolucionCompra
        where pci_id_pedido = @pci_id
  
      end else begin
  
        set @aplicadoOrden  = 0
        set @aplicadoCotizacion   = 0
  
        select @aplicadoPedido = @aplicadoPedido + isnull(sum(pcdc_cantidad),0)
        from 
              PedidoDevolucionCompra
        where pci_id_devolucion = @pci_id
      end
  
      set @aplicadoOrden = IsNull(@aplicadoOrden,0)
      set @aplicadoCotizacion  = IsNull(@aplicadoCotizacion,0)
      set @aplicadoPedido  = IsNull(@aplicadoPedido,0)
  
      update PedidoCompraItem set pci_pendiente         = pci_cantidadaremitir 
                                                         - @aplicadoOrden 
                                                         - @aplicadoCotizacion 
                                                         - @aplicadoPedido
            where pci_id = @pci_id
    
      if @@error <> 0 goto ControlError
  
      fetch next from c_pciPendiente into @pci_id
    end
  
    close c_pciPendiente 
    deallocate c_pciPendiente 

  end else begin

    update PedidoCompraItem set pci_pendiente = 0 where pc_id = @@pc_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del pedido de compra. sp_DocPedidoCompraSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go