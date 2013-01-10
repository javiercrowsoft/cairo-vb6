if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_TareaHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TareaHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_TareaHelp 1,1,0,'',0,0,'tar_plantilla = 0'

*/
create procedure sp_TareaHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@tar_id          int            = 0,
  @@filteraux       varchar(255)  = ''
)
as
begin

  set nocount on
  
  set @@filter = replace(@@filter,'''','''''')

    declare @sqlstmt varchar(8000)

    if @@filteraux = '' set @@filteraux = '1=1' -- para que no falle cuando esta vacio

    if @@check <> 0 begin

      set @sqlstmt = 

     'select  tar_id,
              tar_nombre        as [Nombre],
              tar_numero         as [Número]
  
      from Tarea t inner join Proyecto proy on t.proy_id = proy.proy_id
  
      where (tar_nombre = '''+convert(varchar(255),@@filter)+''' or tar_numero = '''+convert(varchar(255),@@filter)+''')
        and '''+convert(varchar(255),@@filter)+''' <> ''''
        and t.activo <> 0
        and ('+@@filteraux+')
        and (      '+convert(varchar(255),@@bForAbm)+' <> 0 
              or (exists (select * from Permiso p
                          where p.pre_id = proy.pre_id_listTarea
                            and (     us_id  = '+convert(varchar(255),@@us_id)+' 
                                  or exists(select * from usuariorol where rol_id = p.rol_id and us_id = '+convert(varchar(255),@@us_id)+')
                                )
                         )
                  )
            )'
  
    end else begin

        set @sqlstmt = 
  
       'select top 50
               tar_id,
               tar_nombre       as [Nombre],
               tar_numero      as [Número],
               cli_nombre      as [Cliente],
               proy_nombre     as [Proyecto]
  
        from Tarea t inner join Proyecto proy on t.proy_id = proy.proy_id
                     inner join Cliente cli   on t.cli_id  = cli.cli_id
    
          where (tar_numero like ''%'+convert(varchar(255),@@filter)+'%'' or tar_nombre like ''%'+convert(varchar(255),@@filter)+'%'' 
                  or '''+convert(varchar(255),@@filter)+''' = '''')
          and ('+@@filteraux+')
          and (      '+convert(varchar(255),@@bForAbm)+' <> 0 
                or (
                   (exists (select * from Permiso p
                            where p.pre_id = proy.pre_id_listTarea 
                              and (     us_id  = '+convert(varchar(255),@@us_id)+'
                                    or exists(select * from usuariorol where rol_id = p.rol_id and us_id = '+convert(varchar(255),@@us_id)+')
                                  )
                           )
                    ) 
                    and t.activo <> 0
                    )
              )'

    end

    exec(@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

