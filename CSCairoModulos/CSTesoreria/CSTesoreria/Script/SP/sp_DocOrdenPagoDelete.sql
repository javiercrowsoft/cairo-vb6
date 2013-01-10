if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoDelete]

go
/*

 sp_DocOrdenPagoDelete 93

*/

create procedure sp_DocOrdenPagoDelete (
  @@opg_id         int,
  @@emp_id        int,
  @@us_id          int,
  @@bSuccess      tinyint = 0 out,
  @@ErrorMsg       varchar(5000) = '' out

)
as

begin

  set nocount on

  set @@bSuccess = 0
  set @@ErrorMsg = ''

  if isnull(@@opg_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocOrdenPagoEditableGet    @@emp_id      ,
                                    @@opg_id       ,
                                    @@us_id       ,
                                    @bEditable     out,
                                    @editMsg       out,
                                    0              , --@@ShowMsg
                                    0              ,  --@@bNoAnulado
                                    1                --@@bDelete

  if @bEditable = 0 begin

    set @editMsg = '@@ERROR_SP:' + @editMsg
    raiserror (@editMsg, 16, 1)

    return
  end

  begin transaction

  declare @as_id int

  select @as_id = as_id from OrdenPago where opg_id = @@opg_id
  update OrdenPago set as_id = null where opg_id = @@opg_id
  exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenPagoSetCredito @@opg_id,1
  if @@error <> 0 goto ControlError

  delete OrdenPagoItem where opg_id = @@opg_id
  if @@error <> 0 goto ControlError

  -----------------------------------------------------------------------------------------------------------------

  -- Hay tres situaciones a resolver con los cheques
  --
  -- 1- Borrar los cheques propios emitidos por esta orden
  --
  -- 2- Devolver a la cuenta mencionada en el ultimo 
  --    movimiento de fondos que menciono al cheque
  --
  -- 3- Devolver a documentos en cartera los cheques
  --    ingresados por una cobranza


  -- Borro los cheques propios entregados al proveedor
  delete Cheque 
  where opg_id = @@opg_id 
    and chq_id is not null   -- solo los cheques propios tienen chequera (chq_id)
    and mf_id  is null      -- no entraron por movimiento de fondos
  if @@error <> 0 goto ControlError

  -- Devuelvo a documentos en cartera los cheques de tercero y los desvinculo de esta orden de pago
  update Cheque set cue_id = mfi.cue_id_debe, opg_id = null 
  from MovimientoFondoItem mfi
  where Cheque.cheq_id = mfi.cheq_id
    and Cheque.mf_id   = mfi.mf_id
    and Cheque.opg_id  = @@opg_id
  if @@error <> 0 goto ControlError

  -- Devuelvo a documentos en cartera los cheques de tercero y los desvinculo de esta orden de pago
  update Cheque set cue_id = cobzi.cue_id, opg_id = null from CobranzaItem cobzi
                where   cobzi.cheq_id   = Cheque.cheq_id 
                    and Cheque.opg_id   = @@opg_id
                    and mf_id is null
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenPagoChequeSetCredito @@opg_id,1
  if @@error <> 0 goto ControlError

  -----------------------------------------------------------------------------------------------------------------
  delete OrdenPago where opg_id = @@opg_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  set @@bSuccess = 0
  set @@ErrorMsg = 'Ha ocurrido un error al borrar la Orden de Pago. sp_DocOrdenPagoDelete.'

  raiserror (@@ErrorMsg, 16, 1)
  rollback transaction  

end