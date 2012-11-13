if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaComprasSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaComprasSetCredito]

/*

 sp_DocFacturaComprasSetCredito 

*/

go
create procedure sp_DocFacturaComprasSetCredito (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @fc_id int

	declare c_compras insensitive cursor for 
		select fc_id from facturacompra where fc_fecha between @@desde and @@hasta

	open c_compras

	fetch next from c_compras into @fc_id
	while @@fetch_status = 0 begin

		exec sp_DocFacturaCompraSetCredito @fc_id

		fetch next from c_compras into @fc_id
  end

	close c_compras
	deallocate c_compras
end