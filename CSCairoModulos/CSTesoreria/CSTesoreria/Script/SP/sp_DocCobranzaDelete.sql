if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaDelete]

go
/*

 sp_DocCobranzaDelete 93

*/

create procedure sp_DocCobranzaDelete (
  @@cobz_id       int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@cobz_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocCobranzaEditableGet    @@emp_id      ,
                                    @@cobz_id     ,
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

  select @as_id = as_id from Cobranza where cobz_id = @@cobz_id
  update Cobranza set as_id = null where cobz_id = @@cobz_id
  exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
  if @@error <> 0 goto ControlError

  exec sp_DocCobranzaSetCredito @@cobz_id,1
  if @@error <> 0 goto ControlError

  delete CobranzaItem where cobz_id = @@cobz_id
  if @@error <> 0 goto ControlError

  -- Borro los cheques de clientes que entraron por esta cobranza
  delete Cheque where cobz_id = @@cobz_id
  if @@error <> 0 goto ControlError

  exec sp_DocCobranzaChequeSetCredito @@cobz_id,1
  if @@error <> 0 goto ControlError

  -- Borro los cupones de tarjeta que entraron por esta cobranza
  delete TarjetaCreditoCupon where cobz_id = @@cobz_id
  if @@error <> 0 goto ControlError

  delete Cobranza where cobz_id = @@cobz_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la cobranza. sp_DocCobranzaDelete.', 16, 1)
  rollback transaction  

end