/*---------------------------------------------------------------------
Nombre: Ingresos y Egresos 12 meses
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0220_aux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0220_aux]

/*

create table #t_meses(

												pr_id     int,

												mes1						varchar(50),
												mes2						varchar(50),
												mes3						varchar(50),
												mes4						varchar(50),
												mes5						varchar(50),
												mes6						varchar(50),
												mes7						varchar(50),
												mes8						varchar(50),
												mes9						varchar(50),
												mes10						varchar(50),
												mes11						varchar(50),
												mes12						varchar(50),

												imes1						decimal(18,6) not null default(0),
												imes2						decimal(18,6) not null default(0),
												imes3						decimal(18,6) not null default(0),
												imes4						decimal(18,6) not null default(0),
												imes5						decimal(18,6) not null default(0),
												imes6						decimal(18,6) not null default(0),
												imes7						decimal(18,6) not null default(0),
												imes8						decimal(18,6) not null default(0),
												imes9						decimal(18,6) not null default(0),
												imes10					decimal(18,6) not null default(0),
												imes11					decimal(18,6) not null default(0),
												imes12					decimal(18,6) not null default(0)

											)


	exec DC_CSC_TSR_0220_aux '20090223','20191211',1

	select * from #t_meses

	drop table #t_meses

*/

go
create procedure DC_CSC_TSR_0220_aux (

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@pr_id 	 int,
	@@cue_id   int,

	@@tipo 		 int

)as 

begin

set nocount on

	declare @fecha  datetime

	declare @mes1   datetime
	declare @mes2   datetime
	declare @mes3   datetime

	declare @mes4   datetime
	declare @mes5   datetime
	declare @mes6   datetime

	declare @mes7   datetime
	declare @mes8   datetime
	declare @mes9   datetime

	declare @mes10  datetime
	declare @mes11  datetime
	declare @mes12  datetime

	set @@Fini = dateadd(d,-datepart(d,@@Fini)+1,@@Fini)

	set @@Ffin = dateadd(m,1,@@Ffin)
	set @@Ffin = dateadd(d,-datepart(d,@@Ffin),@@Ffin)

	set @fecha = @@Fini

	while @fecha < @@Ffin
	begin

		set @mes1  = @fecha
		set @mes2  = dateadd(m,1,@fecha)
		set @mes3  = dateadd(m,2,@fecha)
		set @mes4  = dateadd(m,3,@fecha)
		set @mes5  = dateadd(m,4,@fecha)
		set @mes6  = dateadd(m,5,@fecha)
		set @mes7  = dateadd(m,6,@fecha)
		set @mes8  = dateadd(m,7,@fecha)
		set @mes9  = dateadd(m,8,@fecha)
		set @mes10 = dateadd(m,9,@fecha)
		set @mes11 = dateadd(m,10,@fecha)
		set @mes12 = dateadd(m,11,@fecha)

		insert into #t_meses(

												tipo,

												pr_id,
												cue_id,

												mes1,
												mes2,
												mes3,

												mes4,
												mes5,
												mes6,

												mes7,
												mes8,
												mes9,

												mes10,
												mes11,
												mes12

											)

		values (
												@@tipo,
												@@pr_id,
												@@cue_id,

												convert(varchar(7),@mes1,111),
												convert(varchar(7),@mes2,111),
												convert(varchar(7),@mes3,111),

												convert(varchar(7),@mes4,111),
												convert(varchar(7),@mes5,111),
												convert(varchar(7),@mes6,111),

												convert(varchar(7),@mes7,111),
												convert(varchar(7),@mes8,111),
												convert(varchar(7),@mes9,111),

												convert(varchar(7),@mes10,111),
												convert(varchar(7),@mes11,111),
												convert(varchar(7),@mes12,111)
						)

		set @fecha = dateadd(m,12,@fecha)

	end

end

GO