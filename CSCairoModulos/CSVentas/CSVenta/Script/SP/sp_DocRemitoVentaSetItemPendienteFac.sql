if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSetItemPendienteFac]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSetItemPendienteFac]

/*

  exec  sp_DocRemitoVentaSetItemPendienteFac 23

*/

go
create procedure sp_DocRemitoVentaSetItemPendienteFac (
  @@rv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @rvi_id        int

  begin transaction

  declare @aplicadofactura   decimal(18,6)
  
  declare c_RviPendiente insensitive cursor for 

        select rvi_id
        from 
              RemitoVentaItem 

        where rv_id = @@rv_id

  open c_RviPendiente 
  
  fetch next from c_RviPendiente into @rvi_id
  while @@fetch_status = 0 
  begin

    select @aplicadofactura = isnull(sum(rvfv_cantidad),0)
    from 
          RemitoFacturaVenta
    where rvi_id = @rvi_id

    update RemitoVentaItem set rvi_pendientefac = rvi_cantidadaremitir - IsNull(@aplicadofactura ,0)
          where rvi_id = @rvi_id
  
    if @@error <> 0 goto ControlError

    fetch next from c_RviPendiente into @rvi_id
  end

  close c_RviPendiente 
  deallocate c_RviPendiente 

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el pendiente del remito de venta. sp_DocRemitoVentaSetItemPendienteFac.', 16, 1)
  rollback transaction  

end 

go