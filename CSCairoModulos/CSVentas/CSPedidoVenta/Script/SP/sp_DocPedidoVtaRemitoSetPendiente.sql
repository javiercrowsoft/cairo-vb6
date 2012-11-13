if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVtaRemitoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVtaRemitoSetPendiente]

/*

 sp_DocPedidoVtaRemitoSetPendiente 124

*/

GO
create procedure sp_DocPedidoVtaRemitoSetPendiente (
	@@pv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los Remitos
	--
	declare @rv_id int

	declare c_RemitoPendiente insensitive cursor for 
		select distinct rv_id 
		from PedidoRemitoVenta pvrv 	inner join PedidoVentaItem pvi 	on pvrv.pvi_id = pvi.pvi_id
															  	inner join RemitoVentaItem rvi on pvrv.rvi_id = rvi.rvi_id
		where pv_id = @@pv_id
	union
		select rv_id from #PedidoVentaRemito
	
	open c_RemitoPendiente
	fetch next from c_RemitoPendiente into @rv_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda del remito
		exec sp_DocRemitoVentaSetItemPendiente @rv_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocRV		@rv_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_RemitoPendiente into @rv_id
	end
	close c_RemitoPendiente
	deallocate c_RemitoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPedidoVtaRemitoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO