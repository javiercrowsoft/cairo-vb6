if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionDelete]

go
/*

 sp_DocParteReparacionDelete 93

*/

create procedure sp_DocParteReparacionDelete (
  @@prp_id         int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@prp_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocParteReparacionEditableGet  @@emp_id      ,
                                        @@prp_id       ,
                                        @@us_id       ,
                                        @bEditable     out,
                                        @editMsg       out,
                                        0              , --@@ShowMsg
                                        1              ,  --@@bNoAnulado
                                        1                --@@bDelete

  if @bEditable = 0 begin

    set @editMsg = '@@ERROR_SP:' + @editMsg
    raiserror (@editMsg, 16, 1)

    return
  end

  begin transaction

  declare @st_id int

  select @st_id = st_id from ParteReparacion where prp_id = @@prp_id
  update ParteReparacion set st_id = null where prp_id = @@prp_id
  if @@error <> 0 goto ControlError

  exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
  if @@error <> 0 goto ControlError

  delete ParteReparacionItem where prp_id = @@prp_id
  if @@error <> 0 goto ControlError

  delete ParteReparacion where prp_id = @@prp_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar del parte de reparación. sp_DocParteReparacionDelete.', 16, 1)
  rollback transaction  

end