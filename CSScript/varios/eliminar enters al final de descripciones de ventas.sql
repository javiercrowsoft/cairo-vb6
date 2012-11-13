declare @fv_id int
declare @fv_descrip varchar(255)

declare c_facturas insensitive cursor for select fv_id, fv_descrip from Facturaventa

open c_facturas

fetch next from c_facturas into @fv_id, @fv_descrip
while @@fetch_status=0
begin


	while right(@fv_descrip,1)=char(13) or right(@fv_descrip,1)=char(10) 
	begin
		if len(@fv_descrip) <= 1 set @fv_descrip = ''
		else                     set @fv_descrip = left(@fv_descrip,len(@fv_descrip)-1)
	end

	update Facturaventa set fv_descrip = @fv_descrip where fv_id = @fv_id


	fetch next from c_facturas into @fv_id, @fv_descrip
end

close c_facturas

deallocate c_facturas