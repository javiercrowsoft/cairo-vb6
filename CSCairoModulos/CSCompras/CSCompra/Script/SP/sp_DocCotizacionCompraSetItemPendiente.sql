if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCotizacionCompraSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCotizacionCompraSetItemPendiente]

/*

  select * from PedidoCotizacionCompra

  exec  sp_DocCotizacionCompraSetItemPendiente 10

*/

go
create procedure sp_DocCotizacionCompraSetItemPendiente (
  @@cot_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @coti_id    int
  declare @doct_id     int
  declare @est_id     int

  select @doct_id = doct_id, @est_id = est_id 
  from CotizacionCompra where cot_id = @@cot_id

  begin transaction

  if @est_id <> 7 begin

    declare @aplicadoPedido   decimal(18,6)
    declare @aplicadoOrden    decimal(18,6)
    
    declare c_cotiPendiente insensitive cursor for 
  
          select coti_id
          from 
                CotizacionCompraItem 
  
          where cot_id = @@cot_id
  
    open c_cotiPendiente 
    
    fetch next from c_cotiPendiente into @coti_id
    while @@fetch_status = 0 
    begin
  
      if @doct_id = 35 begin
  
        select @aplicadoPedido = isnull(sum(pccot_cantidad),0) 
        from 
              PedidoCotizacionCompra   
        where coti_id = @coti_id
  
        select @aplicadoOrden = @aplicadoOrden + isnull(sum(cotoc_cantidad),0)
        from 
              CotizacionOrdenCompra
        where coti_id = @coti_id
  
      end else begin
  
        set @aplicadoPedido   = 0
  
        select @aplicadoOrden = @aplicadoOrden + isnull(sum(cotoc_cantidad),0)
        from 
              CotizacionOrdenCompra
        where coti_id = @coti_id
      end
  
      set @aplicadoPedido = IsNull(@aplicadoPedido,0)
      set @aplicadoOrden  = IsNull(@aplicadoOrden,0)
  
      update CotizacionCompraItem set coti_pendienteoc =  coti_cantidad
                                                         - @aplicadoOrden,
                                       coti_pendiente   = coti_cantidad 
                                                        - @aplicadoPedido
            where coti_id = @coti_id
  
      if @@error <> 0 goto ControlError
  
      fetch next from c_cotiPendiente into @coti_id
    end
  
    close c_cotiPendiente 
    deallocate c_cotiPendiente 

  end else begin

    update CotizacionCompraItem set coti_pendiente     = 0,
                                    coti_pendienteoc  = 0 
    where cot_id = @@cot_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la Cotizacion. sp_DocCotizacionCompraSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go