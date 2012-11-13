if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_EmpleadoAsistenciaTipoHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoAsistenciaTipoHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_EmpleadoAsistenciaTipoHelp 0,1,0,'',0,0,''

*/
create procedure sp_EmpleadoAsistenciaTipoHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@east_id         int           = 0,
	@@filter2         varchar(255)  = ''
)
as
begin

	set nocount on

	create table #t_horas	( east_id 			int, 
													east_nombre 	varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL, 
													east_codigo 	varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
													east_codigo2	decimal(18,6)
												)

	exec sp_EmpleadoAsistenciaTipoHelpTbl

	if @@check <> 0 begin

		-- Si no es en el abm de Tipos de Asistencia
		--
		if @@bForAbm = 0 begin

			-- Tienen prioridad las horas
			--
			if exists ( select *
									from #t_horas
									where (east_nombre = @@filter or east_codigo = @@filter)
										and (east_id = @@east_id or @@east_id=0)
								) begin
				
				select 	east_id,
								east_nombre					as [Nombre],
								east_codigo   			as [Codigo]
		
				from #t_horas
		
				where (east_nombre = @@filter or east_codigo = @@filter)
					and (east_id = @@east_id or @@east_id=0)

				-- Aca se termino todo
				--
				return

			end
		end

		-- Si llegue hasta aca es por que no son horas
		--
		select 	east_id,
						east_codigo					as [Nombre],
						east_codigo   			as [Codigo]

		from EmpleadoAsistenciaTipo

		where (east_nombre = @@filter or east_codigo = @@filter)
			and (east_id = @@east_id or @@east_id=0)
			and (
							@@bForAbm <> 0 or activo <> 0
					)

	end else begin

		-- Tipos de asistencia
		--
		select top 50
					 east_id,
           east_nombre       as Nombre,
           east_codigo       as Codigo

		from EmpleadoAsistenciaTipo

		where (		 east_codigo like '%'+@@filter+'%' 
						or east_nombre like '%'+@@filter+'%' 
            or @@filter = ''
					)
		and (		@@bForAbm <> 0 or activo <> 0
				)

		-- Horas
		--
		union all

		select top 50
					 east_id,
           east_nombre       as Nombre,
           east_codigo       as Codigo

		from #t_horas

		where (		 east_codigo like '%'+@@filter+'%' 
						or east_nombre like '%'+@@filter+'%' 
            or @@filter = ''
					)
		and @@bForAbm = 0

		order by east_nombre

	end		

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

