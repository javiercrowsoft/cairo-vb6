declare  c_anulado insensitive cursor for select fc_id,as_id from facturacompra where est_id = 7 and as_id is not null
open c_anulado

declare @fc_id int
declare @as_id int

fetch next from c_anulado into @fc_id, @as_id
while @@fetch_status=0
begin

	update facturacompra set as_id = null where fc_id = @fc_id
	exec sp_docasientodelete @as_id

	fetch next from c_anulado into @fc_id, @as_id
end

close c_anulado
deallocate c_anulado

