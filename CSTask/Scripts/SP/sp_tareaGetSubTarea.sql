if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tareaGetSubTarea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tareaGetSubTarea]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

  sp_tareaGetSubTarea 131

*/

create procedure sp_tareaGetSubTarea (
  @@tar_id  int
)
as

set nocount on

begin

  select  t.tar_id,
          t.tar_nombre,
          esta.tarest_nombre,
          us_nombre,
          proy_nombre
  from 
    tarea  t inner join proyecto proy       on t.proy_id   = proy.proy_id
            left  join tareaestado esta   on t.tarest_id = esta.tarest_id
            left  join usuario res          on us_id_responsable = res.us_id

  where 
       tar_id_padre = @@tar_id
  end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



