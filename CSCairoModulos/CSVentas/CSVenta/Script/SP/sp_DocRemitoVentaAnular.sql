if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaAnular]

go

create procedure sp_DocRemitoVentaAnular (
  @@us_id       int,
  @@rv_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@rv_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  if exists(select rv_id from pedidoremitoventa r inner join remitoventaitem rvi on r.rvi_id = rvi.rvi_id where rv_id = @@rv_id) begin
    goto VinculadaPedido
  end

  if exists(select rv_id from remitofacturaventa r inner join remitoventaitem rvi on r.rvi_id = rvi.rvi_id where rv_id = @@rv_id) begin
    goto VinculadaFactura
  end

  -- No se puede des-anular un remito que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select rv_id from RemitoVenta rv 
              inner join Documento d on rv.doc_id = d.doc_id 
              where rv_id = @@rv_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update RemitoVenta set est_id = @estado_anulado, rv_pendiente = 0
    where rv_id = @@rv_id
    set @est_id = @estado_anulado

    exec sp_DocRemitoVentaSetCredito @@rv_id,1
    if @@error <> 0 goto ControlError

    -- Borro el movimiento de stock asociado a este remito
    declare @st_id int
  
    select @st_id = st_id from RemitoVenta where rv_id = @@rv_id
    update RemitoVenta set st_id = null where rv_id = @@rv_id
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError

    select @st_id = st_id_consumo from RemitoVenta where rv_id = @@rv_id
    update RemitoVenta set st_id_consumo = null where rv_id = @@rv_id
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError

    select @st_id = st_id_consumoTemp from RemitoVenta where rv_id = @@rv_id
    update RemitoVenta set st_id_consumoTemp = null where rv_id = @@rv_id
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError

    select @st_id = st_id_producido from RemitoVenta where rv_id = @@rv_id
    update RemitoVenta set st_id_producido = null where rv_id = @@rv_id
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError

  end else begin

    update RemitoVenta set est_id = @estado_pendiente, rv_pendiente = rv_total
    where rv_id = @@rv_id

    exec sp_DocRemitoVentaSetEstado @@rv_id,0,@est_id out

    exec sp_DocRemitoVentaSetCredito @@rv_id
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

  exec sp_AuditoriaAnularCheckDocRV    @@rv_id,
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

  update RemitoVenta set modificado = getdate(), modifico = @@us_id where rv_id = @@rv_id

  if @@anular <> 0 exec sp_HistoriaUpdate 16002, @@rv_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 16002, @@rv_id, @@us_id, 8

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 PARTICULARIDADES DE LOS CLIENTES                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocRemitoVentaAnularCliente @@rv_id, 
                                      @@us_id,
                                      @@anular,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del remito de venta. sp_DocRemitoVentaAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  Goto fin

VinculadaFactura:
  raiserror ('@@ERROR_SP:El documento esta vinculado a una factura de venta.', 16, 1)
  Goto fin

VinculadaPedido:
  raiserror ('@@ERROR_SP:El documento esta vinculado a un pedido de venta.', 16, 1)
  Goto fin

MueveStock:
  raiserror ('@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.', 16, 1)
  Goto fin

fin:

end