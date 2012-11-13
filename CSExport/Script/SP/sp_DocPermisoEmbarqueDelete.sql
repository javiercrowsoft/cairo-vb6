if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueDelete]

go
/*

 sp_DocPermisoEmbarqueDelete 93

*/

create procedure sp_DocPermisoEmbarqueDelete (
	@@pemb_id 			int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@pemb_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocPermisoEmbarqueEditableGet	@@emp_id    	,
																				@@pemb_id 		,
																			  @@us_id     	,
																				@bEditable 		out,
																				@editMsg   		out,
																			  0							, --@@ShowMsg
																				0  						,	--@@bNoAnulado
																				1							  --@@bDelete

	if @bEditable = 0 begin

		set @editMsg = '@@ERROR_SP:' + @editMsg
		raiserror (@editMsg, 16, 1)

		return
	end

	begin transaction

	delete PermisoEmbarqueItem where pemb_id = @@pemb_id
	if @@error <> 0 goto ControlError

	delete PermisoEmbarque where pemb_id = @@pemb_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar del permiso de embarque. sp_DocPermisoEmbarqueDelete.', 16, 1)
	rollback transaction	

end