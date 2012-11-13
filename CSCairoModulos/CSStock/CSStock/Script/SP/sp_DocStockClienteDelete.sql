if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockClienteDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockClienteDelete]

/*

 sp_DocStockClienteDelete 93

*/

go
create procedure sp_DocStockClienteDelete (
	@@stcli_id 			  int,
	@@emp_id    			int,
	@@us_id						int,
	@@bNotUpdatePrns	tinyint = 0
)
as

begin

	set nocount on

	if isnull(@@stcli_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocStockClienteEditableGet	@@emp_id    	,
																			@@stcli_id		,
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

	declare @st_id      int

	declare @bSuccess 							tinyint
	declare @Message  							varchar(255)

	begin transaction

	select @st_id = st_id from StockCliente where stcli_id = @@stcli_id
	update StockCliente set st_id = null where stcli_id = @@stcli_id
	if @@error <> 0 goto ControlError

	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	delete StockCliente where stcli_id = @@stcli_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la transferencia de stock a cliente. sp_DocStockClienteDelete.', 16, 1)
	goto Roll

Validate:

	set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
	raiserror (@Message, 16, 1)

Roll:
	rollback transaction	

end