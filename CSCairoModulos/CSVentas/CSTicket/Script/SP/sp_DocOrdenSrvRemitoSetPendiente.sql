if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenSrvRemitoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenSrvRemitoSetPendiente]

/*

 sp_DocOrdenSrvRemitoSetPendiente 124

*/

GO
create procedure sp_DocOrdenSrvRemitoSetPendiente (
  @@os_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de los Remitos
  --
  declare @rv_id int

  declare c_OrdenPendiente insensitive cursor for 
    select distinct rv_id 
    from OrdenRemitoVenta osrv   inner join OrdenServicioItem osi   on osrv.osi_id = osi.osi_id
                                inner join RemitoVentaItem rvi     on osrv.rvi_id = rvi.rvi_id
    where os_id = @@os_id
  union
    select rv_id from #OrdenServicioRemito
  
  open c_OrdenPendiente
  fetch next from c_OrdenPendiente into @rv_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda del remito
    exec sp_DocRemitoVentaSetItemPendiente @rv_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --
      
      -- ESTADO
        exec sp_AuditoriaEstadoCheckDocRV    @rv_id,
                                            @@bSuccess  out,
                                            @MsgError out
      
        -- Si el documento no es valido
        if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_OrdenPendiente into @rv_id
  end
  close c_OrdenPendiente
  deallocate c_OrdenPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente de la orden de servicio. sp_DocOrdenSrvRemitoSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO