if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaAnular]

go

create procedure sp_DocFacturaVentaAnular (
	@@us_id       int,
	@@fv_id 			int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

	if @@fv_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

	declare @est_id           int
	declare @estado_pendiente int set @estado_pendiente = 1
	declare @estado_anulado   int set @estado_anulado   = 7
	declare @as_id 						int

	if exists(select fv_id from facturaventacobranza where fv_id = @@fv_id) begin
		goto VinculadaCobranza
	end

	if exists(select fv_id_factura from facturaventanotacredito where fv_id_factura = @@fv_id or fv_id_notacredito = @@fv_id) begin
		goto VinculadaNC
	end

	if exists(select fv_id from remitofacturaventa r inner join facturaventaitem fvi on r.fvi_id = fvi.fvi_id where fv_id = @@fv_id) begin
		goto VinculadaRemito
	end

	if exists(select fv_id from pedidofacturaventa r inner join facturaventaitem fvi on r.fvi_id = fvi.fvi_id where fv_id = @@fv_id) begin
		goto VinculadaPedido
	end

	if exists(select fv_id from packinglistfacturaventa r inner join facturaventaitem fvi on r.fvi_id = fvi.fvi_id where fv_id = @@fv_id) begin
		goto VinculadaPacking
	end

  -- No se puede des-anular una factura que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select fv_id from FacturaVenta fv 
              inner join Documento d on fv.doc_id = d.doc_id 
              where fv_id = @@fv_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

	if @@anular <> 0 begin

		update FacturaVenta set est_id = @estado_anulado, fv_pendiente = 0
		where fv_id = @@fv_id
		set @est_id = @estado_anulado

		-- Borro el asiento	
		select @as_id = as_id from FacturaVenta where fv_id = @@fv_id
	  update FacturaVenta set as_id = null where fv_id = @@fv_id
		exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
		if @@error <> 0 goto ControlError

		delete FacturaVentaDeuda where fv_id = @@fv_id
	  update FacturaVentaItem set fvi_pendiente = 0, fvi_pendientepklst = 0 where fv_id = @@fv_id

		exec sp_DocFacturaVentaSetCredito @@fv_id,1

    -- Borro el movimiento de stock asociado a esta factura
  	declare @st_id int
  
  	select @st_id = st_id from FacturaVenta where fv_id = @@fv_id
    update FacturaVenta set st_id = null where fv_id = @@fv_id
  	exec sp_DocStockDelete @st_id,0,0,0,1
  	if @@error <> 0 goto ControlError

	end else begin

		update FacturaVenta set est_id = @estado_pendiente
		where fv_id = @@fv_id

		declare @cpg_id 			int
		declare @fv_fecha 		datetime
		declare @fv_fechaVto  datetime
		declare @fv_total 		decimal(18,6)
    declare @bSuccess			tinyint

		declare	@fv_descuento1    decimal(18, 6)
		declare	@fv_descuento2    decimal(18, 6)

		declare	@fv_totalpercepciones     decimal(18, 6)

	  select 
						@fv_total 						= fv_total, 
						@fv_fecha 						= fv_fecha, 
						@fv_fechaVto					= fv_fechaVto,
						@cpg_id 							= cpg_id,
					  @fv_descuento1  			= fv_descuento1,
					  @fv_descuento2  			= fv_descuento2,
					  @fv_totalpercepciones = fv_totalpercepciones

		from FacturaVenta where fv_id = @@fv_id

		declare @fv_totaldeuda decimal(18,6)
	
		select @fv_totaldeuda = sum(fvi_importe) 
		from FacturaVentaItem fvi inner join TipoOperacion t on fvi.to_id = t.to_id
		where fv_id = @@fv_id 
			and to_generadeuda <> 0
	
		set @fv_totaldeuda = @fv_totaldeuda - ((@fv_totaldeuda * @fv_descuento1) / 100)
		set @fv_totaldeuda = @fv_totaldeuda - ((@fv_totaldeuda * @fv_descuento2) / 100)
		set @fv_totaldeuda = @fv_totaldeuda + @fv_totalpercepciones
	
		exec sp_DocFacturaVentaSaveDeuda 			
																			@@fv_id,
																			@cpg_id,
																			@fv_fecha,
																			@fv_fechaVto,
																			@fv_totaldeuda,
																			@estado_pendiente,
																	    @bSuccess	out

		-- Si fallo al guardar
		if IsNull(@bSuccess,0) = 0 goto ControlError

		update FacturaVentaItem set 
																fvi_pendiente 			= fvi_cantidadaremitir, 
																fvi_pendientepklst 	= fvi_cantidadaremitir 
		where fv_id = @@fv_id

		exec sp_DocFacturaVentaSetCredito @@fv_id
    exec sp_DocFacturaVentaSetEstado @@fv_id,0,@est_id out

		-- Genero nuevamente el asiento
		declare @bError 	 smallint
		declare @MsgError  varchar(5000) set @MsgError = ''

		exec sp_DocFacturaVentaAsientoSave @@fv_id,0,@bError out, @MsgError out
	  if @bError <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_AuditoriaAnularCheckDocFV		@@fv_id,
																			@bSuccess	out,
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

	update FacturaVenta set modificado = getdate(), modifico = @@us_id where fv_id = @@fv_id

	if @@anular <> 0 exec sp_HistoriaUpdate 16001, @@fv_id, @@us_id, 7
	else             exec sp_HistoriaUpdate 16001, @@fv_id, @@us_id, 8

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

	set @MsgError = 'Ha ocurrido un error al actualizar el estado de la factura de venta. sp_DocFacturaVentaAnular. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	
	Goto fin

VinculadaCobranza:
	raiserror ('@@ERROR_SP:El documento esta vinculado a una cobranza.', 16, 1)
	Goto fin

VinculadaNC:
	raiserror ('@@ERROR_SP:El documento esta vinculado a una factura o nota de credito.', 16, 1)
	Goto fin

VinculadaRemito:
	raiserror ('@@ERROR_SP:El documento esta vinculado a un remito.', 16, 1)
	Goto fin

VinculadaPacking:
	raiserror ('@@ERROR_SP:El documento esta vinculado a un packing list.', 16, 1)
	Goto fin

VinculadaPedido:
	raiserror ('@@ERROR_SP:El documento esta vinculado a un pedido de venta.', 16, 1)
	Goto fin

MueveStock:
	raiserror ('@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.', 16, 1)
	Goto fin

fin:

end