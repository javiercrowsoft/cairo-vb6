if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaSetItemPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaSetItemPendiente]

/*

	select * from Presupuestoventa

	exec	sp_DocPresupuestoVentaSetItemPendiente 23

*/

go
create procedure sp_DocPresupuestoVentaSetItemPendiente (
	@@prv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @prvi_id     int
	declare @doct_id 		int
	declare @est_id     int

	select @doct_id = doct_id, @est_id = est_id 
	from PresupuestoVenta where prv_id = @@prv_id

	begin transaction

	if @est_id <> 7 begin

		declare @aplicadoPedido 				decimal(18,6)
	  declare @aplicadoPresupuesto    decimal(18,6)
		
		declare c_PviPendiente insensitive cursor for 
	
					select prvi_id
					from 
								PresupuestoVentaItem 
	
					where prv_id = @@prv_id
	
		open c_PviPendiente 
		
		fetch next from c_PviPendiente into @prvi_id
		while @@fetch_status = 0 
		begin
	
			if @doct_id = 11 begin
	
				select @aplicadoPedido = isnull(sum(prvpv_cantidad),0)
				from 
							PresupuestoPedidoVenta
				where prvi_id = @prvi_id
	
				select @aplicadoPresupuesto = @aplicadoPresupuesto + isnull(sum(prvdv_cantidad),0)
				from 
							PresupuestoDevolucionVenta
				where prvi_id_Presupuesto = @prvi_id
	
			end else begin
	
				set @aplicadoPedido  = 0
	
				select @aplicadoPresupuesto = @aplicadoPresupuesto + isnull(sum(prvdv_cantidad),0)
				from 
							PresupuestoDevolucionVenta
				where prvi_id_devolucion = @prvi_id
			end
	
			set @aplicadoPedido = IsNull(@aplicadoPedido,0)
			set @aplicadoPresupuesto  = IsNull(@aplicadoPresupuesto,0)
	
			update PresupuestoVentaItem set prvi_pendiente 		=  prvi_cantidadaremitir 
																												 - @aplicadoPedido 
																												 - @aplicadoPresupuesto
						where prvi_id = @prvi_id
		
			if @@error <> 0 goto ControlError
	
			fetch next from c_PviPendiente into @prvi_id
		end
	
		close c_PviPendiente 
		deallocate c_PviPendiente 

	end else begin

		update PresupuestoVentaItem set prvi_pendiente = 0
		where prv_id = @@prv_id
		if @@error <> 0 goto ControlError

	end

	commit transaction

	set @@bSuccess = 1

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el pendiente del Presupuesto de venta. sp_DocPresupuestoVentaSetItemPendiente.', 16, 1)
	rollback transaction	

end 

go