if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_contactoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_contactoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(tar_id) from tarea

-- sp_contactoGet 0

create procedure sp_contactoGet (
  @@cont_id  int
)
as

set nocount on

begin

  select 
          cont.*,
          cli_nombre,
          prov_nombre,
          agn_nombre,
          us_nombre,
          pro_nombre,
          ciu_nombre,
          pa_nombre
  
  from Contacto cont inner join Agenda agn       on cont.agn_id  = agn.agn_id
                     left  join Cliente cli      on cont.cli_id  = cli.cli_id
                     left  join Proveedor prov  on cont.prov_id = prov.prov_id
                     left  join Pais pa         on cont.pa_id   = pa.pa_id
                     left  join Provincia pro   on cont.pro_id  = pro.pro_id
                     left  join Ciudad ciu      on cont.ciu_id  = ciu.ciu_id
                     left  join Usuario us      on cont.us_id   = us.us_id

  where cont_id = @@cont_id


end
go
set quoted_identifier off 
go
set ansi_nulls on 
go



