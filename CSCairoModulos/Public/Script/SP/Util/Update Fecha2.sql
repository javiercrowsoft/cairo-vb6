set nocount on

declare @fvd_id 			int
declare @fvd_fecha 		datetime
declare @fecha2 			datetime

declare c_facturaventa insensitive cursor for select fvd_id, fvd_fecha from facturaventadeuda
open c_facturaventa

fetch next from c_facturaventa into @fvd_id, @fvd_fecha
while @@fetch_status=0
begin


	exec sp_DocGetFecha2 @fvd_fecha,@fecha2 out, 0, null
	update facturaventadeuda set fvd_fecha2 = @fecha2 where fvd_id = @fvd_id
		
	fetch next from c_facturaventa into @fvd_id, @fvd_fecha
end

close c_facturaventa
deallocate c_facturaventa

GO
------------------------

set nocount on

declare @fcd_id 			int
declare @fcd_fecha 		datetime
declare @fecha2 			datetime

declare c_facturacompra insensitive cursor for select fcd_id, fcd_fecha from facturacompradeuda
open c_facturacompra

fetch next from c_facturacompra into @fcd_id, @fcd_fecha
while @@fetch_status=0
begin


	exec sp_DocGetFecha2 @fcd_fecha,@fecha2 out, 0, null
	update facturacompradeuda set fcd_fecha2 = @fecha2 where fcd_id = @fcd_id
		
	fetch next from c_facturacompra into @fcd_id, @fcd_fecha
end

close c_facturacompra
deallocate c_facturacompra

GO
------------------------

set nocount on

declare @cheq_id 			int
declare @cheq_fecha 	datetime
declare @fecha2 			datetime
declare @cle_id       int

declare c_cheque insensitive cursor for select cheq_id, cheq_fechacobro, cle_id from cheque
open c_cheque

fetch next from c_cheque into @cheq_id, @cheq_fecha, @cle_id
while @@fetch_status=0
begin

	exec sp_DocGetFecha2 @cheq_fecha,@fecha2 out, 1, @cle_id
	update cheque set cheq_fecha2 = @fecha2 where cheq_id = @cheq_id
		
	fetch next from c_cheque into @cheq_id, @cheq_fecha, @cle_id
end

close c_cheque
deallocate c_cheque