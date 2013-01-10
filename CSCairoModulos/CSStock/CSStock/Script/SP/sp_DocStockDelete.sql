if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockDelete]

/*

 sp_DocStockDelete 93

*/

go
create procedure [dbo].[sp_DocStockDelete] (
  @@st_id           int,
  @@emp_id          int,
  @@us_id            int,
  @@bNotUpdatePrns  tinyint = 0,
  @@bNoCheckAccess  tinyint = 0
)
as

begin

  set nocount on

  if isnull(@@st_id,0) = 0 return

  if @@bNoCheckAccess = 0 begin

    declare @bEditable     tinyint
    declare @editMsg       varchar(255)
  
    exec sp_DocStockEditableGet  @@emp_id      ,
                                @@st_id       ,
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
  end

  declare @bSuccess               tinyint
  declare @Message                varchar(255)

  begin transaction

  --////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Quito de StockCache lo que se movio con los items de este movimiento
  --////////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @@st_id, 1, @@bNotUpdatePrns -- Restar
  if IsNull(@bSuccess,0) = 0 goto Validate

  exec Sp_DocStockValidate @Message out, @bSuccess out, @@st_id
  if IsNull(@bSuccess,0) = 0 goto Validate

  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////////

  delete StockItem where st_id = @@st_id
  if @@error <> 0 goto ControlError

  delete StockItemKit where st_id = @@st_id
  if @@error <> 0 goto ControlError

  delete Stock where st_id = @@st_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el stock. sp_DocStockDelete.', 16, 1)
  goto Roll

Validate:

  set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
  raiserror (@Message, 16, 1)

Roll:

  rollback transaction  

end


