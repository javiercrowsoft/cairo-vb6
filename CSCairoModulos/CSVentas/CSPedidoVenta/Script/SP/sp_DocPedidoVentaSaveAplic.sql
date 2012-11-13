if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSaveAplic]

/*
begin transaction
	exec	sp_DocPedidoVentaSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocPedidoVentaSaveAplic (
	@@pvTMP_id int	
)
as

begin

	set nocount on

	declare @MsgError varchar(5000)

	declare @pv_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @pv_id = pv_id, @modifico = modifico from PedidoVentaTMP where pvTMP_id = @@pvTMP_id

	---------------------------------
	-- Si no hay pedido no hago nada
	--
	if @pv_id is null begin

		select @pv_id
		return
	end

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PEDIDOS - PEDIDOS                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoVtaSaveAplic @pv_id, @@pvTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoVentaSetCredito @pv_id
	if @@error <> 0 goto ControlError

	exec sp_DocPedidoVentaSetEstado @pv_id
	if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        VALIDACIONES                                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

		--/////////////////////////////////////////////////////////////////////////////////////////////////
		-- Validaciones
		--

			-- ESTADO
					exec sp_AuditoriaEstadoCheckDocPV		@pv_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError
			
			-- CREDITO
					exec sp_AuditoriaCreditoCheckDocPV	@pv_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError

		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_HistoriaUpdate 16003, @pv_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete PedidoDevolucionVentaTMP where pvTMP_id = @@pvTMP_id
	delete PresupuestoPedidoVentaTMP where pvTMP_id = @@pvTMP_id
	delete PedidoFacturaVentaTMP where pvTMP_id = @@pvTMP_id
	delete PedidoRemitoVentaTMP where pvTMP_id = @@pvTMP_id
	delete PedidoVentaTMP where pvTMP_id = @@pvTMP_id

	commit transaction

	select @pv_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la aplicación del pedido de venta. sp_DocPedidoVentaSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end 

go