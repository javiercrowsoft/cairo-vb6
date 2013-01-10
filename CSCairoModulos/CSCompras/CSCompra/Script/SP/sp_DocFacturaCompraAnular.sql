if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraAnular]

go

create procedure sp_DocFacturaCompraAnular (
  @@us_id       int,
  @@fc_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@fc_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @bSuccess   tinyint
  declare @MsgError  varchar(5000) set @MsgError = ''
  
  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7
  declare @as_id             int
  declare @cpg_id           int

  -- Para facturas con condicio de pago por debito automatico o fondo fijo
  -- que se cancelan automaticamente generando una orden de pago
  --
  select @cpg_id=cpg_id from FacturaCompra where fc_id = @@fc_id

  if exists(select fc_id from facturaCompraOrdenPago where fc_id = @@fc_id) begin

    if not exists(select cpg_id from CondicionPago where cpg_id = @cpg_id and cpg_tipo in (2,3))
    begin

      goto VinculadaOrdenPago
    end
  end

  if exists(select fc_id_factura from facturaCompranotacredito where fc_id_factura = @@fc_id or fc_id_notacredito = @@fc_id) begin
    goto VinculadaNC
  end

  if exists(select fc_id from remitofacturaCompra r inner join facturaCompraitem fci on r.fci_id = fci.fci_id where fc_id = @@fc_id) begin
    goto VinculadaRemito
  end

  if exists(select fc_id from ordenFacturaCompra oc inner join facturaCompraitem fci on oc.fci_id = fci.fci_id where fc_id = @@fc_id) begin
    goto VinculadaOrden
  end

  -- No se puede des-anular una factura que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select fc_id from FacturaCompra fc 
              inner join Documento d on fc.doc_id = d.doc_id 
              where fc_id = @@fc_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update FacturaCompra set est_id = @estado_anulado, fc_pendiente = 0
    where fc_id = @@fc_id
    set @est_id = @estado_anulado

    -- Borro el asiento  
    select @as_id = as_id from FacturaCompra where fc_id = @@fc_id
    update FacturaCompra set as_id = null where fc_id = @@fc_id
    exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
    if @@error <> 0 goto ControlError

    delete FacturaCompraDeuda where fc_id = @@fc_id
    update FacturaCompraItem set fci_pendiente = 0 where fc_id = @@fc_id

    exec sp_DocFacturaCompraSetCredito @@fc_id,1

    -- Borro el movimiento de stock asociado a esta factura
    declare @st_id int
  
    select @st_id = st_id from FacturaCompra where fc_id = @@fc_id
    update FacturaCompra set st_id = null where fc_id = @@fc_id
  
    --////////////////////////////////////////////////////////////////////////////////////////////////

    declare @doct_id int

    select @doct_id = doct_id from FacturaCompra where fc_id = @@fc_id

    if @doct_id <> 8 begin
  
      create table #NroSerieDelete (prns_id int)
      insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id
  
    end

    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError

    if @doct_id <> 8 begin
  
      delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
      if @@error <> 0 goto ControlError
  
      delete ProductoNumeroSerie where prns_id in (select prns_id from #NroSerieDelete)
      if @@error <> 0 goto ControlError

    end  
    --////////////////////////////////////////////////////////////////////////////////////////////////

    /*
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                                    //
    //                          GENERACION AUTOMATICA DE ORDEN DE PAGO                                                    //
    //                                                                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
      declare @emp_id   int

      select @emp_id = doc.emp_id 
      from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
      where fc_id = @@fc_id

      exec sp_DocFacturaCompraOrdenPagoDelete   @@fc_id         ,
                                                @emp_id          ,
                                                @@us_id          ,
                                                @bSuccess        out,
                                                @MsgError       out
      if @bSuccess = 0 goto ControlError

      if exists(select cpg_id from CondicionPago where cpg_id = @cpg_id and cpg_tipo in (2,3))
      begin

        delete FacturaCompraPago where fc_id = @@fc_id
        if @@error <> 0 goto ControlError

      end  
    /*
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                                    //
    //                          FIN GENERACION AUTOMATICA DE ORDEN DE PAGO                                                //
    //                                                                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

  end else begin

    update FacturaCompra set est_id = @estado_pendiente
    where fc_id = @@fc_id

    declare @fc_fecha     datetime
    declare @fc_fechaVto  datetime
    declare @fc_total     decimal(18,6)

    declare  @fc_descuento1    decimal(18, 6)
    declare  @fc_descuento2    decimal(18, 6)
  
    declare  @fc_totalotros            decimal(18, 6)
    declare  @fc_totalpercepciones     decimal(18, 6)

    select @fc_total                = fc_total, 
           @fc_fecha                = fc_fecha, 
           @fc_fechaVto             = fc_fechaVto,
           @cpg_id                  = cpg_id,
           @fc_descuento1          = fc_descuento1,
           @fc_descuento2          = fc_descuento2,
           @fc_totalotros          = fc_totalotros,
           @fc_totalpercepciones   = fc_totalpercepciones

    from FacturaCompra where fc_id = @@fc_id

    declare @fc_totaldeuda decimal(18,6)
  
    select @fc_totaldeuda = sum(fci_importe) 
    from FacturaCompraItem fci inner join TipoOperacion t on fci.to_id = t.to_id
    where fc_id = @@fc_id 
      and to_generadeuda <> 0
  
    set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento1) / 100)
    set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento2) / 100)
    set @fc_totaldeuda = @fc_totaldeuda + @fc_totalotros + @fc_totalpercepciones
  
    exec sp_DocFacturaCompraSaveDeuda       
                                      @@fc_id,
                                      @cpg_id,
                                      @fc_fecha,
                                      @fc_fechaVto,
                                      @fc_totaldeuda,
                                      @estado_pendiente,
                                      @bSuccess  out

    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError

    update FacturaCompraItem set fci_pendiente = fci_cantidadaremitir where fc_id = @@fc_id

    exec sp_DocFacturaCompraSetCredito @@fc_id
    exec sp_DocFacturaCompraSetEstado  @@fc_id,0,@est_id out

    -- Genero nuevamente el asiento
    declare @bError    smallint

    exec sp_DocFacturaCompraAsientoSave @@fc_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

    /*
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                                    //
    //                          GENERACION AUTOMATICA DE ORDEN DE PAGO                                                    //
    //                                                                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
        exec sp_DocFacturaCompraOrdenPagoSave @@fc_id,   
                                              @bSuccess out,
                                              @MsgError out
        -- Si fallo al guardar
        if @bSuccess = 0 goto ControlError

    /*
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                                    //
    //                          FIN GENERACION AUTOMATICA DE ORDEN DE PAGO                                                //
    //                                                                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select @est_id = est_id from FacturaCompra where fc_id = @@fc_id

  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_AuditoriaAnularCheckDocFC    @@fc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

/*
-- select * from HistoriaOperacion where tbl_id = 0
-- select * from tabla where tbl_nombrefisico = 'facturacompra'
sp_HistoriaUpdate (
  @@tbl_id          int,
  @@id              int,
  @@modifico        int,
  @@hst_operacion   tinyint,
  @@hst_descrip     varchar(255) = ''
*/

  update FacturaCompra set modificado = getdate(), modifico = @@us_id where fc_id = @@fc_id

  if @@anular <> 0 exec sp_HistoriaUpdate 17001, @@fc_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 17001, @@fc_id, @@us_id, 8

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  if @bInternalTransaction <> 0 
    commit transaction

  if @@Select <> 0 begin
    select est_id, est_nombre from Estado where est_id = @est_id
  end

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el estado de la factura de compra. sp_DocFacturaCompraAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  Goto fin

VinculadaOrdenPago:
  raiserror ('@@ERROR_SP:El documento esta vinculado a una orden de pago.', 16, 1)
  Goto fin

VinculadaNC:
  raiserror ('@@ERROR_SP:El documento esta vinculado a una factura o nota de credito.', 16, 1)
  Goto fin

VinculadaRemito:
  raiserror ('@@ERROR_SP:El documento esta vinculado a un remito.', 16, 1)
  Goto fin

VinculadaOrden:
  raiserror ('@@ERROR_SP:El documento esta vinculado a una orden de compra.', 16, 1)
  Goto fin

MueveStock:
  raiserror ('@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.', 16, 1)
  Goto fin

fin:

end