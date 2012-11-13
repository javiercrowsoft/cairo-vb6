declare @db         sysname, 
				@sqlstmt		varchar(5000),
				@log_size   decimal(15,2)

select  @db = db_name()

create table #loginfo ( 
    id          int identity, 
    FileId      int, 
    FileSize    numeric(22,0), 
    StartOffset numeric(22,0), 
    FSeqNo      int, 
    Status      int, 
    Parity      smallint, 
    CreateTime  varchar(255) 
)

insert  #loginfo ( FileId, FileSize, StartOffset, FSeqNo, Status, Parity, CreateTime ) exec ( 'dbcc loginfo' )

select  @log_size = sum( FileSize ) / 1048576.00
from    #loginfo

if @log_size < 90 begin

	set @sqlstmt = 'ALTER DATABASE '+@db+' MODIFY FILE (NAME = Cairo_Log, SIZE = 100MB)'

	exec(@sqlstmt)

end

drop table #loginfo 
