if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_CamionHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CamionHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_CamionHelp 1,'300%',0,0,596

 sp_CamionHelp 3,'',0,0,1 

  select * from usuario where us_nombre like '%ahidal%'

*/
create procedure sp_CamionHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@cam_id          int           = 0,
  @@filter2         varchar(255)  = ''
)
as
begin

  set nocount on
  
  if @@check <> 0 begin
  
    select   cam_id,
            cam_patente        as [Nombre],
            cam_codigo         as [Codigo]

    from Camion

    where (cam_patente = @@filter or cam_codigo = @@filter)
      and (cam_essemi = 0)
      and (cam_id = @@cam_id or @@cam_id=0)
      and (
              @@bForAbm <> 0 or activo <> 0
          )

  end else begin

    select top 50
           cam.cam_id,
           cam_patente       as Nombre,
           cam_codigo        as Codigo,
           trans_nombre      as Transporte,
           chof_nombre       as Chofer

    from Camion cam left join Chofer chof        on cam.chof_id = chof.chof_id
                    left join Transporte trans  on cam.trans_id = trans.trans_id

    where (     cam_codigo like '%'+@@filter+'%' 
            or cam_patente like '%'+@@filter+'%' 
            or @@filter = ''
          )
    and (    @@bForAbm <> 0 
          or 
            (      
                  cam_essemi = 0
              and cam.activo <> 0
            )
        )

  end    

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

