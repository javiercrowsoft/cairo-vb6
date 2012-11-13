if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaComprasSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaComprasSetPendiente]

/*

 sp_DocFacturaComprasSetPendiente 

*/

go
create procedure sp_DocFacturaComprasSetPendiente (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @fc_id int

	declare c_Compras insensitive cursor for 
		select fc_id from facturaCompra where fc_fecha between @@desde and @@hasta

	open c_Compras

	fetch next from c_Compras into @fc_id
	while @@fetch_status = 0 begin

		exec sp_DocFacturaCompraSetItemPendiente @fc_id
		exec sp_DocFacturaCompraSetPendiente @fc_id

		fetch next from c_Compras into @fc_id
  end

	close c_Compras
	deallocate c_Compras
end