if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewGetViews]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewGetViews]

/*

sp_GridViewGetViews '',114,1

*/

go
create procedure sp_GridViewGetViews (
  @@grid_name     varchar(1000),
  @@rpt_id        int,
  @@us_id         int
)
as

begin

  set nocount on

  if @@grid_name <> '' begin

    select *
    from GridView
    where grid_name = @@grid_name
      and (us_id = @@us_id or grdv_publica <> 0)

  end else begin

    declare @inf_id int

    select @inf_id = inf_id from Reporte where rpt_id = @@rpt_id

    select grdv.*
    from GridView grdv inner join Reporte rpt on grdv.rpt_id = rpt.rpt_id
    where inf_id = @inf_id
      and (grdv.us_id = @@us_id or grdv_publica <> 0)

  end

end
go