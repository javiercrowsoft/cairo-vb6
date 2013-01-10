if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioDelete]

go
/*

 sp_DocPresupuestoEnvioDelete 93

*/

create procedure sp_DocPresupuestoEnvioDelete (
  @@pree_id       int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@pree_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocPresupuestoEnvioEditableGet    @@emp_id      ,
                                            @@pree_id     ,
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

  delete PresupuestoEnvioItem where pree_id = @@pree_id
  if @@error <> 0 goto ControlError

  delete PresupuestoEnvioGasto where pree_id = @@pree_id
  if @@error <> 0 goto ControlError

  delete PresupuestoEnvio where pree_id = @@pree_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el presupuesto. sp_DocPresupuestoEnvioDelete.', 16, 1)
  rollback transaction  

end