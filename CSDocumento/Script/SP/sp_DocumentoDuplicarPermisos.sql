if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoDuplicarPermisos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoDuplicarPermisos]

/*

*/

go
create procedure sp_DocumentoDuplicarPermisos (
	@@us_id			int,
	@@IdFrom 		int,
	@@IdTo    	int
)
as

begin

	declare @pre_id_new_from						int
	declare @pre_id_edit_from						int
	declare @pre_id_delete_from					int
	declare @pre_id_list_from						int
	declare @pre_id_anular_from					int
	declare @pre_id_desanular_from			int
	declare @pre_id_aplicar_from				int
	declare @pre_id_print_from					int

	select

					@pre_id_new_from							= pre_id_new,
					@pre_id_edit_from							= pre_id_edit,
					@pre_id_delete_from						= pre_id_delete,
					@pre_id_list_from							= pre_id_list,
					@pre_id_anular_from						= pre_id_anular,
					@pre_id_desanular_from				= pre_id_desanular,
					@pre_id_aplicar_from					= pre_id_aplicar,
					@pre_id_print_from						= pre_id_print
	from
				Documento
	where
				doc_id = @@IdFrom

	declare @pre_id_new							int
	declare @pre_id_edit						int
	declare @pre_id_delete					int
	declare @pre_id_list						int
	declare @pre_id_anular					int
	declare @pre_id_desanular				int
	declare @pre_id_aplicar					int
	declare @pre_id_print						int

	select

					@pre_id_new							= pre_id_new,
					@pre_id_edit						= pre_id_edit,
					@pre_id_delete					= pre_id_delete,
					@pre_id_list						= pre_id_list,
					@pre_id_anular					= pre_id_anular,
					@pre_id_desanular				= pre_id_desanular,
					@pre_id_aplicar					= pre_id_aplicar,
					@pre_id_print						= pre_id_print
	from
				Documento
	where
				doc_id = @@IdTo

	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_new_from				,@pre_id_new
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_edit_from				,@pre_id_edit
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_delete_from			,@pre_id_delete
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_list_from				,@pre_id_list
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_anular_from			,@pre_id_anular
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_desanular_from	,@pre_id_desanular
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_aplicar_from		,@pre_id_aplicar
	exec sp_DocumentoDuplicarPermiso @@us_id, @pre_id_print_from			,@pre_id_print

end

go