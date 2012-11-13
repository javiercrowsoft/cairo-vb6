if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewSaveGrupo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewSaveGrupo]

/*

*/

go
create procedure sp_GridViewSaveGrupo (
	@@grdv_id 					int,
	@@grdvg_indice			int,
	@@grdvg_columna     varchar(255),
	@@grdvg_orden       tinyint
)
as

begin

	set nocount on

	begin transaction

	declare @grdvg_id int

	exec sp_dbgetnewid 'GridViewGrupo', 'grdvg_id', @grdvg_id out, 0
			 
	insert into GridViewGrupo (grdv_id, grdvg_id, grdvg_columna, grdvg_indice, grdvg_orden)
									values    (@@grdv_id, @grdvg_id, @@grdvg_columna, @@grdvg_indice, @@grdvg_orden)
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar el grupo. sp_GridViewSaveGrupo.', 16, 1)
	rollback transaction	

end
go