if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaDelete]

go
/*

 sp_DocFacturaVentaDelete 1093

*/

create procedure sp_DocFacturaVentaDelete (
	@@fv_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@fv_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocFacturaVentaEditableGet	@@emp_id    	,
																			@@fv_id 			,
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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 ALMACENO LA FACTURA EN HISTORIA                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @descrip_factura varchar(7500)

	select @descrip_factura = 'factura venta ' 
													+ convert(varchar, fv_numero) 
													+ ' ' +  fv_nrodoc 
													+ ' ' + ' del ' + convert(varchar,fv_fecha,105)
													+ ' para ' 
													+ cli_nombre + ' ' + cli_cuit
													+ ' por $ ' + convert(varchar,convert(decimal(18,2),fv_total))

	from FacturaVenta fv inner join Cliente cli on fv.cli_id = cli.cli_id
	where fv_id = @@fv_id

	declare @producto varchar(255)
	declare @cantidad decimal(18,2)
	declare @neto     decimal(18,2)

	declare c_items_fv_desc insensitive cursor for 
		select pr_nombreventa, fvi_cantidad, fvi_neto
		from FacturaVentaItem fvi inner join Producto pr
					on fvi.pr_id = pr.pr_id
		where fvi.fv_id = @@fv_id

	set @descrip_factura = @descrip_factura 
												+ char(13)+char(10) 
												+ char(13)+char(10) 
												+ ' Producto / Cantidad / Neto '												

	open c_items_fv_desc
	fetch next from c_items_fv_desc into @producto, @cantidad, @neto
	while @@fetch_status = 0
	begin

		set @descrip_factura = @descrip_factura 
													+ char(13)+char(10) 
													+ @producto
													+ ' - ' 
													+ convert(varchar,@cantidad)
													+ ' - ' 
													+ convert(varchar,@neto)

		fetch next from c_items_fv_desc into @producto, @cantidad, @neto
	end
	close c_items_fv_desc
	deallocate c_items_fv_desc

	exec sp_HistoriaUpdate 16001, @@fv_id, @@us_id, 4, @descrip_factura

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 ELIMINACION DEL COMPROBANTE                                              		 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaVentaDeleteEx @@fv_id
	if @@error <> 0 goto ControlError

	declare @as_id int

	select @as_id = as_id from FacturaVenta where fv_id = @@fv_id
  update FacturaVenta set as_id = null where fv_id = @@fv_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

	declare @st_id int

	select @st_id = st_id from FacturaVenta where fv_id = @@fv_id
  update FacturaVenta set st_id = null where fv_id = @@fv_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	delete FacturaVentaCajero where fv_id = @@fv_id
	if @@error <> 0 goto ControlError

	delete FacturaVentaDeuda where fv_id = @@fv_id
	if @@error <> 0 goto ControlError

	exec sp_DocFacturaVentaSetCredito @@fv_id,1
	if @@error <> 0 goto ControlError

	delete FacturaVentaPercepcion where fv_id = @@fv_id
	if @@error <> 0 goto ControlError

	delete FacturaVentaItem where fv_id = @@fv_id
	if @@error <> 0 goto ControlError

	delete CursoItem where fv_id = @@fv_id
	if @@error <> 0 goto ControlError

	delete FacturaVenta where fv_id = @@fv_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la factura de venta. sp_DocFacturaVentaDelete.', 16, 1)
	rollback transaction	

end