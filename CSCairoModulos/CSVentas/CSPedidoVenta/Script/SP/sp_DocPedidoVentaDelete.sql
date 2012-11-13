if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaDelete]

/*

 sp_DocPedidoVentaDelete 93

*/

go
create procedure sp_DocPedidoVentaDelete (
	@@pv_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@pv_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocPedidoVentaEditableGet		@@emp_id    	,
																			@@pv_id 			,
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

	update ComunidadInternetMail set pv_id = null where pv_id = @@pv_id
	if @@error <> 0 goto ControlError

	exec sp_DocPedidoVentaSetCredito @@pv_id,1
	if @@error <> 0 goto ControlError

	delete PedidoVentaItemStock where pv_id = @@pv_id
	if @@error <> 0 goto ControlError

	delete PedidoVentaItem where pv_id = @@pv_id
	if @@error <> 0 goto ControlError

	delete PedidoVenta where pv_id = @@pv_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el pedido de venta. sp_DocPedidoVentaDelete.', 16, 1)
	rollback transaction	

end