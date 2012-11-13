if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoAnular]

go

create procedure sp_DocOrdenPagoAnular (
	@@us_id       int,
	@@opg_id 			int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

	if @@opg_id = 0 return

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- Aplicaciones Automaticas (Debito Automatico y Fondo Fijo)
	--
	if exists(select fc_id from OrdenPago where opg_id = @@opg_id and fc_id is not null) begin
		raiserror ('@@ERROR_SP:El comprobante fue generado automaticamente por una factura de compra. No se puede editar manualmente.', 16, 1)
    Goto fin
  end
	--
	-- FIN: Aplicaciones Automaticas (Debito Automatico y Fondo Fijo)
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

	declare @est_id           int
	declare @estado_pendiente int set @estado_pendiente = 1
	declare @estado_anulado   int set @estado_anulado   = 7
	declare @as_id 						int

  if @@anular = 0 begin
		-- Solo puedo des-Anular si los cheques de tercero 
		-- que menciona esta orden de pago cumplen con:
		--
    -- 1- no se depositaron
		--
		-- 2- no se entregaron en otra orden de pago
		--
		-- 3- no los movio de cuenta un movimiento de fondos
		--
		-- 4- no estan anulados
		--

		-- Cheque depositado
		if exists(select cheq.cheq_id 
							from Cheque cheq inner join DepositoBancoItem dbcoi on cheq.cheq_id 	= dbcoi.cheq_id
												  		 inner join DepositoBanco dbco 			on dbcoi.dbco_id 	= dbco.dbco_id
                          		 inner join OrdenPagoItem opgi    	on cheq.cheq_id		= opgi.cheq_id 
						  where opgi.opg_id = @@opg_id 
								and dbco.est_id <> 7 /*Anulado*/) begin
			goto ChequeDepositado
		end

		-- Cheque entregado a un proveedor
		if exists(select cheq.cheq_id 
							from Cheque cheq inner join OrdenPagoItem opgi on cheq.cheq_id = opgi.cheq_id
							where cheq.cue_id is null 
								and cheq.cheq_anulado = 0
								and opgi.opg_id = @@opg_id) begin
			goto ChequeEnProveedor
		end

		-- Cheque que se movio por un movimiento de fondos
		if exists(select cheq.cheq_id 
							from Cheque cheq inner join OrdenPagoItem opgi on cheq.cheq_id = opgi.cheq_id
							where cheq.mf_id  is not null
								and cheq.cue_id <> opgi.cue_id -- Ya no esta en la cuenta mencinoada por la OP
								and opgi.opg_id = @@opg_id) begin
			goto ChequeEnMovimientoFondo
		end

		-- Cheque que ingreso por un movimiento de fondos y se anulo
		if exists(select cheq.cheq_id 
							from Cheque cheq inner join OrdenPagoItem opgi on cheq.cheq_id = opgi.cheq_id
							where cheq.mf_id  is not null
								and cheq.cheq_anulado <> 0
								and opgi.opg_id = @@opg_id) begin
			goto ChequeAnulado
		end

  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

	if @@anular <> 0 begin

		-- Anulo los cheques propios	
		update Cheque set cheq_anulado = 1 
		where opg_id = @@opg_id 

			-- No entro por movimiento de fondos
			and mf_id is null 

			-- Es un cheque propio
			-- (solo los cheques propios tienen chequera (chq_id))
			and	chq_id is not null

		if @@error <> 0 goto ControlError

		-- Devuelvo a documentos en cartera los cheques de tercero
		update Cheque set cue_id = mfi.cue_id_debe, opg_id = null 
		from MovimientoFondoItem mfi
		where Cheque.cheq_id = mfi.cheq_id
			and Cheque.mf_id   = mfi.mf_id
			and Cheque.opg_id  = @@opg_id
		if @@error <> 0 goto ControlError
	
		-- Devuelvo a documentos en cartera los cheques de tercero
		update Cheque set cue_id = cobzi.cue_id, opg_id = null 
		from CobranzaItem cobzi
		where cobzi.cheq_id = Cheque.cheq_id 
			and Cheque.opg_id = @@opg_id
			and Cheque.mf_id  is null
		if @@error <> 0 goto ControlError

		-- Borro el asiento	
		select @as_id = as_id from OrdenPago where opg_id = @@opg_id
	  update OrdenPago set as_id = null where opg_id = @@opg_id
		exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
		if @@error <> 0 goto ControlError

		update OrdenPago set est_id = @estado_anulado, opg_pendiente = 0
		where opg_id = @@opg_id
		set @est_id = @estado_anulado

		exec sp_DocOrdenPagoChequeSetCredito @@opg_id,1
		if @@error <> 0 goto ControlError

	end else begin

		-- Des-Anulo los cheques propios													 
		update Cheque set cheq_anulado = 0
		where opg_id = @@opg_id 

			-- No entro por movimiento de fondos
			and mf_id is null 

			-- Es un cheque propio
			-- (solo los cheques propios tienen chequera (chq_id))
			and	chq_id is not null
					
		if @@error <> 0 goto ControlError

		-- Recupero de documentos en cartera los cheques de tercero
		update Cheque set cue_id = null 
		from OrdenPagoItem opgi
		where Cheque.cheq_id 	= opgi.cheq_id
			and	opgi.opg_id			= @@opg_id
		if @@error <> 0 goto ControlError

		update OrdenPago set est_id = @estado_pendiente, opg_pendiente = opg_total
		where opg_id = @@opg_id
		if @@error <> 0 goto ControlError

    exec sp_DocOrdenPagoSetEstado @@opg_id,0,@est_id out
		if @@error <> 0 goto ControlError

		-- Genero nuevamente el asiento
		declare @bError 	 smallint
		declare @MsgError  varchar(5000) set @MsgError = ''

		exec sp_DocOrdenPagoAsientoSave @@opg_id,0,@bError out, @MsgError out
	  if @bError <> 0 goto ControlError

		exec sp_DocOrdenPagoSetCredito @@opg_id
		if @@error <> 0 goto ControlError

		exec sp_DocOrdenPagoChequeSetCredito @@opg_id
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

	exec sp_AuditoriaAnularCheckDocOPG	@@opg_id,
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

	update OrdenPago set modificado = getdate(), modifico = @@us_id where opg_id = @@opg_id

	if @@anular <> 0 exec sp_HistoriaUpdate 18005, @@opg_id, @@us_id, 7
	else             exec sp_HistoriaUpdate 18005, @@opg_id, @@us_id, 8

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

	set @MsgError = 'Ha ocurrido un error al actualizar el estado de la Orden de Pago. sp_DocOrdenPagoAnular. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	
	goto fin

ChequeDepositado:
	raiserror ('@@ERROR_SP:La orden de pago incluye cheques que se han depositado.', 16, 1)
	Goto fin

ChequeEnProveedor:
	raiserror ('@@ERROR_SP:La orden de pago incluye cheques que se han entregado como parte de pago a proveedores.', 16, 1)
	Goto fin

ChequeEnMovimientoFondo:
	raiserror ('@@ERROR_SP:La orden de pago incluye cheques que se han utilizado en uno o mas movimientos de fondos.', 16, 1)
	Goto fin

ChequeAnulado:
	raiserror ('@@ERROR_SP:La orden de pago incluye cheques que han sido anulados.', 16, 1)
	Goto fin

fin:

end