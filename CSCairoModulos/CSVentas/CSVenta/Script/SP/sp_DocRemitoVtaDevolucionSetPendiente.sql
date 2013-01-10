if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVtaDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVtaDevolucionSetPendiente]

/*

 sp_DocRemitoVtaDevolucionSetPendiente 124

*/

GO
create procedure sp_DocRemitoVtaDevolucionSetPendiente (
  @@rv_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las Facturas
  --
  declare @rv_id int
  declare @doct_id int

  select @doct_id = doct_id from RemitoVenta where rv_id = @@rv_id

  if @doct_id = 3 begin

    declare c_RemitoPendiente insensitive cursor for 
      select distinct rvi.rv_id 
      from RemitoDevolucionVenta rvdv   inner join RemitoVentaItem rvi    on rvdv.rvi_id_devolucion = rvi.rvi_id
                                        inner join RemitoVentaItem rvir  on rvdv.rvi_id_remito = rvir.rvi_id
      where rvir.rv_id = @@rv_id
    union
      select rv_id from #RemitoDevolucionVenta

  end else begin

    declare c_RemitoPendiente insensitive cursor for 
      select distinct rvi.rv_id 
      from RemitoDevolucionVenta rvdv   inner join RemitoVentaItem rvi    on rvdv.rvi_id_remito = rvi.rvi_id
                                        inner join RemitoVentaItem rvid  on rvdv.rvi_id_devolucion = rvid.rvi_id
      where rvid.rv_id = @@rv_id
    union
      select rv_id from #RemitoDevolucionVenta
  end
                      
  open c_RemitoPendiente
  fetch next from c_RemitoPendiente into @rv_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la Remito
    exec sp_DocRemitoVentaSetPendiente @rv_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    exec sp_DocRemitoVentaSetCredito @rv_id
    if @@error <> 0 goto ControlError

    -- Estado
    exec sp_DocRemitoVentaSetEstado @rv_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocRV    @rv_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocRV  @rv_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_RemitoPendiente into @rv_id
  end
  close c_RemitoPendiente
  deallocate c_RemitoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del remito de venta. sp_DocRemitoVtaDevolucionSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO