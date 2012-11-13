if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenComprasSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenComprasSetCredito]

/*

 sp_DocOrdenComprasSetCredito 

*/

go
create procedure sp_DocOrdenComprasSetCredito (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @oc_id int

	declare c_compras insensitive cursor for 
		select oc_id from Ordencompra where oc_fecha between @@desde and @@hasta

	open c_compras

	fetch next from c_compras into @oc_id
	while @@fetch_status = 0 begin

		exec sp_DocOrdenCompraSetCredito @oc_id

		fetch next from c_compras into @oc_id
  end

	close c_compras
	deallocate c_compras
end