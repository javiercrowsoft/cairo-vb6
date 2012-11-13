if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingLstSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingLstSaveAplic]

/*

 sp_DocPackingLstSaveAplic 124

*/

GO
create procedure sp_DocPackingLstSaveAplic (
	@@pklst_id 		int,
	@@pklstTMP_id int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @pklsti_id 	int
	declare @iOrden 	  int 
	declare @doct_id 	  int

	select @doct_id = doct_id from PackingList where pklst_id = @@pklst_id

	create table #ManifiestoPacking     (mfc_id int)
	create table #PedidoVentaPacking    (pv_id int)
	create table #FacturaVentaPacking   (fv_id int)
	create table #PackingListDevolucion (pklst_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PEDIDO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvpklst_id 					int
declare @pvpklst_cantidad			decimal(18,6)
declare @pvi_id               int

	set @iOrden = 0

	insert into #PedidoVentaPacking(pv_id) select distinct pv_id 
																			 	from PedidoPackingList pvpklst inner join PedidoVentaItem pvi 
																																						on pvpklst.pvi_id = pvi.pvi_id 
																																		inner join PackingListItem pklsti 
																																						on pvpklst.pklsti_id = pklsti.pklsti_id 
 																			 	where not exists(
 																											select * from PedidoPackingListTMP 
  																														where pklstTMP_id = @@pklstTMP_id and pvi_id = pvpklst.pvi_id
 																											)
																						and pklsti.pklst_id = @@pklst_id

	-- Borro toda la aplicacion actual de este packing con pedidos
	--
	delete PedidoPackingList where pklsti_id in (select pklsti_id from PackingListItem where pklst_id = @@pklst_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los pedidos
	declare c_aplicPedido insensitive cursor for

  			select 
								pvpklst_id, 
								pklsti_id,
								pvi_id, 
								pvpklst_cantidad
				
				from PedidoPackingListTMP where pklstTMP_id = @@pklstTMP_id

	open c_aplicPedido

  fetch next from c_aplicPedido into @pvpklst_id, @pklsti_id, @pvi_id, @pvpklst_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pklsti que le corresponde a este pvi
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pklsti_id = pklsti_id from PackingListItem where pklst_id = @@pklst_id and pklsti_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PedidoPackingList','pvpklst_id',@pvpklst_id out,0
		insert into PedidoPackingList (
																				pvpklst_id,
																				pvpklst_cantidad,
																				pklsti_id,
																				pvi_id
																			)
                            	values (
																				@pvpklst_id,
																				@pvpklst_cantidad,
																				@pklsti_id,		
																				@pvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPedido into @pvpklst_id, @pklsti_id, @pvi_id, @pvpklst_cantidad
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

	exec sp_DocPackingLstPedidoSetPendiente @@pklst_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION MANIFIESTO                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @mfcpklst_id 					  int
declare @mfcpklst_cantidad			decimal(18,6)
declare @mfci_id                int

	set @iOrden = 0

	insert into #ManifiestoPacking(mfc_id) 
														select distinct mfc_id 
														from ManifiestoPackingList mfcpklst inner join ManifiestoCargaItem mfci 
																																			on mfcpklst.mfci_id = mfci.mfci_id 
																																inner join PackingListItem pklsti 
																																			on mfcpklst.pklsti_id = pklsti.pklsti_id 
													 	where not exists(
																							select * from ManifiestoPackingListTMP 
																							where pklstTMP_id = @@pklstTMP_id and mfci_id = mfcpklst.mfci_id
																						)
															and pklsti.pklst_id = @@pklst_id

	-- Borro toda la aplicacion actual de este packing con Manifiestos
	--
	delete ManifiestoPackingList where pklsti_id in (select pklsti_id from PackingListItem where pklst_id = @@pklst_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los Manifiestos
	declare c_aplicManifiesto insensitive cursor for

  			select 
								mfcpklst_id, 
								pklsti_id,
								mfci_id, 
								mfcpklst_cantidad
				
				from ManifiestoPackingListTMP where pklstTMP_id = @@pklstTMP_id

	open c_aplicManifiesto

  fetch next from c_aplicManifiesto into @mfcpklst_id, @pklsti_id, @mfci_id, @mfcpklst_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pklsti que le corresponde a este mfci
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pklsti_id = pklsti_id from PackingListItem where pklst_id = @@pklst_id and pklsti_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'ManifiestoPackingList','mfcpklst_id',@mfcpklst_id out,0
		insert into ManifiestoPackingList (
																				mfcpklst_id,
																				mfcpklst_cantidad,
																				pklsti_id,
																				mfci_id
																			)
                            	values (
																				@mfcpklst_id,
																				@mfcpklst_cantidad,
																				@pklsti_id,		
																				@mfci_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicManifiesto into @mfcpklst_id, @pklsti_id, @mfci_id, @mfcpklst_cantidad
	end

  close c_aplicManifiesto
  deallocate c_aplicManifiesto

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN MANIFIESTOS                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPackingLstManifiestoSetPendiente @@pklst_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION FACTURA                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pklstfv_id 							int
declare @pklstfv_cantidad				decimal(18,6)
declare @fvi_id               int

	set @iOrden = 0

	insert into #FacturaVentaPacking(fv_id) 
															select distinct fv_id 
															from PackingListFacturaVenta pklstfv inner join FacturaVentaItem fvi 
																																				on pklstfv.fvi_id = fvi.fvi_id 
															  																	 inner join PackingListItem pklsti 
																																				on pklstfv.pklsti_id = pklsti.pklsti_id 
														  where not exists(
																								select * from PackingListFacturaVentaTMP 
																								where pklstTMP_id = @@pklstTMP_id and fvi_id = pklstfv.fvi_id
																							)
																and pklsti.pklst_id = @@pklst_id

	-- Borro toda la aplicacion actual de este packing con pedidos
	--
	delete PackingListFacturaVenta where pklsti_id in (select pklsti_id from PackingListItem where pklst_id = @@pklst_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los packing list
	declare c_aplicPacking insensitive cursor for

  			select 
								pklstfv_id,
								pklsti_id,  
								fvi_id, 
								pklstfv_cantidad

				 from PackingListFacturaVentaTMP where pklstTMP_id = @@pklstTMP_id

	open c_aplicPacking

  fetch next from c_aplicPacking into @pklstfv_id, @pklsti_id, @fvi_id, @pklstfv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el pklsti que le corresponde a este fvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @pklsti_id = pklsti_id from PackingListItem where pklst_id = @@pklst_id and pklsti_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PackingListFacturaVenta','pklstfv_id',@pklstfv_id out,0
		insert into PackingListFacturaVenta (
																				pklstfv_id,
																				pklstfv_cantidad,
																				pklsti_id,
																				fvi_id
																			)
                            	values (
																				@pklstfv_id,
																				@pklstfv_cantidad,
																				@pklsti_id,		
																				@fvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPacking into @pklstfv_id, @pklsti_id, @fvi_id, @pklstfv_cantidad
	end

  close c_aplicPacking
  deallocate c_aplicPacking

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN FACTURAS                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPackingLstFacturaSetPendiente @@pklst_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pklstdv_id 						 int
declare @pklstdv_cantidad				 decimal(18,6)
declare @pklsti_id_pklst         int
declare @pklsti_id_devolucion    int

	set @iOrden = 0

	if @doct_id = 3 begin

		insert into #PackingListDevolucion(pklst_id) 
															select distinct pklsti.pklst_id 
															from PackingListDevolucion pklstdv inner join PackingListItem pklsti 
																																		on pklstdv.pklsti_id_devolucion = pklsti.pklsti_id 

																															 inner join PackingListItem pklstir 
																																		on pklstdv.pklsti_id_pklst = pklstir.pklsti_id
														  where not exists(
																								select * from PackingListDevolucionTMP 
																								where pklstTMP_id = @@pklstTMP_id and pklsti_id_devolucion = pklstdv.pklsti_id_devolucion
																							)
																and pklstir.pklst_id = @@pklst_id
	
		-- Borro toda la aplicacion actual de este packing list con devoluciones
		--
		delete PackingListDevolucion where pklsti_id_pklst in (select pklsti_id from PackingListItem where pklst_id = @@pklst_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre el packing list
		-- y las devoluciones
		declare c_aplicPacking insensitive cursor for
	
	  			select 
									pklstdv_id,
									pklsti_id_pklst,  
									pklsti_id_devolucion, 
									pklstdv_cantidad
	
					 from PackingListDevolucionTMP where pklstTMP_id = @@pklstTMP_id
	
		open c_aplicPacking
	
	  fetch next from c_aplicPacking into @pklstdv_id, @pklsti_id_pklst, @pklsti_id_devolucion, @pklstdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el pklsti_pedido que le corresponde a este pklsti_devolucion
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @pklsti_id_pklst = pklsti_id from PackingListItem where pklst_id = @@pklst_id and pklsti_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PackingListDevolucion','pklstdv_id',@pklstdv_id out,0
			insert into PackingListDevolucion (
																					pklstdv_id,
																					pklstdv_cantidad,
																					pklsti_id_pklst,
																					pklsti_id_devolucion
																				)
	                            	values (
																					@pklstdv_id,
																					@pklstdv_cantidad,
																					@pklsti_id_pklst,		
																					@pklsti_id_devolucion
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPacking into @pklstdv_id, @pklsti_id_pklst, @pklsti_id_devolucion, @pklstdv_cantidad
		end
	
	  close c_aplicPacking
	  deallocate c_aplicPacking
	
	/*
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                               //
	//                                        UPDATE PENDIENTE EN PACKING LIST                                       //
	//                                                                                                               //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
	
		exec sp_DocPackingLstDevolucionSetPendiente @@pklst_id, @@bSuccess	out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
	end else begin

		insert into #PackingListDevolucion(pklst_id) 
															select distinct pklsti.pklst_id 
															from PackingListDevolucion pklstdv inner join PackingListItem pklsti 
																																		on pklstdv.pklsti_id_pklst = pklsti.pklsti_id 
	
																																 inner join PackingListItem pklstid 
																																		on pklstdv.pklsti_id_devolucion = pklstid.pklsti_id
														  where not exists(
																								select * from PackingListDevolucionTMP 
																								where pklstTMP_id = @@pklstTMP_id and pklsti_id_pklst = pklstdv.pklsti_id_pklst
																							)
																and pklstid.pklst_id = @@pklst_id
	
		-- Borro toda la aplicacion actual de esta devolucion con packing list
		--
		delete PackingListDevolucion where pklsti_id_devolucion in (select pklsti_id from PackingListItem where pklst_id = @@pklst_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre la devolucion
		-- y los packing list
		declare c_aplicPacking insensitive cursor for
	
	  			select 
									pklstdv_id,
									pklsti_id_devolucion,  
									pklsti_id_pklst, 
									pklstdv_cantidad
	
					 from PackingListDevolucionTMP where pklstTMP_id = @@pklstTMP_id
	
		open c_aplicPacking
	
	  fetch next from c_aplicPacking into @pklstdv_id, @pklsti_id_devolucion, @pklsti_id_pklst, @pklstdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el pklsti_devolucion que le corresponde a este pklsti_pedido
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @pklsti_id_devolucion = pklsti_id from PackingListItem where pklst_id = @@pklst_id and pklsti_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PackingListDevolucion','pklstdv_id',@pklstdv_id out,0
			insert into PackingListDevolucion (
																					pklstdv_id,
																					pklstdv_cantidad,
																					pklsti_id_devolucion,
																					pklsti_id_pklst
																				)
	                            	values (
																					@pklstdv_id,
																					@pklstdv_cantidad,
																					@pklsti_id_devolucion,		
																					@pklsti_id_pklst
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPacking into @pklstdv_id, @pklsti_id_devolucion, @pklsti_id_pklst, @pklstdv_cantidad
		end
	
	  close c_aplicPacking
	  deallocate c_aplicPacking
	
	/*
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                               //
	//                                        UPDATE PENDIENTE EN PACKING LIST                                            //
	//                                                                                                               //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
	
		exec sp_DocPackingLstDevolucionSetPendiente @@pklst_id, @@bSuccess	out
	
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

	exec sp_DocPackingListSetItemPendiente @@pklst_id, @@bSuccess	out
	
	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError


	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculación del packing list con las facturas, pedidos y devoluciones. sp_DocPackingLstSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO