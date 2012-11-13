if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioAnular]

go

create procedure sp_DocOrdenServicioAnular (
	@@us_id       int,
	@@os_id 			int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

	if @@os_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

	declare @est_id           int
	declare @estado_pendiente int set @estado_pendiente = 1
	declare @estado_anulado   int set @estado_anulado   = 7

	if exists(select os_id from OrdenRemitoVenta r inner join OrdenServicioItem osi on r.osi_id = osi.osi_id where os_id = @@os_id) begin
		goto VinculadaRemito
	end

  -- No se puede des-anular una factura que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select os_id from OrdenServicio rc 
              inner join Documento d on rc.doc_id = d.doc_id 
              where os_id = @@os_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

	if @@anular <> 0 begin

		update OrdenServicio set est_id = @estado_anulado, os_pendiente = 0
		where os_id = @@os_id
		set @est_id = @estado_anulado

		exec sp_DocOrdenServicioSetCredito @@os_id,1
		if @@error <> 0 goto ControlError
  
  	declare @st_id int
  
  	select @st_id = st_id from OrdenServicio where os_id = @@os_id
    update OrdenServicio set st_id = null where os_id = @@os_id
  
  	--////////////////////////////////////////////////////////////////////////////////////////////////
  
  	create table #NroSerieDelete (prns_id int)
  	insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id
  
  	exec sp_DocStockDelete @st_id,0,0,0,1
  	if @@error <> 0 goto ControlError
  
  	delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
  	if @@error <> 0 goto ControlError

  	update OrdenServicio set tar_id = null where tar_id in (select tar_id from Tarea where prns_id in (select prns_id from #NroSerieDelete))
  	if @@error <> 0 goto ControlError

  	delete Tarea where prns_id in (select prns_id from #NroSerieDelete)
  	if @@error <> 0 goto ControlError
  
  	delete ProductoNumeroSerie where prns_id in (select prns_id from #NroSerieDelete)
  	if @@error <> 0 goto ControlError
  
  	--////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin

		update OrdenServicio set est_id = @estado_pendiente, os_pendiente = os_total
		where os_id = @@os_id

    exec sp_DocOrdenServicioSetEstado @@os_id,0,@est_id out

		exec sp_DocOrdenServicioSetCredito @@os_id
		if @@error <> 0 goto ControlError

  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @bSuccess tinyint
	declare @MsgError	varchar(5000) set @MsgError = ''

	exec sp_AuditoriaAnularCheckDocRC		@@os_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	update OrdenServicio set modificado = getdate(), modifico = @@us_id where os_id = @@os_id

	if @@anular <> 0 exec sp_HistoriaUpdate 28008, @@os_id, @@us_id, 7
	else             exec sp_HistoriaUpdate 28008, @@os_id, @@us_id, 8

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	if @bInternalTransaction <> 0 
		commit transaction

	if @@Select <> 0 begin
		select est_id, est_nombre from Estado where est_id = @est_id
	end

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el estado del orden de servicio. sp_DocOrdenServicioAnular. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	
	Goto fin

VinculadaRemito:
	raiserror ('@@ERROR_SP:El documento esta vinculado a un parte de entrega.', 16, 1)
	Goto fin

MueveStock:
	raiserror ('@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.', 16, 1)
	Goto fin

fin:

end