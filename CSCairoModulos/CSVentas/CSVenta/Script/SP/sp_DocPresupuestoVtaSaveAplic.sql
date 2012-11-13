if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVtaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVtaSaveAplic]

/*

 sp_DocPresupuestoVtaSaveAplic 124

*/

GO
create procedure sp_DocPresupuestoVtaSaveAplic (
	@@prv_id 			int,
	@@prvTMP_id   int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @prvi_id int
	declare @iOrden int 
	declare @doct_id 	int

	select @doct_id = doct_id from PresupuestoVenta where prv_id = @@prv_id

	create table #PresupuestoVentaPedido  		(pv_id int)
	create table #PresupuestoDevolucionVenta	(prv_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PEDIDO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @prvpv_id 						int
declare @prvpv_cantidad				decimal(18,6)
declare @pvi_id               int

	set @iOrden = 0

	insert into #PresupuestoVentaPedido(pv_id) select distinct pv_id 
																				 from PresupuestoPedidoVenta pvrpv  inner join PedidoVentaItem pvi 
																																							on pvrpv.pvi_id = pvi.pvi_id 
																																		  			inner join PresupuestoVentaItem prvi
        																																			on pvrpv.prvi_id = prvi.prvi_id
		 																		 where not exists(
		 																											select * from PresupuestoPedidoVentaTMP 
		  																														where prvTMP_id = @@prvTMP_id and pvi_id = pvrpv.pvi_id
		 																											)
																							and prvi.prv_id = @@prv_id

	-- Borro toda la aplicacion actual de esta factura con Presupuestos
	--
	delete PresupuestoPedidoVenta where prvi_id in (select prvi_id from PresupuestoVentaItem where prv_id = @@prv_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los remitos
	declare c_aplicPedido insensitive cursor for

  			select 
								prvpv_id,
								prvi_id,  
								pvi_id, 
								prvpv_cantidad

				 from PresupuestoPedidoVentaTMP where prvTMP_id = @@prvTMP_id

	open c_aplicPedido

  fetch next from c_aplicPedido into @prvpv_id, @prvi_id, @pvi_id, @prvpv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el prvi que le corresponde a este pvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @prvi_id = prvi_id from PresupuestoVentaItem where prv_id = @@prv_id and prvi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'PresupuestoPedidoVenta','prvpv_id',@prvpv_id out,0
		if @@error <> 0 goto ControlError

		insert into PresupuestoPedidoVenta (
																				prvpv_id,
																				prvpv_cantidad,
																				prvi_id,
																				pvi_id
																			)
                            	values (
																				@prvpv_id,
																				@prvpv_cantidad,
																				@prvi_id,		
																				@pvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicPedido into @prvpv_id, @prvi_id, @pvi_id, @prvpv_cantidad
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

	exec sp_DocPresupuestoVtaPedidoSetPendiente @@prv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION DEVOLUCION                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @prvdv_id 						int
declare @prvdv_cantidad				decimal(18,6)
declare @prvi_id_presupuesto  int
declare @prvi_id_devolucion   int

	set @iOrden = 0

	if @doct_id = 11 begin

		insert into #PresupuestoDevolucionVenta(prv_id) select distinct prvi.prv_id 
																					 from PresupuestoDevolucionVenta pvdv inner join PresupuestoVentaItem prvi 
																																								on pvdv.prvi_id_devolucion = prvi.prvi_id 
	
																																					 inner join PresupuestoVentaItem pvir 
																																								on pvdv.prvi_id_presupuesto = pvir.prvi_id
			 																		 where not exists(
			 																											select * from PresupuestoDevolucionVentaTMP 
			  																														where prvTMP_id = @@prvTMP_id and prvi_id_devolucion = pvdv.prvi_id_devolucion
			 																											)
																								and pvir.prv_id = @@prv_id
	
		-- Borro toda la aplicacion actual de este Presupuesto con devoluciones
		--
		delete PresupuestoDevolucionVenta where prvi_id_presupuesto in (select prvi_id from PresupuestoVentaItem where prv_id = @@prv_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre el Presupuesto
		-- y las devoluciones
		declare c_aplicPresupuesto insensitive cursor for
	
	  			select 
									prvdv_id,
									prvi_id_presupuesto,  
									prvi_id_devolucion, 
									prvdv_cantidad
	
					 from PresupuestoDevolucionVentaTMP where prvTMP_id = @@prvTMP_id
	
		open c_aplicPresupuesto
	
	  fetch next from c_aplicPresupuesto into @prvdv_id, @prvi_id_presupuesto, @prvi_id_devolucion, @prvdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el prvi_Presupuesto que le corresponde a este prvi_devolucion
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @prvi_id_presupuesto = prvi_id from PresupuestoVentaItem where prv_id = @@prv_id and prvi_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PresupuestoDevolucionVenta','prvdv_id',@prvdv_id out,0
			if @@error <> 0 goto ControlError

			insert into PresupuestoDevolucionVenta (
																					prvdv_id,
																					prvdv_cantidad,
																					prvi_id_presupuesto,
																					prvi_id_devolucion
																				)
	                            	values (
																					@prvdv_id,
																					@prvdv_cantidad,
																					@prvi_id_presupuesto,		
																					@prvi_id_devolucion
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPresupuesto into @prvdv_id, @prvi_id_presupuesto, @prvi_id_devolucion, @prvdv_cantidad
		end
	
	  close c_aplicPresupuesto
	  deallocate c_aplicPresupuesto
	
	/*
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                               //
	//                                        UPDATE PENDIENTE EN PRESUPUESTOS                                       //
	//                                                                                                               //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
	
		exec sp_DocPresupuestoVtaDevolucionSetPendiente @@prv_id, @@bSuccess	out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
	end else begin

		insert into #PresupuestoDevolucionVenta(prv_id) select distinct prvi.prv_id 
																					 from PresupuestoDevolucionVenta pvdv inner join PresupuestoVentaItem prvi 
																																								on pvdv.prvi_id_presupuesto = prvi.prvi_id 
	
																																					 inner join PresupuestoVentaItem pvid 
																																								on pvdv.prvi_id_devolucion = pvid.prvi_id
			 																		 where not exists(
			 																											select * from PresupuestoDevolucionVentaTMP 
			  																														where prvTMP_id = @@prvTMP_id and prvi_id_presupuesto = pvdv.prvi_id_presupuesto
			 																											)
																								and pvid.prv_id = @@prv_id
	
		-- Borro toda la aplicacion actual de esta devolucion con Presupuestos
		--
		delete PresupuestoDevolucionVenta where prvi_id_devolucion in (select prvi_id from PresupuestoVentaItem where prv_id = @@prv_id)
	
		-- Creo un cursor sobre los registros de aplicacion entre la devolucion
		-- y los Presupuestos
		declare c_aplicPresupuesto insensitive cursor for
	
	  			select 
									prvdv_id,
									prvi_id_devolucion,  
									prvi_id_presupuesto, 
									prvdv_cantidad
	
					 from PresupuestoDevolucionVentaTMP where prvTMP_id = @@prvTMP_id
	
		open c_aplicPresupuesto
	
	  fetch next from c_aplicPresupuesto into @prvdv_id, @prvi_id_devolucion, @prvi_id_presupuesto, @prvdv_cantidad
	
		while @@fetch_status = 0 begin
	
			-- Obtengo por el orden el prvi_devolucion que le corresponde a este prvi_Presupuesto
			if @@bIsAplic = 0 begin
				set @iOrden = @iOrden + 1
				select @prvi_id_devolucion = prvi_id from PresupuestoVentaItem where prv_id = @@prv_id and prvi_orden = @iOrden
			end
	
			-- Finalmente grabo la vinculacion
			--
			exec SP_DBGetNewId 'PresupuestoDevolucionVenta','prvdv_id',@prvdv_id out,0
			if @@error <> 0 goto ControlError

			insert into PresupuestoDevolucionVenta (
																					prvdv_id,
																					prvdv_cantidad,
																					prvi_id_devolucion,
																					prvi_id_presupuesto
																				)
	                            	values (
																					@prvdv_id,
																					@prvdv_cantidad,
																					@prvi_id_devolucion,		
																					@prvi_id_presupuesto
																				)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_aplicPresupuesto into @prvdv_id, @prvi_id_devolucion, @prvi_id_presupuesto, @prvdv_cantidad
		end
	
	  close c_aplicPresupuesto
	  deallocate c_aplicPresupuesto
	
	/*
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                               //
	//                                        UPDATE PENDIENTE EN PRESUPUESTOS                                       //
	//                                                                                                               //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
	
		exec sp_DocPresupuestoVtaDevolucionSetPendiente @@prv_id, @@bSuccess	out
	
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
	exec sp_DocPresupuestoVentaSetPendiente @@prv_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculación del presupuesto de venta con los pedidos y las cancelaciones. sp_DocPresupuestoVtaSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO