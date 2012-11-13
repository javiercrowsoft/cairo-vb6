if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraDelete]

go
/*

 sp_DocOrdenCompraDelete 93

*/

create procedure sp_DocOrdenCompraDelete (
	@@oc_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@oc_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocOrdenCompraEditableGet		@@emp_id    	,
																			@@oc_id 			,
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

	exec sp_DocOrdenCompraSetCredito @@oc_id,1
	if @@error <> 0 goto ControlError

	delete OrdenCompraItem where oc_id = @@oc_id
	if @@error <> 0 goto ControlError

	delete OrdenCompra where oc_id = @@oc_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el Orden de compra. sp_DocOrdenCompraDelete.', 16, 1)
	rollback transaction	

end