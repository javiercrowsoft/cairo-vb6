if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Legajo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Legajo]

go

set quoted_identifier on 
go
set ansi_nulls on 
go


-- sp_lsdoc_Legajo 1

create procedure sp_lsdoc_Legajo (
  @@Lgj_id  int
)
as

set nocount on

begin

select 

  lgj_id,
  'TypeTask'    = '',
  'Cliente'     = cli_nombre,
  'Estado'      = est_nombre,
  'Código'      = lgj_codigo,
  'Título'      = lgj_titulo,
  'Fecha'       = lgj_fecha,
  'Descripción' = lgj_descrip

  from 

    legajo lgj   inner join estado est   on lgj.est_id  =  est.est_id
                 left  join cliente cli  on lgj.cli_id = cli.cli_id
  where 

    -- Filtros
    @@Lgj_id = lgj.Lgj_id
end




go
set quoted_identifier off 
go
set ansi_nulls on 
go



