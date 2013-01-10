if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVtaDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVtaDevolucionSetPendiente]

/*

 sp_DocPresupuestoVtaDevolucionSetPendiente 124

*/

GO
create procedure sp_DocPresupuestoVtaDevolucionSetPendiente (
  @@prv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las Facturas
  --
  declare @prv_id int
  declare @doct_id int

  select @doct_id = doct_id from PresupuestoVenta where prv_id = @@prv_id

  if @doct_id = 11 begin

    declare c_PresupuestoPendiente insensitive cursor for 
      select distinct prvi.prv_id 
      from PresupuestoDevolucionVenta pvdv   inner join PresupuestoVentaItem prvi   on pvdv.prvi_id_devolucion = prvi.prvi_id
                                            inner join PresupuestoVentaItem prvir on pvdv.prvi_id_Presupuesto = prvir.prvi_id
      where prvir.prv_id = @@prv_id
    union
      select prv_id from #PresupuestoDevolucionVenta

  end else begin

    declare c_PresupuestoPendiente insensitive cursor for 
      select distinct prvi.prv_id 
      from PresupuestoDevolucionVenta pvdv   inner join PresupuestoVentaItem prvi    on pvdv.prvi_id_Presupuesto = prvi.prvi_id
                                            inner join PresupuestoVentaItem prvid  on pvdv.prvi_id_devolucion = prvid.prvi_id
      where prvid.prv_id = @@prv_id
    union
      select prv_id from #PresupuestoDevolucionVenta
  end
                      
  open c_PresupuestoPendiente
  fetch next from c_PresupuestoPendiente into @prv_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la Presupuesto
    exec sp_DocPresupuestoVentaSetPendiente @prv_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    -- Estado
    exec sp_DocPresupuestoVentaSetEstado @prv_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocPRV  @prv_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_PresupuestoPendiente into @prv_id
  end
  close c_PresupuestoPendiente
  deallocate c_PresupuestoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del presupuesto de venta. sp_DocPresupuestoVtaDevolucionSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO