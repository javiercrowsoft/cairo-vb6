if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCpraDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCpraDevolucionSetPendiente]

/*

 sp_DocOrdenCpraDevolucionSetPendiente 124

*/

GO
create procedure sp_DocOrdenCpraDevolucionSetPendiente (
  @@oc_id       int,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Finalmente actualizo el pendiente de las ordenes de compra
  --
  declare @oc_id int
  declare @doct_id int

  select @doct_id = doct_id from OrdenCompra where oc_id = @@oc_id

  if @doct_id = 35 begin

    declare c_OrdenPendiente insensitive cursor for 
      select distinct oci.oc_id 
      from OrdenDevolucionCompra ocdv   inner join OrdenCompraItem oci    on ocdv.oci_id_devolucion = oci.oci_id
                                        inner join OrdenCompraItem ocir  on ocdv.oci_id_Orden = ocir.oci_id
      where ocir.oc_id = @@oc_id
    union
      select oc_id from #OrdenDevolucionCompra

  end else begin

    declare c_OrdenPendiente insensitive cursor for 
      select distinct oci.oc_id 
      from OrdenDevolucionCompra ocdv   inner join OrdenCompraItem oci    on ocdv.oci_id_Orden = oci.oci_id
                                        inner join OrdenCompraItem ocid  on ocdv.oci_id_devolucion = ocid.oci_id
      where ocid.oc_id = @@oc_id
    union
      select oc_id from #OrdenDevolucionCompra
  end
                      
  open c_OrdenPendiente
  fetch next from c_OrdenPendiente into @oc_id
  while @@fetch_status = 0 begin

    -- Actualizo la deuda de la Orden
    exec sp_DocOrdenCompraSetPendiente @oc_id, @@bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError

    exec sp_DocOrdenCompraSetCredito @oc_id
    if @@error <> 0 goto ControlError

    -- Estado
    exec sp_DocOrdenCompraSetEstado @oc_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocOC    @oc_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocOC  @oc_id,
                                              @@bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_OrdenPendiente into @oc_id
  end
  close c_OrdenPendiente
  deallocate c_OrdenPendiente

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del Orden de Compra. sp_DocOrdenCpraDevolucionSetPendiente. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO