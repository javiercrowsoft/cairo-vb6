if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_UsuarioDuplicarPermisos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_UsuarioDuplicarPermisos]

/*

*/

go
create procedure sp_UsuarioDuplicarPermisos (
	@@us_id			int,
	@@IdFrom 		int,
	@@IdTo    	int
)
as

begin

	declare @per_id int
	declare @pre_id int

	declare c_permisos insensitive cursor for 
		select pre_id 
		from permiso 
		where us_id = @@IdFrom

	open c_permisos

	fetch next from c_permisos into @pre_id
	while @@fetch_status = 0
	begin

		exec sp_dbgetnewid 'Permiso','per_id', @per_id out, 0

		insert into Permiso (per_id, per_id_padre, pre_id, us_id, rol_id, modifico)
									values(@per_id, null, @pre_id, @@IdTo, null, @@us_id)

		fetch next from c_permisos into @pre_id
	end

	close c_permisos
	deallocate c_permisos

	exec sp_SysModuloGetEx @@IdTo

end

go