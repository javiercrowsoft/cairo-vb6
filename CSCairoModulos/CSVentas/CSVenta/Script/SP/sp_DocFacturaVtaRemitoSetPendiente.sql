if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVtaRemitoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVtaRemitoSetPendiente]

/*

 sp_DocFacturaVtaRemitoSetPendiente 124

*/

GO
create procedure sp_DocFacturaVtaRemitoSetPendiente (
	@@fv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los remitos
	--
	declare @rv_id int

	declare c_remitoPendiente insensitive cursor for 
		select distinct rv_id 
		from RemitoFacturaVenta rvfv inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
															  inner join RemitoVentaItem rvi on rvfv.rvi_id = rvi.rvi_id
		where fv_id = @@fv_id
	union
		select rv_id from #RemitoVentaFac
	
	open c_remitoPendiente
	fetch next from c_remitoPendiente into @rv_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la factura
		exec sp_DocRemitoVentaSetPendiente @rv_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocRemitoVentaSetCredito @rv_id
		if @@error <> 0 goto ControlError

		exec sp_DocRemitoVentaSetEstado @rv_id
		if @@error <> 0 goto ControlError

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

		fetch next from c_remitoPendiente into @rv_id
	end
	close c_remitoPendiente
	deallocate c_remitoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del remito de venta. sp_DocFacturaVtaRemitoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO