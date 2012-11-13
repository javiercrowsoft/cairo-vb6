if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaDelete]

/*

 sp_DocPresupuestoVentaDelete 93

*/

go
create procedure sp_DocPresupuestoVentaDelete (
	@@prv_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@prv_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocPresupuestoVentaEditableGet	@@emp_id    	,
																					@@prv_id 			,
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

	delete PresupuestoVentaItem where prv_id = @@prv_id
	if @@error <> 0 goto ControlError

	delete PresupuestoVenta where prv_id = @@prv_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el presupuesto de venta. sp_DocPresupuestoVentaDelete.', 16, 1)
	rollback transaction	

end