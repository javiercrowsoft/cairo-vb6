if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EmpleadoPeriodoGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoPeriodoGetItems]

go

-- sp_EmpleadoPeriodoGetItems 1

create procedure sp_EmpleadoPeriodoGetItems (
	@@empe_id int
)
as

begin

	create table #t_horas	( east_id 			int, 
													east_nombre 	varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL, 
													east_codigo 	varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
													east_codigo2	decimal(18,6)
												)

	exec sp_EmpleadoAsistenciaTipoHelpTbl

	select 	emh.emh_id			as emh_id,
					emh.ccos_id			as ccos_id,
					emh.east_id 		as east_id,
					emh.em_id				as em_id,
					emh.emh_desde		as emh_desde,
					emh.emh_fecha		as emh_fecha,
					emh.emh_hasta		as emh_hasta,
					emh.empe_id			as empe_id,
					em_apellido + ', ' + em_nombre 
													as em_nombre,
					ccos_nombre			as ccos_nombre,
					east_codigo			as east_codigo

	from EmpleadoHoras emh inner join Empleado em on emh.em_id = em.em_id
												 inner join EmpleadoAsistenciaTipo east on emh.east_id = east.east_id
												 left  join CentroCosto ccos on emh.ccos_id = ccos.ccos_id

	where empe_id = @@empe_id

	union all

	select 	emh.emh_id			as emh_id,
					emh.ccos_id			as ccos_id,
					t.east_id 			as east_id,
					emh.em_id				as em_id,
					emh.emh_desde		as emh_desde,
					emh.emh_fecha		as emh_fecha,
					emh.emh_hasta		as emh_hasta,
					emh.empe_id			as empe_id,
					em_apellido + ', ' + em_nombre 
													as em_nombre,
					ccos_nombre			as ccos_nombre,
					east_nombre			as east_codigo

	from EmpleadoHoras emh inner join Empleado em on emh.em_id = em.em_id
												 left  join #t_horas t on emh.emh_horas = t.east_codigo2
												 left  join CentroCosto ccos on emh.ccos_id = ccos.ccos_id

	where empe_id = @@empe_id
		and emh.east_id is null

	order by em_nombre, emh.em_id, ccos_nombre, emh.ccos_id, emh_fecha

end

go