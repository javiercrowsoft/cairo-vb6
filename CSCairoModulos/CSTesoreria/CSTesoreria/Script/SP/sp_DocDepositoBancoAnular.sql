if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoAnular]

go

create procedure sp_DocDepositoBancoAnular (
  @@us_id       int,
  @@dbco_id     int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@dbco_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7
  declare @as_id             int

  if @@anular = 0 begin
    -- Solo puedo des-Anular si los cheques de tercero 
    -- que menciona este deposito bancario cumplen con:
    --
    -- 1- no se depositaron en otro deposito
    --
    -- 2- no se entregaron a un proveedor en una orden de pago
    --
    -- 3- no los movio de cuenta un movimiento de fondos
    --
    -- 4- no estan anulados
    --

    -- Cheque depositado
    if exists(select cheq.cheq_id 
              from Cheque cheq inner join DepositoBancoItem dbcoi   on cheq.cheq_id   = dbcoi.cheq_id
                               inner join DepositoBanco dbco         on dbcoi.dbco_id   = dbco.dbco_id
                               inner join DepositoBancoItem dbcoi2  on cheq.cheq_id    = dbcoi2.cheq_id 
                               inner join DepositoBanco dbco2       on dbcoi2.dbco_id = dbco2.dbco_id
              where dbco2.dbco_id = @@dbco_id 
                and dbco.est_id <> 7 /*Anulado*/) begin
      goto ChequeDepositado
    end

    -- Cheque entregado a un proveedor
    if exists(select cheq.cheq_id 
              from Cheque cheq inner join DepositoBancoItem dbcoi on cheq.cheq_id = dbcoi.cheq_id
              where cheq.cue_id = null
                and  dbcoi.dbco_id = @@dbco_id) begin
      goto ChequeEnProveedor
    end

    -- Cheque que se movio por un movimiento de fondos
    if exists(select cheq.cheq_id 
              from Cheque cheq inner join DepositoBancoItem dbcoi on cheq.cheq_id = dbcoi.cheq_id
              where cheq.mf_id   is not null
                and cheq.cue_id  <> dbcoi.cue_id -- Ya no esta en la cuenta mencinoada por el Deposito
                and dbcoi.dbco_id = @@dbco_id) begin
      goto ChequeEnMovimientoFondo
    end

    -- Cheque que ingreso por un movimiento de fondos y se anulo
    if exists(select cheq.cheq_id 
              from Cheque cheq inner join DepositoBancoItem dbcoi on cheq.cheq_id = dbcoi.cheq_id
              where cheq.mf_id  is not null
                and cheq.cheq_anulado <> 0
                and dbcoi.dbco_id = @@dbco_id) begin
      goto ChequeAnulado
    end

  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    -- Devuelvo a documentos en cartera los cheques de tercero
    update Cheque set cue_id = mfi.cue_id_debe
    from MovimientoFondoItem mfi
    where Cheque.cheq_id = mfi.cheq_id
      and Cheque.mf_id   = mfi.mf_id
      and exists(select cheq_id 
                 from DepositoBancoItem dbcoi
                 where cheq_id = Cheque.cheq_id 
                   and dbcoi.dbco_id = @@dbco_id
                )
    if @@error <> 0 goto ControlError
  
    -- Devuelvo a documentos en cartera los cheques de tercero
    update Cheque set cue_id = cobzi.cue_id
    from CobranzaItem cobzi
    where cobzi.cheq_id = Cheque.cheq_id 
      and Cheque.mf_id  is null
      and exists(select cheq_id 
                 from DepositoBancoItem dbcoi
                 where cheq_id = Cheque.cheq_id 
                   and dbcoi.dbco_id = @@dbco_id
                )
    if @@error <> 0 goto ControlError

    -- Anulo los cheques propios                         
    update Cheque set cheq_anulado = 0 
    where dbco_id = @@dbco_id 
    if @@error <> 0 goto ControlError

    -- Borro el asiento  
    select @as_id = as_id from DepositoBanco where dbco_id = @@dbco_id
    update DepositoBanco set as_id = null where dbco_id = @@dbco_id
    exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
    if @@error <> 0 goto ControlError

    update DepositoBanco set est_id = @estado_anulado
    where dbco_id = @@dbco_id
    set @est_id = @estado_anulado

  end else begin

    -- Recupero de documentos en cartera los cheques de tercero
    update Cheque set cue_id = dbco.cue_id 
    from DepositoBancoItem dbcoi 
            inner join DepositoBanco dbco 
                    on dbcoi.dbco_id = dbco.dbco_id
    where Cheque.cheq_id   = dbcoi.cheq_id
      and  dbcoi.dbco_id    = @@dbco_id
    if @@error <> 0 goto ControlError

    -- Des-Anulo los cheques propios                         
    update Cheque set cheq_anulado = 0 
    where dbco_id = @@dbco_id 
    if @@error <> 0 goto ControlError

    update DepositoBanco set est_id = @estado_pendiente
    where dbco_id = @@dbco_id
    if @@error <> 0 goto ControlError

    exec sp_DocDepositoBancoSetEstado @@dbco_id,0,@est_id out
    if @@error <> 0 goto ControlError

    -- Genero nuevamente el asiento
    declare @bError    smallint
    declare @MsgError  varchar(5000) set @MsgError = ''

    exec sp_DocDepositoBancoAsientoSave @@dbco_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bSuccess tinyint

  exec sp_AuditoriaAnularCheckDocDBCO  @@dbco_id,
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

  update DepositoBanco set modificado = getdate(), modifico = @@us_id where dbco_id = @@dbco_id

  if @@anular <> 0 exec sp_HistoriaUpdate 18007, @@dbco_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 18007, @@dbco_id, @@us_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del deposito bancario. sp_DocDepositoBancoAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  goto fin

ChequeDepositado:
  raiserror ('@@ERROR_SP:El deposito incluye cheques que se han depositado.', 16, 1)
  Goto fin

ChequeEnProveedor:
  raiserror ('@@ERROR_SP:El deposito incluye cheques que se han entregado como parte de pago a proveedores.', 16, 1)
  Goto fin

ChequeEnMovimientoFondo:
  raiserror ('@@ERROR_SP:El deposito incluye cheques que se han utilizado en uno o mas movimientos de fondos.', 16, 1)
  Goto fin

ChequeAnulado:
  raiserror ('@@ERROR_SP:El deposito incluye cheques que han sido anulados.', 16, 1)
  Goto fin

fin:

end