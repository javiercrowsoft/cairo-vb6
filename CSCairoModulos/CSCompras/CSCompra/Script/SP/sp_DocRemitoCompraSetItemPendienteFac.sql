if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraSetItemPendienteFac]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraSetItemPendienteFac]

/*

	exec	sp_DocRemitoCompraSetItemPendienteFac 23

*/

go
create procedure sp_DocRemitoCompraSetItemPendienteFac (
	@@rc_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @rci_id        int

	begin transaction

	declare @aplicadofactura 	decimal(18,6)
	
	declare c_RciPendiente insensitive cursor for 

				select rci_id
				from 
							RemitoCompraItem 

				where rc_id = @@rc_id

	open c_RciPendiente 
	
	fetch next from c_RciPendiente into @rci_id
	while @@fetch_status = 0 
	begin

		select @aplicadofactura = isnull(sum(rcfc_cantidad),0)
		from 
					RemitoFacturaCompra
		where rci_id = @rci_id

		update RemitoCompraItem set rci_pendientefac = rci_cantidadaremitir - @aplicadofactura 
					where rci_id = @rci_id
	
		if @@error <> 0 goto ControlError

		fetch next from c_RciPendiente into @rci_id
	end

	close c_RciPendiente 
	deallocate c_RciPendiente 

	commit transaction

	set @@bSuccess = 1

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el pendiente del remito de compra. sp_DocRemitoCompraSetItemPendienteFac.', 16, 1)
	rollback transaction	

end 

go