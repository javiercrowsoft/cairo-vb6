if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentasSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentasSetPendiente]

/*

 sp_DocPresupuestoVentasSetPendiente 

*/

go
create procedure sp_DocPresupuestoVentasSetPendiente (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @prv_id int

	declare c_Ventas insensitive cursor for 
		select prv_id from PresupuestoVenta where prv_fecha between @@desde and @@hasta

	open c_Ventas

	fetch next from c_Ventas into @prv_id
	while @@fetch_status = 0 begin

		exec sp_DocPresupuestoVentaSetPendiente @prv_id

		fetch next from c_Ventas into @prv_id
  end

	close c_Ventas
	deallocate c_Ventas
end