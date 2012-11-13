if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioUpdateAlarma]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioUpdateAlarma]

/*

exec sp_web_ParteDiarioUpdateAlarma 1,15,'19000106',1,'01:00:00',0

select ptd_id,ptd_alarma, ptd_fechaini, ptd_fechafin, ptd_horaini, ptd_horafin from 
partediario where ptd_titulo = 'Reporte de cuentas corrientes por remito (Cristian)'

*/

go
create procedure sp_web_ParteDiarioUpdateAlarma (
  @@us_id                       int,
	@@ptd_id 											int,
	@@ptd_alarma									datetime,
	@@ptd_cumplida								tinyint,
	@@ptd_horaini                 datetime,
  @@rtn                   			int out	
)
as

begin

	set nocount on

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%partediario%'*/
  exec sp_HistoriaUpdate 15002, @@ptd_id, @@us_id, 1

	set @@ptd_alarma									= IsNull(@@ptd_alarma,'19000101')
	set @@ptd_cumplida								= IsNull(@@ptd_cumplida,1)
	set @@ptd_horaini                 = IsNull(@@ptd_horaini,'19000101')

  if @@ptd_cumplida = 3 begin

  	update ParteDiario set
  													ptd_cumplida	= @@ptd_cumplida
  
  	where ptd_id = @@ptd_id

  end else begin

    declare @ptd_alarma   datetime

    set @ptd_alarma   = getdate() 

		declare @dias int
		set @dias = DateDiff(dd,'19000101',@@ptd_alarma)

	  if @dias > 0
	    set @ptd_alarma = DateAdd(dd,@dias,@ptd_alarma)

    set @ptd_alarma = DateAdd(hh,DatePart(hh,@@ptd_horaini),@ptd_alarma)
    set @ptd_alarma = DateAdd(n,DatePart(n,@@ptd_horaini),@ptd_alarma)

  	update ParteDiario set
  													ptd_alarma		= @ptd_alarma
  
  	where ptd_id = @@ptd_id
  end

  exec sp_web_ParteDiarioUpdateAviso @@ptd_id

	set @@rtn = @@ptd_id

end

go