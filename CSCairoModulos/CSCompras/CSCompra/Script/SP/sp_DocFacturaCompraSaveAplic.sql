if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraSaveAplic]

/*

	exec	sp_DocFacturaCompraSaveAplic 38

*/

go
create procedure sp_DocFacturaCompraSaveAplic (
	@@fcTMP_id int	
)
as

begin

	set nocount on

	declare @MsgError varchar(5000)

	declare @fc_id 				int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @modifico int

	select @fc_id = fc_id, @modifico = modifico from FacturaCompraTMP where fcTMP_id = @@fcTMP_id

	---------------------------------
	-- Si no hay factura no hago nada
	--
	if @fc_id is null begin

		select @fc_id
		return
	end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        VALIDACIONES A LA APLICACION                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	delete FacturaCompraNotaCreditoTMP 
	where fcTMP_id = @@fcTMP_id
		and fcd_id_factura is null
		and fcp_id_factura is null
		and fcd_id_notacredito is null
		and fcp_id_notacredito is null

	delete FacturaCompraOrdenPagoTMP 
	where opgTMP_id in (select opgTMP_id from OrdenPagoTMP where fcTMP_id = @@fcTMP_id)
		and fcd_id is null
		and fcp_id is null

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
//                                        ORDENES - REMITOS                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaCpraOrdenRemitoSaveAplic @fc_id, @@fcTMP_id, 1, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACIONES AUTOMATICAS                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	declare @cpg_tipo tinyint
	select @cpg_tipo = cpg_tipo
	from FacturaCompra fc inner join CondicionPago cpg on fc.cpg_id = cpg.cpg_id
	where fc_id = @fc_id

	if not @cpg_tipo in (2,3) /*Debito automatico o Fondo fijo*/ begin

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        NOTA DE CREDITO                                                        //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		
			-- Este sp se encarga de todo
		  exec sp_DocFacturaCompraNotaCreditoSave @@fcTMP_id, @bSuccess out
		
			-- Si fallo al guardar
			if IsNull(@bSuccess,0) = 0 goto ControlError
		
		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        OrdenPago                                                               //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		
			declare @opgTMP_id 		int
		
			-- Recorro cada una de las aplicaciones
			--
			declare c_OrdenPago insensitive cursor for
				select opgTMP_id from OrdenPagoTMP where fcTMP_id = @@fcTMP_id
		
			open c_OrdenPago
			
			fetch next from c_OrdenPago into @opgTMP_id
			while @@fetch_status = 0 begin
		
				-- Aplico la OrdenPago con la factura
				exec sp_DocOrdenPagoSaveAplic @opgTMP_id, 0, @bSuccess out, 0
		
				-- Si fallo al guardar
				if IsNull(@bSuccess,0) = 0 goto ControlError
				
				fetch next from c_OrdenPago into @opgTMP_id
			end
		  close c_OrdenPago
		  deallocate c_OrdenPago

	end -- APLICACIONES AUTOMATICAS

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocFacturaCompraSetCredito @fc_id
	if @@error <> 0 goto ControlError

	exec sp_DocFacturaCompraSetEstado @fc_id
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
					exec sp_AuditoriaEstadoCheckDocFC		@fc_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError

			-- VTOS
					exec sp_AuditoriaVtoCheckDocFC			@fc_id,
																							@bSuccess	out,
																							@MsgError out
				
					-- Si el documento no es valido
					if IsNull(@bSuccess,0) = 0 goto ControlError
			
			-- CREDITO
					exec sp_AuditoriaCreditoCheckDocFC	@fc_id,
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

	exec sp_HistoriaUpdate 17001, @fc_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete FacturaCompraNotaCreditoTMP where fcTMP_id = @@fcTMP_id
	delete FacturaCompraOrdenPagoTMP where opgTMP_id in (select opgTMP_id from OrdenPagoTMP where fcTMP_id = @@fcTMP_id)
  delete OrdenPagoTMP where fcTMP_id = @@fcTMP_id
	delete OrdenFacturaCompraTMP where fcTMP_id = @@fcTMP_id
	delete RemitoFacturaCompraTMP where fcTMP_id = @@fcTMP_id
	delete FacturaCompraTMP where fcTMP_id = @@fcTMP_id

	commit transaction

	select @fc_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la aplicación de la factura de Compra. sp_DocFacturaCompraSaveAplic. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end 

go