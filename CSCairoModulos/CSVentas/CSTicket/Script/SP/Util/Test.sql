
/*
select * from cliente where cli_nombre like '%arg%'
select * from clientesucursal where cli_id = 39
select * from proyecto where cli_id = 39
select * from rubro 
*/

declare	@@inicio 			datetime
declare	@@bLlegada    tinyint
declare	@@estado1			datetime
declare	@@estado2			datetime
declare	@@fin					datetime

set @@inicio 		= getdate()
set @@bLlegada 	= 0 

exec sp_alarmaGetFechas 39, 13, 4, 3, @@inicio, @@bllegada, @@estado1 out, @@estado2 out, @@fin out

select @@estado1, @@estado2, @@fin

declare @fin_fecha datetime

		-- le sacamos las horas, minutos, segundos y milisegundos
		--
		set @fin_fecha = dateadd(hh, -datepart(hh,@@fin), @@fin)
		set @fin_fecha = dateadd(n, -datepart(n,@fin_fecha), @fin_fecha)
		set @fin_fecha = dateadd(s, -datepart(s,@fin_fecha), @fin_fecha)
		set @fin_fecha = dateadd(ms, -datepart(ms,@fin_fecha), @fin_fecha)


select @fin_fecha