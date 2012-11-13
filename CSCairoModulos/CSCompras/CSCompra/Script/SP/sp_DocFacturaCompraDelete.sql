if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraDelete]

go
/*

 sp_DocFacturaCompraDelete 93

*/

create procedure sp_DocFacturaCompraDelete (
	@@fc_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@fc_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)
	declare @MsgError 		varchar(5000)

	exec sp_DocFacturaCompraEditableGet	@@emp_id    	,
																			@@fc_id 			,
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

	select @as_id = as_id from FacturaCompra where fc_id = @@fc_id
  update FacturaCompra set as_id = null where fc_id = @@fc_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

	declare @st_id int

	select @st_id = st_id from FacturaCompra where fc_id = @@fc_id
  update FacturaCompra set st_id = null where fc_id = @@fc_id

	--////////////////////////////////////////////////////////////////////////////////////////////////

	declare @doct_id int

	select @doct_id = doct_id from FacturaCompra where fc_id = @@fc_id

	if @doct_id <> 8 begin

		create table #NroSerieDelete (prns_id int)
		insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id

	end

	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	if @doct_id <> 8 begin

		delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
		if @@error <> 0 goto ControlError
	
		delete ProductoNumeroSerie where prns_id in (select prns_id from #NroSerieDelete)
		if @@error <> 0 goto ControlError

	end
	--////////////////////////////////////////////////////////////////////////////////////////////////


	/*
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                                    //
	//                          GENERACION AUTOMATICA DE ORDEN DE PAGO																										//
	//                                                                                                                    //
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
		declare @bSuccess tinyint
		exec sp_DocFacturaCompraOrdenPagoDelete 	@@fc_id 				,
																							@@emp_id    		,
																							@@us_id					,
																						  @bSuccess    	  out,
																							@MsgError   	  out
		if @bSuccess = 0 goto ControlError

		declare @cpg_id int

		select @cpg_id = cpg_id from FacturaCompra where fc_id = @@fc_id

		if exists(select cpg_id from CondicionPago where cpg_id = @cpg_id and cpg_tipo in (2,3))
    begin
	
			delete FacturaCompraPago where fc_id = @@fc_id
			if @@error <> 0 goto ControlError
		end

	/*
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                                    //
	//                          FIN GENERACION AUTOMATICA DE ORDEN DE PAGO																								//
	//                                                                                                                    //
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/

	delete FacturaCompraDeuda where fc_id = @@fc_id
	if @@error <> 0 goto ControlError

	exec sp_DocFacturaCompraSetCredito @@fc_id,1
	if @@error <> 0 goto ControlError

	delete FacturaCompraItem where fc_id = @@fc_id
	if @@error <> 0 goto ControlError

	delete FacturaCompraOtro where fc_id = @@fc_id
	if @@error <> 0 goto ControlError

	delete FacturaCompraPercepcion where fc_id = @@fc_id
	if @@error <> 0 goto ControlError

	delete FacturaCompraLegajo where fc_id = @@fc_id
	if @@error <> 0 goto ControlError

	delete FacturaCompra where fc_id = @@fc_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al borrar la factura de Compra. sp_DocFacturaCompraDelete. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)
	rollback transaction	

end