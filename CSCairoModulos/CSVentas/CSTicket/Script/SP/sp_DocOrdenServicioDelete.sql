if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioDelete]

go
/*

 sp_DocOrdenServicioDelete 93

*/

create procedure sp_DocOrdenServicioDelete (
	@@os_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if not exists(select * from OrdenServicio where os_id = @@os_id)
		set @@os_id = 0

	if isnull(@@os_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocOrdenServicioEditableGet	@@emp_id    	,
																			@@os_id 			,
																		  @@us_id     	,
																			@bEditable 		out,
																			@editMsg   		out,
																		  0							, --@@ShowMsg
																			0  						,	--@@bNoAnulado
																			1							  --@@bDelete

	if @bEditable = 0 begin

		set @editMsg = isnull(@editMsg,'')
		set @editMsg = '@@ERROR_SP:' + @editMsg
		raiserror (@editMsg, 16, 1)

		return
	end

	begin transaction

	declare @st_id int

	select @st_id = st_id from OrdenServicio where os_id = @@os_id
  update OrdenServicio set st_id = null where os_id = @@os_id

	--////////////////////////////////////////////////////////////////////////////////////////////////

	create table #NroSerieDelete (prns_id int)
	insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id and prns_id is not null

	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
	if @@error <> 0 goto ControlError

	delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
	if @@error <> 0 goto ControlError

	update OrdenServicio set tar_id = null where os_id = @@os_id
	if @@error <> 0 goto ControlError

	update ProductoNumeroSerie set tar_id = null where prns_id in (select prns_id from #NroSerieDelete)
	if @@error <> 0 goto ControlError

	delete Tarea where os_id = @@os_id
	if @@error <> 0 goto ControlError

	delete OrdenServicioSerie where os_id = @@os_id
	if @@error <> 0 goto ControlError

	delete ProductoNumeroSerie 
	where prns_id in (select prns_id from #NroSerieDelete s
										where not exists(select * from StockItem where prns_id = s.prns_id))
	if @@error <> 0 goto ControlError

	declare @prns_id int
	declare c_prns_to_update insensitive cursor for select prns_id from #NroSerieDelete

	open c_prns_to_update
	fetch next from c_prns_to_update into @prns_id
	while @@fetch_status=0
	begin

		declare @doc_id_ingreso int
		set @doc_id_ingreso = 0

		select @doc_id_ingreso = max(os_id) 
		from OrdenServicio os inner join StockItem sti on os.st_id = sti.st_id
		where prns_id = @prns_id 

		if IsNull(@doc_id_ingreso,0) <> 0 begin

			update ProductoNumeroSerie set doc_id_ingreso  = @doc_id_ingreso,
																		 doct_id_ingreso = 42
			where prns_id = @prns_id
			if @@error <> 0 goto ControlError

		end

		fetch next from c_prns_to_update into @prns_id
	end
	close c_prns_to_update
	deallocate c_prns_to_update

	--////////////////////////////////////////////////////////////////////////////////////////////////

	exec sp_DocOrdenServicioSetCredito @@os_id,1
	if @@error <> 0 goto ControlError

	delete OrdenServicioItem where os_id = @@os_id
	if @@error <> 0 goto ControlError

	delete OrdenServicio where os_id = @@os_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la orden de servicio. sp_DocOrdenServicioDelete.', 16, 1)
	rollback transaction	

end