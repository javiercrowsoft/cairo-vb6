if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proyectoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proyectoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(hora_id) from hora

-- sp_proyectoGet 1

create procedure sp_proyectoGet (
  @@proy_id  int
)
as

set nocount on

begin

  select        
          proy.*,
          cli_nombre,
          prov_nombre,
          pr_nombreventa,
          ta_nombre,
          proy2.proy_nombre as padre

  From proyecto proy  left  join cliente    cli      on proy.cli_id           = cli.cli_id
                      left  join proveedor  prov    on proy.prov_id         = prov.prov_id
                      left  join producto   pr      on proy.pr_id           = pr.pr_id
                      left  join proyecto   proy2   on proy.proy_id_padre    = proy2.proy_id
                      left  join talonario  ta      on proy.ta_id           = ta.ta_id

  where proy.proy_id = @@proy_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
