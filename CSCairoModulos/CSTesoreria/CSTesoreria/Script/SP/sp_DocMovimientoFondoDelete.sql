if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoDelete]

go
/*

 sp_DocMovimientoFondoDelete 93

*/

create procedure sp_DocMovimientoFondoDelete (
	@@mf_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@mf_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocMovimientoFondoEditableGet	@@emp_id    	,
																				@@mf_id 			,
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

	--------------------------------------------------------------------------------------------
	declare @Message  			varchar(8000)
	declare @bChequeUsado		tinyint
	declare @bCanDelete     tinyint

	-- Controlo que ningun cheque mencionado en 
	-- este movimiento de fondos este utilizado
	-- por otro movimiento de fondos o por una 
	-- orden de pago ya que si es asi, no puedo
	-- vincular asociar este cheque con la cuenta
	-- mencionada en la cobranza, sino que debo:
	--
	--  1-  dar un error si esta usado en una orden de pago
	--      o un deposito bancario, 
	--  2-  dar un error si esta usado en un movimiento
  --      de fondo posterior,
	--  3-  asociarlo al movimiento de fondos inmediato anterior
  --      al movimiento que estoy borrando

	exec sp_DocMovimientoFondoItemCanDelete @@mf_id,
																					null, -- mfTMP_id
																					1, -- bIsDelete = True
																					@Message out,
																					@bChequeUsado out,
																					@bCanDelete out
	if @@error <> 0 goto ControlError

	if @bCanDelete = 0 goto ChequeUsado
	--------------------------------------------------------------------------------------------
	
	begin transaction

	-- Asiento
	--
	declare @as_id int

	select @as_id = as_id from MovimientoFondo where mf_id = @@mf_id
  update MovimientoFondo set as_id = null where mf_id = @@mf_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

	-- Items
	--
	exec sp_DocMovimientoFondoItemDelete 	@@mf_id,
																				null, -- mfTMP_id
																				1, -- bIsDelete = True
																				@bChequeUsado
	if @@error <> 0 goto ControlError

	-- Movimiento de Fondos
	--
	delete MovimientoFondo where mf_id = @@mf_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el movimiento de fondos. sp_DocMovimientoFondoDelete.', 16, 1)
	rollback transaction	

	return

ChequeUsado:
	
	raiserror (@Message, 16, 1)

	return

end