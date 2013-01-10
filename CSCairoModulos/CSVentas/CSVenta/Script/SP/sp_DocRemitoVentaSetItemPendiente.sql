if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSetItemPendiente]

/*

  exec  sp_DocRemitoVentaSetItemPendiente 24,0

*/

go
create procedure sp_DocRemitoVentaSetItemPendiente (
  @@rv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @rvi_id         int
  declare @doct_id         int
  declare @est_id          int
  declare @rv_desde_os    tinyint 
  declare @pr_esrepuesto  tinyint

  select  @doct_id       = rv.doct_id, 
          @est_id        = est_id,
          @rv_desde_os  = doc_rv_desde_os

  from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
  where rv_id = @@rv_id

  begin transaction

  if @est_id <> 7 begin
  
    if @rv_desde_os <> 0 begin

      update RemitoVentaItem set rvi_pendiente = 0 
      from Producto pr 
      where rv_id = @@rv_id
        and RemitoVentaItem.pr_id = pr.pr_id
        and pr_esrepuesto <> 0
      if @@error <> 0 goto ControlError

    end

    declare @aplicadoPedido   decimal(18,6)
    declare @aplicadoRemito   decimal(18,6)
    
    declare c_RviPendiente insensitive cursor for 
  
          select rvi_id, pr_esrepuesto
          from 
                RemitoVentaItem rvi inner join Producto pr on rvi.pr_id = pr.pr_id
  
          where rv_id = @@rv_id
  
    open c_RviPendiente 
    
    fetch next from c_RviPendiente into @rvi_id, @pr_esrepuesto
    while @@fetch_status = 0 
    begin

      if (@pr_esrepuesto = 0 or @rv_desde_os = 0) begin
  
        select @aplicadoPedido = isnull(sum(pvrv_cantidad),0) from PedidoRemitoVenta  where rvi_id = @rvi_id
        select @aplicadoPedido = isnull(@aplicadoPedido,0) 
                                +isnull(sum(osrv_cantidad),0) from OrdenRemitoVenta where rvi_id = @rvi_id
      end

      select @aplicadoRemito = isnull(sum(rvfv_cantidad),0)  from RemitoFacturaVenta  where rvi_id = @rvi_id
  
      if @doct_id = 3 begin
  
        select @aplicadoRemito = isnull(@aplicadoRemito,0)
                               + isnull(sum(rvdv_cantidad),0) from RemitoDevolucionVenta where rvi_id_remito = @rvi_id
      end else begin
  
        select @aplicadoRemito = isnull(@aplicadoRemito,0)
                               + isnull(sum(rvdv_cantidad),0) from RemitoDevolucionVenta where rvi_id_devolucion = @rvi_id
      end

      set @aplicadoPedido = isnull(@aplicadoPedido,0)
      set @aplicadoRemito = isnull(@aplicadoRemito,0)
  
      if (@pr_esrepuesto = 0 or @rv_desde_os = 0) begin

        update RemitoVentaItem set rvi_pendiente     = rvi_cantidad - @aplicadoPedido, 
                                   rvi_pendientefac = rvi_cantidadaremitir  - @aplicadoRemito
    
              where rvi_id = @rvi_id
  
      end else begin

        update RemitoVentaItem set rvi_pendientefac = rvi_cantidadaremitir  - @aplicadoRemito
    
              where rvi_id = @rvi_id
      end
  
      if @@error <> 0 goto ControlError
  
      fetch next from c_RviPendiente into @rvi_id, @pr_esrepuesto
    end
  
    close c_RviPendiente 
    deallocate c_RviPendiente 

  end else begin

    update RemitoVentaItem set rvi_pendiente     = 0,
                               rvi_pendientefac  = 0 
    where rv_id = @@rv_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del remito de venta. sp_DocRemitoVentaSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go