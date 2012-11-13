if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCpraPedidoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCpraPedidoSetPendiente]

/*

 sp_DocOrdenCpraPedidoSetPendiente 10

*/

GO
create procedure sp_DocOrdenCpraPedidoSetPendiente (
	@@oc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los pedidos
	--
	declare @pc_id int

	declare c_pedidoPendiente insensitive cursor for 
		select distinct pc_id 
		from PedidoOrdenCompra pcoc inner join OrdenCompraItem oci on pcoc.oci_id = oci.oci_id
															  inner join PedidoCompraItem pci on pcoc.pci_id = pci.pci_id
		where oc_id = @@oc_id
	union
		select pc_id from #PedidoOrdenCompra
	
	open c_pedidoPendiente
	fetch next from c_pedidoPendiente into @pc_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la factura
		exec sp_DocPedidoCompraSetPendiente @pc_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocPedidoCompraSetEstado @pc_id
		if @@error <> 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--

			-- ESTADO
					exec sp_AuditoriaEstadoCheckDocPC		@pc_id,
																							@@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_pedidoPendiente into @pc_id
	end
	close c_pedidoPendiente
	deallocate c_pedidoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de compra. sp_DocOrdenCpraPedidoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO