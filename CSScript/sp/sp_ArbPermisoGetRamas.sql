/*-----------------------------------------------------------------------

Proposito: Devuelve todas las ramas para un arbol de permisos que tienen
           para un rol o usuario determinado, todas las prestaciones
           concedidas. Se usa en los dos cTree de la interfaz de 
           permisos para marcar las carpetas que tienen todos los 
           items seleccionados.

-------------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbPermisoGetRamas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbPermisoGetRamas]


/*

select * from rol

sp_arbpermisogetramas 0,13,1

*/

go
create procedure sp_ArbPermisoGetRamas (
	@@us_id  			int,
	@@rol_id 			int,
  @@arb_id 	    int
)
as

begin

	set nocount on

	create table #rama_sel (ram_id int not null,
													ram_id_padre int not null)

	delete hoja
	from arbol
	where not exists(select pre_id from prestacion where pre_id = id)
		and hoja.arb_id = @@arb_id
		and hoja.arb_id = arbol.arb_id
    and arbol.tbl_id = 1 /* Prestacion */

	declare @n  int
	declare @c1 int
	declare @c2 int
	set @n  = 1
	set @c1 = 2
	set @c2 =-1

	if @@us_id <> 0 begin
		insert into #rama_sel (ram_id,ram_id_padre)
		select ram_id,ram_id_padre 
		from rama 
		where arb_id = @@arb_id
			-- Solo ramas sin subramas (sin hijos)
			and not exists (select * from rama r where r.arb_id = @@arb_id and r.ram_id_padre = rama.ram_id)
			-- No existen prestaciones en esta rama sin permiso para este usuario
			and not exists (select * from hoja 
											where  ram_id = rama.ram_id 
												 and not exists(select * from permiso where pre_id = id
			                                                          and (us_id = @@us_id
																																		 or exists(select *
																																		           from usuariorol
																																		           where rol_id = permiso.rol_id
																																		             and us_id  = @@us_id
																																							)
																																		)
																				)
										)
			-- Tiene que tener hojas
			and exists (select * from hoja where  ram_id = rama.ram_id)

		while exists( -- Siempre que exista una rama en este arbol
									select * from rama t1 where arb_id = @@arb_id
									-- que:
									-- Tenga un hijo en #rama_sel
									and exists (select * from #rama_sel t2 where t2.ram_id_padre = t1.ram_id)
									-- No este aun en #rama_sel
									and not exists(select * from #rama_sel t2 where t2.ram_id = t1.ram_id)
									-- No tenga hijos fuera de #rama_sel
									and not exists(select * from rama t3 
																 where t3.ram_id_padre = t1.ram_id
																	 and not exists(select * from #rama_sel t4 where t4.ram_id = t3.ram_id)
																)
								)
					and @n < 20
					and @c1 <> @c2

		begin

				set @c2 = @c1
				select @c1 = count(*) from rama t1 where arb_id = @@arb_id
									-- que:
									-- Tenga un hijo en #rama_sel
									and exists (select * from #rama_sel t2 where t2.ram_id_padre = t1.ram_id)
									-- No este aun en #rama_sel
									and not exists(select * from #rama_sel t2 where t2.ram_id = t1.ram_id)
									-- No tenga hijos fuera de #rama_sel
									and not exists(select * from rama t3 
																 where t3.ram_id_padre = t1.ram_id
																	 and not exists(select * from #rama_sel t4 where t4.ram_id = t3.ram_id)
																)

				insert into #rama_sel (ram_id,ram_id_padre)
				select ram_id,ram_id_padre
				from rama 
				where arb_id = @@arb_id
					--and not exists (select * from rama r where r.arb_id = @@arb_id and r.ram_id_padre = rama.ram_id)
					and not exists (select * from hoja 
													where  ram_id = rama.ram_id 
														 and not exists(select * from permiso where pre_id = id
					                                                          and (us_id = @@us_id
																																				 or exists(select *
																																				           from usuariorol
																																				           where rol_id = permiso.rol_id
																																				             and us_id  = @@us_id
																																									)
																																				)
																						)
												)

					and exists( -- Siempre que la rama cumpla con las reglas del while
									select * from rama t1 where t1.ram_id = rama.ram_id
									-- que:
									-- Tenga un hijo en #rama_sel
									and exists (select * from #rama_sel t2 where t2.ram_id_padre = t1.ram_id)
									-- No este aun en #rama_sel
									and not exists(select * from #rama_sel t2 where t2.ram_id = t1.ram_id)
									-- No tenga hijos fuera de #rama_sel
									and not exists(select * from rama t3 
																 where t3.ram_id_padre = t1.ram_id
																	 and not exists(select * from #rama_sel t4 where t4.ram_id = t3.ram_id)
																)
								)
			set @n = @n +1
		end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		insert into #rama_sel (ram_id,ram_id_padre)
		select ram_id,ram_id_padre 
		from rama 
		where arb_id = @@arb_id
			-- Solo ramas sin subramas (sin hijos)
			and not exists (select * from rama r where r.arb_id = @@arb_id and r.ram_id_padre = rama.ram_id)
			-- No existen prestaciones en esta rama sin permiso para este rol
			and not exists (select * from hoja 
											where  ram_id = rama.ram_id 
												 and not exists(select * from permiso where pre_id = id
			                                                          and rol_id = @@rol_id
																				)
										)
			-- Tiene que tener hojas
			and exists (select * from hoja where  ram_id = rama.ram_id)

		while exists( -- Siempre que exista una rama en este arbol
									select * from rama t1 where arb_id = @@arb_id
									-- que:
									-- Tenga un hijo en #rama_sel
									and exists (select * from #rama_sel t2 where t2.ram_id_padre = t1.ram_id)
									-- No este aun en #rama_sel
									and not exists(select * from #rama_sel t2 where t2.ram_id = t1.ram_id)
									-- No tenga hijos fuera de #rama_sel
									and not exists(select * from rama t3 
																 where t3.ram_id_padre = t1.ram_id
																	 and not exists(select * from #rama_sel t4 where t4.ram_id = t3.ram_id)
																)
								)
					and @n < 20
					and @c1 <> @c2

		begin

				set @c2 = @c1
				select @c1 = count(*) from rama t1 where arb_id = @@arb_id
									-- que:
									-- Tenga un hijo en #rama_sel
									and exists (select * from #rama_sel t2 where t2.ram_id_padre = t1.ram_id)
									-- No este aun en #rama_sel
									and not exists(select * from #rama_sel t2 where t2.ram_id = t1.ram_id)
									-- No tenga hijos fuera de #rama_sel
									and not exists(select * from rama t3 
																 where t3.ram_id_padre = t1.ram_id
																	 and not exists(select * from #rama_sel t4 where t4.ram_id = t3.ram_id)
																)


				insert into #rama_sel (ram_id,ram_id_padre)
				select ram_id,ram_id_padre
				from rama 
				where arb_id = @@arb_id
					--and not exists (select * from rama r where r.arb_id = @@arb_id and r.ram_id_padre = rama.ram_id)
					and not exists (select * from hoja 
													where  ram_id = rama.ram_id 
														 and not exists(select * from permiso where pre_id = id
					                                                          and rol_id = @@rol_id
																						)
												)

					and exists( -- Siempre que la rama cumpla con las reglas del while
									select * from rama t1 where t1.ram_id = rama.ram_id
									-- que:
									-- Tenga un hijo en #rama_sel
									and exists (select * from #rama_sel t2 where t2.ram_id_padre = t1.ram_id)
									-- No este aun en #rama_sel
									and not exists(select * from #rama_sel t2 where t2.ram_id = t1.ram_id)
									-- No tenga hijos fuera de #rama_sel
									and not exists(select * from rama t3 
																 where t3.ram_id_padre = t1.ram_id
																	 and not exists(select * from #rama_sel t4 where t4.ram_id = t3.ram_id)
																)
								)
			set @n = @n +1
		end
	end

--	select r.* from #rama_sel t inner join rama r on t.ram_id = r.ram_id

	select distinct ram_id from #rama_sel order by ram_id

end
go