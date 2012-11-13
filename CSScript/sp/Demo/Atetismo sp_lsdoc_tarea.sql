if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_tarea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_tarea]

go
create procedure sp_lsdoc_tarea (
	@@tar_id	int
)
as

set nocount on

begin

declare @ambas tinyint
set @ambas = 2

select 
	tar_id,
	'TypeTask'	= '',
	'Tipo Entreno'	= proy_nombre,
	'Título'	= tar_nombre,
	'Fecha inicio'  = tar_fechaini,
	'Fecha fin'	= tar_fechafin,
        'Finalizada'	= case 
				when tar_finalizada <> 0 then 	'Si'
				else 				'No'
				end,
	'Cumplida'	= case 
				when tar_cumplida <> 0 then 	'Si'
				else 				'No'
				end,
	'Activa'	= case 
				when t.activo <> 0 then 	'Si'
				else 				'No'
				end,
	'Intensidad'	= cont_nombre,
	'Entrenamientos'	= prio_nombre,
	'Estado'	= tarest_nombre,

	-- Tiene que ser la ultima columna para que funcione bien el ABM de documentos
	'Descripción' 	= tar_descrip

	from 
		tarea t,
		usuario r,
		usuario a,
		prioridad p,
		contacto c,
		tareaestado te,
		proyecto pr
	where 
		-- Joins
		t.us_id_responsable 	*= r.us_id and 
		t.us_id_asignador   	*= a.us_id and
		t.prio_id		*= p.prio_id and
		t.tarest_id		*= te.tarest_id and
		t.cont_id		*= c.cont_id and
		t.proy_id		*= pr.proy_id and

		-- Filtros
		@@tar_id = t.tar_id
end


