if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListDelete]

go
/*

 sp_DocPackingListDelete 93
 
*/

create procedure sp_DocPackingListDelete (
  @@pklst_id       int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@pklst_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocPackingListEditableGet    @@emp_id      ,
                                      @@pklst_id    ,
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

  exec sp_DocPackingListSetCredito @@pklst_id,1
  if @@error <> 0 goto ControlError

  delete PackingListItem where pklst_id = @@pklst_id
  if @@error <> 0 goto ControlError

  delete PackingList where pklst_id = @@pklst_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar del packing list. sp_DocPackingListDelete.', 16, 1)
  rollback transaction  

end