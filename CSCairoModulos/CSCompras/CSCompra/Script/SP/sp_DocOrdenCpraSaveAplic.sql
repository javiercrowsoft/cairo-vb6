if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCpraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCpraSaveAplic]

/*

 sp_DocOrdenCpraSaveAplic 124

*/

GO
create procedure sp_DocOrdenCpraSaveAplic (
  @@oc_id       int,
  @@ocTMP_id    int,
  @@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  declare @oci_id int
  declare @iOrden int 
  declare @doct_id   int

  select @doct_id = doct_id from OrdenCompra where oc_id = @@oc_id

  create table #OrdenCompraFactura    (fc_id int)
  create table #OrdenCompraRemito     (rc_id int)
  create table #OrdenDevolucionCompra  (oc_id int)
  create table #PedidoOrdenCompra     (pc_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION FACTURA                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @ocfc_id               int
declare @ocfc_cantidad        decimal(18,6)
declare @fci_id               int

  set @iOrden = 0

  insert into #OrdenCompraFactura(fc_id) select distinct fc_id 
                                         from OrdenFacturaCompra ocfc inner join FacturaCompraItem fci 
                                                                              on ocfc.fci_id = fci.fci_id 
                                                                      inner join OrdenCompraItem oci
                                                                              on ocfc.oci_id = oci.oci_id
                                          where not exists(
                                                           select * from OrdenFacturaCompraTMP 
                                                                  where ocTMP_id = @@ocTMP_id and fci_id = ocfc.fci_id
                                                           )
                                              and oci.oc_id = @@oc_id

  -- Borro toda la aplicacion actual de esta factura con Ordenes
  --
  delete OrdenFacturaCompra where oci_id in (select oci_id from OrdenCompraItem where oc_id = @@oc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la factura
  -- y los remitos
  declare c_aplicFactura insensitive cursor for

        select 
                ocfc_id,
                oci_id,  
                fci_id, 
                ocfc_cantidad

         from OrdenFacturaCompraTMP where ocTMP_id = @@ocTMP_id

  open c_aplicFactura

  fetch next from c_aplicFactura into @ocfc_id, @oci_id, @fci_id, @ocfc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el oci que le corresponde a este fci
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @oci_id = oci_id from OrdenCompraItem where oc_id = @@oc_id and oci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
    --
    exec SP_DBGetNewId 'OrdenFacturaCompra','ocfc_id',@ocfc_id out,0
    if @@error <> 0 goto ControlError

    insert into OrdenFacturaCompra (
                                        ocfc_id,
                                        ocfc_cantidad,
                                        oci_id,
                                        fci_id
                                      )
                              values (
                                        @ocfc_id,
                                        @ocfc_cantidad,
                                        @oci_id,    
                                        @fci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicFactura into @ocfc_id, @oci_id, @fci_id, @ocfc_cantidad
  end

  close c_aplicFactura
  deallocate c_aplicFactura

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN FACTURAS                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocOrdenCpraFacturaSetPendiente @@oc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION REMITO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @ocrc_id               int
declare @ocrc_cantidad        decimal(18,6)
declare @rci_id               int

  set @iOrden = 0

  insert into #OrdenCompraRemito(rc_id) select distinct rc_id 
                                         from OrdenRemitoCompra ocrc inner join RemitoCompraItem rci 
                                                                              on ocrc.rci_id = rci.rci_id 
                                                                     inner join OrdenCompraItem oci
                                                                              on ocrc.oci_id = oci.oci_id
                                          where not exists(
                                                           select * from OrdenRemitoCompraTMP 
                                                                  where ocTMP_id = @@ocTMP_id and rci_id = ocrc.rci_id
                                                           )
                                              and oci.oc_id = @@oc_id

  -- Borro toda la aplicacion actual de esta Remito con Ordenes
  --
  delete OrdenRemitoCompra where oci_id in (select oci_id from OrdenCompraItem where oc_id = @@oc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la Remito
  -- y los remitos
  declare c_aplicRemito insensitive cursor for

        select 
                ocrc_id,
                oci_id,  
                rci_id, 
                ocrc_cantidad

         from OrdenRemitoCompraTMP where ocTMP_id = @@ocTMP_id

  open c_aplicRemito

  fetch next from c_aplicRemito into @ocrc_id, @oci_id, @rci_id, @ocrc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el oci que le corresponde a este rci
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @oci_id = oci_id from OrdenCompraItem where oc_id = @@oc_id and oci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
    --
    exec SP_DBGetNewId 'OrdenRemitoCompra','ocrc_id',@ocrc_id out,0
    if @@error <> 0 goto ControlError

    insert into OrdenRemitoCompra (
                                        ocrc_id,
                                        ocrc_cantidad,
                                        oci_id,
                                        rci_id
                                      )
                              values (
                                        @ocrc_id,
                                        @ocrc_cantidad,
                                        @oci_id,    
                                        @rci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicRemito into @ocrc_id, @oci_id, @rci_id, @ocrc_cantidad
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

  exec sp_DocOrdenCpraRemitoSetPendiente @@oc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PEDIDO DE COMPRA                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pcoc_id               int
declare @pcoc_cantidad        decimal(18,6)
declare @pci_id               int

  set @iOrden = 0

  insert into #PedidoOrdenCompra(pc_id) select distinct pc_id 
                                         from PedidoOrdenCompra pcoc inner join PedidoCompraItem pci 
                                                                            on pcoc.pci_id = pci.pci_id 
                                                                     inner join OrdenCompraItem oci
                                                                            on pcoc.oci_id = oci.oci_id
                                          where not exists(
                                                       select * from PedidoOrdenCompraTMP 
                                                              where ocTMP_id = @@ocTMP_id and pci_id = pcoc.pci_id
                                                       )
                                            and oci.oc_id = @@oc_id

  -- Borro toda la aplicacion actual de esta factura con ordenes de compra
  --
  delete PedidoOrdenCompra where oci_id in (select oci_id from OrdenCompraItem where oc_id = @@oc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la factura
  -- y los ordenes de compra
  declare c_aplicOrden insensitive cursor for

        select 
                pcoc_id, 
                oci_id,
                pci_id, 
                pcoc_cantidad
        
        from PedidoOrdenCompraTMP where ocTMP_id = @@ocTMP_id

  open c_aplicOrden

  fetch next from c_aplicOrden into @pcoc_id, @oci_id, @pci_id, @pcoc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el oci que le corresponde a este pci
    --
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @oci_id = oci_id from OrdenCompraItem where oc_id = @@oc_id and oci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion
    --
    exec SP_DBGetNewId 'PedidoOrdenCompra','pcoc_id',@pcoc_id out,0
    if @@error <> 0 goto ControlError

    insert into PedidoOrdenCompra (
                                        pcoc_id,
                                        pcoc_cantidad,
                                        oci_id,
                                        pci_id
                                      )
                              values (
                                        @pcoc_id,
                                        @pcoc_cantidad,
                                        @oci_id,    
                                        @pci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicOrden into @pcoc_id, @oci_id, @pci_id, @pcoc_cantidad
  end

  close c_aplicOrden
  deallocate c_aplicOrden

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN PEDIDOS                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocOrdenCpraPedidoSetPendiente @@oc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @ocdc_id               int
declare @ocdc_cantidad        decimal(18,6)
declare @oci_id_Orden        int
declare @oci_id_devolucion    int

  set @iOrden = 0

  if @doct_id = 35 begin

    insert into #OrdenDevolucionCompra(oc_id) select distinct oci.oc_id 
                                           from OrdenDevolucionCompra ocdc inner join OrdenCompraItem oci 
                                                                                on ocdc.oci_id_devolucion = oci.oci_id 
  
                                                                           inner join OrdenCompraItem ocir 
                                                                                on ocdc.oci_id_Orden = ocir.oci_id
                                            where not exists(
                                                             select * from OrdenDevolucionCompraTMP 
                                                                    where ocTMP_id = @@ocTMP_id and oci_id_devolucion = ocdc.oci_id_devolucion
                                                             )
                                                and ocir.oc_id = @@oc_id
  
    -- Borro toda la aplicacion actual de este Orden con devoluciones
    --
    delete OrdenDevolucionCompra where oci_id_Orden in (select oci_id from OrdenCompraItem where oc_id = @@oc_id)
  
    -- Creo un cursor sobre los registros de aplicacion entre el Orden
    -- y las devoluciones
    declare c_aplicOrden insensitive cursor for
  
          select 
                  ocdc_id,
                  oci_id_Orden,  
                  oci_id_devolucion, 
                  ocdc_cantidad
  
           from OrdenDevolucionCompraTMP where ocTMP_id = @@ocTMP_id
  
    open c_aplicOrden
  
    fetch next from c_aplicOrden into @ocdc_id, @oci_id_Orden, @oci_id_devolucion, @ocdc_cantidad
  
    while @@fetch_status = 0 begin
  
      -- Obtengo por el orden el oci_Orden que le corresponde a este oci_devolucion
      if @@bIsAplic = 0 begin
        set @iOrden = @iOrden + 1
        select @oci_id_Orden = oci_id from OrdenCompraItem where oc_id = @@oc_id and oci_orden = @iOrden
      end
  
      -- Finalmente grabo la vinculacion
      --
      exec SP_DBGetNewId 'OrdenDevolucionCompra','ocdc_id',@ocdc_id out,0
      if @@error <> 0 goto ControlError

      insert into OrdenDevolucionCompra (
                                          ocdc_id,
                                          ocdc_cantidad,
                                          oci_id_Orden,
                                          oci_id_devolucion
                                        )
                                values (
                                          @ocdc_id,
                                          @ocdc_cantidad,
                                          @oci_id_Orden,    
                                          @oci_id_devolucion
                                        )
      if @@error <> 0 goto ControlError
  
      fetch next from c_aplicOrden into @ocdc_id, @oci_id_Orden, @oci_id_devolucion, @ocdc_cantidad
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
  
    exec sp_DocOrdenCpraDevolucionSetPendiente @@oc_id, @@bSuccess  out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError
  
  end else begin

    insert into #OrdenDevolucionCompra(oc_id) select distinct oci.oc_id 
                                           from OrdenDevolucionCompra ocdc inner join OrdenCompraItem oci 
                                                                                on ocdc.oci_id_Orden = oci.oci_id 
  
                                                                           inner join OrdenCompraItem ocid 
                                                                                on ocdc.oci_id_devolucion = ocid.oci_id
                                            where not exists(
                                                             select * from OrdenDevolucionCompraTMP 
                                                                    where ocTMP_id = @@ocTMP_id and oci_id_Orden = ocdc.oci_id_Orden
                                                             )
                                                and ocid.oc_id = @@oc_id
  
    -- Borro toda la aplicacion actual de esta devolucion con Ordenes
    --
    delete OrdenDevolucionCompra where oci_id_devolucion in (select oci_id from OrdenCompraItem where oc_id = @@oc_id)
  
    -- Creo un cursor sobre los registros de aplicacion entre la devolucion
    -- y los Ordenes
    declare c_aplicOrden insensitive cursor for
  
          select 
                  ocdc_id,
                  oci_id_devolucion,  
                  oci_id_Orden, 
                  ocdc_cantidad
  
           from OrdenDevolucionCompraTMP where ocTMP_id = @@ocTMP_id
  
    open c_aplicOrden
  
    fetch next from c_aplicOrden into @ocdc_id, @oci_id_devolucion, @oci_id_Orden, @ocdc_cantidad
  
    while @@fetch_status = 0 begin
  
      -- Obtengo por el orden el oci_devolucion que le corresponde a este oci_Orden
      if @@bIsAplic = 0 begin
        set @iOrden = @iOrden + 1
        select @oci_id_devolucion = oci_id from OrdenCompraItem where oc_id = @@oc_id and oci_orden = @iOrden
      end
  
      -- Finalmente grabo la vinculacion
      --
      exec SP_DBGetNewId 'OrdenDevolucionCompra','ocdc_id',@ocdc_id out,0
      if @@error <> 0 goto ControlError

      insert into OrdenDevolucionCompra (
                                          ocdc_id,
                                          ocdc_cantidad,
                                          oci_id_devolucion,
                                          oci_id_Orden
                                        )
                                values (
                                          @ocdc_id,
                                          @ocdc_cantidad,
                                          @oci_id_devolucion,    
                                          @oci_id_Orden
                                        )
      if @@error <> 0 goto ControlError
  
      fetch next from c_aplicOrden into @ocdc_id, @oci_id_devolucion, @oci_id_Orden, @ocdc_cantidad
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
  
    exec sp_DocOrdenCpraDevolucionSetPendiente @@oc_id, @@bSuccess  out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError
  
  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ITEMS                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  exec sp_DocOrdenCompraSetPendiente @@oc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la vinculación del Orden de Compra con los remitos, facturas, devoluciones y packing list. sp_DocOrdenCpraSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO