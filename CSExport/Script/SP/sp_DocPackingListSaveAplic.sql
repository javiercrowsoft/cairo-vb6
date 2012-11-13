if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListSaveAplic]

/*
begin transaction
	exec	sp_DocPackingListSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocPackingListSaveAplic (
	@@pklstTMP_id int	
)
as

begin

	set nocount on

	declare @pklst_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @pklst_id = pklst_id, @modifico = modifico from PackingListTMP where pklstTMP_id = @@pklstTMP_id

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PEDIDOS - PACKING LIST                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPackingLstSaveAplic @pklst_id, @@pklstTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPackingListSetCredito @pklst_id
	exec sp_DocPackingListSetEstado @pklst_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_HistoriaUpdate 22005, @pklst_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete PackingListFacturaVentaTMP where pklstTMP_ID = @@pklstTMP_ID
	delete PedidoPackingListTMP where pklstTMP_ID = @@pklstTMP_ID
  delete PackingListDevolucionTMP where pklstTMP_ID = @@pklstTMP_ID
	delete PackingListTMP where pklstTMP_ID = @@pklstTMP_ID

	commit transaction

	select @pklst_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la aplicación del packing list. sp_DocPackingListSaveAplic.', 16, 1)
	rollback transaction	

end 

go