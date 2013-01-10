declare @table varchar(255)

declare c_t insensitive cursor for select name from sysobjects where xtype = 'U' and name not like '%dtp%'

open c_t

fetch next from c_t into @table
while @@fetch_status = 0
begin

    print 'ALTER TABLE ' + @table + ' DISABLE TRIGGER ALL;'

    fetch next from c_t into @table
end

close c_t

open c_t

fetch next from c_t into @table
while @@fetch_status = 0
begin

    exec sp_CreateDataLoadScript @table

    fetch next from c_t into @table
end

close c_t

open c_t

fetch next from c_t into @table
while @@fetch_status = 0
begin

    print 'ALTER TABLE ' + @table + ' ENABLE TRIGGER ALL;'

    fetch next from c_t into @table
end

close c_t

deallocate c_t