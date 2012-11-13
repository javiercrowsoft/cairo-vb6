if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewDeleteItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewDeleteItems]

/*

*/

go
create procedure sp_GridViewDeleteItems (
	@@grdv_id 		int
)
as

begin

	set nocount on

	begin transaction


	delete GridViewColumn where grdv_id = @@grdv_id
	if @@error <> 0 goto ControlError

	delete GridViewGrupo where grdv_id = @@grdv_id
	if @@error <> 0 goto ControlError

	delete GridViewFiltro where grdv_id = @@grdv_id
	if @@error <> 0 goto ControlError

	delete GridViewFormato where grdv_id = @@grdv_id
	if @@error <> 0 goto ControlError

	delete GridViewFormula where grdv_id = @@grdv_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la vista. sp_GridViewDeleteItems.', 16, 1)
	rollback transaction	

end
go