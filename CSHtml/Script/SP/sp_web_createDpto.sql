SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_createDpto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_createDpto]
GO

/*

  create table #webDpto (
                          dpto_id       int,
                          dpto_nombre1 varchar(255),
                          dpto_nombre2 varchar(255),
                          dpto_nombre3 varchar(255),
                          dpto_nombre4 varchar(255),
                          dpto_nombre5 varchar(255),
                          dpto_nombre6 varchar(255)
                        )

  exec sp_web_createDpto null,1

  select * from #webDpto 

  drop table #webDpto 

*/

create procedure sp_web_createDpto(
  @@dpto_id int,
  @@n       tinyint
)
as
begin

  set nocount on

/*
  create table #webDpto (
                          dpto_id      int,
                          dpto_nombre1 varchar(255),
                          dpto_nombre2 varchar(255),
                          dpto_nombre3 varchar(255),
                          dpto_nombre4 varchar(255),
                          dpto_nombre5 varchar(255),
                          dpto_nombre6 varchar(255)
                        )
*/

  declare @sqlstmt varchar(5000)

  if @@n = 2  update #webDpto set dpto_nombre2='',dpto_nombre3='',dpto_nombre4='',dpto_nombre5='',dpto_nombre6='',dpto_nombre7='',dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 3  update #webDpto set dpto_nombre3='',dpto_nombre4='',dpto_nombre5='',dpto_nombre6='',dpto_nombre7='',dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 4  update #webDpto set dpto_nombre4='',dpto_nombre5='',dpto_nombre6='',dpto_nombre7='',dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 5  update #webDpto set dpto_nombre5='',dpto_nombre6='',dpto_nombre7='',dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 6  update #webDpto set dpto_nombre6='',dpto_nombre7='',dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 7  update #webDpto set dpto_nombre7='',dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 8  update #webDpto set dpto_nombre8='',dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 9  update #webDpto set dpto_nombre9='',dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 10 update #webDpto set dpto_nombre10='',dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 11 update #webDpto set dpto_nombre11='',dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 12 update #webDpto set dpto_nombre12='',dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 13 update #webDpto set dpto_nombre13='',dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 14 update #webDpto set dpto_nombre14='',dpto_nombre15='' where dpto_id = @@dpto_id
  if @@n = 15 update #webDpto set dpto_nombre15='' where dpto_id = @@dpto_id


  set @sqlstmt = 'insert into #webDpto (dpto_id,dpto_nombre'
  if @@n = 1 set @sqlstmt = @sqlstmt + '1'
  if @@n = 2 set @sqlstmt = @sqlstmt + '2'
  if @@n = 3 set @sqlstmt = @sqlstmt + '3'
  if @@n = 4 set @sqlstmt = @sqlstmt + '4'
  if @@n = 5 set @sqlstmt = @sqlstmt + '5'
  if @@n = 6 set @sqlstmt = @sqlstmt + '6'
  if @@n = 7 set @sqlstmt = @sqlstmt + '7'
  if @@n = 8 set @sqlstmt = @sqlstmt + '8'
  if @@n = 9 set @sqlstmt = @sqlstmt + '9'
  if @@n = 10 set @sqlstmt = @sqlstmt + '10'
  if @@n = 11 set @sqlstmt = @sqlstmt + '11'
  if @@n = 12 set @sqlstmt = @sqlstmt + '12'
  if @@n = 13 set @sqlstmt = @sqlstmt + '13'
  if @@n = 14 set @sqlstmt = @sqlstmt + '14'
  if @@n = 15 set @sqlstmt = @sqlstmt + '15'

  set @sqlstmt = @sqlstmt + ') select dpto_id, dpto_nombre from Departamento where dpto_id_padre '

  if @@dpto_id is null set @sqlstmt = @sqlstmt +  ' is null'
  else                 set @sqlstmt = @sqlstmt +  '= ' + convert(varchar(255),@@dpto_id)

  exec (@sqlstmt)

  declare @sqlstmt3 varchar(5000)

  declare @dpto_id int

  set @sqlstmt = 'update #webDpto set dpto_nombre' 

  if @@n = 1 set @sqlstmt = @sqlstmt + '1'
  if @@n = 2 set @sqlstmt = @sqlstmt + '2'
  if @@n = 3 set @sqlstmt = @sqlstmt + '3'
  if @@n = 4 set @sqlstmt = @sqlstmt + '4'
  if @@n = 5 set @sqlstmt = @sqlstmt + '5'
  if @@n = 6 set @sqlstmt = @sqlstmt + '6'
  if @@n = 7 set @sqlstmt = @sqlstmt + '7'
  if @@n = 8 set @sqlstmt = @sqlstmt + '8'
  if @@n = 9 set @sqlstmt = @sqlstmt + '9'
  if @@n = 10 set @sqlstmt = @sqlstmt + '10'
  if @@n = 11 set @sqlstmt = @sqlstmt + '11'
  if @@n = 12 set @sqlstmt = @sqlstmt + '12'
  if @@n = 13 set @sqlstmt = @sqlstmt + '13'
  if @@n = 14 set @sqlstmt = @sqlstmt + '14'
  if @@n = 15 set @sqlstmt = @sqlstmt + '15'

  set @sqlstmt = @sqlstmt + ' = dpto_nombre from Departamento where #webDpto.dpto_nombre'

  if @@n = 1 set @sqlstmt = @sqlstmt + '1'
  if @@n = 2 set @sqlstmt = @sqlstmt + '2'
  if @@n = 3 set @sqlstmt = @sqlstmt + '3'
  if @@n = 4 set @sqlstmt = @sqlstmt + '4'
  if @@n = 5 set @sqlstmt = @sqlstmt + '5'
  if @@n = 6 set @sqlstmt = @sqlstmt + '6'
  if @@n = 7 set @sqlstmt = @sqlstmt + '7'
  if @@n = 8 set @sqlstmt = @sqlstmt + '8'
  if @@n = 9 set @sqlstmt = @sqlstmt + '9'
  if @@n = 10 set @sqlstmt = @sqlstmt + '10'
  if @@n = 11 set @sqlstmt = @sqlstmt + '11'
  if @@n = 12 set @sqlstmt = @sqlstmt + '12'
  if @@n = 13 set @sqlstmt = @sqlstmt + '13'
  if @@n = 14 set @sqlstmt = @sqlstmt + '14'
  if @@n = 15 set @sqlstmt = @sqlstmt + '15'

  declare @sqlstmt2 varchar(5000)

  set @@n = @@n+1

  while exists(select * from Departamento where dpto_id > IsNull(@dpto_id,0) and IsNull(dpto_id_padre,0) = IsNull(@@dpto_id,0))
  begin

    select @dpto_id = min(dpto_id) from Departamento where dpto_id > IsNull(@dpto_id,0) and IsNull(dpto_id_padre,0) = IsNull(@@dpto_id,0)

    exec sp_web_createDpto @dpto_id, @@n

    set @sqlstmt2 = @sqlstmt + ' is null and Departamento.dpto_id ='+convert(varchar(255), @dpto_id)
    exec (@sqlstmt2)

  end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go

