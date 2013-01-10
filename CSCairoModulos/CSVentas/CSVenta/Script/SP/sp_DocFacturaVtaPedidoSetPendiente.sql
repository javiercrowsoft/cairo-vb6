if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVtaPedidoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVtaPedidoSetPendiente]

/*

 sp_DocFacturaVtaPedidoSetPendiente 91

*/

GO
create procedure sp_DocFacturaVtaPedidoSetPendiente (
  @@fv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de los pedidos
  --
  declare @pv_id int

  declare c_pedidoPendiente insensitive cursor for 
    select distinct pv_id 
    from PedidoFacturaVenta pvfv inner join FacturaVentaItem fvi on pvfv.fvi_id = fvi.fvi_id
                                inner join PedidoVentaItem pvi on pvfv.pvi_id = pvi.pvi_id
    where fv_id = @@fv_id
  union
    select pv_id from #PedidoVentaFac
  
  open c_pedidoPendiente
  fetch next from c_pedidoPendiente into @pv_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la factura
    exec sp_DocPedidoVentaSetPendiente @pv_id, @@bSuccess out

    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    -- Estado
    exec sp_DocPedidoVentaSetCredito @pv_id
    if @@error <> 0 goto ControlError

    exec sp_DocPedidoVentaSetEstado @pv_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --
      
      -- ESTADO
        exec sp_AuditoriaEstadoCheckDocPV    @pv_id,
                                            @@bSuccess  out,
                                            @MsgError out
      
        -- Si el documento no es valido
        if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_pedidoPendiente into @pv_id
  end
  close c_pedidoPendiente
  deallocate c_pedidoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocFacturaVtaPedidoSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO