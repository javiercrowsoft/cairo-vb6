if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioChangeEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioChangeEstado]

/*

 sp_web_ParteDiarioChangeEstado 124

*/

go
create procedure sp_web_ParteDiarioChangeEstado (
  @@us_id         int,
	@@ptd_id        int,
	@@ptd_cumplida  tinyint,
	@@tarest_id     int,
	@@rtn						int out

)
as

begin

	set nocount on

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 15002, @@ptd_id, @@us_id, 5

	update ParteDiario set

															ptd_cumplida = @@ptd_cumplida,
                              tarest_id    = @@tarest_id


	where ptd_id = @@ptd_id

	set @@rtn = 1
end