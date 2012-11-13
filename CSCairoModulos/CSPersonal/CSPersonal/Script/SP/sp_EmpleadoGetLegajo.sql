if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EmpleadoGetLegajo ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoGetLegajo ]

go

create procedure sp_EmpleadoGetLegajo (
	@@em_id int
)
as

begin

	select 	 'Legajo: ' +em_legajo+ ' DNI: ' + em_dni as Legajo

	from Empleado em
									
	where em.em_id = @@em_id

end