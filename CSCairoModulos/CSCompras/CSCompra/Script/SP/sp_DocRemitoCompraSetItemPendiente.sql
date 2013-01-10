if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraSetItemPendiente]

/*

  exec  sp_DocRemitoCompraSetItemPendiente 38

*/

go
create procedure sp_DocRemitoCompraSetItemPendiente (
  @@rc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @rci_id     int
  declare @doct_id     int
  declare @est_id     int

  select @doct_id = doct_id, @est_id = est_id 
  from RemitoCompra where rc_id = @@rc_id

  begin transaction

  if @est_id <> 7 begin

    declare @aplicadoOrden    decimal(18,6)
    declare @aplicadoRemito   decimal(18,6)
    
    declare c_RciPendiente insensitive cursor for 
  
          select rci_id
          from 
                RemitoCompraItem 
  
          where rc_id = @@rc_id
  
    open c_RciPendiente 
    
    fetch next from c_RciPendiente into @rci_id
    while @@fetch_status = 0 
    begin
  
      select @aplicadoOrden = isnull(sum(ocrc_cantidad),0) from OrdenRemitoCompra   where rci_id = @rci_id
      select @aplicadoRemito = isnull(sum(rcfc_cantidad),0)  from RemitoFacturaCompra  where rci_id = @rci_id
  
      if @doct_id = 4 begin
  
        select @aplicadoRemito =  isnull(@aplicadoRemito ,0)
                                + isnull(sum(rcdc_cantidad),0) from RemitoDevolucionCompra where rci_id_remito = @rci_id
      end else begin
  
        select @aplicadoRemito =  isnull(@aplicadoRemito ,0)
                                + isnull(sum(rcdc_cantidad),0) from RemitoDevolucionCompra where rci_id_devolucion = @rci_id
      end
  
      set @aplicadoOrden  = isnull(@aplicadoOrden,0)
      set @aplicadoRemito = isnull(@aplicadoRemito,0)
    
      update RemitoCompraItem set rci_pendiente     = rci_cantidad - @aplicadoOrden, 
                                  rci_pendientefac   = rci_cantidadaremitir  - @aplicadoRemito
  
            where rci_id = @rci_id
    
      if @@error <> 0 goto ControlError
  
      fetch next from c_RciPendiente into @rci_id
    end
  
    close c_RciPendiente 
    deallocate c_RciPendiente 

  end else begin

    update RemitoCompraItem set rci_pendiente     = 0,
                                rci_pendientefac  = 0 
    where rc_id = @@rc_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del remito de compra. sp_DocRemitoCompraSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go