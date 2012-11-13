if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraSaveAplic]

/*
begin transaction
	exec	sp_DocPedidoCompraSaveAplic 34
rollback transaction

*/

go
create procedure sp_DocPedidoCompraSaveAplic (
	@@pcTMP_id int	
)
as

begin

	set nocount on

	declare @pc_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @pc_id = pc_id, @modifico = modifico from PedidoCompraTMP where pcTMP_id = @@pcTMP_id

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PEDIDOS - PEDIDOS                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoCpraSaveAplic @pc_id, @@pcTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPedidoCompraSetEstado @pc_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_HistoriaUpdate 17005, @pc_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete PedidoDevolucionCompraTMP where pcTMP_id = @@pcTMP_id
	delete PedidoOrdenCompraTMP where pcTMP_id = @@pcTMP_id
	delete PedidoCotizacionCompraTMP where pcTMP_id = @@pcTMP_id
	delete PedidoCompraTMP where pcTMP_id = @@pcTMP_id

	commit transaction

	select @pc_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la aplicación del pedido de compra. sp_DocPedidoCompraSaveAplic.', 16, 1)
	rollback transaction	

end 

go