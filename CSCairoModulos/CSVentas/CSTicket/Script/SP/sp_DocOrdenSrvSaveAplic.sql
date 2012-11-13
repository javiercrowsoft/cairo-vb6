if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenSrvSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenSrvSaveAplic]

/*

 sp_DocOrdenSrvSaveAplic 124

*/

GO
create procedure sp_DocOrdenSrvSaveAplic (
	@@os_id 			int,
	@@osTMP_id    int,
	@@bIsAplic    tinyint = 0,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	declare @osi_id int
	declare @iOrden int 
	declare @doct_id 	int

	select @doct_id = doct_id from OrdenServicio where os_id = @@os_id

	create table #OrdenServicioRemito (rv_id int)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION REMITOS                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @osrv_id 							int
declare @osrv_cantidad				decimal(18,6)
declare @rvi_id               int

	set @iOrden = 0

	insert into #OrdenServicioRemito(rv_id) select distinct rv_id 
																				 from OrdenRemitoVenta osrv inner join RemitoVentaItem rvi 
																																							on osrv.rvi_id = rvi.rvi_id 
																																		inner join OrdenServicioItem osi
                                                                            	on osrv.osi_id = osi.osi_id
		 																		 where not exists(
		 																											select * from OrdenRemitoVentaTMP 
		  																														where osTMP_id = @@osTMP_id and rvi_id = osrv.rvi_id
		 																											)
																						and osi.os_id = @@os_id

	-- Borro toda la aplicacion actual de esta factura con ordenes de compra
	--
	delete OrdenRemitoVenta where osi_id in (select osi_id from OrdenServicioItem where os_id = @@os_id)

	-- Creo un cursor sobre los registros de aplicacion entre la factura
	-- y los remitos
	declare c_aplicRemito insensitive cursor for

  			select 
								osrv_id,
								osi_id,  
								rvi_id, 
								osrv_cantidad

				 from OrdenRemitoVentaTMP where osTMP_id = @@osTMP_id

	open c_aplicRemito

  fetch next from c_aplicRemito into @osrv_id, @osi_id, @rvi_id, @osrv_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el osi que le corresponde a este rvi
		if @@bIsAplic = 0 begin
			set @iOrden = @iOrden + 1
			select @osi_id = osi_id from OrdenServicioItem where os_id = @@os_id and osi_orden = @iOrden
		end

		-- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
		--
		exec SP_DBGetNewId 'OrdenRemitoVenta','osrv_id',@osrv_id out,0
		if @@error <> 0 goto ControlError

		insert into OrdenRemitoVenta (
																				osrv_id,
																				osrv_cantidad,
																				osi_id,
																				rvi_id
																			)
                            	values (
																				@osrv_id,
																				@osrv_cantidad,
																				@osi_id,		
																				@rvi_id
																			)
		if @@error <> 0 goto ControlError

	  fetch next from c_aplicRemito into @osrv_id, @osi_id, @rvi_id, @osrv_cantidad
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

	exec sp_DocOrdenSrvRemitoSetPendiente @@os_id, @@bSuccess	out

	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN ITEMS                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocOrdenServicioSetPendiente @@os_id, @@bSuccess	out
	
	-- Si fallo al guardar
	if IsNull(@@bSuccess,0) = 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la vinculación de la orden de servicio con los partes de entrega. sp_DocOrdenSrvSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO