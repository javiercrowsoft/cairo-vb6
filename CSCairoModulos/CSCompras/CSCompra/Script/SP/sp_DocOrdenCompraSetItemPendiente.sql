if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraSetItemPendiente]

/*

  select * from PedidoOrdenCompra

  exec  sp_DocOrdenCompraSetItemPendiente 10

*/

go
create procedure sp_DocOrdenCompraSetItemPendiente (
  @@oc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @oci_id     int
  declare @doct_id     int
  declare @est_id     int

  select @doct_id = doct_id, @est_id = est_id 
  from OrdenCompra where oc_id = @@oc_id

  begin transaction

  if @est_id <> 7 begin

    declare @aplicadoPedido   decimal(18,6)
    declare @aplicadoFactura   decimal(18,6)
    declare @aplicadoRemito   decimal(18,6)
    declare @aplicadoOrden    decimal(18,6)
    
    declare c_ociPendiente insensitive cursor for 
  
          select oci_id
          from 
                OrdenCompraItem 
  
          where oc_id = @@oc_id
  
    open c_ociPendiente 
    
    fetch next from c_ociPendiente into @oci_id
    while @@fetch_status = 0 
    begin
  
      if @doct_id = 35 begin
  
        select @aplicadoPedido = isnull(sum(pcoc_cantidad),0) 
        from 
              PedidoOrdenCompra   
        where oci_id = @oci_id
  
        select @aplicadoRemito = isnull(sum(ocrc_cantidad),0)
        from 
              OrdenRemitoCompra
        where oci_id = @oci_id
    
        select @aplicadoFactura = isnull(sum(ocfc_cantidad),0)
        from 
              OrdenFacturaCompra
        where oci_id = @oci_id
  
        select @aplicadoOrden = @aplicadoOrden + isnull(sum(ocdc_cantidad),0)
        from 
              OrdenDevolucionCompra
        where oci_id_Orden = @oci_id
  
      end else begin
  
        set @aplicadoPedido   = 0
        set @aplicadoFactura  = 0
        set @aplicadoRemito   = 0
  
        select @aplicadoOrden = @aplicadoOrden + isnull(sum(ocdc_cantidad),0)
        from 
              OrdenDevolucionCompra
        where oci_id_devolucion = @oci_id
      end
  
      set @aplicadoPedido  = IsNull(@aplicadoPedido,0)
      set @aplicadoFactura = IsNull(@aplicadoFactura,0)
      set @aplicadoRemito  = IsNull(@aplicadoRemito,0)
      set @aplicadoOrden   = IsNull(@aplicadoOrden,0)
  
      update OrdenCompraItem set oci_pendientefac = oci_cantidadaremitir 
                                                     - @aplicadoFactura 
                                                     - @aplicadoRemito 
                                                     - @aplicadoOrden,
                                 oci_pendiente    = oci_cantidad - @aplicadoPedido
            where oci_id = @oci_id
  
      if @@error <> 0 goto ControlError
  
      fetch next from c_ociPendiente into @oci_id
    end
  
    close c_ociPendiente 
    deallocate c_ociPendiente 

  end else begin

    update OrdenCompraItem set oci_pendiente     = 0,
                               oci_pendientefac  = 0 
    where oc_id = @@oc_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la Orden de compra. sp_DocOrdenCompraSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go