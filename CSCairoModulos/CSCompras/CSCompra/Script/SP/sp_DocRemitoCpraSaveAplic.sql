if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCpraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCpraSaveAplic]

/*

 sp_DocRemitoCpraSaveAplic 124

*/

GO
create procedure sp_DocRemitoCpraSaveAplic (
  @@rc_id       int,
  @@rcTMP_id    int,
  @@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @MsgError  varchar(5000) set @MsgError = ''

  declare @rci_id int
  declare @iOrden int 
  declare @doct_id   int

  select @doct_id = doct_id from RemitoCompra where rc_id = @@rc_id

  create table #OrdenCompraRemito  (oc_id int)
  create table #FacturaCompraRemito (fc_id int)
  create table #RemitoDevolucionCompra (rc_id int)
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION ORDEN DE COMPRA                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @ocrc_id               int
declare @ocrc_cantidad        decimal(18,6)
declare @oci_id               int

  set @iOrden = 0

  insert into #OrdenCompraRemito(oc_id) select distinct oc_id 
                                         from OrdenRemitoCompra ocrc inner join OrdenCompraItem oci 
                                                                            on ocrc.oci_id = oci.oci_id 
                                                                     inner join RemitoCompraItem rci
                                                                            on ocrc.rci_id = rci.rci_id
                                          where not exists(
                                                       select * from OrdenRemitoCompraTMP 
                                                              where rcTMP_id = @@rcTMP_id and oci_id = ocrc.oci_id
                                                       )
                                            and rci.rc_id = @@rc_id

  -- Borro toda la aplicacion actual de esta factura con ordenes de compra
  --
  delete OrdenRemitoCompra where rci_id in (select rci_id from RemitoCompraItem where rc_id = @@rc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la factura
  -- y los ordenes de compra
  declare c_aplicOrden insensitive cursor for

        select 
                ocrc_id, 
                rci_id,
                oci_id, 
                ocrc_cantidad
        
        from OrdenRemitoCompraTMP where rcTMP_id = @@rcTMP_id

  open c_aplicOrden

  fetch next from c_aplicOrden into @ocrc_id, @rci_id, @oci_id, @ocrc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el rci que le corresponde a este oci
    --
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @rci_id = rci_id from RemitoCompraItem where rc_id = @@rc_id and rci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion
    --
    exec SP_DBGetNewId 'OrdenRemitoCompra','ocrc_id',@ocrc_id out,0
    if @@error <> 0 goto ControlError

    insert into OrdenRemitoCompra (
                                        ocrc_id,
                                        ocrc_cantidad,
                                        rci_id,
                                        oci_id
                                      )
                              values (
                                        @ocrc_id,
                                        @ocrc_cantidad,
                                        @rci_id,    
                                        @oci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicOrden into @ocrc_id, @rci_id, @oci_id, @ocrc_cantidad
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

  exec sp_DocRemitoCpraOrdenSetPendiente @@rc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION FACTURA                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @rcfc_id               int
declare @rcfc_cantidad        decimal(18,6)
declare @fci_id               int

  set @iOrden = 0

  insert into #FacturaCompraRemito(fc_id) select distinct fc_id 
                                         from RemitoFacturaCompra rcfc inner join FacturaCompraItem fci 
                                                                              on rcfc.fci_id = fci.fci_id 
                                                                        inner join RemitoCompraItem rci
                                                                              on rcfc.rci_id = rci.rci_id
                                          where not exists(
                                                           select * from RemitoFacturaCompraTMP 
                                                                  where rcTMP_id = @@rcTMP_id and fci_id = rcfc.fci_id
                                                           )
                                            and rci.rc_id = @@rc_id

  -- Borro toda la aplicacion actual de esta factura con ordenes de compra
  --
  delete RemitoFacturaCompra where rci_id in (select rci_id from RemitoCompraItem where rc_id = @@rc_id)

  -- Creo un cursor sobre los registros de aplicacion entre la factura
  -- y los remitos
  declare c_aplicRemito insensitive cursor for

        select 
                rcfc_id,
                rci_id,  
                fci_id, 
                rcfc_cantidad

         from RemitoFacturaCompraTMP where rcTMP_id = @@rcTMP_id

  open c_aplicRemito

  fetch next from c_aplicRemito into @rcfc_id, @rci_id, @fci_id, @rcfc_cantidad

  while @@fetch_status = 0 begin

    -- Obtengo por el orden el rci que le corresponde a este fci
    if @@bIsAplic = 0 begin
      set @iOrden = @iOrden + 1
      select @rci_id = rci_id from RemitoCompraItem where rc_id = @@rc_id and rci_orden = @iOrden
    end

    -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
    --
    exec SP_DBGetNewId 'RemitoFacturaCompra','rcfc_id',@rcfc_id out,0
    if @@error <> 0 goto ControlError

    insert into RemitoFacturaCompra (
                                        rcfc_id,
                                        rcfc_cantidad,
                                        rci_id,
                                        fci_id
                                      )
                              values (
                                        @rcfc_id,
                                        @rcfc_cantidad,
                                        @rci_id,    
                                        @fci_id
                                      )
    if @@error <> 0 goto ControlError

    fetch next from c_aplicRemito into @rcfc_id, @rci_id, @fci_id, @rcfc_cantidad
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

  exec sp_DocRemitoCpraFacturaSetPendiente @@rc_id, @@bSuccess  out

  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @rcdc_id               int
declare @rcdc_cantidad        decimal(18,6)
declare @rci_id_remito        int
declare @rci_id_devolucion    int

  set @iOrden = 0

  if @doct_id = 4 begin

    insert into #RemitoDevolucionCompra(rc_id) select distinct rci.rc_id 
                                           from RemitoDevolucionCompra rcdc inner join RemitoCompraItem rci 
                                                                                on rcdc.rci_id_devolucion = rci.rci_id 
  
                                                                           inner join RemitoCompraItem rcir 
                                                                                on rcdc.rci_id_remito = rcir.rci_id
                                            where not exists(
                                                             select * from RemitoDevolucionCompraTMP 
                                                                    where rcTMP_id = @@rcTMP_id and rci_id_devolucion = rcdc.rci_id_devolucion
                                                             )
                                                and rcir.rc_id = @@rc_id
  
    -- Borro toda la aplicacion actual de este remito con devoluciones
    --
    delete RemitoDevolucionCompra where rci_id_remito in (select rci_id from RemitoCompraItem where rc_id = @@rc_id)
  
    -- Creo un cursor sobre los registros de aplicacion entre el remito
    -- y las devoluciones
    declare c_aplicRemito insensitive cursor for
  
          select 
                  rcdc_id,
                  rci_id_remito,  
                  rci_id_devolucion, 
                  rcdc_cantidad
  
           from RemitoDevolucionCompraTMP where rcTMP_id = @@rcTMP_id
  
    open c_aplicRemito
  
    fetch next from c_aplicRemito into @rcdc_id, @rci_id_remito, @rci_id_devolucion, @rcdc_cantidad
  
    while @@fetch_status = 0 begin
  
      -- Obtengo por el orden el rci_remito que le corresponde a este rci_devolucion
      if @@bIsAplic = 0 begin
        set @iOrden = @iOrden + 1
        select @rci_id_remito = rci_id from RemitoCompraItem where rc_id = @@rc_id and rci_orden = @iOrden
      end
  
      -- Finalmente grabo la vinculacion
      --
      exec SP_DBGetNewId 'RemitoDevolucionCompra','rcdc_id',@rcdc_id out,0
      if @@error <> 0 goto ControlError

      insert into RemitoDevolucionCompra (
                                          rcdc_id,
                                          rcdc_cantidad,
                                          rci_id_remito,
                                          rci_id_devolucion
                                        )
                                values (
                                          @rcdc_id,
                                          @rcdc_cantidad,
                                          @rci_id_remito,    
                                          @rci_id_devolucion
                                        )
      if @@error <> 0 goto ControlError
  
      fetch next from c_aplicRemito into @rcdc_id, @rci_id_remito, @rci_id_devolucion, @rcdc_cantidad
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
  
    exec sp_DocRemitoCpraDevolucionSetPendiente @@rc_id, @@bSuccess  out
  
    -- Si fallo al guardar
    if IsNull(@@bSuccess,0) = 0 goto ControlError
  
  end else begin

    insert into #RemitoDevolucionCompra(rc_id) select distinct rci.rc_id 
                                           from RemitoDevolucionCompra rcdc inner join RemitoCompraItem rci 
                                                                                on rcdc.rci_id_remito = rci.rci_id 
  
                                                                           inner join RemitoCompraItem rcid 
                                                                                on rcdc.rci_id_devolucion = rcid.rci_id
                                            where not exists(
                                                             select * from RemitoDevolucionCompraTMP 
                                                                    where rcTMP_id = @@rcTMP_id and rci_id_remito = rcdc.rci_id_remito
                                                             )
                                                and rcid.rc_id = @@rc_id
  
    -- Borro toda la aplicacion actual de esta devolucion con remitos
    --
    delete RemitoDevolucionCompra where rci_id_devolucion in (select rci_id from RemitoCompraItem where rc_id = @@rc_id)
  
    -- Creo un cursor sobre los registros de aplicacion entre la devolucion
    -- y los remitos
    declare c_aplicRemito insensitive cursor for
  
          select 
                  rcdc_id,
                  rci_id_devolucion,  
                  rci_id_remito, 
                  rcdc_cantidad
  
           from RemitoDevolucionCompraTMP where rcTMP_id = @@rcTMP_id
  
    open c_aplicRemito
  
    fetch next from c_aplicRemito into @rcdc_id, @rci_id_devolucion, @rci_id_remito, @rcdc_cantidad
  
    while @@fetch_status = 0 begin
  
      -- Obtengo por el orden el rci_devolucion que le corresponde a este rci_remito
      if @@bIsAplic = 0 begin
        set @iOrden = @iOrden + 1
        select @rci_id_devolucion = rci_id from RemitoCompraItem where rc_id = @@rc_id and rci_orden = @iOrden
      end
  
      -- Finalmente grabo la vinculacion
      --
      exec SP_DBGetNewId 'RemitoDevolucionCompra','rcdc_id',@rcdc_id out,0
      if @@error <> 0 goto ControlError

      insert into RemitoDevolucionCompra (
                                          rcdc_id,
                                          rcdc_cantidad,
                                          rci_id_devolucion,
                                          rci_id_remito
                                        )
                                values (
                                          @rcdc_id,
                                          @rcdc_cantidad,
                                          @rci_id_devolucion,    
                                          @rci_id_remito
                                        )
      if @@error <> 0 goto ControlError
  
      fetch next from c_aplicRemito into @rcdc_id, @rci_id_devolucion, @rci_id_remito, @rcdc_cantidad
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
  
    exec sp_DocRemitoCpraDevolucionSetPendiente @@rc_id, @@bSuccess  out
  
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

  exec sp_DocRemitoCompraSetPendiente @@rc_id, @@bSuccess  out
  
  -- Si fallo al guardar
  if IsNull(@@bSuccess,0) = 0 goto ControlError

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la vinculación del remito de compra con las ordenes de compra, devoluciones y facturas. sp_DocRemitoCpraSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

end

GO