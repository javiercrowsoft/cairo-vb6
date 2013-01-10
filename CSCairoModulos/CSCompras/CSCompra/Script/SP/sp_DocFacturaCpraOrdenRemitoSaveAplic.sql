if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCpraOrdenRemitoSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCpraOrdenRemitoSaveAplic]

/*

 sp_DocFacturaCpraOrdenRemitoSaveAplic 124

*/

GO
create procedure sp_DocFacturaCpraOrdenRemitoSaveAplic (
  @@fc_id       int,
  @@fcTMP_id    int,
  @@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  declare @fci_id int
  declare @iOrden int 

  create table #OrdenCompraFac (oc_id int)
  create table #RemitoCompraFac (rc_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION ORDEN                                                       //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @ocfc_id               int
declare @ocfc_cantidad        decimal(18,6)
declare @oci_cancelado        decimal(18,6)
declare @oci_id               int

  set @iOrden = 0

  insert into #OrdenCompraFac(oc_id) select distinct oc_id 
                                     from OrdenFacturaCompra ocfc inner join OrdenCompraItem oci 
                                                                                on ocfc.oci_id = oci.oci_id 
                                                                  inner join FacturaCompraItem fci 
                                                                                on ocfc.fci_id = fci.fci_id 
                                      where not exists(
                                                       select * from OrdenFacturaCompraTMP 
                                                              where fcTMP_id = @@fcTMP_id and oci_id = ocfc.oci_id
                                                       )
                                          and fci.fc_id = @@fc_id

  -- Borro toda la aplicacion actual de esta factura con ordenes
  --
  delete OrdenFacturaCompra where fci_id in (select fci_id from FacturaCompraItem where fc_id = @@fc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la factura
  -- y los ordenes
  declare c_aplicOrden insensitive cursor for

        select 
                ocfc_id, 
                fci_id,
                oci_id, 
                ocfc_cantidad

         from OrdenFacturaCompraTMP where fcTMP_id = @@fcTMP_id

  open c_aplicOrden

  fetch next from c_aplicOrden into @ocfc_id, @fci_id, @oci_id, @ocfc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el fci que le corresponde a este oci
    --
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @fci_id = fci_id from FacturaCompraItem where fc_id = @@fc_id and fci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
    --
    exec SP_DBGetNewId 'OrdenFacturaCompra','ocfc_id',@ocfc_id out,0
    if @@error <> 0 goto ControlError

    insert into OrdenFacturaCompra (
                                        ocfc_id,
                                        ocfc_cantidad,
                                        fci_id,
                                        oci_id
                                      )
                              values (
                                        @ocfc_id,
                                        @ocfc_cantidad,
                                        @fci_id,    
                                        @oci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicOrden into @ocfc_id, @fci_id, @oci_id, @ocfc_cantidad
  end

  close c_aplicOrden
  deallocate c_aplicOrden

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ORDENES                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaCpraOrdenSetPendiente @@fc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION REMITO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @rcfc_id               int
declare @rcfc_cantidad        decimal(18,6)
declare @rci_cancelado        decimal(18,6)
declare @rci_id               int

  set @iOrden = 0

  insert into #RemitoCompraFac(rc_id) select distinct rc_id 
                                     from RemitoFacturaCompra rcfc inner join RemitoCompraItem rci 
                                                                                on rcfc.rci_id = rci.rci_id 
                                                                   inner join FacturaCompraItem fci 
                                                                                on rcfc.fci_id = fci.fci_id 
                                      where not exists(
                                                       select * from RemitoFacturaCompraTMP 
                                                              where fcTMP_id = @@fcTMP_id and rci_id = rcfc.rci_id
                                                       )
                                          and fci.fc_id = @@fc_id

  -- Borro toda la aplicacion actual de esta factura con ordenes
  --
  delete RemitoFacturaCompra where fci_id in (select fci_id from FacturaCompraItem where fc_id = @@fc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la factura
  -- y los remitos
  declare c_aplicRemito insensitive cursor for

        select 
                rcfc_id, 
                fci_id,
                rci_id, 
                rcfc_cantidad

         from RemitoFacturaCompraTMP where fcTMP_id = @@fcTMP_id

  open c_aplicRemito

  fetch next from c_aplicRemito into @rcfc_id, @fci_id, @rci_id, @rcfc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el fci que le corresponde a este rci
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @fci_id = fci_id from FacturaCompraItem where fc_id = @@fc_id and fci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
    --
    exec SP_DBGetNewId 'RemitoFacturaCompra','rcfc_id',@rcfc_id out,0
    if @@error <> 0 goto ControlError

    insert into RemitoFacturaCompra (
                                        rcfc_id,
                                        rcfc_cantidad,
                                        fci_id,
                                        rci_id
                                      )
                              values (
                                        @rcfc_id,
                                        @rcfc_cantidad,
                                        @fci_id,    
                                        @rci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicRemito into @rcfc_id, @fci_id, @rci_id, @rcfc_cantidad
  end

  close c_aplicRemito
  deallocate c_aplicRemito

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN REMITOS                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaCpraRemitoSetPendiente @@fc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ITEMS                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Actualizo la deuda de la factura
  exec sp_DocFacturaCompraSetItemPendiente @@fc_id, @@bSuccess out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la vinculacion de la factura de compra con las ordenes de compra y remitos. sp_DocFacturaCpraOrdenRemitoSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

end

GO