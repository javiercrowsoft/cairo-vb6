if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraSaveAplic]

/*
begin transaction
	exec	sp_DocOrdenCompraSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocOrdenCompraSaveAplic (
	@@ocTMP_id int	
)
as

begin

	set nocount on

	declare @MsgError varchar(5000)

	declare @oc_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @oc_id = oc_id, @modifico = modifico from OrdenCompraTMP where ocTMP_id = @@ocTMP_id

	---------------------------------
	-- Si no hay pedido no hago nada
	--
	if @oc_id is null begin

		select @oc_id
		return
	end

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        Ordenes - Ordenes                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocOrdenCpraSaveAplic @oc_id, @@ocTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocOrdenCompraSetCredito @oc_id
	if @@error <> 0 goto ControlError

	exec sp_DocOrdenCompraSetEstado @oc_id
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
					exec sp_AuditoriaEstadoCheckDocOC		@oc_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError
			
			-- CREDITO
					exec sp_AuditoriaCreditoCheckDocOC	@oc_id,
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

	exec sp_HistoriaUpdate 17004, @oc_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete OrdenDevolucionCompraTMP where ocTMP_id = @@ocTMP_id
	delete OrdenFacturaCompraTMP where ocTMP_id = @@ocTMP_id
	delete OrdenRemitoCompraTMP where ocTMP_id = @@ocTMP_id
	delete OrdenCompraTMP where ocTMP_id = @@ocTMP_id

	commit transaction

	select @oc_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la aplicación de la orden de compra. sp_DocOrdenCompraSaveAplic.', 16, 1)
	rollback transaction	

	if @@trancount > 0 begin
		rollback transaction	
  end

end 

go