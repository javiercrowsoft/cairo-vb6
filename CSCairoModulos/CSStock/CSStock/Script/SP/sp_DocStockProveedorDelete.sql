if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockProveedorDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockProveedorDelete]

/*

 sp_DocStockProveedorDelete 93

*/

go
create procedure sp_DocStockProveedorDelete (
	@@stprov_id 			int,
	@@emp_id    			int,
	@@us_id						int,
	@@bNotUpdatePrns	tinyint = 0
)
as

begin

	set nocount on

	if isnull(@@stprov_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocStockProveedorEditableGet	@@emp_id    	,
																				@@stprov_id 	,
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

	if @@stprov_id is null return

	declare @st_id      int

	declare @bSuccess 							tinyint
	declare @Message  							varchar(255)

	begin transaction

	select @st_id = st_id from StockProveedor where stprov_id = @@stprov_id
	update StockProveedor set st_id = null where stprov_id = @@stprov_id
	if @@error <> 0 goto ControlError

	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	delete StockProveedor where stprov_id = @@stprov_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la transferencia de stock a proveedor. sp_DocStockProveedorDelete.', 16, 1)
	goto Roll

Validate:

	set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
	raiserror (@Message, 16, 1)

Roll:
	rollback transaction	

end