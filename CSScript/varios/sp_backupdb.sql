/*

declare @file varchar(255)

set @file = 'C:\SQL\Backup\model-' + convert(varchar,getdate(),105) + '.bak'

exec sp_sqlbackup 'model', @file

*/

alter procedure sp_sqlbackup (

	@@database varchar(255),
	@@filename varchar(255)

)

as
begin

	declare @sqlstmt varchar(5000)

	set @sqlstmt = 'BACKUP DATABASE '+ @@database +' TO DISK=''' + @@filename + ''' WITH NOUNLOAD ,  NOSKIP,  INIT'

	exec(@sqlstmt)
	--print @sqlstmt

end