if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoAnular]

go

create procedure sp_DocMovimientoFondoAnular (
  @@us_id       int,
  @@mf_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  set nocount on

  if @@mf_id = 0 return

  --------------------------------------------------------------------------------------------
  declare @Message        varchar(8000)
  declare @bChequeUsado    tinyint
  declare @bCanDelete     tinyint

  -- Controlo que ningun cheque mencionado en 
  -- este movimiento de fondos este utilizado
  -- por otro movimiento de fondos o por una 
  -- orden de pago ya que si es asi, no puedo
  -- vincular asociar este cheque con la cuenta
  -- mencionada en la cobranza, sino que debo:
  --
  --  1-  dar un error si esta usado en una orden de pago
  --      o un deposito bancario, 
  --  2-  dar un error si esta usado en un movimiento
  --      de fondo posterior,
  --  3-  asociarlo al movimiento de fondos inmediato anterior
  --      al movimiento que estoy borrando

  -- NOTA: Uso el mismo sp que en sp_DocMovimientoFondoDelete
  --       ya que las validaciones que hace son las mismas
  --       que necesito al borrar y al anular.
  --       Este sp no borra nada, solo se fija si se puede
  --       borrar o anular.

  exec sp_DocMovimientoFondoItemCanDelete @@mf_id,
                                          null, -- mfTMP_id
                                          1, -- bIsDelete = True  (a los fines de este sp 
                                             --                    anular y borrar es lo mismo)
                                          @Message out,
                                          @bChequeUsado out,
                                          @bCanDelete out
  if @@error <> 0 goto ControlError

  if @bCanDelete = 0 goto ChequeUsado
  --------------------------------------------------------------------------------------------

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7
  declare @as_id             int

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    -- Items
    --
    exec sp_DocMovimientoFondoItemAnular @@mf_id,
                                         @bChequeUsado
    if @@error <> 0 goto ControlError

    -- Borro el asiento  
    --
    select @as_id = as_id from MovimientoFondo where mf_id = @@mf_id
    update MovimientoFondo set as_id = null where mf_id = @@mf_id
    exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
    if @@error <> 0 goto ControlError

    -- Movimiento
    --
    update MovimientoFondo set est_id = @estado_anulado, mf_pendiente = 0
    where mf_id = @@mf_id
    set @est_id = @estado_anulado

  end else begin

    -- Des-Anulo los cheques propios                         
    update Cheque set cheq_anulado = 0 
    where mf_id = @@mf_id 
      and (
                chq_id is not null  -- solo los cheques propios tienen chequera (chq_id)
            or  cobz_id is null     -- los cheques de tercero que entraron 
                                    -- con este movimiento de fondos
          )      
    if @@error <> 0 goto ControlError

    -- Recupero de documentos en cartera los cheques de tercero
    update Cheque set cue_id   = cue_id_debe, 
                      mf_id   = @@mf_id 
    from MovimientoFondoItem mfi 
    where Cheque.cheq_id   = mfi.cheq_id 
      and mfi.mf_id        = @@mf_id
    if @@error <> 0 goto ControlError

    update MovimientoFondo set est_id = @estado_pendiente, mf_pendiente = mf_total
    where mf_id = @@mf_id

    exec sp_DocMovimientoFondoSetEstado @@mf_id,0,@est_id out

    -- Genero nuevamente el asiento
    declare @bError    smallint
    declare @MsgError  varchar(5000) set @MsgError = ''

    exec sp_DocMovimientoFondoAsientoSave @@mf_id,0,@bError out, @MsgError out
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

  exec sp_AuditoriaAnularCheckDocMF    @@mf_id,
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

  update MovimientoFondo set modificado = getdate(), modifico = @@us_id where mf_id = @@mf_id

  if @@anular <> 0 exec sp_HistoriaUpdate 18006, @@mf_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 18006, @@mf_id, @@us_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del movimiento de fondos. sp_DocMovimientoFondoAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

  return

ChequeUsado:
  
  raiserror (@Message, 16, 1)

  return

end