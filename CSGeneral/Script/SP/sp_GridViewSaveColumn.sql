if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewSaveColumn]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewSaveColumn]

/*

*/

go
create procedure sp_GridViewSaveColumn (
  @@grdv_id          int,
  @@grdvc_nombre     varchar(255),
  @@grdvc_visible    tinyint,
  @@grdvc_width       smallint,
  @@grdvc_index       smallint

)
as

begin

  set nocount on

  begin transaction

  declare @grdvc_id int

  exec sp_dbgetnewid 'GridViewColumn', 'grdvc_id', @grdvc_id out, 0
       
  insert into GridViewColumn (grdv_id, grdvc_id, grdvc_nombre, grdvc_visible, grdvc_width, grdvc_index)
                    values    (@@grdv_id, @grdvc_id, @@grdvc_nombre, @@grdvc_visible, @@grdvc_width, @@grdvc_index)
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar la columna. sp_GridViewSaveColumn.', 16, 1)
  rollback transaction  

end
go