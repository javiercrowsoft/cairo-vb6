if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_alarmaGetFromFilters]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarmaGetFromFilters]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(al_id) from tarea

-- sp_alarmaGetFromFilters 131

create procedure sp_alarmaGetFromFilters (
	@@cli_id 			int,
	@@clis_id			int,
	@@proy_id			int,
	@@rub_id			int,
	@@diasemana		int,
	@@diames			int,
	@@al_id				int out
)
as

set nocount on

begin

	set @@al_id = null

	-- Voy desde el filtro mas coincidente hasta el mas generico
	--
	select @@al_id = al_id from Alarma 
	where rub_id  = @@rub_id 
		and	proy_id = @@proy_id 
		and clis_id = @@clis_id
		and cli_id  = @@cli_id
		and (
						 exists(select * from AlarmaDiaSemana 
									 where  alds_dia = @@diasemana 
											and al_id = Alarma.al_id 
											and alds_activo <> 0
									)
					or
						 exists(select * from AlarmaDiaMes
									 where  aldm_dia = @@diames
											and al_id = Alarma.al_id 
											and aldm_activo <> 0
									)
				)

	if @@al_id is null
	begin

		-- Es para este proyecto y para esta sucursal
		-- y para todos los rubros
		--
		select @@al_id = al_id from Alarma 
		where rub_id  is null
			and	proy_id = @@proy_id 
			and clis_id = @@clis_id
			and cli_id  = @@cli_id
			and (
							 exists(select * from AlarmaDiaSemana 
										 where  alds_dia = @@diasemana 
												and al_id = Alarma.al_id 
												and alds_activo <> 0
										)
						or
							 exists(select * from AlarmaDiaMes
										 where  aldm_dia = @@diames
												and al_id = Alarma.al_id 
												and aldm_activo <> 0
										)
					)

		if @@al_id is null
		begin

			-- Es para este rubro y para esta sucursal
			-- y acepta cualquier proyecto
			--	
			select @@al_id = al_id from Alarma 
			where rub_id  = @@rub_id
				and	proy_id is null
				and clis_id = @@clis_id
				and cli_id  = @@cli_id
				and (
								 exists(select * from AlarmaDiaSemana 
											 where  alds_dia = @@diasemana 
													and al_id = Alarma.al_id 
													and alds_activo <> 0
											)
							or
								 exists(select * from AlarmaDiaMes
											 where  aldm_dia = @@diames
													and al_id = Alarma.al_id 
													and aldm_activo <> 0
											)
						)
	
			if @@al_id is null
			begin
		
				-- Es para esta sucursal y acepta
				-- cualquier proyecto y cualquier
				-- rubro
				--
				select @@al_id = al_id from Alarma 
				where rub_id  is null
					and	proy_id is null
					and clis_id = @@clis_id
					and cli_id  = @@cli_id
					and (
									 exists(select * from AlarmaDiaSemana 
												 where  alds_dia = @@diasemana 
														and al_id = Alarma.al_id 
														and alds_activo <> 0
												)
								or
									 exists(select * from AlarmaDiaMes
												 where  aldm_dia = @@diames
														and al_id = Alarma.al_id 
														and aldm_activo <> 0
												)
							)		

				if @@al_id is null
				begin
			
					-- Es para esta rubro y este proyecto
					-- y acepta cualquier sucursal
					--
					select @@al_id = al_id from Alarma 
					where rub_id  = @@rub_id
						and	proy_id = @@proy_id
						and clis_id is null
						and cli_id  = @@cli_id
						and (
										 exists(select * from AlarmaDiaSemana 
													 where  alds_dia = @@diasemana 
															and al_id = Alarma.al_id 
															and alds_activo <> 0
													)
									or
										 exists(select * from AlarmaDiaMes
													 where  aldm_dia = @@diames
															and al_id = Alarma.al_id 
															and aldm_activo <> 0
													)
								)
			
					if @@al_id is null
					begin
				
						-- Es para este proyecto y
						-- acepta cualquier sucursal 
						-- y cualquier rubro
						-- 
						select @@al_id = al_id from Alarma 
						where rub_id  is null
							and	proy_id = @@proy_id
							and clis_id is null
							and cli_id  = @@cli_id
							and (
											 exists(select * from AlarmaDiaSemana 
														 where  alds_dia = @@diasemana 
																and al_id = Alarma.al_id 
																and alds_activo <> 0
														)
										or
											 exists(select * from AlarmaDiaMes
														 where  aldm_dia = @@diames
																and al_id = Alarma.al_id 
																and aldm_activo <> 0
														)
									)
				
						if @@al_id is null
						begin
					
							-- Es para este rubro y para este
							-- cliente y acepta cualquier proyecto
							-- y cualquier sucursal
							--
							select @@al_id = al_id from Alarma 
							where rub_id  = @@rub_id
								and	proy_id is null
								and clis_id is null
								and cli_id  = @@cli_id
								and (
												 exists(select * from AlarmaDiaSemana 
															 where  alds_dia = @@diasemana 
																	and al_id = Alarma.al_id 
																	and alds_activo <> 0
															)
											or
												 exists(select * from AlarmaDiaMes
															 where  aldm_dia = @@diames
																	and al_id = Alarma.al_id 
																	and aldm_activo <> 0
															)
										)
					
							if @@al_id is null
							begin
						
								-- Es para este cliente y acepta
								-- cualquier rubro, cualquier proyecto
								-- y cualquier sucursal
								--
								select @@al_id = al_id from Alarma 
								where rub_id  is null
									and	proy_id is null
									and clis_id is null
									and cli_id  = @@cli_id
									and (
													 exists(select * from AlarmaDiaSemana 
																 where  alds_dia = @@diasemana 
																		and al_id = Alarma.al_id 
																		and alds_activo <> 0
																)
												or
													 exists(select * from AlarmaDiaMes
																 where  aldm_dia = @@diames
																		and al_id = Alarma.al_id 
																		and aldm_activo <> 0
																)
											)
						
								if @@al_id is null
								begin
							
									-- Es para este rubro
									-- y se aplica a cualquier cliente
									--
									select @@al_id = al_id from Alarma 
									where rub_id  = @@rub_id
										and	proy_id is null
										and clis_id is null
										and cli_id  is null
										and (
														 exists(select * from AlarmaDiaSemana 
																	 where  alds_dia = @@diasemana 
																			and al_id = Alarma.al_id 
																			and alds_activo <> 0
																	)
													or
														 exists(select * from AlarmaDiaMes
																	 where  aldm_dia = @@diames
																			and al_id = Alarma.al_id 
																			and aldm_activo <> 0
																	)
												)
							
									-- Agarra lo que venga con sus
									-- super garras de aguila como diria
									-- la boluda de castellano de tercero
									-- "¿Ud. tiene garras?, ¿no verdad?,
									-- entonces no agarra, toma..."
									-- Uno se encuentra con cada boludo/a
									-- en la vida
									--
									if @@al_id is null
									begin
								
										select @@al_id = al_id from Alarma 
										where rub_id  is null
											and	proy_id is null
											and clis_id is null
											and cli_id  is null
											and (
															 exists(select * from AlarmaDiaSemana 
																		 where  alds_dia = @@diasemana 
																				and al_id = Alarma.al_id 
																				and alds_activo <> 0
																		)
														or
															 exists(select * from AlarmaDiaMes
																		 where  aldm_dia = @@diames
																				and al_id = Alarma.al_id 
																				and aldm_activo <> 0
																		)
													)
								
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
