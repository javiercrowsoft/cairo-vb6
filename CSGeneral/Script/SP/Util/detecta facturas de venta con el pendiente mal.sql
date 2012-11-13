create table #t_fv( fv_id			int,
										pendiente decimal(18,6),
										total     decimal(18,6),
										cobrado   decimal(18,6),
										aplicnc   decimal(18,6)
										)


declare @fv_id int

declare @pendiente decimal(18,6)
declare @cobrado   decimal(18,6)
declare @aplicnc   decimal(18,6)
declare @total     decimal(18,6)

declare c_fv insensitive cursor for select fv_id from facturaventa --where cli_id = 2
open c_fv
fetch next from c_fv into @fv_id
while @@fetch_status=0
begin

	set @pendiente =0
	set @cobrado   =0
	set @aplicnc   =0
	set @total     =0

	select @pendiente = fv_pendiente, @total = fv_total from facturaventa where fv_id = @fv_id

	select @cobrado = sum(fvcobz_importe) from facturaventacobranza where fv_id = @fv_id
	select @aplicnc = sum(fvnc_importe) from facturaventanotacredito where fv_id_notacredito = @fv_id or fv_id_factura = @fv_id

	set @pendiente =isnull(@pendiente,0)
	set @cobrado   =isnull(@cobrado,0)
	set @aplicnc   =isnull(@aplicnc,0)
	set @total     =isnull(@total,0)

	if abs(@pendiente) - abs(@total - @cobrado - @aplicnc)>0.05
		insert into #t_fv values(@fv_id,@pendiente, @total, @cobrado, @aplicnc)

	fetch next from c_fv into @fv_id
end
close c_fv
deallocate c_fv

select 'exec sp_DocFacturaVentaSetPendiente ' + convert(varchar,fv_id),* from #t_fv
drop table #t_fv