if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraSaveAplic]

/*
begin transaction
	exec	sp_DocRemitoCompraSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocRemitoCompraSaveAplic (
	@@rcTMP_id int	
)
as

begin

	set nocount on

	declare @MsgError varchar(5000)

	declare @rc_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @rc_id = rc_id, @modifico = modifico from RemitoCompraTMP where rcTMP_id = @@rcTMP_id

	---------------------------------
	-- Si no hay remito no hago nada
	--
	if @rc_id is null begin

		select @rc_id
		return
	end

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ORDENES DE COMPRA - REMITOS                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocRemitoCpraSaveAplic @rc_id, @@rcTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocRemitoCompraSetCredito @rc_id
	if @@error <> 0 goto ControlError

	exec sp_DocRemitoCompraSetEstado @rc_id
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
					exec sp_AuditoriaEstadoCheckDocRC		@rc_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError
			
			-- CREDITO
					exec sp_AuditoriaCreditoCheckDocRC	@rc_id,
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

	exec sp_HistoriaUpdate 17003, @rc_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete RemitoFacturaCompraTMP where rcTMP_ID = @@rcTMP_ID
	delete OrdenRemitoCompraTMP where rcTMP_ID = @@rcTMP_ID
  delete RemitoDevolucionCompraTMP where rcTMP_ID = @@rcTMP_ID
	delete RemitoCompraTMP where rcTMP_ID = @@rcTMP_ID

	commit transaction

	select @rc_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la aplicación del remito de compra. sp_DocRemitoCompraSaveAplic.', 16, 1)
	rollback transaction	

end 

go