if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_alarma]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_alarma]

go

set quoted_identifier on 
go
set ansi_nulls on 
go


-- sp_lsdoc_alarma 1

create procedure sp_lsdoc_alarma (
  @@al_id  int
)
as

set nocount on

begin

select 

  al_id,
  ''                as TypeTask,
  cli_nombre        as Cliente,
  proy_nombre        as Proyecto,
  rub_nombre        as [Rubro],
  al_nombre          as Nombre,
  al_codigo         as [Código],
  al_descrip        as [Descripción]

from 

    Alarma al    left join proyecto proy         on al.proy_id   = proy.proy_id
                left join cliente c             on al.cli_id     = c.cli_id
                left join rubro rub             on al.rub_id    = rub.rub_id
where 

    al.al_id = @@al_id 

end




go
set quoted_identifier off 
go
set ansi_nulls on 
go



