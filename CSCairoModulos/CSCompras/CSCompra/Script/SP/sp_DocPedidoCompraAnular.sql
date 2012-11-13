if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraAnular]

go

create procedure sp_DocPedidoCompraAnular (
	@@us_id       int,
	@@pc_id 			int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

	if @@pc_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

	declare @est_id           int
	declare @estado_pendiente int set @estado_pendiente = 1
	declare @estado_anulado   int set @estado_anulado   = 7

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

	if @@anular <> 0 begin

		update PedidoCompra set est_id = @estado_anulado, pc_pendiente = 0
		where pc_id = @@pc_id
		set @est_id = @estado_anulado

	end else begin

		update PedidoCompra set est_id = @estado_pendiente, pc_pendiente = pc_total
		where pc_id = @@pc_id

    exec sp_DocPedidoCompraSetEstado @@pc_id,0,@est_id out

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

	exec sp_AuditoriaAnularCheckDocPC		@@pc_id,
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

	update PedidoCompra set modificado = getdate(), modifico = @@us_id where pc_id = @@pc_id

	if @@anular <> 0 exec sp_HistoriaUpdate 17005, @@pc_id, @@us_id, 7
	else             exec sp_HistoriaUpdate 17005, @@pc_id, @@us_id, 8

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

	set @MsgError = 'Ha ocurrido un error al actualizar el estado del pedido de compra. sp_DocPedidoCompraAnular. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	

end