if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionDelete]

go
/*

 sp_DocLiquidacionDelete 93

*/

create procedure sp_DocLiquidacionDelete (
	@@liq_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@liq_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocLiquidacionEditableGet	@@emp_id    	,
																		@@liq_id 			,
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

	-- Asiento
	--
	declare @as_id int

	select @as_id = as_id from Liquidacion where liq_id = @@liq_id
  update Liquidacion set as_id = null where liq_id = @@liq_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

	delete LiquidacionItem where liq_id = @@liq_id
	if @@error <> 0 goto ControlError

	delete LiquidacionExcepcion where liq_id = @@liq_id
	if @@error <> 0 goto ControlError

	delete LiquidacionConceptoAdm where liq_id = @@liq_id
	if @@error <> 0 goto ControlError

	-- Liquidacion
	--
	delete Liquidacion where liq_id = @@liq_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la liquidación de haberes. sp_DocLiquidacionDelete.', 16, 1)
	rollback transaction	

	return

end