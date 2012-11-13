if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVtaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVtaSaveAplic]

/*

 sp_DocRemitoVtaSaveAplic 124

*/

GO
create procedure sp_DocRemitoVtaSaveAplic (
	@@rv_id 			int,
	@@rvTMP_id    int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @rvi_id 	int
	declare @iOrden 	int 
	declare @doct_id 	int

	select @doct_id = doct_id from RemitoVenta where rv_id = @@rv_id

	create table #PedidoVentaRemito  		(pv_id int)
	create table #OrdenServicioRemito  	(os_id int)
	create table #FacturaVentaRemito 		(fv_id int)
	create table #RemitoDevolucionVenta (rv_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PEDIDO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvrv_id 							int
declare @pvrv_cantidad				decimal(18,6)
declare @pvi_id               int

	set @iOrden = 0

	insert into #PedidoVentaRemito(pv_id) select distinct pv_id 
																			 	from PedidoRemitoVenta pvrv inner join PedidoVentaItem pvi 
																																						on pvrv.pvi_id = pvi.pvi_id 
																																		inner join RemitoVentaItem rvi 
																																						on pvrv.rvi_id = rvi.rvi_id 
 																			 	where not exists(
 																											select * from PedidoRemitoVentaTMP 
  																														where rvTMP_id = @@rvTMP_id and pvi_id = pvrv.pvi_id
 																											)
																						and rvi.rv_id = @@rv_id

	-- Borro toda la aplicacion actual de este remito con pedidos
	--
	delete PedidoRemitoVenta where rvi_id in (select rvi_id from RemitoVentaItem where rv_id = @@rv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los pedidos
	declare c_aplicPedido insensitive cursor for

  			select 
								pvrv_id, 
								rvi_id,
								pvi_id, 
								pvrv_cantidad
				
				from PedidoRemitoVentaTMP where rvTMP_id = @@rvTMP_id

	open c_aplicPedido

  fetch next from c_aplicPedido into @pvrv_id, @rvi_id, @pvi_id, @pvrv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el rvi que le corresponde a este pvi
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @rvi_id = rvi_id from RemitoVentaItem where rv_id = @@rv_id and rvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PedidoRemitoVenta','pvrv_id',@pvrv_id out,0
		insert into PedidoRemitoVenta (
																				pvrv_id,
																				pvrv_cantidad,
																				rvi_id,
																				pvi_id
																			)
                            	values (
																				@pvrv_id,
																				@pvrv_cantidad,
																				@rvi_id,		
																				@pvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPedido into @pvrv_id, @rvi_id, @pvi_id, @pvrv_cantidad
	end

  close c_aplicPedido
  deallocate c_aplicPedido

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN PEDIDOS                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocRemitoVtaPedidoSetPendiente @@rv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION ORDEN                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @osrv_id 							int
declare @osrv_cantidad				decimal(18,6)
declare @osi_id               int

	set @iOrden = 0

	insert into #OrdenServicioRemito(os_id) select distinct os_id 
																			 	from OrdenRemitoVenta osrv inner join OrdenServicioItem osi 
																																						on osrv.osi_id = osi.osi_id 
																																		inner join RemitoVentaItem rvi 
																																						on osrv.rvi_id = rvi.rvi_id 
 																			 	where not exists(
 																											select * from OrdenRemitoVentaTMP 
  																														where rvTMP_id = @@rvTMP_id and osi_id = osrv.osi_id
 																											)
																						and rvi.rv_id = @@rv_id

	-- Borro toda la aplicacion actual de este remito con ordenes de servicio
	--
	delete OrdenRemitoVenta where rvi_id in (select rvi_id from RemitoVentaItem where rv_id = @@rv_id)

	-- Creo un cursor sobre los registros de aplicacion entre el remito
	-- y las ordenes
	declare c_aplicOrden insensitive cursor for

  			select 
								osrv_id, 
								rvi_id,
								osi_id, 
								osrv_cantidad
				
				from OrdenRemitoVentaTMP where rvTMP_id = @@rvTMP_id

	open c_aplicOrden

  fetch next from c_aplicOrden into @osrv_id, @rvi_id, @osi_id, @osrv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el rvi que le corresponde a este osi
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
	
		if @osi_id > 0 -- Solo equipos
				select @rvi_id = rvi_id from RemitoVentaItem where rv_id = @@rv_id and rvi_orden = @iOrden
		end

		if @osi_id > 0 begin -- Descarto los repuesto ya que me vienen con Id en negativo
												 -- para que pueda distinguirlos

			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'OrdenRemitoVenta','osrv_id',@osrv_id out,0
			insert into OrdenRemitoVenta (
																					osrv_id,
																					osrv_cantidad,
																					rvi_id,
																					osi_id
																				)
	                            	values (
																					@osrv_id,
																					@osrv_cantidad,
																					@rvi_id,		
																					@osi_id
																				)
			if @@error <> 0 goto ControlError

		end

	  fetch next from c_aplicOrden into @osrv_id, @rvi_id, @osi_id, @osrv_cantidad
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

	exec sp_DocRemitoVtaOrdenSetPendiente @@rv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION FACTURA                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @rvfv_id 							int
declare @rvfv_cantidad				decimal(18,6)
declare @fvi_id               int

	set @iOrden = 0

	insert into #FacturaVentaRemito(fv_id) select distinct fv_id 
																				 from RemitoFacturaVenta rvfv inner join FacturaVentaItem fvi 
																																							on rvfv.fvi_id = fvi.fvi_id 
																																		inner join RemitoVentaItem rvi 
																																						on rvfv.rvi_id = rvi.rvi_id 
		 																		 where not exists(
		 																											select * from RemitoFacturaVentaTMP 
		  																														where rvTMP_id = @@rvTMP_id and fvi_id = rvfv.fvi_id
		 																											)
																						and rvi.rv_id = @@rv_id

	-- Borro toda la aplicacion actual de este remito con pedidos
	--
	delete RemitoFacturaVenta where rvi_id in (select rvi_id from RemitoVentaItem where rv_id = @@rv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los remitos
	declare c_aplicRemito insensitive cursor for

  			select 
								rvfv_id,
								rvi_id,  
								fvi_id, 
								rvfv_cantidad

				 from RemitoFacturaVentaTMP where rvTMP_id = @@rvTMP_id

	open c_aplicRemito

  fetch next from c_aplicRemito into @rvfv_id, @rvi_id, @fvi_id, @rvfv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el rvi que le corresponde a este fvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @rvi_id = rvi_id from RemitoVentaItem where rv_id = @@rv_id and rvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'RemitoFacturaVenta','rvfv_id',@rvfv_id out,0
		insert into RemitoFacturaVenta (
																				rvfv_id,
																				rvfv_cantidad,
																				rvi_id,
																				fvi_id
																			)
                            	values (
																				@rvfv_id,
																				@rvfv_cantidad,
																				@rvi_id,		
																				@fvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicRemito into @rvfv_id, @rvi_id, @fvi_id, @rvfv_cantidad
	end

  close c_aplicRemito
  deallocate c_aplicRemito

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN FACTURAS                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocRemitoVtaFacturaSetPendiente @@rv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @rvdv_id 							int
declare @rvdv_cantidad				decimal(18,6)
declare @rvi_id_remito        int
declare @rvi_id_devolucion    int

	set @iOrden = 0

	if @doct_id = 3 begin

		insert into #RemitoDevolucionVenta(rv_id) select distinct rvi.rv_id 
																					 from RemitoDevolucionVenta rvdv inner join RemitoVentaItem rvi 
																																								on rvdv.rvi_id_devolucion = rvi.rvi_id 
	
																																					 inner join RemitoVentaItem rvir 
																																								on rvdv.rvi_id_remito = rvir.rvi_id
			 																		 where not exists(
			 																											select * from RemitoDevolucionVentaTMP 
			  																														where rvTMP_id = @@rvTMP_id and rvi_id_devolucion = rvdv.rvi_id_devolucion
			 																											)
																								and rvir.rv_id = @@rv_id
	
		-- Borro toda la aplicacion actual de este remito con devoluciones
		--
		delete RemitoDevolucionVenta where rvi_id_remito in (select rvi_id from RemitoVentaItem where rv_id = @@rv_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre el remito
		-- y las devoluciones
		declare c_aplicRemito insensitive cursor for
	
	  			select 
									rvdv_id,
									rvi_id_remito,  
									rvi_id_devolucion, 
									rvdv_cantidad
	
					 from RemitoDevolucionVentaTMP where rvTMP_id = @@rvTMP_id
	
		open c_aplicRemito
	
	  fetch next from c_aplicRemito into @rvdv_id, @rvi_id_remito, @rvi_id_devolucion, @rvdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el rvi_pedido que le corresponde a este rvi_devolucion
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @rvi_id_remito = rvi_id from RemitoVentaItem where rv_id = @@rv_id and rvi_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'RemitoDevolucionVenta','rvdv_id',@rvdv_id out,0
			insert into RemitoDevolucionVenta (
																					rvdv_id,
																					rvdv_cantidad,
																					rvi_id_remito,
																					rvi_id_devolucion
																				)
	                            	values (
																					@rvdv_id,
																					@rvdv_cantidad,
																					@rvi_id_remito,		
																					@rvi_id_devolucion
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicRemito into @rvdv_id, @rvi_id_remito, @rvi_id_devolucion, @rvdv_cantidad
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
	
		exec sp_DocRemitoVtaDevolucionSetPendiente @@rv_id, @@bSuccess	out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
	end else begin

		insert into #RemitoDevolucionVenta(rv_id) select distinct rvi.rv_id 
																					 from RemitoDevolucionVenta rvdv inner join RemitoVentaItem rvi 
																																								on rvdv.rvi_id_remito = rvi.rvi_id 
	
																																					 inner join RemitoVentaItem rvid 
																																								on rvdv.rvi_id_devolucion = rvid.rvi_id
			 																		 where not exists(
			 																											select * from RemitoDevolucionVentaTMP 
			  																														where rvTMP_id = @@rvTMP_id and rvi_id_remito = rvdv.rvi_id_remito
			 																											)
																								and rvid.rv_id = @@rv_id
	
		-- Borro toda la aplicacion actual de esta devolucion con remitos
		--
		delete RemitoDevolucionVenta where rvi_id_devolucion in (select rvi_id from RemitoVentaItem where rv_id = @@rv_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre la devolucion
		-- y los remitos
		declare c_aplicRemito insensitive cursor for
	
	  			select 
									rvdv_id,
									rvi_id_devolucion,  
									rvi_id_remito, 
									rvdv_cantidad
	
					 from RemitoDevolucionVentaTMP where rvTMP_id = @@rvTMP_id
	
		open c_aplicRemito
	
	  fetch next from c_aplicRemito into @rvdv_id, @rvi_id_devolucion, @rvi_id_remito, @rvdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el rvi_devolucion que le corresponde a este rvi_pedido
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @rvi_id_devolucion = rvi_id from RemitoVentaItem where rv_id = @@rv_id and rvi_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'RemitoDevolucionVenta','rvdv_id',@rvdv_id out,0
			insert into RemitoDevolucionVenta (
																					rvdv_id,
																					rvdv_cantidad,
																					rvi_id_devolucion,
																					rvi_id_remito
																				)
	                            	values (
																					@rvdv_id,
																					@rvdv_cantidad,
																					@rvi_id_devolucion,		
																					@rvi_id_remito
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicRemito into @rvdv_id, @rvi_id_devolucion, @rvi_id_remito, @rvdv_cantidad
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
	
		exec sp_DocRemitoVtaDevolucionSetPendiente @@rv_id, @@bSuccess	out
	
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

	exec sp_DocRemitoVentaSetPendiente @@rv_id, @@bSuccess	out
	
	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError


	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculación del remito de venta con las facturas, pedidos y devoluciones. sp_DocRemitoVtaSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO