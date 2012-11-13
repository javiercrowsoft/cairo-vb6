if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaRemitoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaRemitoSave]

/*

 sp_DocFacturaVentaRemitoSave 124

*/

go
create procedure sp_DocFacturaVentaRemitoSave (
  @@fv_id    				int,
	@@rv_nrodoc       varchar(50),
  @@bError          smallint out,
  @@MsgError        varchar(5000) out
)
as

begin

	set nocount on

	declare @rvTMP_id 	int

	exec sp_dbgetnewid 'RemitoVentaTMP', 'rvTMP_id', @rvTMP_id out, 0

	insert into RemitoVentaTMP
									(
												rvTMP_id,
												rv_id,
												rv_numero,
												rv_nrodoc,
												rv_descrip,
												rv_fecha,
												rv_fechaentrega,
												rv_neto,
												rv_ivari,
												rv_ivarni,
												rv_subtotal,
												rv_total,
												rv_descuento1,
												rv_descuento2,
												rv_importedesc1,
												rv_importedesc2,
												rv_cotizacion,
												est_id,
												suc_id,
												cli_id,
												doc_id,
												lp_id,
												ld_id,
												lgj_id,
												cpg_id,
												ccos_id,
												ven_id,
												st_id,
												depl_id,
												depl_id_temp,
												pro_id_origen,
												pro_id_destino,
												trans_id,
												clis_id,
												creado,
												modificado,
												modifico
									)
					select
												@rvTMP_id,
												0,
												0,
												@@rv_nrodoc,
												fv_descrip,
												fv_fecha,
												fv_fechaentrega,
												fv_neto,
												fv_ivari,
												fv_ivarni,
												fv_subtotal,
												fv_total-fv_totalpercepciones,
												fv_descuento1,
												fv_descuento2,
												fv_importedesc1,
												fv_importedesc2,
												fv_cotizacion,
												est_id,
												suc_id,
												cli_id,
												doc_id_remito,
												lp_id,
												ld_id,
												lgj_id,
												cpg_id,
												ccos_id,
												ven_id,
												null,
												null,
												null,
												pro_id_origen,
												pro_id_destino,
												trans_id,
												clis_id,
												fv.creado,
												fv.modificado,
												fv.modifico

				from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id where fv_id = @@fv_id


	declare @rviTMP_id									int
	declare @rvi_orden									smallint
	declare @rvi_cantidad								decimal(18,6)
	declare @rvi_cantidadaremitir				decimal(18,6)
	declare @rvi_pendiente							decimal(18,6)
	declare @rvi_pendientefac						decimal(18,6)
	declare @rvi_descrip								varchar(255)
	declare @rvi_precio									decimal(18,6)
	declare @rvi_precioUsr							decimal(18,6)
	declare @rvi_precioLista						decimal(18,6)
	declare @rvi_descuento							varchar(100)
	declare @rvi_neto										decimal(18,6)
	declare @rvi_ivari									decimal(18,6)
	declare @rvi_ivarni									decimal(18,6)
	declare @rvi_ivariporc							decimal(18,6)
	declare @rvi_ivarniporc							decimal(18,6)
	declare @rvi_importe								decimal(18,6)
	declare @pr_id											int
	declare @ccos_id										int

	declare c_Items insensitive cursor for select
																									fvi_orden,
																									fvi_cantidad,
																									fvi_cantidadaremitir,
																									fvi_pendiente,
																									fvi_pendiente,
																									fvi_descrip,
																									fvi_precio,
																									fvi_precioUsr,
																									fvi_precioLista,
																									fvi_descuento,
																									fvi_neto,
																									fvi_ivari,
																									fvi_ivarni,
																									fvi_ivariporc,
																									fvi_ivarniporc,
																									fvi_importe,
																									pr_id,
																									ccos_id
																					from FacturaVentaItem where fv_id = @@fv_id order by fvi_orden


	open c_Items

	fetch next from c_Items into
																	@rvi_orden,
																	@rvi_cantidad,
																	@rvi_cantidadaremitir,
																	@rvi_pendiente,
																	@rvi_pendientefac,
																	@rvi_descrip,
																	@rvi_precio,
																	@rvi_precioUsr,
																	@rvi_precioLista,
																	@rvi_descuento,
																	@rvi_neto,
																	@rvi_ivari,
																	@rvi_ivarni,
																	@rvi_ivariporc,
																	@rvi_ivarniporc,
																	@rvi_importe,
																	@pr_id,
																	@ccos_id

	while @@fetch_status=0
	begin

		exec sp_dbgetnewid 'RemitoVentaItemTMP', 'rviTMP_id', @rviTMP_id out, 0

		insert into RemitoVentaItemTMP (
																		rvTMP_id,
																		rviTMP_id,
																		rvi_id,
																		rvi_orden,
																		rvi_cantidad,
																		rvi_cantidadaremitir,
																		rvi_pendiente,
																		rvi_pendientefac,
																		rvi_descrip,
																		rvi_precio,
																		rvi_precioUsr,
																		rvi_precioLista,
																		rvi_descuento,
																		rvi_neto,
																		rvi_ivari,
																		rvi_ivarni,
																		rvi_ivariporc,
																		rvi_ivarniporc,
																		rvi_importe,
																		rvi_importCodigo,
																		pr_id,
																		ccos_id

																)
												values  (
																		@rvTMP_id,
																		@rviTMP_id,
																		0,
																		@rvi_orden,
																		@rvi_cantidad,
																		@rvi_cantidadaremitir,
																		@rvi_pendiente,
																		@rvi_pendientefac,
																		@rvi_descrip,
																		@rvi_precio,
																		@rvi_precioUsr,
																		@rvi_precioLista,
																		@rvi_descuento,
																		@rvi_neto,
																		@rvi_ivari,
																		@rvi_ivarni,
																		@rvi_ivariporc,
																		@rvi_ivarniporc,
																		@rvi_importe,
																		'',
																		@pr_id,
																		@ccos_id
																)
		fetch next from c_Items into
																		@rvi_orden,
																		@rvi_cantidad,
																		@rvi_cantidadaremitir,
																		@rvi_pendiente,
																		@rvi_pendientefac,
																		@rvi_descrip,
																		@rvi_precio,
																		@rvi_precioUsr,
																		@rvi_precioLista,
																		@rvi_descuento,
																		@rvi_neto,
																		@rvi_ivari,
																		@rvi_ivarni,
																		@rvi_ivariporc,
																		@rvi_ivarniporc,
																		@rvi_importe,
																		@pr_id,
																		@ccos_id
	end

	close c_Items
	deallocate c_Items

	declare @rv_id 		int
	declare @rvfv_id	int

	exec sp_DocRemitoVentaSave @rvTMP_id, @rv_id out, 0
	if @@error <> 0 goto ControlError

	---------------------------------------------------------------------------------------------------------------
	-- Aplicacion

	declare @fvi_id 				int
	declare @pvi_id         int
	declare @pvfv_cantidad  decimal(18,6)
	declare @fvi_cantidad 	decimal(18,6)
	declare @fvi_orden			int
	declare @rvi_id         int
	declare @pvrv_id        int

	-- Si existe una aplicacion entre la factura y pedidos de venta
	-- traspaso dicha aplicacion al remito que acabo de generar
	--
	if exists(select * from FacturaVentaItem fvi 
															inner join PedidoFacturaVenta pvfv 
																			on 		fvi.fv_id  = @@fv_id 
																				and fvi.fvi_id = pvfv.fvi_id
						) 
	begin
	
		declare c_aplicRemito insensitive cursor for 
							select pvfv_cantidad, pvi_id, fvi_orden 
							from FacturaVentaItem fvi 
															inner join PedidoFacturaVenta pvfv 
																			on 		fvi.fv_id  = @@fv_id 
																				and fvi.fvi_id = pvfv.fvi_id
	
		open c_aplicRemito
	
		fetch next from c_aplicRemito into @pvfv_cantidad, @pvi_id, @fvi_orden
		while @@fetch_status=0
		begin
	
			exec sp_dbgetnewid 'PedidoRemitoVenta', 'pvrv_id', @pvrv_id out, 0
	
			select @rvi_id = rvi_id from RemitoVentaItem where rv_id = @rv_id and rvi_orden = @fvi_orden
	
			insert into PedidoRemitoVenta (
																				pvrv_id,
																				pvrv_cantidad,
																				pvi_id,
																				rvi_id
																			)
															values (
																				@pvrv_id,
																				@pvfv_cantidad,
																				@pvi_id,
																				@rvi_id
																			)
			fetch next from c_aplicRemito into @pvfv_cantidad, @pvi_id, @fvi_orden
		end
	
		close c_aplicRemito
		deallocate c_aplicRemito

		delete PedidoFacturaVenta 
		where pvfv_id in (
											select pvfv_id from FacturaVentaItem fvi 
																						inner join PedidoFacturaVenta pvfv 
																										on 		fvi.fv_id  = @@fv_id 
																											and fvi.fvi_id = pvfv.fvi_id
 											)
	end

	declare c_aplicRemito insensitive cursor for 
						select fvi_id, fvi_cantidad, fvi_orden from FacturaVentaItem where fv_id = @@fv_id order by fvi_orden

	open c_aplicRemito

	fetch next from c_aplicRemito into @fvi_id, @fvi_cantidad, @fvi_orden
	while @@fetch_status=0
	begin

		exec sp_dbgetnewid 'RemitoFacturaVenta', 'rvfv_id', @rvfv_id out, 0

		select @rvi_id = rvi_id from RemitoVentaItem where rv_id = @rv_id and rvi_orden = @fvi_orden

		insert into RemitoFacturaVenta (
																			rvfv_id,
																			rvfv_cantidad,
																			rvi_id,
																			fvi_id
																		)
														values (
																			@rvfv_id,
																			@fvi_cantidad,
																			@rvi_id,
																			@fvi_id
																		)
		fetch next from c_aplicRemito into @fvi_id, @fvi_cantidad, @fvi_orden
	end

	close c_aplicRemito
	deallocate c_aplicRemito


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- PENDIENTE
	declare @bSuccess  tinyint

	exec sp_DocFacturaVentaSetItemPendiente @@fv_id, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

	-- Actualizo la deuda de la Pedido
	exec sp_DocRemitoVentaSetPendiente @rv_id, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	exec sp_DocRemitoVentaSetCredito @rv_id
	if @@error <> 0 goto ControlError

	exec sp_DocRemitoVentaSetEstado @rv_id
	if @@error <> 0 goto ControlError

	set @@bError = 0

	return
ControlError:

	set @@bError = -1
	set @@MsgError = 'Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaRemitoSave.'

end

go