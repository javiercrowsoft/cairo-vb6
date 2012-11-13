if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_tareas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_tareas]
--sp_lsdoc_tareas '20010101','20020901',1,2,2,0,0,0,0,0,0,2
go
create procedure sp_lsdoc_tareas (
	@@Fini 		datetime,
	@@Ffin 		datetime,
	@@Finalizada 	tinyint,
	@@Cumplida 	tinyint,
	@@Rechazada	tinyint,
	@@us_id_responsable int,
	@@us_id_asignador   int,
	@@cont_id	    int,
	@@tarest_id	    int,
	@@prio_id	    int,
	@@proy_id	    int,
	@@activa	    tinyint
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
	'Entrenamientos'= prio_nombre,
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
		(
				
				@@Fini <= tar_fechaini
			and	@@Ffin >= tar_fechafin 		

			and	(@@Finalizada  = tar_finalizada or @@Finalizada = @ambas)	
			and	(@@Cumplida    = tar_cumplida   or @@Cumplida   = @ambas)	
			and	(@@Rechazada   = tar_rechazada  or @@Rechazada  = @ambas)	
			and 	(@@activa = t.activo 		or @@activa 	= @ambas)	

			and	(@@us_id_responsable = us_id_responsable or @@us_id_responsable = 0)
			and	(@@us_id_asignador   = us_id_asignador   or @@us_id_asignador   = 0)
			and	(@@cont_id   = t.cont_id		 or @@cont_id    	= 0)
			and	(@@tarest_id = t.tarest_id		 or @@tarest_id		= 0)
			and	(@@prio_id   = t.prio_id		 or @@prio_id		= 0)
			and	(@@proy_id   = t.proy_id		 or @@proy_id		= 0)
		) 
end


