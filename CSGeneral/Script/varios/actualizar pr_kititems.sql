declare @pr_id int

declare c_pr insensitive cursor for select pr_id from producto where pr_eskit <> 0

open c_pr

fetch next from c_pr into @pr_id

while @@fetch_status=0 begin

	exec sp_ProductoSaveKit @pr_id

	fetch next from c_pr into @pr_id

end

close c_pr
deallocate c_pr