if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaDelete]

go
/*

 sp_DocRemitoVentaDelete 93

*/

create procedure sp_DocRemitoVentaDelete (
	@@rv_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@rv_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocRemitoVentaEditableGet		@@emp_id    	,
																			@@rv_id 			,
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
//                                 ALMACENO EL REMITO EN HISTORIA                                                //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @descrip_remito varchar(7500)

	select @descrip_remito = 'remito venta ' 
													+ convert(varchar, rv_numero) 
													+ ' ' +  rv_nrodoc 
													+ ' ' + ' del ' + convert(varchar,rv_fecha,105)
													+ ' para ' 
													+ cli_nombre + ' ' + cli_cuit
													+ ' por $ ' + convert(varchar,convert(decimal(18,2),rv_total))

	from RemitoVenta rv inner join Cliente cli on rv.cli_id = cli.cli_id
	where rv_id = @@rv_id

	declare @producto varchar(255)
	declare @cantidad decimal(18,2)
	declare @neto     decimal(18,2)

	declare c_items_rv_desc insensitive cursor for 
		select pr_nombreventa, rvi_cantidad, rvi_neto
		from RemitoVentaItem rvi inner join Producto pr
					on rvi.pr_id = pr.pr_id
		where rvi.rv_id = @@rv_id

	set @descrip_remito = @descrip_remito 
												+ char(13)+char(10) 
												+ char(13)+char(10) 
												+ ' Producto / Cantidad / Neto '												

	open c_items_rv_desc
	fetch next from c_items_rv_desc into @producto, @cantidad, @neto
	while @@fetch_status = 0
	begin

		set @descrip_remito = @descrip_remito 
													+ char(13)+char(10) 
													+ @producto
													+ ' - ' 
													+ convert(varchar,@cantidad)
													+ ' - ' 
													+ convert(varchar,@neto)

		fetch next from c_items_rv_desc into @producto, @cantidad, @neto
	end
	close c_items_rv_desc
	deallocate c_items_rv_desc

	exec sp_HistoriaUpdate 16002, @@rv_id, @@us_id, 4, @descrip_remito

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 PARTICULARIDADES DE LOS CLIENTES                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @bSuccess tinyint
	declare @MsgError	varchar(5000) set @MsgError = ''

	exec sp_DocRemitoVentaDeleteCliente @@rv_id, 
																			@@us_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	declare @st_id int

	select @st_id = st_id from RemitoVenta where rv_id = @@rv_id
  update RemitoVenta set st_id = null where rv_id = @@rv_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	select @st_id = st_id_consumo from RemitoVenta where rv_id = @@rv_id
  update RemitoVenta set st_id_consumo = null where rv_id = @@rv_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	select @st_id = st_id_consumoTemp from RemitoVenta where rv_id = @@rv_id
  update RemitoVenta set st_id_consumoTemp = null where rv_id = @@rv_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	select @st_id = st_id_producido from RemitoVenta where rv_id = @@rv_id
  update RemitoVenta set st_id_producido = null where rv_id = @@rv_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	exec sp_DocRemitoVentaSetCredito @@rv_id,1
	if @@error <> 0 goto ControlError

	delete RemitoVentaItem where rv_id = @@rv_id
	if @@error <> 0 goto ControlError

	delete RemitoVenta where rv_id = @@rv_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar del remito de venta. sp_DocRemitoVentaDelete.', 16, 1)
	rollback transaction	

end