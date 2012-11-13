if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVtaOrdenSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVtaOrdenSetPendiente]

/*

 sp_DocRemitoVtaOrdenSetPendiente 91

*/

GO
create procedure sp_DocRemitoVtaOrdenSetPendiente (
	@@rv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los ordenes
	--
	declare @os_id int

	declare c_ordenPendiente insensitive cursor for 
		select distinct os_id 
		from OrdenRemitoVenta osrv  inner join RemitoVentaItem rvi   on osrv.rvi_id = rvi.rvi_id
															  inner join OrdenServicioItem osi on osrv.osi_id = osi.osi_id
		where rv_id = @@rv_id
	union
		select os_id from #OrdenServicioRemito
	
	open c_ordenPendiente
	fetch next from c_ordenPendiente into @os_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la orden de servicio
		exec sp_DocOrdenServicioSetPendiente @os_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocOrdenServicioSetCredito @os_id
		if @@error <> 0 goto ControlError

		exec sp_DocOrdenServicioSetEstado @os_id
		if @@error <> 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--
			
			-- ESTADO
				exec sp_AuditoriaEstadoCheckDocOS		@os_id,
																						@@bSuccess	out,
																						@MsgError out
			
				-- Si el documento no es valido
				if IsNull(@@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_ordenPendiente into @os_id
	end
	close c_ordenPendiente
	deallocate c_ordenPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente de la orden de servicio. sp_DocRemitoVtaOrdenSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO