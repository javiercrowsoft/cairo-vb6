if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_EmpleadoPeriodoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoPeriodoSave]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_EmpleadoPeriodoSave 1,10,2

*/
create procedure sp_EmpleadoPeriodoSave (
	@@empe_id  		int,
	@@max_horas 	decimal(18,6),
	@@max_ccos   	int
)
as
begin

	set nocount on

	update EmpleadoPeriodo set empe_numero = empe_id where empe_id = @@empe_id

	create table #t_horas_mal (emh_id int, tipo int)

	create table #t_horas	( east_id 			int, 
													east_nombre 	varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL, 
													east_codigo 	varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
													east_codigo2	decimal(18,6)
												)

	exec sp_EmpleadoAsistenciaTipoHelpTbl

	----------------------------------------------------------------------------------------------------
	--
	-- Superan el maximo de horas x dia
	--

	insert into #t_horas_mal (emh_id, tipo)

	select emh_id, 1

	from EmpleadoHoras

	where em_id in (select em_id
									from EmpleadoHoras
									where empe_id = @@empe_id
										group by em_id, emh_fecha
										having sum(emh_horas) > @@max_horas
									)
		and emh_fecha in 
									(select emh_fecha
									from EmpleadoHoras
									where empe_id = @@empe_id
										group by em_id, emh_fecha
										having sum(emh_horas) > @@max_horas
									)	

	----------------------------------------------------------------------------------------------------
	--
	-- Superan el maximo de obras x dia
	--

	insert into #t_horas_mal (emh_id, tipo)

	select emh_id, 2

	from EmpleadoHoras

	where em_id in (select em_id
									from EmpleadoHoras
									where empe_id = @@empe_id
										group by em_id, emh_fecha
										having count(ccos_id) > @@max_ccos
									)
		and emh_fecha in 
									(select emh_fecha
									from EmpleadoHoras
									where empe_id = @@empe_id
										group by em_id, emh_fecha
										having count(ccos_id) > @@max_ccos
									)	

	----------------------------------------------------------------------------------------------------

	if not exists(select * from #t_horas_mal) begin

		select 	1 	as success, 
						0 	as warning, 
						''	as message

		return
	end

	select 	1 as success, 
					1 as warning, 
					'Se encontraron registros que Ud. debe analizar para descartar que no existan cargas incorrectas.'
						as message

	----------------------------------------------------------------------------------------------------

	select 	emh.emh_id			as emh_id,
					emh.em_id       as em_id,
					case tm.tipo 
							when 1 then 'Supera maximo de horas' 
							when 2 then 'Supera maximo de obras'
					end							as Motivo,
					em_apellido + ', ' + em_nombre as Empleado,
					emh.emh_fecha		as Fecha,
					ccos_nombre			as [Centro de Costo],
					east_codigo			as Horas,
					case when emh.emh_desde='19000101' then '' else convert(varchar(5),emh.emh_desde,114) end		as Desde,
					case when emh.emh_hasta='19000101' then '' else convert(varchar(5),emh.emh_hasta,114) end		as Hasta

	from EmpleadoHoras emh inner join Empleado em on emh.em_id = em.em_id
												 inner join CentroCosto ccos on emh.ccos_id = ccos.ccos_id
												 inner join EmpleadoAsistenciaTipo east on emh.east_id = east.east_id
												 inner join #t_horas_mal tm on emh.emh_id = tm.emh_id

	where empe_id = @@empe_id

	union all

	select 	emh.emh_id			as emh_id,
					emh.em_id       as em_id,
					case tm.tipo 
							when 1 then 'Supera maximo de horas' 
							when 2 then 'Supera maximo de obras'
					end							as Motivo,
					em_apellido + ', ' + em_nombre as Empleado,
					emh.emh_fecha		as Fecha,
					ccos_nombre			as [Centro de Costo],
					east_codigo			as Horas,
					case when emh.emh_desde='19000101' then '' else convert(varchar(5),emh.emh_desde,114) end		as Desde,
					case when emh.emh_hasta='19000101' then '' else convert(varchar(5),emh.emh_hasta,114) end		as Hasta

	from EmpleadoHoras emh inner join Empleado em on emh.em_id = em.em_id
												 inner join CentroCosto ccos on emh.ccos_id = ccos.ccos_id
												 left  join #t_horas t on emh.emh_horas = t.east_codigo2
												 inner join #t_horas_mal tm on emh.emh_id = tm.emh_id

	where empe_id = @@empe_id
		and emh.east_id is null

	order by Empleado, emh.em_id, Fecha, [Centro de Costo], Motivo

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

