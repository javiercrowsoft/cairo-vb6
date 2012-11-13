if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponDelete]

go
/*

 sp_DocResolucionCuponDelete 93

*/

create procedure sp_DocResolucionCuponDelete (
	@@rcup_id 			int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@rcup_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocResolucionCuponEditableGet	@@emp_id    	,
																				@@rcup_id 		,
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

	declare @as_id int

	select @as_id = as_id from ResolucionCupon where rcup_id = @@rcup_id
  update ResolucionCupon set as_id = null where rcup_id = @@rcup_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

  -- Devuelvo los cupones a su estado original
  --
  update TarjetaCreditoCupon set cue_id = CobranzaItem.cue_id 
  from CobranzaItem 
  where TarjetaCreditoCupon.tjcc_id = CobranzaItem.tjcc_id
    and exists(select * from ResolucionCuponItem where tjcc_id = TarjetaCreditoCupon.tjcc_id and rcup_id = @@rcup_id)
	if @@error <> 0 goto ControlError

  update TarjetaCreditoCupon set cue_id = DepositoCuponItem.cue_id 
  from DepositoCuponItem 
  where TarjetaCreditoCupon.tjcc_id = DepositoCuponItem.tjcc_id
    and exists(select * from ResolucionCuponItem where tjcc_id = TarjetaCreditoCupon.tjcc_id and rcup_id = @@rcup_id)
	if @@error <> 0 goto ControlError
  -----------------------------------------------------------------------------------------

	delete ResolucionCuponItem where rcup_id = @@rcup_id
	if @@error <> 0 goto ControlError

	delete ResolucionCupon where rcup_id = @@rcup_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la resolucion de cupones. sp_DocResolucionCuponDelete.', 16, 1)
	rollback transaction	

end