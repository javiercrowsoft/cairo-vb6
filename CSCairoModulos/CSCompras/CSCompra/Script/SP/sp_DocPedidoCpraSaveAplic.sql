if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCpraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCpraSaveAplic]

/*

 sp_DocPedidoCpraSaveAplic 124

*/

GO
create procedure sp_DocPedidoCpraSaveAplic (
	@@pc_id 			int,
	@@pcTMP_id    int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @pci_id 	int
	declare @iOrden 	int 
	declare @doct_id 	int

	select @doct_id = doct_id from PedidoCompra where pc_id = @@pc_id

	create table #PedidoCompraOrden  			(oc_id int)
	create table #PedidoCompraCotizacion  (cot_id int)
	create table #PedidoDevolucionCompra	(pc_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION ORDEN COMPRA                                                //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pcoc_id 							int
declare @pcoc_cantidad				decimal(18,6)
declare @oci_id               int

	set @iOrden = 0

	insert into #PedidoCompraOrden(oc_id) select distinct oc_id 
																				 from PedidoOrdenCompra pcoc inner join OrdenCompraItem oci 
																																							on pcoc.oci_id = oci.oci_id 
																																		  inner join PedidoCompraItem pci
        																																			on pcoc.pci_id = pci.pci_id
		 																		 where not exists(
		 																											select * from PedidoOrdenCompraTMP 
		  																														where pcTMP_id = @@pcTMP_id and oci_id = pcoc.oci_id
		 																											)
																							and pci.pc_id = @@pc_id
		 																											
	-- Borro toda la aplicacion actual de esta orden de compra con pedidos
	--
	delete PedidoOrdenCompra where pci_id in (select pci_id from PedidoCompraItem where pc_id = @@pc_id)

	-- Creo un cursor sobre los registros de aplicacion entre la orden de compra
	-- y las cotizaciones
	declare c_aplicOrden insensitive cursor for

  			select 
								pcoc_id,
								pci_id,  
								oci_id, 
								pcoc_cantidad

				 from PedidoOrdenCompraTMP where pcTMP_id = @@pcTMP_id

	open c_aplicOrden

  fetch next from c_aplicOrden into @pcoc_id, @pci_id, @oci_id, @pcoc_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pci que le corresponde a este oci
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pci_id = pci_id from PedidoCompraItem where pc_id = @@pc_id and pci_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'PedidoOrdenCompra','pcoc_id',@pcoc_id out,0
		insert into PedidoOrdenCompra (
																				pcoc_id,
																				pcoc_cantidad,
																				pci_id,
																				oci_id
																			)
                            	values (
																				@pcoc_id,
																				@pcoc_cantidad,
																				@pci_id,		
																				@oci_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicOrden into @pcoc_id, @pci_id, @oci_id, @pcoc_cantidad
	end

  close c_aplicOrden
  deallocate c_aplicOrden

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ORDENES DE COMPRA                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoCpraOrdenSetPendiente @@pc_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION COTIZACIONES                                                //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pccot_id 							int
declare @pccot_cantidad				decimal(18,6)
declare @coti_id               int

	set @iOrden = 0

	insert into #PedidoCompraCotizacion(cot_id) select distinct cot_id 
																				 from PedidoCotizacionCompra pccot inner join CotizacionCompraItem coti 
																																							on pccot.coti_id = coti.coti_id 
																																		 			inner join PedidoCompraItem pci
        																																			on pccot.pci_id = pci.pci_id
		 																		 where not exists(
		 																											select * from PedidoCotizacionCompraTMP 
		  																														where pcTMP_id = @@pcTMP_id and coti_id = pccot.coti_id
		 																											)
																							and pci.pc_id = @@pc_id

	-- Borro toda la aplicacion actual de esta cotizacion con pedidos
	--
	delete PedidoCotizacionCompra where pci_id in (select pci_id from PedidoCompraItem where pc_id = @@pc_id)

	-- Creo un cursor sobre los registros de aplicacion entre la cotizacion
	-- y los pedidos
	declare c_aplicCotizacion insensitive cursor for

  			select 
								pccot_id,
								pci_id,  
								coti_id, 
								pccot_cantidad

				 from PedidoCotizacionCompraTMP where pcTMP_id = @@pcTMP_id

	open c_aplicCotizacion

  fetch next from c_aplicCotizacion into @pccot_id, @pci_id, @coti_id, @pccot_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pci que le corresponde a este coti
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pci_id = pci_id from PedidoCompraItem where pc_id = @@pc_id and pci_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'PedidoCotizacionCompra','pccot_id',@pccot_id out,0
		insert into PedidoCotizacionCompra (
																				pccot_id,
																				pccot_cantidad,
																				pci_id,
																				coti_id
																			)
                            	values (
																				@pccot_id,
																				@pccot_cantidad,
																				@pci_id,		
																				@coti_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicCotizacion into @pccot_id, @pci_id, @coti_id, @pccot_cantidad
	end

  close c_aplicCotizacion
  deallocate c_aplicCotizacion

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ORDENES DE COMPRA                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoCpraCotizacionSetPendiente @@pc_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pcdc_id 							int
declare @pcdc_cantidad				decimal(18,6)
declare @pci_id_pedido        int
declare @pci_id_devolucion    int

	set @iOrden = 0

	if @doct_id = 6 begin

		insert into #PedidoDevolucionCompra(pc_id) select distinct pci.pc_id 
																					 from PedidoDevolucionCompra pcdc inner join PedidoCompraItem pci 
																																								on pcdc.pci_id_devolucion = pci.pci_id 
	
																																					 inner join PedidoCompraItem pcir 
																																								on pcdc.pci_id_pedido = pcir.pci_id
			 																		 where not exists(
			 																											select * from PedidoDevolucionCompraTMP 
			  																														where pcTMP_id = @@pcTMP_id and pci_id_devolucion = pcdc.pci_id_devolucion
			 																											)
																								and pcir.pc_id = @@pc_id
	
		-- Borro toda la aplicacion actual de este Pedido con devoluciones
		--
		delete PedidoDevolucionCompra where pci_id_pedido in (select pci_id from PedidoCompraItem where pc_id = @@pc_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre el Pedido
		-- y las devoluciones
		declare c_aplicPedido insensitive cursor for
	
	  			select 
									pcdc_id,
									pci_id_pedido,  
									pci_id_devolucion, 
									pcdc_cantidad
	
					 from PedidoDevolucionCompraTMP where pcTMP_id = @@pcTMP_id
	
		open c_aplicPedido
	
	  fetch next from c_aplicPedido into @pcdc_id, @pci_id_pedido, @pci_id_devolucion, @pcdc_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el pci_pedido que le corresponde a este pci_devolucion
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @pci_id_pedido = pci_id from PedidoCompraItem where pc_id = @@pc_id and pci_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PedidoDevolucionCompra','pcdc_id',@pcdc_id out,0
			insert into PedidoDevolucionCompra (
																					pcdc_id,
																					pcdc_cantidad,
																					pci_id_pedido,
																					pci_id_devolucion
																				)
	                            	values (
																					@pcdc_id,
																					@pcdc_cantidad,
																					@pci_id_pedido,		
																					@pci_id_devolucion
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPedido into @pcdc_id, @pci_id_pedido, @pci_id_devolucion, @pcdc_cantidad
		end
	
	  close c_aplicPedido
	  deallocate c_aplicPedido
	
	/*
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                               //
	//                                        UPDATE PENDIENTE EN PedidoS                                            //
	//                                                                                                               //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
	
		exec sp_DocPedidoCpraDevolucionSetPendiente @@pc_id, @@bSuccess	out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
	end else begin

		insert into #PedidoDevolucionCompra(pc_id) select distinct pci.pc_id 
																					 from PedidoDevolucionCompra pcdc inner join PedidoCompraItem pci 
																																								on pcdc.pci_id_pedido = pci.pci_id 
	
																																					 inner join PedidoCompraItem pcid 
																																								on pcdc.pci_id_devolucion = pcid.pci_id
			 																		 where not exists(
			 																											select * from PedidoDevolucionCompraTMP 
			  																														where pcTMP_id = @@pcTMP_id and pci_id_pedido = pcdc.pci_id_pedido
			 																											)
																								and pcid.pc_id = @@pc_id
	
		-- Borro toda la aplicacion actual de esta devolucion con Pedidos
		--
		delete PedidoDevolucionCompra where pci_id_devolucion in (select pci_id from PedidoCompraItem where pc_id = @@pc_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre la devolucion
		-- y los Pedidos
		declare c_aplicPedido insensitive cursor for
	
	  			select 
									pcdc_id,
									pci_id_devolucion,  
									pci_id_pedido, 
									pcdc_cantidad
	
					 from PedidoDevolucionCompraTMP where pcTMP_id = @@pcTMP_id
	
		open c_aplicPedido
	
	  fetch next from c_aplicPedido into @pcdc_id, @pci_id_devolucion, @pci_id_pedido, @pcdc_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el pci_devolucion que le corresponde a este pci_pedido
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @pci_id_devolucion = pci_id from PedidoCompraItem where pc_id = @@pc_id and pci_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PedidoDevolucionCompra','pcdc_id',@pcdc_id out,0
			insert into PedidoDevolucionCompra (
																					pcdc_id,
																					pcdc_cantidad,
																					pci_id_devolucion,
																					pci_id_pedido
																				)
	                            	values (
																					@pcdc_id,
																					@pcdc_cantidad,
																					@pci_id_devolucion,		
																					@pci_id_pedido
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPedido into @pcdc_id, @pci_id_devolucion, @pci_id_pedido, @pcdc_cantidad
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
	
		exec sp_DocPedidoCpraDevolucionSetPendiente @@pc_id, @@bSuccess	out
	
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
	exec sp_DocPedidoCompraSetPendiente @@pc_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculación del pedido de compra con las cotizaciones, ordenes de compra, y devoluciones. sp_DocPedidoCpraSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO