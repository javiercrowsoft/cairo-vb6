if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCpraDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCpraDevolucionSetPendiente]

/*

 sp_DocRemitoCpraDevolucionSetPendiente 124

*/

GO
create procedure sp_DocRemitoCpraDevolucionSetPendiente (
  @@rc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las Facturas
  --
  declare @rc_id     int
  declare @doct_id   int

  select @doct_id = doct_id from RemitoCompra where rc_id = @@rc_id

  if @doct_id = 4 begin

    declare c_RemitoPendiente insensitive cursor for 
      select distinct rci.rc_id 
      from RemitoDevolucionCompra rcdc   inner join RemitoCompraItem rci    on rcdc.rci_id_devolucion = rci.rci_id
                                        inner join RemitoCompraItem rcir  on rcdc.rci_id_remito = rcir.rci_id
      where rcir.rc_id = @@rc_id
    union
      select rc_id from #RemitoDevolucionCompra

  end else begin

    declare c_RemitoPendiente insensitive cursor for 
      select distinct rci.rc_id 
      from RemitoDevolucionCompra rcdc   inner join RemitoCompraItem rci    on rcdc.rci_id_remito = rci.rci_id
                                        inner join RemitoCompraItem rcid  on rcdc.rci_id_devolucion = rcid.rci_id
      where rcid.rc_id = @@rc_id
    union
      select rc_id from #RemitoDevolucionCompra
  end
                      
  open c_RemitoPendiente
  fetch next from c_RemitoPendiente into @rc_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda del remito
    exec sp_DocRemitoCompraSetPendiente @rc_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    exec sp_DocRemitoCompraSetCredito @rc_id
    if @@error <> 0 goto ControlError

    -- Estado
    exec sp_DocRemitoCompraSetEstado @rc_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocRC    @rc_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocRC  @rc_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_RemitoPendiente into @rc_id
  end
  close c_RemitoPendiente
  deallocate c_RemitoPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del remito de Compra. sp_DocRemitoCpraDevolucionSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

end

GO