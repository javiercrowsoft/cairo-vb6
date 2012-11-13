if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCpraRemitoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCpraRemitoSetPendiente]

/*

 sp_DocFacturaCpraRemitoSetPendiente 124

*/

GO
create procedure sp_DocFacturaCpraRemitoSetPendiente (
	@@fc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los remitos
	--
	declare @rc_id int

	declare c_remitoPendiente insensitive cursor for 
		select distinct rc_id 
		from RemitoFacturaCompra rcfc inner join FacturaCompraItem fci on rcfc.fci_id = fci.fci_id
															  inner join RemitoCompraItem rci on rcfc.rci_id = rci.rci_id
		where fc_id = @@fc_id
	union
		select rc_id from #RemitoCompraFac
	
	open c_remitoPendiente
	fetch next from c_remitoPendiente into @rc_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la factura
		exec sp_DocRemitoCompraSetPendiente @rc_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocRemitoCompraSetCredito @rc_id
		if @@error <> 0 goto ControlError

		exec sp_DocRemitoCompraSetEstado @rc_id
		if @@error <> 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocRC		@rc_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_remitoPendiente into @rc_id
	end
	close c_remitoPendiente
	deallocate c_remitoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del remito de compra. sp_DocFacturaCpraRemitoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO