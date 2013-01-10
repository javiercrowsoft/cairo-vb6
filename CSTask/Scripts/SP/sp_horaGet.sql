if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_horaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_horaGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(hora_id) from hora

-- sp_horaGet 246

create procedure sp_horaGet (
  @@hora_id  int
)
as

set nocount on

begin

  select        
          hora.*,
          cli_nombre,
          proy_nombre,
          proyi_nombre,
          obje_nombre,
          us_nombre,
          tar_nombre

  From    hora inner join cliente         on hora.cli_id     = cliente.cli_id
               inner join proyecto         on hora.proy_id   = proyecto.proy_id
               inner join proyectoitem     on hora.proyi_id   = proyectoitem.proyi_id
               inner join objetivo         on hora.obje_id   = objetivo.obje_id
               left  join tarea           on hora.tar_id     = tarea.tar_id
               inner join usuario         on hora.us_id     = usuario.us_id

  where hora_id = @@hora_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



