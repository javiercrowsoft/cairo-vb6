if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCpraCotizacionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCpraCotizacionSetPendiente]

/*

 sp_DocPedidoCpraCotizacionSetPendiente 124

*/

GO
create procedure sp_DocPedidoCpraCotizacionSetPendiente (
	@@pc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los Cotizacions
	--
	declare @cot_id int

	declare c_CotizacionPendiente insensitive cursor for 
		select distinct cot_id 
		from PedidoCotizacionCompra pccot 	inner join PedidoCompraItem pci 			on pccot.pci_id = pci.pci_id
															  				inner join CotizacionCompraItem coti 	on pccot.coti_id = coti.coti_id
		where pc_id = @@pc_id
	union
		select cot_id from #PedidoCompraCotizacion
	
	open c_CotizacionPendiente
	fetch next from c_CotizacionPendiente into @cot_id
	while @@fetch_status = 0 begin
		-- Actualizo la deuda del pedido
		exec sp_DocCotizacionCompraSetItemPendiente @cot_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		fetch next from c_CotizacionPendiente into @cot_id
	end
	close c_CotizacionPendiente
	deallocate c_CotizacionPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de Compra. sp_DocPedidoCpraCotizacionSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO