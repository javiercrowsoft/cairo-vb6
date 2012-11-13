if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraDelete]

go
/*

 sp_DocPedidoCompraDelete 93

*/

create procedure sp_DocPedidoCompraDelete (
	@@pc_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@pc_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocPedidoCompraEditableGet	@@emp_id    	,
																			@@pc_id 			,
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

	delete PedidoCompraItem where pc_id = @@pc_id
	if @@error <> 0 goto ControlError

	delete PedidoCompra where pc_id = @@pc_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el pedido de compra. sp_DocPedidoCompraDelete.', 16, 1)
	rollback transaction	

end