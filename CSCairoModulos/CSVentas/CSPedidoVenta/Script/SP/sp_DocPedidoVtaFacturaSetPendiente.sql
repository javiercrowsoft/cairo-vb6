if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVtaFacturaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVtaFacturaSetPendiente]

/*

 sp_DocPedidoVtaFacturaSetPendiente 124

*/

GO
create procedure sp_DocPedidoVtaFacturaSetPendiente (
	@@pv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de las Facturas
	--
	declare @fv_id int

	declare c_FacturaPendiente insensitive cursor for 
		select distinct fv_id 
		from PedidoFacturaVenta pvfv 	inner join PedidoVentaItem pvi 	on pvfv.pvi_id = pvi.pvi_id
															  	inner join FacturaVentaItem fvi on pvfv.fvi_id = fvi.fvi_id
		where pv_id = @@pv_id
	union
		select fv_id from #PedidoVentaFactura
	
	open c_FacturaPendiente
	fetch next from c_FacturaPendiente into @fv_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la factura
		exec sp_DocFacturaVentaSetItemPendiente @fv_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocFV		@fv_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_FacturaPendiente into @fv_id
	end
	close c_FacturaPendiente
	deallocate c_FacturaPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPedidoVtaFacturaSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO