if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaSaveAplic]

/*
begin transaction
	exec	sp_DocPresupuestoVentaSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocPresupuestoVentaSaveAplic (
	@@prvTMP_id int	
)
as

begin

	set nocount on

	declare @MsgError varchar(5000)

	declare @prv_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @prv_id = prv_id, @modifico = modifico from PresupuestoVentaTMP where prvTMP_id = @@prvTMP_id

	---------------------------------
	-- Si no hay Presupuesto no hago nada
	--
	if @prv_id is null begin

		select @prv_id
		return
	end

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PRESUPUESTOS - PRESUPUESTOS                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPresupuestoVtaSaveAplic @prv_id, @@prvTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocPresupuestoVentaSetEstado @prv_id
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
					exec sp_AuditoriaEstadoCheckDocPRV	@prv_id,
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

	exec sp_HistoriaUpdate 16004, @prv_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete PresupuestoDevolucionVentaTMP where prvTMP_id = @@prvTMP_id
	delete PresupuestoPedidoVentaTMP where prvTMP_id = @@prvTMP_id
	delete PresupuestoVentaTMP where prvTMP_id = @@prvTMP_id

	commit transaction

	select @prv_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la aplicación del presupuesto de venta. sp_DocPresupuestoVentaSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end 

go