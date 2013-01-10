if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraAnular]

go

create procedure sp_DocRemitoCompraAnular (
  @@us_id       int,
  @@rc_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0,
  @@bSuccess    tinyint = 0 out,
  @@ErrorMsg    varchar(5000) = '' out
)
as

begin

  set nocount on

  set @@bSuccess = 0
  set @@ErrorMsg = ''

  if @@rc_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  if exists(select rc_id from RemitoFacturaCompra r inner join RemitoCompraItem rci on r.rci_id = rci.rci_id where rc_id = @@rc_id) begin
    goto VinculadaFactura
  end

  if exists(select rc_id from OrdenRemitoCompra r inner join RemitoCompraItem rci on r.rci_id = rci.rci_id where rc_id = @@rc_id) begin
    goto VinculadaOrden
  end

  -- No se puede des-anular una factura que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select rc_id from RemitoCompra rc 
              inner join Documento d on rc.doc_id = d.doc_id 
              where rc_id = @@rc_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update RemitoCompra set est_id = @estado_anulado, rc_pendiente = 0
    where rc_id = @@rc_id
    set @est_id = @estado_anulado

    exec sp_DocRemitoCompraSetCredito @@rc_id,1
    if @@error <> 0 goto ControlError
  
    declare @st_id int
  
    select @st_id = st_id from RemitoCompra where rc_id = @@rc_id
    update RemitoCompra set st_id = null where rc_id = @@rc_id
  
    --////////////////////////////////////////////////////////////////////////////////////////////////
  
    create table #NroSerieDelete (prns_id int)
    insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id
  
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError
  
    delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
    if @@error <> 0 goto ControlError
  
    delete ProductoNumeroSerie where prns_id in (select prns_id from #NroSerieDelete)
    if @@error <> 0 goto ControlError
  
    --////////////////////////////////////////////////////////////////////////////////////////////////
  end else begin

    update RemitoCompra set est_id = @estado_pendiente, rc_pendiente = rc_total
    where rc_id = @@rc_id

    exec sp_DocRemitoCompraSetEstado @@rc_id,0,@est_id out

    exec sp_DocRemitoCompraSetCredito @@rc_id
    if @@error <> 0 goto ControlError

  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bSuccess tinyint
  declare @MsgError  varchar(5000) set @MsgError = ''

  exec sp_AuditoriaAnularCheckDocRC    @@rc_id,
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

  update RemitoCompra set modificado = getdate(), modifico = @@us_id where rc_id = @@rc_id

  if @@anular <> 0 exec sp_HistoriaUpdate 17003, @@rc_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 17003, @@rc_id, @@us_id, 8

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  if @bInternalTransaction <> 0 
    commit transaction

  set @@bSuccess = 1

  if @@Select <> 0 begin
    select est_id, est_nombre from Estado where est_id = @est_id
  end

  return
ControlError:

  set @@bSuccess = 0
  set @@ErrorMsg = 'Ha ocurrido un error al actualizar el estado del remito de compra. sp_DocRemitoCompraAnular. ' + IsNull(@MsgError,'')

  raiserror (@@ErrorMsg, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  Goto fin

VinculadaFactura:

  set @@bSuccess = 0
  set @@ErrorMsg = '@@ERROR_SP:El documento esta vinculado a una factura de compra.'

  raiserror (@@ErrorMsg, 16, 1)
  Goto fin

VinculadaOrden:

  set @@bSuccess = 0
  set @@ErrorMsg = '@@ERROR_SP:El documento esta vinculado a una orden de compra.'

  raiserror (@@ErrorMsg, 16, 1)
  Goto fin

MueveStock:

  set @@bSuccess = 0
  set @@ErrorMsg = '@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.'

  raiserror (@@ErrorMsg, 16, 1)
  Goto fin

fin:

end