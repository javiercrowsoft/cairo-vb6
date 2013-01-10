if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_TareaEstadoHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TareaEstadoHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_TareaEstadoHelp 1,1,0,'',0,0,'2'

*/
create procedure sp_TareaEstadoHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@tarest_id       int            = 0,
  @@filteraux       varchar(255)  = ''
)
as
begin

  set nocount on

  set @@filter = replace(@@filter,'''','''''')
  
  if @@filteraux <> '' begin
    set @@filteraux = 'inner join ProyectoTareaEstado proy on t.tarest_id = proy.tarest_id and proy.proy_id = ' + @@filteraux
  end

  declare @sqlstmt varchar(8000)

  if @@check <> 0 begin

    set @sqlstmt = 

   'select  t.tarest_id,
            tarest_nombre        as [Nombre],
            tarest_codigo       as [Codigo]

    from TareaEstado t ' + @@filteraux + '
    where (tarest_nombre = '''+convert(varchar(255),@@filter)+''' or tarest_codigo = '''+convert(varchar(255),@@filter)+''')
      and t.activo <> 0'

  end else begin

      set @sqlstmt = 

     'select top 50
             t.tarest_id,
             tarest_nombre       as [Nombre],
             tarest_codigo        as [Codigo]

      from TareaEstado t '+ @@filteraux + '
        where (tarest_codigo like ''%'+convert(varchar(255),@@filter)+'%'' or tarest_nombre like ''%'+convert(varchar(255),@@filter)+'%'' 
                or '''+convert(varchar(255),@@filter)+''' = '''')
        and ('+convert(varchar(255),@@bForAbm)+' <> 0 or t.activo <> 0)'
  end

  exec(@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

