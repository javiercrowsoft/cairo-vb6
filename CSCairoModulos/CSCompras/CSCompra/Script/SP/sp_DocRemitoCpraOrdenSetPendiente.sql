if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCpraOrdenSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCpraOrdenSetPendiente]

/*

 sp_DocRemitoCpraOrdenSetPendiente 91

*/

GO
create procedure sp_DocRemitoCpraOrdenSetPendiente (
	@@rc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los Ordenes
	--
	declare @oc_id int

	declare c_OrdenPendiente insensitive cursor for 
		select distinct oc_id 
		from OrdenRemitoCompra ocrc inner join RemitoCompraItem rci on ocrc.rci_id = rci.rci_id
															  inner join OrdenCompraItem oci on ocrc.oci_id = oci.oci_id
		where rc_id = @@rc_id
	union
		select oc_id from #OrdenCompraRemito
	
	open c_OrdenPendiente
	fetch next from c_OrdenPendiente into @oc_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la factura
		exec sp_DocOrdenCompraSetPendiente @oc_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocOrdenCompraSetCredito @oc_id
		if @@error <> 0 goto ControlError

		exec sp_DocOrdenCompraSetEstado @oc_id
		if @@error <> 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocOC		@oc_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_OrdenPendiente into @oc_id
	end
	close c_OrdenPendiente
	deallocate c_OrdenPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del Orden de compra. sp_DocRemitoCpraOrdenSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO