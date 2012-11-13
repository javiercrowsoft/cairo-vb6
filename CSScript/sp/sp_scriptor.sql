if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_Scriptor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_Scriptor]

go
create procedure sp_scriptor(
	@@table varchar(50),
	@@condicion varchar(8000)='',
	@@PrintPlantilla smallint = 0
)
as
set nocount on

declare @sqlselect varchar(20)
declare @sqlstmt varchar(8000)
declare @sqlstmt2 varchar(8000)
declare @campo varchar(50)
declare @tipo int

create table #tcampos (nombre varchar(50),tipo int)

insert into #tcampos exec sp_columnas @@table

select @sqlselect = 'select p = '''
select @sqlstmt = ' insert into ' + @@table + ' ('
select @sqlstmt2 =''

declare campos insensitive cursor for select nombre,tipo from #tcampos

open campos
fetch next from campos
into @campo,@tipo
 while @@fetch_status= 0
 begin
	select @sqlstmt = @sqlstmt + @campo + ','
	if @campo is null 
		select @sqlstmt2 = @sqlstmt2 + 'NULL +' + ''',''' + '+'	
	else
	begin
		if (@tipo = 56 
		or @tipo = 52)select @sqlstmt2 = @sqlstmt2 + 'convert(varchar(15),' + @campo + ')+' + ''',''' + '+'
		if @tipo = 39 select @sqlstmt2 = @sqlstmt2 + '''''''''' + '+' + @campo + '+' + '''''''''' + '+' + ''',''' + '+'
		if @tipo = 61 select @sqlstmt2 = @sqlstmt2 + '''''''''' + '+' + 'convert(varchar(10),' + @campo + ',20)+' +'''''''''' + '+' + ''',''' + '+'
	end
	
	fetch next from campos
	into @campo,@tipo
 end
close campos
deallocate campos

select @sqlstmt = substring(@sqlstmt,1,len(@sqlstmt)-1) + ') values ('
select @sqlstmt2 = substring(@sqlstmt2,1,len(@sqlstmt2)-5) +'+'+''''+ ')'+ ''''
select @sqlstmt = @sqlselect + @sqlstmt +''''+'+'+ @sqlstmt2 + 'from '+ @@table 

if @@PrintPlantilla <> 0 print @sqlstmt

exec (@sqlstmt)
go