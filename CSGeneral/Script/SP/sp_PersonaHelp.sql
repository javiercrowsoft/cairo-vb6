if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PersonaHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PersonaHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_personahelp 1, 1, 0, 'Alvarez',-1,0,'prs_esempleado <> 0'

*/

create procedure sp_PersonaHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@prs_id          int           = 0,
  @@filter2         varchar(255)  = ''
)
as

begin
  set nocount on
  
  set @@filter = replace(@@filter,'''','''''')

  declare @sqlstmt varchar(5000)

  set @@filter = replace(@@filter,'''','''''')

  if @@check <> 0 begin
  
    set @sqlstmt =             'select prs_id, '
    set @sqlstmt = @sqlstmt + '        prs_apellido +'', '' + prs_nombre'
    set @sqlstmt = @sqlstmt + '                      as [Nombre], '
    set @sqlstmt = @sqlstmt + '        prs_codigo     as [Codigo] '

    set @sqlstmt = @sqlstmt + 'from Persona prs '

    set @sqlstmt = @sqlstmt + 'where (prs_id > 0) and '
                            + '((prs_nombre = '''+@@filter +''' and prs_nombre<>'''')'
                            +  ' or (prs_apellido = '''+@@filter +''' and prs_apellido<>'''')'
                            +  ' or prs_apellido + '', '' + prs_nombre = '''+@@filter
                            +''' or prs_codigo = '''+@@filter+''''
                            +') '

    if @@prs_id <> 0
      set @sqlstmt = @sqlstmt + '   and (prs_id = ' + convert(varchar(20),@@prs_id) + ') '

    if @@bForAbm = 0 set @sqlstmt = @sqlstmt + '  and prs.activo <> 0 ' 

    if @@filter2 <> '' 
      set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

  end else begin

    declare @filter_apellido varchar(255)
    declare @filter_nombre   varchar(255)

    if charindex(' ',@@filter)<> 0 begin

      set @filter_nombre       = rtrim(ltrim(left(@@filter, charindex(' ',@@filter))))
      set @filter_apellido    = rtrim(ltrim(substring(@@filter, charindex(' ',@@filter),255)))

    end else begin

      set @filter_apellido = ''
      set @filter_nombre   = ''

    end

    set @sqlstmt =            'select top 50 prs_id, '
    set @sqlstmt = @sqlstmt + '        prs_apellido  as Apellido,'
    set @sqlstmt = @sqlstmt + '        prs_nombre    as Nombre,'
    set @sqlstmt = @sqlstmt + '       prs_codigo    as Codigo,'
    set @sqlstmt = @sqlstmt + '       prs_celular   as Celular,'
    set @sqlstmt = @sqlstmt + '       prs_email     as Email,'
    set @sqlstmt = @sqlstmt + '       prs_telCasa   as Telefono,'
    set @sqlstmt = @sqlstmt + '       prs.activo    as Activo '
    set @sqlstmt = @sqlstmt + 'from Persona prs '
    
    set @sqlstmt = @sqlstmt + 'where '+
                              '(prs_codigo like ''%'+@@filter
                                +'%'' or prs_apellido like ''%'+@@filter
                                +'%'' or prs_apellido+'' ''+prs_nombre like ''%'+@@filter
                                +'%'' or prs_apellido+'', ''+prs_nombre like ''%'+@@filter
                                +'%'' or prs_nombre+'' ''+prs_apellido like ''%'+@@filter
                                +'%'' or prs_nombre like ''%'+@@filter
                                +'%'' or prs_celular like ''%'+@@filter
                                +'%'' or prs_telCasa like ''%'+@@filter+ '%'''

                            if @filter_nombre <> '' and @filter_apellido <> '' begin
                                set @sqlstmt = @sqlstmt
                                +' or (charindex('''+@filter_nombre+''',prs_nombre)<>0'
                                     +' and charindex('''+@filter_apellido+''',prs_apellido)<>0'
                                     +')'
                                +' or (charindex('''+@filter_apellido+''',prs_nombre)<>0'
                                     +' and charindex('''+@filter_nombre+''',prs_apellido)<>0'
                                     +')'
                            end

    set @sqlstmt = @sqlstmt 
                                +   ' or prs_email like ''%'+@@filter
                                +'%'' or ''' + @@filter + ''' = '''') '
    
    if @@bForAbm = 0 set @sqlstmt = @sqlstmt + '  and prs.activo <> 0 ' 
    
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

