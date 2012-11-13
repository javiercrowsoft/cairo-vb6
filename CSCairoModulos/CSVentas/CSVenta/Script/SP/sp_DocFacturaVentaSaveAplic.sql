if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveAplic]

/*

begin tran
	exec sp_DocFacturaVentaSaveAplic 80227
	select doct_id,doc_id, est_id,fv_nrodoc from facturaventa where fv_id = 91846
rollback tran

*/

go
create procedure sp_DocFacturaVentaSaveAplic (
	@@fvTMP_id int,
	@@bSelect tinyint = 1
)
as

begin

	set nocount on

	declare @MsgError varchar(5000)

	declare @fv_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @fv_id = fv_id, @modifico = modifico from FacturaVentaTMP where fvTMP_id = @@fvTMP_id

	---------------------------------
	-- Si no hay factura no hago nada
	--
	if @fv_id is null begin

		select @fv_id
		return
	end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        VALIDACIONES A LA APLICACION                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	delete FacturaVentaNotaCreditoTMP 
	where fvTMP_id = @@fvTMP_id
		and fvd_id_factura is null
		and fvp_id_factura is null
		and fvd_id_notacredito is null
		and fvp_id_notacredito is null

	delete FacturaVentaCobranzaTMP 
	where cobzTMP_id in (select cobzTMP_id from CobranzaTMP where fvTMP_id = @@fvTMP_id)
		and fvd_id is null
		and fvp_id is null

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TRANSACCION                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PEDIDOS - REMITOS                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaVtaPedidoRemitoSaveAplic @fv_id, @@fvTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        NOTA DE CREDITO                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- Este sp se encarga de todo
  exec sp_DocFacturaVentaNotaCreditoSave @@fvTMP_id, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        COBRANZA                                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @cobzTMP_id 		int

	-- Recorro cada una de las aplicaciones
	--
	declare c_cobranza insensitive cursor for
		select cobzTMP_id from CobranzaTMP where fvTMP_id = @@fvTMP_id

	open c_cobranza
	
	fetch next from c_cobranza into @cobzTMP_id
	while @@fetch_status = 0 begin

		-- Aplico la cobranza con la factura
		exec sp_DocCobranzaSaveAplic @cobzTMP_id, 0, @bSuccess out, 0

		-- Si fallo al guardar
		if IsNull(@bSuccess,0) = 0 goto ControlError
		
		fetch next from c_cobranza into @cobzTMP_id
	end
  close c_cobranza
  deallocate c_cobranza

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaVentaSetCredito @fv_id
	if @@error <> 0 goto ControlError

	exec sp_DocFacturaVentaSetEstado @fv_id
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
					exec sp_AuditoriaEstadoCheckDocFV		@fv_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError

			-- VTOS
					exec sp_AuditoriaVtoCheckDocFV			@fv_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError
			
			-- CREDITO
					exec sp_AuditoriaCreditoCheckDocFV	@fv_id,
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

	exec sp_HistoriaUpdate 16001, @fv_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete PackingListFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
	delete PedidoFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
	delete RemitoFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
	delete FacturaVentaCobranzaTMP where cobzTMP_id in (select cobzTMP_id from CobranzaTMP where fvTMP_ID = @@fvTMP_ID)
	delete CobranzaTMP where fvTMP_id = @@fvTMP_ID
	delete FacturaVentaNotaCreditoTMP where fvTMP_ID = @@fvTMP_ID
	delete FacturaVentaTMP where fvTMP_ID = @@fvTMP_ID

	commit transaction

	if @@bSelect <> 0 select @fv_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la aplicación de la factura de venta. sp_DocFacturaVentaSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end 

go