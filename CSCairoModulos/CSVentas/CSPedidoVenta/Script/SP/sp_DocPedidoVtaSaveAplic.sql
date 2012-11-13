if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVtaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVtaSaveAplic]

/*

 sp_DocPedidoVtaSaveAplic 124

*/

GO
create procedure sp_DocPedidoVtaSaveAplic (
	@@pv_id 			int,
	@@pvTMP_id    int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @pvi_id int
	declare @iOrden int 
	declare @doct_id 	int

	select @doct_id = doct_id from PedidoVenta where pv_id = @@pv_id

	create table #PresupuestoVtaPedido  (prv_id int)
	create table #PedidoPackingList    	(pklst_id int)
	create table #PedidoVentaFactura  	(fv_id int)
	create table #PedidoVentaRemito   	(rv_id int)
	create table #PedidoDevolucionVenta	(pv_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PRESUPUESTO                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @prvpv_id 						int
declare @prvpv_cantidad				decimal(18,6)
declare @prvi_id              int

	set @iOrden = 0

	insert into #PresupuestoVtaPedido(prv_id) select distinct prv_id 
																			 	from PresupuestoPedidoVenta pvrpv 
																																		inner join PresupuestoVentaItem prvi 
																																						on pvrpv.prvi_id = prvi.prvi_id 
																																		inner join PedidoVentaItem pvi 
																																						on pvrpv.pvi_id = pvi.pvi_id 
 																			 	where not exists(
 																											select * from PresupuestoPedidoVentaTMP 
  																														where pvTMP_id = @@pvTMP_id and prvi_id = pvrpv.prvi_id
 																											)
																						and pvi.pv_id = @@pv_id

	-- Borro toda la aplicacion actual de este pedido con presupuestos
	--
	delete PresupuestoPedidoVenta where pvi_id in (select pvi_id from PedidoVentaItem where pv_id = @@pv_id)

	-- Creo un cursor sobre los registros de aplicacion entre el pedido
	-- y los presupuestos
	declare c_aplicPresupuesto insensitive cursor for

  			select 
								prvpv_id, 
								pvi_id,
								prvi_id, 
								prvpv_cantidad
				
				from PresupuestoPedidoVentaTMP where pvTMP_id = @@pvTMP_id

	open c_aplicPresupuesto

  fetch next from c_aplicPresupuesto into @prvpv_id, @pvi_id, @prvi_id, @prvpv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pvi que le corresponde a este prvi
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pvi_id = pvi_id from PedidoVentaItem where pv_id = @@pv_id and pvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PresupuestoPedidoVenta','prvpv_id',@prvpv_id out,0
		insert into PresupuestoPedidoVenta (
																				prvpv_id,
																				prvpv_cantidad,
																				pvi_id,
																				prvi_id
																			)
                            	values (
																				@prvpv_id,
																				@prvpv_cantidad,
																				@pvi_id,		
																				@prvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPresupuesto into @prvpv_id, @pvi_id, @prvi_id, @prvpv_cantidad
	end

  close c_aplicPresupuesto
  deallocate c_aplicPresupuesto

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN PRESUPUESTO                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoVtaPresupuestoSetPendiente @@pv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PACKINGLIST                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvpk_id 							int
declare @pvpk_cantidad				decimal(18,6)
declare @pklsti_id            int

	set @iOrden = 0

	insert into #PedidoPackingList(pklst_id) select distinct pv_id 
																			 	from PedidoPackingList pvpk inner join PackingListItem pklsti 
																																						on pvpk.pklsti_id = pklsti.pklsti_id 
																																		inner join PedidoVentaItem pvi
        																																		on pvpk.pvi_id = pvi.pvi_id
 																			 	where not exists(
 																											select * from PedidoPackingListTMP 
  																														where pvTMP_id = @@pvTMP_id and pklsti_id = pvpk.pklsti_id
 																											)
																							and pvi.pv_id = @@pv_id

	-- Borro toda la aplicacion actual de este pedido con PackingList
	--
	delete PedidoPackingList where pvi_id in (select pvi_id from PedidoVentaItem where pv_id = @@pv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los pedidos
	declare c_aplicPacking insensitive cursor for

  			select 
								pvpklst_id, 
								pvi_id,
								pklsti_id, 
								pvpklst_cantidad
				
				from PedidoPackingListTMP where pvTMP_id = @@pvTMP_id

	open c_aplicPacking

  fetch next from c_aplicPacking into @pvpk_id, @pvi_id, @pklsti_id, @pvpk_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pvi que le corresponde a este pklsti
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pvi_id = pvi_id from PedidoVentaItem where pv_id = @@pv_id and pvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PedidoPackingList','pvpklst_id',@pvpk_id out,0
		if @@error <> 0 goto ControlError

		insert into PedidoPackingList (
																				pvpklst_id,
																				pvpklst_cantidad,
																				pvi_id,
																				pklsti_id
																			)
                            	values (
																				@pvpk_id,
																				@pvpk_cantidad,
																				@pvi_id,		
																				@pklsti_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPacking into @pvpk_id, @pvi_id, @pklsti_id, @pvpk_cantidad
	end

  close c_aplicPacking
  deallocate c_aplicPacking

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN PACKINGLIST                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoVtaPackingSetPendiente @@pv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION FACTURA                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvfv_id 							int
declare @pvfv_cantidad				decimal(18,6)
declare @fvi_id               int

	set @iOrden = 0

	insert into #PedidoVentaFactura(fv_id) select distinct fv_id 
																				 from PedidoFacturaVenta pvfv inner join FacturaVentaItem fvi 
																																							on pvfv.fvi_id = fvi.fvi_id 
																																		  inner join PedidoVentaItem pvi
        																																			on pvfv.pvi_id = pvi.pvi_id
		 																		 where not exists(
		 																											select * from PedidoFacturaVentaTMP 
		  																														where pvTMP_id = @@pvTMP_id and fvi_id = pvfv.fvi_id
		 																											)
																							and pvi.pv_id = @@pv_id

	-- Borro toda la aplicacion actual de esta factura con pedidos
	--
	delete PedidoFacturaVenta where pvi_id in (select pvi_id from PedidoVentaItem where pv_id = @@pv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los remitos
	declare c_aplicFactura insensitive cursor for

  			select 
								pvfv_id,
								pvi_id,  
								fvi_id, 
								pvfv_cantidad

				 from PedidoFacturaVentaTMP where pvTMP_id = @@pvTMP_id

	open c_aplicFactura

  fetch next from c_aplicFactura into @pvfv_id, @pvi_id, @fvi_id, @pvfv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pvi que le corresponde a este fvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pvi_id = pvi_id from PedidoVentaItem where pv_id = @@pv_id and pvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'PedidoFacturaVenta','pvfv_id',@pvfv_id out,0
		if @@error <> 0 goto ControlError

		insert into PedidoFacturaVenta (
																				pvfv_id,
																				pvfv_cantidad,
																				pvi_id,
																				fvi_id
																			)
                            	values (
																				@pvfv_id,
																				@pvfv_cantidad,
																				@pvi_id,		
																				@fvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicFactura into @pvfv_id, @pvi_id, @fvi_id, @pvfv_cantidad
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

	exec sp_DocPedidoVtaFacturaSetPendiente @@pv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION REMITO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvrv_id 							int
declare @pvrv_cantidad				decimal(18,6)
declare @rvi_id               int

	set @iOrden = 0

	insert into #PedidoVentaRemito(rv_id) select distinct rv_id 
																				 from PedidoRemitoVenta pvrv inner join RemitoVentaItem rvi 
																																							on pvrv.rvi_id = rvi.rvi_id 
																																		 inner join PedidoVentaItem pvi
        																																			on pvrv.pvi_id = pvi.pvi_id
		 																		 where not exists(
		 																											select * from PedidoRemitoVentaTMP 
		  																														where pvTMP_id = @@pvTMP_id and rvi_id = pvrv.rvi_id
		 																											)
																							and pvi.pv_id = @@pv_id

	-- Borro toda la aplicacion actual de esta Remito con pedidos
	--
	delete PedidoRemitoVenta where pvi_id in (select pvi_id from PedidoVentaItem where pv_id = @@pv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la Remito
	-- y los remitos
	declare c_aplicRemito insensitive cursor for

  			select 
								pvrv_id,
								pvi_id,  
								rvi_id, 
								pvrv_cantidad

				 from PedidoRemitoVentaTMP where pvTMP_id = @@pvTMP_id

	open c_aplicRemito

  fetch next from c_aplicRemito into @pvrv_id, @pvi_id, @rvi_id, @pvrv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pvi que le corresponde a este rvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pvi_id = pvi_id from PedidoVentaItem where pv_id = @@pv_id and pvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'PedidoRemitoVenta','pvrv_id',@pvrv_id out,0
		if @@error <> 0 goto ControlError

		insert into PedidoRemitoVenta (
																				pvrv_id,
																				pvrv_cantidad,
																				pvi_id,
																				rvi_id
																			)
                            	values (
																				@pvrv_id,
																				@pvrv_cantidad,
																				@pvi_id,		
																				@rvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicRemito into @pvrv_id, @pvi_id, @rvi_id, @pvrv_cantidad
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

	exec sp_DocPedidoVtaRemitoSetPendiente @@pv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvdv_id 							int
declare @pvdv_cantidad				decimal(18,6)
declare @pvi_id_pedido        int
declare @pvi_id_devolucion    int

	set @iOrden = 0

	if @doct_id = 5 begin

		insert into #PedidoDevolucionVenta(pv_id) select distinct pvi.pv_id 
																					 from PedidoDevolucionVenta pvdv inner join PedidoVentaItem pvi 
																																								on pvdv.pvi_id_devolucion = pvi.pvi_id 
	
																																					 inner join PedidoVentaItem pvir 
																																								on pvdv.pvi_id_pedido = pvir.pvi_id
			 																		 where not exists(
			 																											select * from PedidoDevolucionVentaTMP 
			  																														where pvTMP_id = @@pvTMP_id and pvi_id_devolucion = pvdv.pvi_id_devolucion
			 																											)
																								and pvir.pv_id = @@pv_id
	
		-- Borro toda la aplicacion actual de este Pedido con devoluciones
		--
		delete PedidoDevolucionVenta where pvi_id_pedido in (select pvi_id from PedidoVentaItem where pv_id = @@pv_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre el Pedido
		-- y las devoluciones
		declare c_aplicPedido insensitive cursor for
	
	  			select 
									pvdv_id,
									pvi_id_pedido,  
									pvi_id_devolucion, 
									pvdv_cantidad
	
					 from PedidoDevolucionVentaTMP where pvTMP_id = @@pvTMP_id
	
		open c_aplicPedido
	
	  fetch next from c_aplicPedido into @pvdv_id, @pvi_id_pedido, @pvi_id_devolucion, @pvdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el pvi_pedido que le corresponde a este pvi_devolucion
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @pvi_id_pedido = pvi_id from PedidoVentaItem where pv_id = @@pv_id and pvi_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PedidoDevolucionVenta','pvdv_id',@pvdv_id out,0
			if @@error <> 0 goto ControlError

			insert into PedidoDevolucionVenta (
																					pvdv_id,
																					pvdv_cantidad,
																					pvi_id_pedido,
																					pvi_id_devolucion
																				)
	                            	values (
																					@pvdv_id,
																					@pvdv_cantidad,
																					@pvi_id_pedido,		
																					@pvi_id_devolucion
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPedido into @pvdv_id, @pvi_id_pedido, @pvi_id_devolucion, @pvdv_cantidad
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
	
		exec sp_DocPedidoVtaDevolucionSetPendiente @@pv_id, @@bSuccess	out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
	end else begin

		insert into #PedidoDevolucionVenta(pv_id) select distinct pvi.pv_id 
																					 from PedidoDevolucionVenta pvdv inner join PedidoVentaItem pvi 
																																								on pvdv.pvi_id_pedido = pvi.pvi_id 
	
																																					 inner join PedidoVentaItem pvid 
																																								on pvdv.pvi_id_devolucion = pvid.pvi_id
			 																		 where not exists(
			 																											select * from PedidoDevolucionVentaTMP 
			  																														where pvTMP_id = @@pvTMP_id and pvi_id_pedido = pvdv.pvi_id_pedido
			 																											)
																								and pvid.pv_id = @@pv_id
	
		-- Borro toda la aplicacion actual de esta devolucion con pedidos
		--
		delete PedidoDevolucionVenta where pvi_id_devolucion in (select pvi_id from PedidoVentaItem where pv_id = @@pv_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre la devolucion
		-- y los Pedidos
		declare c_aplicPedido insensitive cursor for
	
	  			select 
									pvdv_id,
									pvi_id_devolucion,  
									pvi_id_pedido, 
									pvdv_cantidad
	
					 from PedidoDevolucionVentaTMP where pvTMP_id = @@pvTMP_id
	
		open c_aplicPedido
	
	  fetch next from c_aplicPedido into @pvdv_id, @pvi_id_devolucion, @pvi_id_pedido, @pvdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el pvi_devolucion que le corresponde a este pvi_pedido
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @pvi_id_devolucion = pvi_id from PedidoVentaItem where pv_id = @@pv_id and pvi_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PedidoDevolucionVenta','pvdv_id',@pvdv_id out,0
			if @@error <> 0 goto ControlError

			insert into PedidoDevolucionVenta (
																					pvdv_id,
																					pvdv_cantidad,
																					pvi_id_devolucion,
																					pvi_id_pedido
																				)
	                            	values (
																					@pvdv_id,
																					@pvdv_cantidad,
																					@pvi_id_devolucion,		
																					@pvi_id_pedido
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPedido into @pvdv_id, @pvi_id_devolucion, @pvi_id_pedido, @pvdv_cantidad
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
	
		exec sp_DocPedidoVtaDevolucionSetPendiente @@pv_id, @@bSuccess	out
	
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
	exec sp_DocPedidoVentaSetPendiente @@pv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculación del pedido de venta con los remitos, facturas, devoluciones y packing list. sp_DocPedidoVtaSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO