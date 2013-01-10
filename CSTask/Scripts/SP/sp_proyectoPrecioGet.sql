if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proyectoPrecioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proyectoPrecioGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(hora_id) from hora

-- sp_proyectoPrecioGet 1

create procedure sp_proyectoPrecioGet (
  @@proy_id  int
)
as

set nocount on

begin

  select        
          proyp.*,
          us_nombre,
          pr_nombreventa

  From proyectoPrecio proyp inner join usuario us  on proyp.us_id = us.us_id
                            left   join producto pr on proyp.pr_id = pr.pr_id

  where proy_id = @@proy_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
