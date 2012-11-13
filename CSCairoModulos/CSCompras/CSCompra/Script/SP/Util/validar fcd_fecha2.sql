begin tran

declare @fcd_id int
declare @fecha datetime
declare @fcd_fecha datetime

declare c_fechas insensitive cursor for

select fcd_id, fcd_fecha from facturacompradeuda where fcd_fecha2 < fcd_fecha

open c_fechas
fetch next from c_fechas into @fcd_id, @fcd_fecha
while @@fetch_status=0
begin

	exec sp_DocGetFecha2 @fcd_fecha, @fecha out, 0, null	

	update FacturaCompraDeuda set fcd_fecha2 = @fecha where fcd_id = @fcd_id

	fetch next from c_fechas into @fcd_id, @fcd_fecha
end
close c_fechas
deallocate c_fechas

select fcd_id, fcd_fecha from facturacompradeuda where fcd_fecha2 < fcd_fecha

rollback tran