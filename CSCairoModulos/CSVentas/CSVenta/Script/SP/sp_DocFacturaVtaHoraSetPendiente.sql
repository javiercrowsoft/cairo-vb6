if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVtaHoraSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVtaHoraSetPendiente]

/*

 sp_DocFacturaVtaHoraSetPendiente 124

*/

GO
create procedure sp_DocFacturaVtaHoraSetPendiente (
  @@fv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las horas
  --
  declare @hora_id int

  declare c_horaPendiente insensitive cursor for 
    select distinct horafv.hora_id 
    from HoraFacturaVenta horafv inner join FacturaVentaItem fvi on horafv.fvi_id  = fvi.fvi_id
                                 inner join Hora hora            on horafv.hora_id = hora.hora_id
    where fv_id = @@fv_id
  union
    select hora_id from #HoraFac
  
  open c_horaPendiente
  fetch next from c_horaPendiente into @hora_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la factura
    exec sp_horaSetPendiente @hora_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

-- TODO: VALIDACION

    fetch next from c_horaPendiente into @hora_id
  end
  close c_horaPendiente
  deallocate c_horaPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente de la hora. sp_DocFacturaVtaHoraSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO