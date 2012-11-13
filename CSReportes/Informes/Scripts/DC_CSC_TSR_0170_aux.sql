/*---------------------------------------------------------------------
Nombre: Prespuesto Financiero
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0170_aux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0170_aux]

/*

create table #t_meses(

												concepto_id     int,
												concepto        varchar(255),

												mes1						varchar(50),
												mes2						varchar(50),
												mes3						varchar(50),

												ccos_id1				int,
												ccos_id2				int,
												ccos_id3				int,
												ccos_id4				int,
												ccos_id5				int,


												mes1_ccos1				decimal(18,6),
												mes1_ccos2				decimal(18,6),
												mes1_ccos3				decimal(18,6),
												mes1_ccos4				decimal(18,6),
												mes1_ccos5				decimal(18,6),
												mes1_otros				decimal(18,6),

												mes2_ccos1				decimal(18,6),
												mes2_ccos2				decimal(18,6),
												mes2_ccos3				decimal(18,6),
												mes2_ccos4				decimal(18,6),
												mes2_ccos5				decimal(18,6),
												mes2_otros				decimal(18,6),

												mes3_ccos1				decimal(18,6),
												mes3_ccos2				decimal(18,6),
												mes3_ccos3				decimal(18,6),
												mes3_ccos4				decimal(18,6),
												mes3_ccos5				decimal(18,6),
												mes3_otros				decimal(18,6)
											)


	exec DC_CSC_TSR_0170_aux '20090223','20091211',1,'Ingresos',1,2,3,4,5


	drop table #t_meses

*/

go
create procedure DC_CSC_TSR_0170_aux (

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@grupo_id int,

	@@concepto_id int,
	@@concepto		varchar(255),

	@@ccos_id1				int,
	@@ccos_id2				int,
	@@ccos_id3				int,
	@@ccos_id4				int,
	@@ccos_id5				int

)as 

begin

set nocount on

	declare @fecha datetime
	declare @mes1  datetime
	declare @mes2  datetime
	declare @mes3  datetime

	set @@Fini = dateadd(d,-datepart(d,@@Fini)+1,@@Fini)

	set @@Ffin = dateadd(m,1,@@Ffin)
	set @@Ffin = dateadd(d,-datepart(d,@@Ffin),@@Ffin)

	set @fecha = @@Fini

	while @fecha < @@Ffin
	begin

		set @mes1 = @fecha
		set @mes2 = dateadd(m,1,@fecha)
		set @mes3 = dateadd(m,2,@fecha)

		insert into #t_meses(

												grupo_id,

												concepto_id,
												concepto,

												mes1,
												mes2,
												mes3,

												ccos_id1,
												ccos_id2,
												ccos_id3,
												ccos_id4,
												ccos_id5
											)

		values (
												@@grupo_id,

												@@concepto_id,
												@@concepto,

												convert(varchar(7),@mes1,111),
												convert(varchar(7),@mes2,111),
												convert(varchar(7),@mes3,111),

												@@ccos_id1,
												@@ccos_id2,
												@@ccos_id3,
												@@ccos_id4,
												@@ccos_id5
						)

		set @fecha = dateadd(m,3,@fecha)

	end

end

GO