if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_GetRptReclamoList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_GetRptReclamoList]

go
create procedure sp_web_GetRptReclamoList 
as

begin

	set nocount on

  select min(rpt_id) as rpt_id
  from Reporte inner join Informe on Reporte.inf_id = Informe.inf_id
  where inf_codigo = 'IC_MUR_ERC_0010'
                
end
go