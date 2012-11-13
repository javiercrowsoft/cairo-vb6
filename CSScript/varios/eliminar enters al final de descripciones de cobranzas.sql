declare @cobz_id int
declare @cobz_descrip varchar(255)

declare c_facturas insensitive cursor for select cobz_id, cobz_descrip from Cobranza

open c_facturas

fetch next from c_facturas into @cobz_id, @cobz_descrip
while @@fetch_status=0
begin


	while right(@cobz_descrip,1)=char(13) or right(@cobz_descrip,1)=char(10) 
	begin
		if len(@cobz_descrip) <= 1 set @cobz_descrip = ''
		else                       set @cobz_descrip = left(@cobz_descrip,len(@cobz_descrip)-1)
	end

	update Cobranza set cobz_descrip = @cobz_descrip where cobz_id = @cobz_id


	fetch next from c_facturas into @cobz_id, @cobz_descrip
end

close c_facturas

deallocate c_facturas