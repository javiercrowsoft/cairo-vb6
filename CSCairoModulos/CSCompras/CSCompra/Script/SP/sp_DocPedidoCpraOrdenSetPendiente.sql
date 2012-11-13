if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCpraOrdenSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCpraOrdenSetPendiente]

/*

 sp_DocPedidoCpraOrdenSetPendiente 124

*/

GO
create procedure sp_DocPedidoCpraOrdenSetPendiente (
	@@pc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los Ordens
	--
	declare @oc_id int

	declare c_OrdenPendiente insensitive cursor for 
		select distinct oc_id 
		from PedidoOrdenCompra pcoc 	inner join PedidoCompraItem pci 	on pcoc.pci_id = pci.pci_id
															  	inner join OrdenCompraItem oci 		on pcoc.oci_id = oci.oci_id
		where pc_id = @@pc_id
	union
		select oc_id from #PedidoCompraOrden
	
	open c_OrdenPendiente
	fetch next from c_OrdenPendiente into @oc_id
	while @@fetch_status = 0 begin
		-- Actualizo la deuda del pedido
		exec sp_DocOrdenCompraSetItemPendiente @oc_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
		fetch next from c_OrdenPendiente into @oc_id
	end
	close c_OrdenPendiente
	deallocate c_OrdenPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del pedido de compra. sp_DocPedidoCpraOrdenSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO