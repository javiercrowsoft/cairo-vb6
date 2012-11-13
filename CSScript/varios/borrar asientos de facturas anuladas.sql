declare  c_anulado insensitive cursor for select fv_id,as_id from facturaventa where est_id = 7 and as_id is not null
open c_anulado

declare @fv_id int
declare @as_id int

fetch next from c_anulado into @fv_id, @as_id
while @@fetch_status=0
begin

	update facturaventa set as_id = null where fv_id = @fv_id
	exec sp_docasientodelete @as_id

	fetch next from c_anulado into @fv_id, @as_id
end

close c_anulado
deallocate c_anulado

