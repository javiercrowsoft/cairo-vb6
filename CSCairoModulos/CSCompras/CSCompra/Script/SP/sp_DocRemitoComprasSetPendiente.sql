if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoComprasSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoComprasSetPendiente]

/*

 sp_DocRemitoComprasSetPendiente 

*/

go
create procedure sp_DocRemitoComprasSetPendiente (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @rc_id int

	declare c_Compras insensitive cursor for 
		select rc_id from RemitoCompra where rc_fecha between @@desde and @@hasta

	open c_Compras

	fetch next from c_Compras into @rc_id
	while @@fetch_status = 0 begin

		exec sp_DocRemitoCompraSetItemPendiente @rc_id
		exec sp_DocRemitoCompraSetPendiente @rc_id

		fetch next from c_Compras into @rc_id
  end

	close c_Compras
	deallocate c_Compras
end