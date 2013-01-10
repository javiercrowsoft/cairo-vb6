if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSetItemPendiente]

/*

  exec  sp_DocFacturaVentaSetItemPendiente 38

*/

go
create procedure sp_DocFacturaVentaSetItemPendiente (
  @@fv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  begin transaction

  declare @fvi_id           int
  declare @aplicadopedido   decimal(18,6)
  declare @aplicadoremito   decimal(18,6)
  declare @aplicadopacking   decimal(18,6)
  declare @est_id           int

  select @est_id = est_id from FacturaVenta where fv_id = @@fv_id

  if @est_id <> 7  begin

    declare c_fviitems insensitive cursor for select fvi_id from FacturaVentaItem where fv_id = @@fv_id
  
    open c_fviitems
    fetch next from c_fviitems into @fvi_id
    while @@fetch_status = 0 begin
    
      select @aplicadopedido = isnull(sum(pvfv_cantidad),0)
      from 
            PedidoFacturaVenta
      where fvi_id = @fvi_id
  
      select @aplicadoremito = isnull(sum(rvfv_cantidad),0)
      from 
            RemitoFacturaVenta
      where fvi_id = @fvi_id
  
      select @aplicadopacking = isnull(sum(pklstfv_cantidad),0) 
      from 
            PackingListFacturaVenta 
      where fvi_id = @fvi_id
  
  
      set @aplicadopedido   = isnull(@aplicadopedido,0)
      set @aplicadoremito   = isnull(@aplicadoremito,0)
      set @aplicadopacking   = isnull(@aplicadopacking,0)
  
      update FacturaVentaItem set fvi_pendiente         = fvi_cantidadaremitir 
                                                            - @aplicadopedido 
                                                            - @aplicadoremito,
  
                                  fvi_pendientepklst    = fvi_cantidadaremitir 
                                                            - @aplicadopacking  
            where fvi_id = @fvi_id
    
      if @@error <> 0 goto ControlError
  
      fetch next from c_fviitems into @fvi_id
    end
    close c_fviitems
    deallocate c_fviitems

  end else begin

    update FacturaVentaItem set fvi_pendiente       = 0,
                                fvi_pendientepklst  = 0
    where fv_id = @@fv_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la factura de venta. sp_DocFacturaVentaSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go