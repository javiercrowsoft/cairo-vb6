if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_hora]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_hora]

go

set quoted_identifier on 
go
set ansi_nulls on 
go


-- sp_lsdoc_hora 1

create procedure sp_lsdoc_hora (
	@@hora_id	int
)
as

set nocount on

begin

select 

	hora_id,
	''                as TypeTask,
  cli_nombre				as Cliente,
	proy_nombre				as Proyecto,
  proyi_nombre			as [Sub Proyecto],
	hora_titulo				as [Título],
	hora_fecha				as Fecha,
	convert(varchar(5),hora_desde,14)	as [Hora Desde],
	convert(varchar(5),hora_hasta,14) as [Hora Hasta],
  convert(varchar(5),convert(datetime,convert(varchar(2),hora_horas) +':'+convert(varchar(2),hora_minutos)),14)
										as Tiempo,
	us_nombre					as Usuario,
	tar_nombre				as Tarea,
  obje_nombre				as Objetivo,
  case hora_facturable
		when 0 then 'No'
    else 'Si'
  end								as Facturable,
	-- Tiene que ser la ultima columna para que funcione bien el ABM de documentos
  convert(decimal(18,2),round((hora_horas * isnull(proyp_precio,0)) + ((hora_minutos / 60.0) * isnull(proyp_precio,0)),2))
										as Importe,
	hora_descrip			as [Descripción]


from 

		hora h			inner join usuario u 						on h.us_id 			= u.us_id
								inner join proyecto proy     		on h.proy_id 		= proy.proy_id
								inner join proyectoitem pri			on h.proyi_id 	= pri.proyi_id
								inner join cliente c            on h.cli_id 		= c.cli_id
					
								left  join tarea t							on h.tar_id 		= t.tar_id
								left  join objetivo o           on h.obje_id 		= o.obje_id
								left  join proyectoprecio proyp on 		proy.proy_id = proyp.proy_id
																									and	u.us_id      = proyp.us_id
where

		h.hora_id = @@hora_id 

end




go
set quoted_identifier off 
go
set ansi_nulls on 
go



