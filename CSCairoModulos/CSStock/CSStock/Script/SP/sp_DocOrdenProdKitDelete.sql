if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenProdKitDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenProdKitDelete]

go
/*

 sp_DocOrdenProdKitDelete 93

*/

create procedure sp_DocOrdenProdKitDelete (
  @@opk_id         int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@opk_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocOrdenProdKitEditableGet  @@emp_id      ,
                                      @@opk_id       ,
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

  delete OrdenProdKitItem where opk_id = @@opk_id
  if @@error <> 0 goto ControlError

  delete OrdenProdKit where opk_id = @@opk_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el parte de desarme de kit. sp_DocOrdenProdKitDelete.', 16, 1)
  rollback transaction  

end