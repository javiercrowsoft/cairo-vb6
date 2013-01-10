if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaDelete]

go
/*

 sp_DocManifiestoCargaDelete 93

*/

create procedure sp_DocManifiestoCargaDelete (
  @@mfc_id         int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@mfc_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocManifiestoCargaEditableGet  @@emp_id      ,
                                        @@mfc_id       ,
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

  delete ManifiestoCargaItem where mfc_id = @@mfc_id
  if @@error <> 0 goto ControlError

  delete ManifiestoCarga where mfc_id = @@mfc_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar del manifiesto de carga. sp_DocManifiestoCargaDelete.', 16, 1)
  rollback transaction  

end