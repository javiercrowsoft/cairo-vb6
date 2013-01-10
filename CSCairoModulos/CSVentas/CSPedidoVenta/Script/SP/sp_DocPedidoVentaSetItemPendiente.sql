if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSetItemPendiente]

/*

  select * from pedidoventa

  exec  sp_DocPedidoVentaSetItemPendiente 23

*/

go
create procedure sp_DocPedidoVentaSetItemPendiente (
  @@pv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @pvi_id     int
  declare @doct_id     int
  declare @est_id     int

  select @doct_id = doct_id, @est_id = est_id 
  from PedidoVenta where pv_id = @@pv_id

  begin transaction

  if @est_id <> 7 begin

    declare @aplicadoPresupuesto  decimal(18,6)
    declare @aplicadoPacking       decimal(18,6)
    declare @aplicadoFactura       decimal(18,6)
    declare @aplicadoRemito       decimal(18,6)
    declare @aplicadoPedido       decimal(18,6)
    
    declare c_PviPendiente insensitive cursor for 
  
          select pvi_id
          from 
                PedidoVentaItem 
  
          where pv_id = @@pv_id
  
    open c_PviPendiente 
    
    fetch next from c_PviPendiente into @pvi_id
    while @@fetch_status = 0 
    begin
  
      if @doct_id = 5 begin
  
        select @aplicadoPresupuesto = isnull(sum(prvpv_cantidad),0)
        from 
              PresupuestoPedidoVenta
        where pvi_id = @pvi_id

        select @aplicadoRemito = isnull(sum(pvrv_cantidad),0)
        from 
              PedidoRemitoVenta
        where pvi_id = @pvi_id
    
        select @aplicadoFactura = isnull(sum(pvfv_cantidad),0)
        from 
              PedidoFacturaVenta
        where pvi_id = @pvi_id
  
        select @aplicadoPedido = @aplicadoPedido + isnull(sum(pvdv_cantidad),0)
        from 
              PedidoDevolucionVenta
        where pvi_id_pedido = @pvi_id
  
        select @aplicadoPacking = isnull(sum(pvpklst_cantidad),0)
        from 
              PedidoPackingList
        where pvi_id = @pvi_id
  
      end else begin
  
        set @aplicadoPresupuesto   = 0
        set @aplicadoFactura      = 0
        set @aplicadoRemito       = 0
        set @aplicadoPacking      = 0
  
        select @aplicadoPedido = @aplicadoPedido + isnull(sum(pvdv_cantidad),0)
        from 
              PedidoDevolucionVenta
        where pvi_id_devolucion = @pvi_id
      end
  
      set @aplicadoPresupuesto   = IsNull(@aplicadoPresupuesto,0)
      set @aplicadoFactura       = IsNull(@aplicadoFactura,0)
      set @aplicadoRemito        = IsNull(@aplicadoRemito,0)
      set @aplicadoPedido        = IsNull(@aplicadoPedido,0)
      set @aplicadoPacking       = IsNull(@aplicadoPacking,0)
  
      update PedidoVentaItem set pvi_pendiente         = pvi_cantidadaremitir 
                                                         - @aplicadoFactura 
                                                         - @aplicadoRemito 
                                                         - @aplicadoPedido,
  
                                 pvi_pendientepklst    = pvi_cantidad - @aplicadoPacking,

                                 pvi_pendienteprv      = pvi_cantidad - @aplicadoPresupuesto

            where pvi_id = @pvi_id
    
      if @@error <> 0 goto ControlError
  
      fetch next from c_PviPendiente into @pvi_id
    end
  
    close c_PviPendiente 
    deallocate c_PviPendiente 

  end else begin

    update PedidoVentaItem set pvi_pendiente       = 0,
                               pvi_pendientepklst  = 0,
                               pvi_pendienteprv   = 0 
    where pv_id = @@pv_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPedidoVentaSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go