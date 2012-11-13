if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RenameColumns]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RenameColumns]
GO


-- sp_RenameColumns 'descripcion','descrip'
create procedure sp_RenameColumns(
	@@toSearch		varchar(255),
        @@ReplaceWith		varchar(255)
)
as

declare @column  varchar (255)
declare @table   varchar (255)
declare @newname varchar (255)
declare @sqlstmt varchar (5000)
declare c_cols insensitive cursor for 
select c.name,o.name from syscolumns c, sysobjects o where c.name like '%'+ @@toSearch and c.id = o.id

open c_cols

fetch next from c_cols into @column ,@table
while @@fetch_status = 0 begin

	set @NewName = replace(@column,@@toSearch,@@ReplaceWith)

	set @sqlstmt = 'sp_rename ' + '''' + @table +'.[' + @column + ']' + '''' + ',' 
                                    + '''' + @NewName + '''' + ','
                                    + '''COLUMN'''
	print (@sqlstmt)
	exec (@sqlstmt)

	fetch next from c_cols into @column, @table
end

close c_cols
deallocate c_cols

go

--EXEC sp_rename 'customers.[contact title]', 'title', 'COLUMN'