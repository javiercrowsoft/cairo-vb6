create table #t_fc( fc_id			int,
										pendiente decimal(18,6),
										total     decimal(18,6),
										cobrado   decimal(18,6),
										aplicnc   decimal(18,6)
										)


declare @fc_id int

declare @pendiente decimal(18,6)
declare @cobrado   decimal(18,6)
declare @aplicnc   decimal(18,6)
declare @total     decimal(18,6)

declare c_fc insensitive cursor for select fc_id from facturacompra --where prov_id = 2
open c_fc
fetch next from c_fc into @fc_id
while @@fetch_status=0
begin

	set @pendiente =0
	set @cobrado   =0
	set @aplicnc   =0
	set @total     =0

	select @pendiente = fc_pendiente, @total = fc_total from facturacompra where fc_id = @fc_id

	select @cobrado = sum(fcopg_importe) from facturacompraordenpago where fc_id = @fc_id
	select @aplicnc = sum(fcnc_importe) from facturacompranotacredito where fc_id_notacredito = @fc_id or fc_id_factura = @fc_id

	set @pendiente =isnull(@pendiente,0)
	set @cobrado   =isnull(@cobrado,0)
	set @aplicnc   =isnull(@aplicnc,0)
	set @total     =isnull(@total,0)

	if abs(@pendiente) - abs(@total - @cobrado - @aplicnc)>0.05
		insert into #t_fc values(@fc_id,@pendiente, @total, @cobrado, @aplicnc)

	fetch next from c_fc into @fc_id
end
close c_fc
deallocate c_fc

select 'exec sp_DocFacturacompraSetPendiente ' + convert(varchar,fc_id),* from #t_fc
drop table #t_fc