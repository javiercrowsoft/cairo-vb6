if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0100]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0100]

/*

DC_CSC_SEG_0100

*/

go
create procedure DC_CSC_SEG_0100 (
	@@us_id						int,
  @@us_id_from  		varchar(255),
  @@us_id_to    		varchar(255)
)
as

begin

	declare @us_id_from        int
	declare @us_id_to          int
	
	declare @ram_id_from       int
	declare @ram_id_to         int
	
	exec sp_ArbConvertId @@us_id_from, @us_id_from out, @ram_id_from out
	exec sp_ArbConvertId @@us_id_to, @us_id_to out, @ram_id_to out

	if @us_id_from = 0 and @@us_id_from <>'0' begin
	
		raiserror ('@@ERROR_SP:Debe indicar un solo usuario desde.', 16, 1)
		return
	
	end

	if @us_id_to = 0 and @@us_id_to <>'0' begin
	
		raiserror ('@@ERROR_SP:Debe indicar un solo usuario destino.', 16, 1)
		return
	
	end

	declare @@IdFrom 		int
	declare @@IdTo    	int

	set @@IdFrom 	= @us_id_from
	set @@IdTo 		= @us_id_to

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

		if not exists(select * from permiso where pre_id = @pre_id and us_id = @@IdTo)

		begin

			exec sp_dbgetnewid 'Permiso','per_id', @per_id out, 0
	
			insert into Permiso (per_id, per_id_padre, pre_id, us_id, rol_id, modifico)
										values(@per_id, null, @pre_id, @@IdTo, null, @@us_id)
		end

		fetch next from c_permisos into @pre_id
	end

	close c_permisos
	deallocate c_permisos

	select 1, 'El proceso se ejecuto con éxito' as Info

end

go