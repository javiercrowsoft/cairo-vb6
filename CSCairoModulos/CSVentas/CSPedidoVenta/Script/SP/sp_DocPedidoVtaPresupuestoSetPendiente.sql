if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVtaPresupuestoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVtaPresupuestoSetPendiente]

/*

 sp_DocPedidoVtaPresupuestoSetPendiente 91

*/

GO
create procedure sp_DocPedidoVtaPresupuestoSetPendiente (
	@@pv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los pedidos
	--
	declare @prv_id int

	declare c_presupuestoPendiente insensitive cursor for 
		select distinct prv_id 
		from PresupuestoPedidoVenta prvpv 
																inner join PedidoVentaItem pvi 			 on prvpv.pvi_id = pvi.pvi_id
															  inner join PresupuestoVentaItem prvi on prvpv.prvi_id = prvi.prvi_id
		where pv_id = @@pv_id
	union
		select prv_id from #PresupuestoVtaPedido
	
	open c_presupuestoPendiente
	fetch next from c_presupuestoPendiente into @prv_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda del pedido de venta
		exec sp_DocPresupuestoVentaSetPendiente @prv_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocPresupuestoVentaSetEstado @prv_id
		if @@error <> 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocPRV	@prv_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_presupuestoPendiente into @prv_id
	end
	close c_presupuestoPendiente
	deallocate c_presupuestoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del presupuesto de venta. sp_DocPedidoVtaPresupuestoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO