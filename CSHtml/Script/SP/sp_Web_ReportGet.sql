SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Web_ReportGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Web_ReportGet]
GO

/*

select * from reporte

sp_Web_ReportGet 1,5

*/

create procedure sp_Web_ReportGet
(
  @@us_id            int,
  @@rpt_id           int
) 
as
begin

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 7001, @@rpt_id, @@us_id, 2

  select 
                inf_nombre,
                inf_codigo,
                inf_totalesgrales,
                inf_connstr,
                inf_storedprocedure,
                inf_colocultas,
                inf_checkbox
  from 
        Informe i left join Reporte r on i.inf_id = r.inf_id
  where 
        r.rpt_id = @@rpt_id

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

