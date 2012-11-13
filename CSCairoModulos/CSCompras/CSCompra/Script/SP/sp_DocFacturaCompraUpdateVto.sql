if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraUpdateVto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraUpdateVto]

/*

 sp_DocFacturaCompraUpdateVto 124

*/

go
create procedure sp_DocFacturaCompraUpdateVto (

			@@fc_id						int,
			@@diff  					int
)
as

begin

	declare @fcd_fecha2  datetime
	declare @fcd_fecha   datetime
	declare @fcd_id      int

	update FacturaCompraDeuda set fcd_fecha = dateadd(d,@@diff,fcd_fecha) where fc_id = @@fc_id
	update FacturaCompraPago  set fcp_fecha = dateadd(d,@@diff,fcp_fecha) where fc_id = @@fc_id

	declare c_deuda insensitive cursor for 
		select fcd_id, fcd_fecha from FacturaCompraDeuda where fc_id = @@fc_id

	open c_deuda

	fetch next from c_deuda into @fcd_id, @fcd_fecha
	while @@fetch_status=0
	begin

		exec sp_DocGetFecha2 @fcd_fecha, @fcd_fecha2 out, 0, null

		update FacturaCompraDeuda set fcd_fecha2 = @fcd_fecha2 where fcd_id = @fcd_id

		fetch next from c_deuda into @fcd_id, @fcd_fecha
	end

	close c_deuda
	deallocate c_deuda


end

go