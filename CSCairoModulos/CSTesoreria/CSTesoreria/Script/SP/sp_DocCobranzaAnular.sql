if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaAnular]

go

create procedure sp_DocCobranzaAnular (
  @@us_id       int,
  @@cobz_id     int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@cobz_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7
  declare @as_id             int

  if @@anular <> 0 begin

    -- Si hay cheques de clientes depositados o entregados a proveedores por ordenes de pago
    -- no se puede anular la cobranza
    --
    if exists(select Cheque.cheq_id 
              from Cheque inner join DepositoBancoItem on Cheque.cheq_id             = DepositoBancoItem.cheq_id
                          inner join DepositoBanco     on DepositoBancoItem.dbco_id = DepositoBanco.dbco_id
                          inner join CobranzaItem      on Cheque.cheq_id             = CobranzaItem.cheq_id 
              where CobranzaItem.cobz_id = @@cobz_id and DepositoBanco.est_id <> 7 /*Anulado*/) begin
      goto ChequeDepositado
    end

    -- Cheque entregado a un proveedor
    if exists(select Cheque.cheq_id from Cheque inner join CobranzaItem on Cheque.cheq_id = CobranzaItem.cheq_id
                             where Cheque.cue_id is null and CobranzaItem.cobz_id = @@cobz_id) begin
      goto ChequeEnProveedor
    end

    -- Cheque utilizado por un movimiento de fondos
    if exists(select Cheque.cheq_id from Cheque inner join CobranzaItem on Cheque.cheq_id = CobranzaItem.cheq_id
                             where Cheque.mf_id is not null and CobranzaItem.cobz_id = @@cobz_id) begin
      goto ChequeEnMovimientoFondo
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    -- Anulo los cheques de tercero
    update cheque set cheq_anulado = 1, cue_id = null where cheq_id in (select cheq_id from CobranzaItem where cobz_id = @@cobz_id)

    -- Borro el asiento  
    select @as_id = as_id from Cobranza where cobz_id = @@cobz_id
    update Cobranza set as_id = null where cobz_id = @@cobz_id
    exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
    if @@error <> 0 goto ControlError

    update Cobranza set est_id = @estado_anulado, cobz_pendiente = 0
    where cobz_id = @@cobz_id
    set @est_id = @estado_anulado

    exec sp_DocCobranzaSetCredito @@cobz_id,1
    if @@error <> 0 goto ControlError
  
    exec sp_DocCobranzaChequeSetCredito @@cobz_id,1
    if @@error <> 0 goto ControlError

  end else begin

    -- Des-Anulo los cheques de tercero
    update cheque set cheq_anulado = 0 , cue_id = cobzi.cue_id
    from CobranzaItem cobzi 
    where cheque.cheq_id in (select cheq_id from CobranzaItem where cobz_id = @@cobz_id)
      and cheque.cheq_id = cobzi.cheq_id
      and cobzi.cobz_id = @@cobz_id

    update Cobranza set est_id = @estado_pendiente, cobz_pendiente = cobz_total
    where cobz_id = @@cobz_id

    exec sp_DocCobranzaSetEstado @@cobz_id,0,@est_id out

    -- Genero nuevamente el asiento
    declare @bError    smallint
    declare @MsgError  varchar(5000) set @MsgError = ''

    exec sp_DocCobranzaAsientoSave @@cobz_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

    exec sp_DocCobranzaSetCredito @@cobz_id
    if @@error <> 0 goto ControlError
  
    exec sp_DocCobranzaChequeSetCredito @@cobz_id
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

  exec sp_AuditoriaAnularCheckDocCOBZ  @@cobz_id,
                                      @bSuccess  out,
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

  update Cobranza set modificado = getdate(), modifico = @@us_id where cobz_id = @@cobz_id

  if @@anular <> 0 exec sp_HistoriaUpdate 18004, @@cobz_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 18004, @@cobz_id, @@us_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado de la cobranza. sp_DocCobranzaAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  Goto fin

ChequeDepositado:
  raiserror ('@@ERROR_SP:La cobranza incluye cheques que se han depositados.', 16, 1)
  Goto fin

ChequeEnProveedor:
  raiserror ('@@ERROR_SP:La cobranza incluye cheques que se han entregado como parte de pago a proveedores.', 16, 1)
  Goto fin

ChequeEnMovimientoFondo:
  raiserror ('@@ERROR_SP:La cobranza incluye cheques que se han utilizado en movimientos de fondos.', 16, 1)
  Goto fin

fin:

end