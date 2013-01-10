if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVtaDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVtaDevolucionSetPendiente]

/*

 sp_DocPedidoVtaDevolucionSetPendiente 124

*/

GO
create procedure sp_DocPedidoVtaDevolucionSetPendiente (
  @@pv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las Facturas
  --
  declare @pv_id int
  declare @doct_id int

  select @doct_id = doct_id from PedidoVenta where pv_id = @@pv_id

  if @doct_id = 5 begin

    declare c_PedidoPendiente insensitive cursor for 
      select distinct pvi.pv_id 
      from PedidoDevolucionVenta pvdv   inner join PedidoVentaItem pvi    on pvdv.pvi_id_devolucion = pvi.pvi_id
                                        inner join PedidoVentaItem pvir  on pvdv.pvi_id_pedido = pvir.pvi_id
      where pvir.pv_id = @@pv_id
    union
      select pv_id from #PedidoDevolucionVenta

  end else begin

    declare c_PedidoPendiente insensitive cursor for 
      select distinct pvi.pv_id 
      from PedidoDevolucionVenta pvdv   inner join PedidoVentaItem pvi    on pvdv.pvi_id_pedido = pvi.pvi_id
                                        inner join PedidoVentaItem pvid  on pvdv.pvi_id_devolucion = pvid.pvi_id
      where pvid.pv_id = @@pv_id
    union
      select pv_id from #PedidoDevolucionVenta
  end
                      
  open c_PedidoPendiente
  fetch next from c_PedidoPendiente into @pv_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la Pedido
    exec sp_DocPedidoVentaSetPendiente @pv_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    exec sp_DocPedidoVentaSetCredito @pv_id
    if @@error <> 0 goto ControlError

    -- Estado
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

      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocPV  @pv_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_PedidoPendiente into @pv_id
  end
  close c_PedidoPendiente
  deallocate c_PedidoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del Pedido de venta. sp_DocPedidoVtaDevolucionSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO