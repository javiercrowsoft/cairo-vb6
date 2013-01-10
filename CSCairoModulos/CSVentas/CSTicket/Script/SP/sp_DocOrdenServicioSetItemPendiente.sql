if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSetItemPendiente]

/*

  exec  sp_DocOrdenServicioSetItemPendiente 38

*/

go
create procedure sp_DocOrdenServicioSetItemPendiente (
  @@os_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @osi_id     int
  declare @doct_id     int
  declare @est_id     int

  select @doct_id = doct_id, @est_id = est_id 
  from OrdenServicio where os_id = @@os_id

  begin transaction

  if @est_id <> 7 begin

    declare @aplicado   decimal(18,6)
    
    declare c_OsiPendiente insensitive cursor for 
  
          select osi_id
          from 
                OrdenServicioItem 
  
          where os_id = @@os_id
  
    open c_OsiPendiente 
    
    fetch next from c_OsiPendiente into @osi_id
    while @@fetch_status = 0 
    begin
  
      select @aplicado = isnull(sum(osrv_cantidad),0)  from OrdenRemitoVenta  where osi_id = @osi_id
  
      set @aplicado = isnull(@aplicado,0)
    
      update OrdenServicioItem set osi_pendiente = osi_cantidadaremitir  - @aplicado
  
            where osi_id = @osi_id
    
      if @@error <> 0 goto ControlError
  
      fetch next from c_OsiPendiente into @osi_id
    end
  
    close c_OsiPendiente 
    deallocate c_OsiPendiente 

  end else begin

    update OrdenServicioItem set osi_pendiente = 0 
    where os_id = @@os_id
    if @@error <> 0 goto ControlError

  end

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente de la orden de servicio. sp_DocOrdenServicioSetItemPendiente.', 16, 1)
  rollback transaction  

end 

go