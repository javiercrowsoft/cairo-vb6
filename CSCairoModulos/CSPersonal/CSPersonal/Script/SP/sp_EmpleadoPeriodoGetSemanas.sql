if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EmpleadoPeriodoGetSemanas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoPeriodoGetSemanas]

go

-- sp_EmpleadoPeriodoGetSemanas 1

create procedure sp_EmpleadoPeriodoGetSemanas (
	@@empe_id int
)
as

begin

	select 	ems.ems_id			as ems_id,
					ems.ccos_id			as ccos_id,
					ems.ems_desde		as ems_desde,
					ems.ems_fecha		as ems_fecha,
					ems.ems_hasta		as ems_hasta,
					ems.ems_horas   as ems_horas,
					ems.empe_id			as empe_id,
					ccos_nombre			as ccos_nombre

	from EmpleadoSemana ems left  join CentroCosto ccos on ems.ccos_id = ccos.ccos_id

	where empe_id = @@empe_id

	order by ccos_nombre, ems.ccos_id, ems_fecha

end

go