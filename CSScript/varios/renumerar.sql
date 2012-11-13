declare c insensitive cursor for select ram_id from rama

declare @ram_id int
declare @ram_id2 int

declare c2 insensitive cursor for select ram_id from rama where ram_id_padre = @ram_id

declare @i smallint

open c

fetch next from c into @ram_id

while @@fetch_status = 0
begin

	set @i=0

	open c2
	fetch next from c into @ram_id2

	while @@fetch_status = 0
	begin
		update rama set ram_orden = @i where ram_id = @ram_id2
		set @i = @i +1		

		fetch next from c into @ram_id2
	end
	close c2	

	fetch next from c into @ram_id	
end

deallocate c
deallocate c2