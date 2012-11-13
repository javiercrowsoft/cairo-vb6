if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCpraDevolucionSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCpraDevolucionSetPendiente]

/*

 sp_DocPedidoCpraDevolucionSetPendiente 124

*/

GO
create procedure sp_DocPedidoCpraDevolucionSetPendiente (
	@@pc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de las Facturas
	--
	declare @pc_id int
	declare @doct_id int

	select @doct_id = doct_id from PedidoCompra where pc_id = @@pc_id

	if @doct_id = 6 begin

		declare c_PedidoPendiente insensitive cursor for 
			select distinct pci.pc_id 
			from PedidoDevolucionCompra pcdv 	inner join PedidoCompraItem pci 	 on pcdv.pci_id_devolucion = pci.pci_id
																  			inner join PedidoCompraItem pcir  on pcdv.pci_id_pedido = pcir.pci_id
			where pcir.pc_id = @@pc_id
		union
			select pc_id from #PedidoDevolucionCompra

	end else begin

		declare c_PedidoPendiente insensitive cursor for 
			select distinct pci.pc_id 
			from PedidoDevolucionCompra pcdv 	inner join PedidoCompraItem pci 	 on pcdv.pci_id_pedido = pci.pci_id
																  			inner join PedidoCompraItem pcid  on pcdv.pci_id_devolucion = pcid.pci_id
			where pcid.pc_id = @@pc_id
		union
			select pc_id from #PedidoDevolucionCompra
	end
											
	open c_PedidoPendiente
	fetch next from c_PedidoPendiente into @pc_id
	while @@fetch_status = 0 begin
		-- Actualizo la deuda de la Pedido
		exec sp_DocPedidoCompraSetPendiente @pc_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocPedidoCompraSetEstado @pc_id

		fetch next from c_PedidoPendiente into @pc_id
	end
	close c_PedidoPendiente
	deallocate c_PedidoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del Pedido de Compra. sp_DocPedidoCpraDevolucionSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO