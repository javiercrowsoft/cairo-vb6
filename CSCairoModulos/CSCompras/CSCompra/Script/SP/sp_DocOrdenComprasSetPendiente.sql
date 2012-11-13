if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenComprasSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenComprasSetPendiente]

/*

 sp_DocOrdenComprasSetPendiente 

*/

go
create procedure sp_DocOrdenComprasSetPendiente (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @oc_id int

	declare c_Compras insensitive cursor for 
		select oc_id from OrdenCompra where oc_fecha between @@desde and @@hasta

	open c_Compras

	fetch next from c_Compras into @oc_id
	while @@fetch_status = 0 begin

		exec sp_DocOrdenCompraSetItemPendiente @oc_id
		exec sp_DocOrdenCompraSetPendiente @oc_id

		fetch next from c_Compras into @oc_id
  end

	close c_Compras
	deallocate c_Compras
end

go