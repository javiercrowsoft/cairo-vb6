if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVtaPedidoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVtaPedidoSetPendiente]

/*

 sp_DocPresupuestoVtaPedidoSetPendiente 124

*/

GO
create procedure sp_DocPresupuestoVtaPedidoSetPendiente (
	@@prv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de las Pedidos
	--
	declare @pv_id int

	declare c_PedidoPendiente insensitive cursor for 
		select distinct pv_id 
		from PresupuestoPedidoVenta prvpv 	inner join PresupuestoVentaItem prvi 	on prvpv.prvi_id 	= prvi.prvi_id
															  				inner join PedidoVentaItem pvi 				on prvpv.pvi_id 	= pvi.pvi_id
		where prv_id = @@prv_id
	union
		select pv_id from #PresupuestoVentaPedido
	
	open c_PedidoPendiente
	fetch next from c_PedidoPendiente into @pv_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda del pedidos
		exec sp_DocPedidoVentaSetItemPendiente @pv_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocPV		@pv_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_PedidoPendiente into @pv_id
	end
	close c_PedidoPendiente
	deallocate c_PedidoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del presupuesto de venta. sp_DocPresupuestoVtaPedidoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO