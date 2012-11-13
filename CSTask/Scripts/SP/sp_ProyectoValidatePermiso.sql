if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProyectoValidatePermiso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProyectoValidatePermiso]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

	sp_ProyectoValidatePermiso 1,0,3,1

	@@what: 

				 1: Busca un permiso asociado a pre_id_addTarea

				 2: Busca un permiso asociado a pre_id_editTarea

																			o pre_id_editTareaP and @@us_id = us_id_alta de @@tar_id
																												  and (		tar_aprobada = 0 
																														or 	proy_llevaAprobacion = 0
																														)

																			o pre_id_editTareaD and us_id_alta de @@tar_id in UsuarioDepartamento 
																													and @@us_id tiene permiso sobre pre_id_asignartareas del departamento
																													and dpto_id de @@tar_id = departamento
																												  and (		tar_aprobada = 0 
																														or 	proy_llevaAprobacion = 0
																														)

				 3: Busca un permiso asociado a pre_id_addHora

				 4: Busca un permiso asociado a pre_id_editHora

	Que puede hacer un usuario con los siguientes permisos:
	
	pre_id_editTarea		Puede editar cualquier tarea del proyecto, 
											ya sea propia o ajena

	pre_id_addTarea			Puede agregar tareas al proyecto

	pre_id_editTareaP		Solo puede editar las tareas que el creo, obviamente
											tiene que tener permiso de agregar tareas para tener
											tareas propias

	pre_id_editTareaD		Puede editar sus tareas, mas aquellas creadas 
											por otros usuarios que estan asociados a departamentos 
											donde el usuario indicado por @@us_id posee 
                      permiso de asignar tareas

	pre_id_editHora			Puede editar horas

	pre_id_addHora			Puede agregar horas


*/
create procedure sp_ProyectoValidatePermiso (
  @@us_id           int,
	@@tar_id          int,
  @@proy_id         int,
  @@what            int
)
as
begin

	set nocount on

		if @@what = 1 begin

			if exists (select	proy_id
								 from Proyecto
								 where proy_id = @@proy_id
									 and (exists (select * from Permiso 
		                          	where pre_id = pre_id_addTarea
																and (		 us_id  = @@us_id 
																			or exists(select * from usuariorol 
																								where rol_id = Permiso.rol_id 
																									and us_id = @@us_id)
																		)
		                         )
											)
									) 
				select 1
			else 
				select 0

		end else begin

			if @@what = 2 begin

				if exists (select	proy_id
									 from Proyecto
									 where proy_id = @@proy_id
										 and (exists (select * from Permiso 
			                          	where pre_id = pre_id_editTarea
																	and (		 us_id = @@us_id 
																				or exists(select * from usuariorol 
																									where rol_id = Permiso.rol_id 
																										and us_id = @@us_id)
																			)
			                         )
												)
										) 
					select 1
												
				else begin
																
					if exists (select proy_id
										 from Proyecto
										 where proy_id = @@proy_id
											 and (exists(select * from Permiso
																	 where pre_id = pre_id_editTareaP
																	 and (		us_id = @@us_id
																				 or exists(select * from usuariorol
																									 where rol_id = Permiso.rol_id
																										 and us_id = @@us_id)
																			)
			                         )
												)
											 and (exists(select * from Tarea
																	 where tar_id = @@tar_id 
																		 and us_id_alta = @@us_id
																		 and (		tar_aprobada = 0
																					or	proy_llevaAprobacion = 0
																				  )
																	 )
													 )
										) 
							select 1
											
					else begin
												
						if exists (select	proy_id
											 from Proyecto
											 where proy_id = @@proy_id
												 and (exists (select * from Permiso 
					                          	where pre_id = pre_id_editTareaD
																			and (		 us_id = @@us_id 
																						or exists(select * from usuariorol 
																											where rol_id = Permiso.rol_id 
																												and us_id = @@us_id)
																					)
					                         )
														)
												 and (exists(select * 
																		 from Tarea t 
																					inner join Departamento d on t.dpto_id = d.dpto_id
																		 where tar_id = @@tar_id
																			and exists(select * from Permiso
																								 where pre_id = pre_id_asignarTareas
																									and (		 us_id = @@us_id 
																												or exists(select * from usuariorol 
																																	where rol_id = Permiso.rol_id 
																																		and us_id = @@us_id)
																											)	
																								)
																		)
														 )
												) 
							select 1
																		
						else
							select 0
					end
				end

			end else begin

				if @@what = 3 begin

					if exists (select	proy_id
										 from Proyecto						
										 where proy_id = @@proy_id
											 and (exists (select * from Permiso 
				                          	where pre_id = pre_id_addHora
																		and (		 us_id  = @@us_id 
																					or exists(select * from usuariorol 
																										where rol_id = Permiso.rol_id 
																											and us_id = @@us_id)
																				)
				                         )
													)
											)
						select 1
					else 
						select 0

				end else begin

					if @@what = 4 begin

						if exists (select	proy_id
											 from Proyecto						
											 where proy_id = @@proy_id
												 and (exists (select * from Permiso 
					                          	where pre_id = pre_id_editHora
																			and (		 us_id  = @@us_id 
																						or exists(select * from usuariorol 
																											where rol_id = Permiso.rol_id 
																												and us_id = @@us_id)
																					)
					                         )
														)
												)
							select 1
						else 
							select 0
					end
				end
			end			
		end
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

