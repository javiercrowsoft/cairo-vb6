if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCpraFacturaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCpraFacturaSetPendiente]

/*

 sp_DocRemitoCpraFacturaSetPendiente 124

*/

GO
create procedure sp_DocRemitoCpraFacturaSetPendiente (
	@@rc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de las Facturas
	--
	declare @fc_id int

	declare c_FacturaPendiente insensitive cursor for 
		select distinct fc_id 
		from RemitoFacturaCompra rcfc 	inner join RemitoCompraItem rci 	on rcfc.rci_id = rci.rci_id
															  		inner join FacturaCompraItem fci 	on rcfc.fci_id = fci.fci_id
		where rc_id = @@rc_id
	union
		select fc_id from #FacturaCompraRemito
	
	open c_FacturaPendiente
	fetch next from c_FacturaPendiente into @fc_id
	while @@fetch_status = 0 begin
		-- Actualizo la deuda de la factura
		exec sp_DocFacturaCompraSetItemPendiente @fc_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError
	
		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocFC		@fc_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_FacturaPendiente into @fc_id
	end
	close c_FacturaPendiente
	deallocate c_FacturaPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del factura de compra. sp_DocRemitoCpraFacturaSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO