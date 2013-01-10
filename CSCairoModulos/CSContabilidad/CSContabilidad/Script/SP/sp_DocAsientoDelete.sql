if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoDelete]

/*

 sp_DocAsientoDelete 93

*/

go
create procedure sp_DocAsientoDelete (
  @@as_id           int,
  @@emp_id          int,
  @@us_id            int,
  @@bNoCheckAccess  tinyint = 0
)
as

begin

  set nocount on

  if isnull(@@as_id,0) = 0 return

  if @@bNoCheckAccess = 0 begin

    declare @bEditable     tinyint
    declare @editMsg       varchar(255)
  
    exec sp_DocAsientoEditableGet    @@emp_id      ,
                                    @@as_id       ,
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

  begin transaction

  delete AsientoItem where as_id = @@as_id
  if @@error <> 0 goto ControlError

  delete Asiento where as_id = @@as_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el Asiento. sp_DocAsientoDelete.', 16, 1)
  rollback transaction  

end