if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewSaveDefault]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewSaveDefault]

/*

*/

go
create procedure sp_GridViewSaveDefault (
  @@grdv_id     int
)
as

begin

  set nocount on

  declare @us_id         int
  declare @rpt_id       int
  declare @grid_name     varchar(255)
  declare @grdv_default  tinyint

  select   @grid_name       = grid_name, 
          @us_id           = us_id, 
          @rpt_id         = rpt_id,
          @grdv_default   = grdv_default

  from GridView where grdv_id = @@grdv_id

  if @grdv_default <> 0 begin

    begin transaction
    
    if @grid_name <> '' begin
  
      update GridView set grdv_default = 0 
      where us_id     =  @us_id 
        and grid_name =  @grid_name 
        and grdv_id   <> @@grdv_id

      if @@error <> 0 goto ControlError
  
    end else begin  
  
      update GridView set grdv_default = 0 
      where us_id   =  @us_id 
        and rpt_id   =  @rpt_id 
        and grdv_id <> @@grdv_id

      if @@error <> 0 goto ControlError
  
    end
  
    commit transaction

  end

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar la vista. sp_GridViewSaveDefault.', 16, 1)
  rollback transaction  

end
go