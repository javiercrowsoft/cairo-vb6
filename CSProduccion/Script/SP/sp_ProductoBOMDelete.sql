if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoBOMDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoBOMDelete]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 exec sp_ProductoBOMDelete 1
*/
create procedure sp_ProductoBOMDelete (
	@@pbm_id  int
)
as

set nocount on

begin

  begin transaction

  delete ProductoBOMItemA 
  where exists(select pbmi_id 
               from ProductoBOMItem 
               where pbm_id = @@pbm_id
                 and pbmi_id = ProductoBOMItemA.pbmi_id
              )
	if @@error <> 0 goto ControlError

  delete ProductoBOMItem where pbm_id = @@pbm_id
	if @@error <> 0 goto ControlError

  delete ProductoBOMElaborado where pbm_id = @@pbm_id
	if @@error <> 0 goto ControlError

  delete ProductoBOM where pbm_id = @@pbm_id
	if @@error <> 0 goto ControlError

  commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la B.O.M.. sp_ProductoBOMDelete.', 16, 1)
	rollback transaction	

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go



