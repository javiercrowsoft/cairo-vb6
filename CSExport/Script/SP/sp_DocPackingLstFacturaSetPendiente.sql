if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingLstFacturaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingLstFacturaSetPendiente]

/*

 sp_DocPackingLstFacturaSetPendiente 124

*/

GO
create procedure sp_DocPackingLstFacturaSetPendiente (
	@@pklst_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de las Facturas
	--
	declare @fv_id int

	declare c_FacturaPendiente insensitive cursor for 
		select distinct fv_id 
		from PackingListFacturaVenta pklstfv 	inner join PackingListItem pklsti 	on pklstfv.pklsti_id = pklsti.pklsti_id
															  	        inner join FacturaVentaItem fvi     on pklstfv.fvi_id = fvi.fvi_id
		where pklst_id = @@pklst_id
	union
		select fv_id from #FacturaVentaPacking
	
	open c_FacturaPendiente
	fetch next from c_FacturaPendiente into @fv_id
	while @@fetch_status = 0 begin
		-- Actualizo la deuda de la factura
		exec sp_DocFacturaVentaSetItemPendiente @fv_id, @@bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		fetch next from c_FacturaPendiente into @fv_id
	end
	close c_FacturaPendiente
	deallocate c_FacturaPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente de la factura de venta. sp_DocPackingLstFacturaSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO