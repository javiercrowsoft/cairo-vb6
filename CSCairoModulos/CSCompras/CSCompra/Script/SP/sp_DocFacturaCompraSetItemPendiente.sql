if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraSetItemPendiente]

/*

  exec  sp_DocFacturaCompraSetItemPendiente 38

*/

go
create procedure sp_DocFacturaCompraSetItemPendiente (
  @@fc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  begin transaction

  declare @fci_id           int
  declare @aplicadoorden     decimal(18,6)
  declare @aplicadoremito   decimal(18,6)
  declare @est_id           int

  select @est_id = est_id from FacturaCompra where fc_id = @@fc_id

  if @est_id <> 7  begin

    declare c_fciitems insensitive cursor for select fci_id from FacturaCompraItem where fc_id = @@fc_id
  
    open c_fciitems
    fetch next from c_fciitems into @fci_id
    while @@fetch_status = 0 begin
    
      select @aplicadoorden = isnull(sum(ocfc_cantidad),0)
      from 
            OrdenFacturaCompra
      where fci_id = @fci_id
  
      select @aplicadoremito = isnull(sum(rcfc_cantidad),0)
      from 
            RemitoFacturaCompra
      where fci_id = @fci_id
  
  
      set @aplicadoorden   = isnull(@aplicadoorden,0)
      set @aplicadoremito   = isnull(@aplicadoremito,0)
  
      update FacturaCompraItem set fci_pendiente         = fci_cantidadaremitir 
                                                            - @aplicadoorden 
                                                            - @aplicadoremito
            where fci_id = @fci_id
    
      if @@error <> 0 goto ControlError
  
      fetch next from c_fciitems into @fci_id
    end
    close c_fciitems
    deallocate c_fciitems

  end else begin

    update FacturaCompraItem set fci_pendiente = 0 where fc_id = @@fc_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la factura de compra. sp_DocFacturaCompraSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go