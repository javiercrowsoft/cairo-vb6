if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempDelete]

go
/*

 sp_DocImportacionTempDelete 93

*/

create procedure sp_DocImportacionTempDelete (
	@@impt_id 			int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@impt_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocImportacionTempEditableGet	@@emp_id    	,
																				@@impt_id 		,
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

	declare @st_id int

	select @st_id = st_id from ImportacionTemp where impt_id = @@impt_id
  update ImportacionTemp set st_id = null where impt_id = @@impt_id

	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	delete ImportacionTempGarantia where impt_id = @@impt_id
	if @@error <> 0 goto ControlError

	delete ImportacionTempItem where impt_id = @@impt_id
	if @@error <> 0 goto ControlError

	delete ImportacionTemp where impt_id = @@impt_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar de la importación temporal. sp_DocImportacionTempDelete.', 16, 1)
	rollback transaction	

end