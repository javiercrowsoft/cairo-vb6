if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CreateDataLoadScript]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CreateDataLoadScript]
GO

Create Procedure sp_CreateDataLoadScript
@TblName varchar(128)
as
/*
exec sp_CreateDataLoadScript 'Lenguaje'
*/
set nocount on

  create table #a (id int identity (1,1), ColType int, ColName varchar(128))

  insert   #a (ColType, ColName)
  select case    when DATA_TYPE like '%char%' then 1
                when DATA_TYPE like '%image%' then 2 
                when DATA_TYPE like '%datetime%' then 3 
                when DATA_TYPE like '%text%' then 4 
                else 0 end ,
    COLUMN_NAME
  from   information_schema.columns
  where   TABLE_NAME = @TblName
  order by ORDINAL_POSITION
  
  if not exists (select * from #a)
  begin
    raiserror('No columns found for table %s', 16,-1, @TblName)
    return
  end

declare  @id int ,
  @maxid int ,
  @insert varchar(8000) ,
  @select1 varchar(8000) ,
  @select2 varchar(8000) ,
  @declare varchar(8000) ,
  @fetchList varchar(8000) ,
  @values varchar(8000) ,
  @lr varchar(10)

  set @lr = char(13) + char(10)

  select @id = 0 ,
    @maxid = max(id)
  from #a

  select  @insert = 'insert into ' + @TblName + ' ( '
  select  @select1 = 'select '
  select  @select2 = ''
  select  @fetchList = 'fetch next from c_cur into '
  select  @values = ''
  select  @declare = ''

  while @id < @maxid
  begin
    select @id = min(id) from #a where id > @id

    select   @insert = @insert + ColName + ',',
            @declare = @declare + 'declare @' + ColName + ' varchar(8000)' + @lr,
            @fetchList = @fetchList + '@' + ColName + @lr + ',',
            @values = @values + ' + @' + Colname + @lr + ' + '','''
    from  #a
    where  id = @id

    if len(@select1) < 7000 begin
        select @select1 =   @select1
            + ' case when ' + ColName + ' is null '
            +  ' then ''null'' '
            +  ' else '
            +    case 
                    when ColType = 1 then ''''''''' + replace(' + ColName + ','''''''','''''''''''') + ''''''''' 
                    when ColType = 2 then '''null'''
                    when ColType = 3 then '''to_date('''''' + convert(varchar(20),' + ColName + ') + '''''', ''''Mon DD YYYY HH:MIAM'''')''' --Jan 21 2009  7:36AM
                    when ColType = 4 then ''''''''' + replace(convert(varchar(8000),' + ColName + '),'''''''','''''''''''') + '''''''''
                    else 'convert(varchar(255),' + ColName + ')' 
                end
            + ' end ' + @lr + ','
        from  #a
        where  id = @id
    end else begin
        select @select2 =   @select2
            + ' case when ' + ColName + ' is null '
            +  ' then ''null'' '
            +  ' else '
            +    case 
                    when ColType = 1 then ''''''''' + replace(' + ColName + ','''''''','''''''''''') + ''''''''' 
                    when ColType = 2 then '''null'''
                    when ColType = 3 then '''to_date('''''' + convert(varchar(20),' + ColName + ') + '''''', ''''Mon DD YYYY HH:MIAM'''')''' --Jan 21 2009  7:36AM 
                    when ColType = 4 then ''''''''' + replace(convert(varchar(8000),' + ColName + '),'''''''','''''''''''') + '''''''''
                    else 'convert(varchar(20),' + ColName + ')' 
                end
            + ' end ' + @lr + ','
        from  #a
        where  id = @id
    end
  end

  select @insert = left(@insert,len(@insert)-1) + ' ) ',
         @fetchList = left(@fetchList,len(@fetchList)-1),
         @values = left(@values,len(@values)-8)
  
  if @select2 = ''
    select @select1 = left(@select1,len(@select1)-1) + ' from ' + @tblName
  else
    select @select2 = left(@select2,len(@select2)-1) + ' from ' + @tblName

  declare @curDeclare varchar(255)
  declare @curOpen varchar(255)
  declare @while varchar(255)
  declare @whileEnd varchar(255)
  declare @curEnd varchar(255)

  set @curDeclare = 'declare c_cur insensitive cursor for '
  set @curOpen = 'open c_cur'
  set @while = 'while @@fetch_status = 0 begin'
  set @whileEnd = 'end'
  set @curEnd = 'close c_cur' + @lr + 'deallocate c_cur'

--  print '--insert: ' + @insert + ' >>'
--  print '--select1: ' + @select1 + ' >>'
--  print '--select2: ' + @select2 + ' >>'
--  print '--curDeclare: ' + @curDeclare + ' >>'
--  print '--curOpen: ' + @curOpen + ' >>'
--  print '--while: ' + @while + ' >>'
--  print '--whileEnd: ' + @whileEnd + ' >>'
--  print '--curEnd: ' + @curEnd + ' >>'
--  print '--values: ' + @values + ' >>'
--  print '--declare: ' + @declare + ' >>'
--  print '--fetchList: ' + @fetchList + ' >>'

  exec (    @declare 
          + @lr
          + @curDeclare 
          + @lr
          + @select1 + @select2 
          + @lr
          + @curOpen
          + @lr
          + @fetchList 
          + @lr
          + @while
            + @lr
            + 'print ''' + @insert + ''''
            + @lr
            + 'print ''values('' ' + @values + ' + '');'''
            + @lr
            + 'print ''--''' 
            + @lr
            + @fetchList 
            + @lr
          + @whileEnd
          + @lr
          + @curEnd
        )
  drop table #a

go