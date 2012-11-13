if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVtaPedidoRemitoSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVtaPedidoRemitoSaveAplic]

/*

 sp_DocFacturaVtaPedidoRemitoSaveAplic 124

*/

GO
create procedure sp_DocFacturaVtaPedidoRemitoSaveAplic (
	@@fv_id 			int,
	@@fvTMP_id    int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @fvi_id int
	declare @iOrden int 

	create table #PedidoVentaFac (pv_id    int)
	create table #RemitoVentaFac (rv_id    int)
	create table #PackingListFac (pklst_id int)
	create table #HoraFac 			 (hora_id  int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PEDIDO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvfv_id 							int
declare @pvfv_cantidad				decimal(18,6)
declare @pvi_id               int

	set @iOrden = 0

	insert into #PedidoVentaFac(pv_id) select distinct pv_id 
																		 from PedidoFacturaVenta pvfv inner join PedidoVentaItem pvi 
																																							on pvfv.pvi_id = pvi.pvi_id 
																																	inner join FacturaVentaItem fvi 
																																							on pvfv.fvi_id = fvi.fvi_id 
 																		 where not exists(
 																											select * from PedidoFacturaVentaTMP 
  																														where fvTMP_id = @@fvTMP_id and pvi_id = pvfv.pvi_id
 																											)
																					and fvi.fv_id = @@fv_id

	-- Borro toda la aplicacion actual de esta factura con pedidos
	--
	delete PedidoFacturaVenta where fvi_id in (select fvi_id from FacturaVentaItem where fv_id = @@fv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los pedidos
	declare c_aplicPedido insensitive cursor for

  			select 
								pvfv_id, 
								fvi_id,
								pvi_id, 
								pvfv_cantidad

				 from PedidoFacturaVentaTMP where fvTMP_id = @@fvTMP_id

	open c_aplicPedido

  fetch next from c_aplicPedido into @pvfv_id, @fvi_id, @pvi_id, @pvfv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el fvi que le corresponde a este pvi
		--
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @fvi_id = fvi_id from FacturaVentaItem where fv_id = @@fv_id and fvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PedidoFacturaVenta','pvfv_id',@pvfv_id out,0
		if @@error <> 0 goto ControlError

		insert into PedidoFacturaVenta (
																				pvfv_id,
																				pvfv_cantidad,
																				fvi_id,
																				pvi_id
																			)
                            	values (
																				@pvfv_id,
																				@pvfv_cantidad,
																				@fvi_id,		
																				@pvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPedido into @pvfv_id, @fvi_id, @pvi_id, @pvfv_cantidad
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

	exec sp_DocFacturaVtaPedidoSetPendiente @@fv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION REMITO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @rvfv_id 							int
declare @rvfv_cantidad				decimal(18,6)
declare @rvi_id               int

	set @iOrden = 0

	insert into #RemitoVentaFac(rv_id) select distinct rv_id 
																		 from RemitoFacturaVenta rvfv inner join RemitoVentaItem rvi 
																																							on rvfv.rvi_id = rvi.rvi_id 
																																	inner join FacturaVentaItem fvi 
																																							on rvfv.fvi_id = fvi.fvi_id 
 																		 where not exists(
 																											select * from RemitoFacturaVentaTMP 
  																														where fvTMP_id = @@fvTMP_id and rvi_id = rvfv.rvi_id
 																											)
																					and fvi.fv_id = @@fv_id

	-- Borro toda la aplicacion actual de esta factura con pedidos
	--
	delete RemitoFacturaVenta where fvi_id in (select fvi_id from FacturaVentaItem where fv_id = @@fv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los remitos
	declare c_aplicRemito insensitive cursor for

  			select 
								rvfv_id,
								fvi_id,  
								rvi_id, 
								rvfv_cantidad

				 from RemitoFacturaVentaTMP where fvTMP_id = @@fvTMP_id

	open c_aplicRemito

  fetch next from c_aplicRemito into @rvfv_id, @fvi_id, @rvi_id, @rvfv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el fvi que le corresponde a este rvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @fvi_id = fvi_id from FacturaVentaItem where fv_id = @@fv_id and fvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'RemitoFacturaVenta','rvfv_id',@rvfv_id out,0
		if @@error <> 0 goto ControlError

		insert into RemitoFacturaVenta (
																				rvfv_id,
																				rvfv_cantidad,
																				fvi_id,
																				rvi_id
																			)
                            	values (
																				@rvfv_id,
																				@rvfv_cantidad,
																				@fvi_id,		
																				@rvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicRemito into @rvfv_id, @fvi_id, @rvi_id, @rvfv_cantidad
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

	exec sp_DocFacturaVtaRemitoSetPendiente @@fv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PACKING LIST                                                //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pklstfv_id 						int
declare @pklstfv_cantidad				decimal(18,6)
declare @pklsti_cancelado       decimal(18,6)
declare @pklsti_id              int

	set @iOrden = 0

	insert into #PackingListFac(pklst_id)  select distinct pklst_id 
																				 from PackingListFacturaVenta pklstfv inner join PackingListItem pklsti 
																																									on pklstfv.pklsti_id = pklsti.pklsti_id 
																																			inner join FacturaVentaItem fvi 
																																									on pklstfv.fvi_id = fvi.fvi_id 
		 																		 where not exists(
		 																											select * from PackingListFacturaVentaTMP 
		  																														where fvTMP_id = @@fvTMP_id and pklsti_id = pklstfv.pklsti_id
		 																											)
																							and fvi.fv_id = @@fv_id


	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los packing list
	declare c_aplicPacking insensitive cursor for

  			select 
								pklstfv_id, 
								pklsti_id, 
								pklstfv_cantidad

				 from PackingListFacturaVentaTMP where fvTMP_id = @@fvTMP_id

	open c_aplicPacking

  fetch next from c_aplicPacking into @pklstfv_id, @pklsti_id, @pklstfv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el fvi que le corresponde a este pklsti
		set @iOrden = @iOrden + 1
		select @fvi_id = fvi_id from FacturaVentaItem where fv_id = @@fv_id and fvi_orden = @iOrden

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'PackingListFacturaVenta','pklstfv_id',@pklstfv_id out,0
		if @@error <> 0 goto ControlError

		insert into PackingListFacturaVenta (
																				pklstfv_id,
																				pklstfv_cantidad,
																				fvi_id,
																				pklsti_id
																			)
                            	values (
																				@pklstfv_id,
																				@pklstfv_cantidad,
																				@fvi_id,		
																				@pklsti_id
																			)
		if @@error <> 0 goto ControlError

		update FacturaVentaItem set fvi_pendientepklst = fvi_cantidadaremitir - @pklstfv_cantidad
    where fvi_id = @fvi_id
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPacking into @pklstfv_id, @pklsti_id, @pklstfv_cantidad
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

	exec sp_DocFacturaVtaPackingSetPendiente @@fv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION HORA                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @horafv_id 							int
declare @horafv_cantidad				decimal(18,6)
declare @hora_id                int

	set @iOrden = 0

	insert into #HoraFac(hora_id) select distinct horafv.hora_id 
																		 from HoraFacturaVenta horafv inner join Hora hora 
																																							on horafv.hora_id = hora.hora_id 
																																	inner join FacturaVentaItem fvi 
																																							on horafv.fvi_id = fvi.fvi_id 
 																		 where not exists(
 																											select * from HoraFacturaVentaTMP 
  																														where fvTMP_id = @@fvTMP_id and hora_id = horafv.hora_id
 																											)
																					and fvi.fv_id = @@fv_id

	-- Borro toda la aplicacion actual de esta factura con pedidos
	--
	delete HoraFacturaVenta where fvi_id in (select fvi_id from FacturaVentaItem where fv_id = @@fv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los Horas
	declare c_aplicHora insensitive cursor for

  			select 
								horafv_id,
								fvi_id,  
								hora_id, 
								horafv_cantidad

				 from HoraFacturaVentaTMP where fvTMP_id = @@fvTMP_id

	open c_aplicHora

  fetch next from c_aplicHora into @horafv_id, @fvi_id, @hora_id, @horafv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el fvi que le corresponde a este hora
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @fvi_id = fvi_id from FacturaVentaItem where fv_id = @@fv_id and fvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'HoraFacturaVenta','horafv_id',@horafv_id out,0
		if @@error <> 0 goto ControlError

		insert into HoraFacturaVenta (
																				horafv_id,
																				horafv_cantidad,
																				fvi_id,
																				hora_id
																			)
                            	values (
																				@horafv_id,
																				@horafv_cantidad,
																				@fvi_id,		
																				@hora_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicHora into @horafv_id, @fvi_id, @hora_id, @horafv_cantidad
	end

  close c_aplicHora
  deallocate c_aplicHora

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN HORAS                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaVtaHoraSetPendiente @@fv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ITEMS                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaVentaSetItemPendiente @@fv_id, @@bSuccess out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculacion de la factura de venta con los pedidos y remitos. sp_DocFacturaVtaPedidoRemitoSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO