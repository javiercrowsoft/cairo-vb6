if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoDuplicarPermiso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoDuplicarPermiso]

/*

*/

go
create procedure sp_DocumentoDuplicarPermiso (
	@@us_id 				int,
	@@pre_id_from  	int,
	@@pre_id_to			int
)
as

begin

	declare @rol_id int
	declare @us_id  int
	declare @per_id int

	declare c_permisos insensitive cursor for 
		select rol_id, us_id 
		from permiso 
		where pre_id = @@pre_id_from

	open c_permisos

	fetch next from c_permisos into @rol_id, @us_id
	while @@fetch_status = 0
	begin

		exec sp_dbgetnewid 'Permiso','per_id', @per_id out, 0

		insert into Permiso (per_id, per_id_padre, pre_id, us_id, rol_id, modifico)
									values(@per_id, null, @@pre_id_to, @us_id, @rol_id, @@us_id)

		fetch next from c_permisos into @rol_id, @us_id
	end

	close c_permisos
	deallocate c_permisos

end

go