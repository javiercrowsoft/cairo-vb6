if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProfesorHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProfesorHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_profesorhelp 1, 1, 1, '''',0,0

*/

create procedure sp_ProfesorHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@prof_id         int           = 0,
  @@filter2         varchar(255)  = ''
)
as

begin
  set nocount on
  
  set @@filter = replace(@@filter,'''','''''')

  declare @sqlstmt varchar(5000)

  set @@filter = replace(@@filter,'''','''''')

  if @@check <> 0 begin
  
    set @sqlstmt =             'select prof_id, '
    set @sqlstmt = @sqlstmt + '        prs_apellido +'', '' + prs_nombre'
    set @sqlstmt = @sqlstmt + '                        as [Nombre], '
    set @sqlstmt = @sqlstmt + '        prof_codigo     as [Codigo] '

    set @sqlstmt = @sqlstmt + 'from Profesor prof inner join Persona prs on prof.prs_id = prs.prs_id '

    set @sqlstmt = @sqlstmt + 'where (prof_id > 0) and '
                            + '((prs_nombre = '''+@@filter +''' and prs_nombre<>'''')'
                            +  ' or (prs_apellido = '''+@@filter +''' and prs_apellido<>'''')'
                            +  ' or prs_apellido + '', '' + prs_nombre = '''+@@filter
                            +''' or prof_codigo = '''+@@filter
                            +''' or (prof_legajo = '''+@@filter +''' and prof_legajo<>'''')'
                            +') '

    if @@prof_id <> 0
      set @sqlstmt = @sqlstmt + '   and (prof_id = ' + convert(varchar(20),@@prof_id) + ') '

    if @@bForAbm = 0 set @sqlstmt = @sqlstmt + '  and prof.activo <> 0 ' 

    if @@filter2 <> '' 
      set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

  end else begin

    set @sqlstmt =            'select prof_id, '
    set @sqlstmt = @sqlstmt + '        prs_apellido  as Apellido,'
    set @sqlstmt = @sqlstmt + '        prs_nombre    as Nombre,'
    set @sqlstmt = @sqlstmt + '       prof_codigo   as Codigo,'
    set @sqlstmt = @sqlstmt + '       prof_legajo   as Legajo,'
    set @sqlstmt = @sqlstmt + '       prof.activo   as Activo,'
    set @sqlstmt = @sqlstmt + '       us_nombre     as Modifico '
    set @sqlstmt = @sqlstmt + 'from Profesor prof inner join Persona prs on prof.prs_id = prs.prs_id'
    set @sqlstmt = @sqlstmt + '                    inner join Usuario us  on prof.modifico = us.us_id '
    
    set @sqlstmt = @sqlstmt + 'where (prof_id > 0 ) and '+
                              '(prof_codigo like ''%'+@@filter
                                +'%'' or prs_apellido like ''%'+@@filter
                                +'%'' or prs_nombre like ''%'+@@filter
                                +'%'' or prof_legajo like ''%'+@@filter
                                +'%'' or ''' + @@filter + ''' = '''') '
    
    if @@bForAbm = 0 set @sqlstmt = @sqlstmt + '  and prof.activo <> 0 ' 
    
    if @@filter2 <> '' 
      set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

  end    

  if @@bForAbm = 0 set @sqlstmt = @sqlstmt

  --print(@sqlstmt)
  exec(@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

