/*---------------------------------------------------------------------
Nombre: Analisis de Pedidos de Venta
---------------------------------------------------------------------*/
/*  

Para testear:

exec [DC_CSC_VEN_0631] 2,'20081101 00:00:00','20090323 00:00:00'

*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0631]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0631]
GO

create procedure DC_CSC_VEN_0631 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime

)as 
begin

set nocount on

	create table #t_DC_CSC_VEN_0631 (fecha datetime)

	declare @fecha datetime
	set @fecha = @@Fini

	declare @dia int
	declare @last_date int

	set @last_date = @@datefirst
	set datefirst 7

	while @fecha <= @@Ffin
	begin

		set @dia = datepart(dw, @fecha)

		if @dia not in (1,7) begin

			insert into #t_DC_CSC_VEN_0631(fecha) values(@fecha)

		end
		set @fecha = dateadd(d,1,@fecha)

	end

	set datefirst @last_date

	select  
					1 as aux_id,
					convert(varchar(10),t.fecha,111) 	as Fecha,
					sum(case when doct_id = 7 then -fv_total else fv_total end)
																						as Vendido,
					sum(case when fv_id is not null then 1 else 0 end)
																						as Facturas,
					sum(case when cli.cli_id is not null then 1 else 0 end) as Cantidad

	from 	#t_DC_CSC_VEN_0631 t 	
						left join Cliente cli on convert(varchar(10),t.fecha,111) = convert(varchar(10),cli.creado,111)
						left join FacturaVenta fv on cli.cli_id = fv.cli_id and fv.est_id <> 7

	group by

	convert(varchar(10),t.fecha,111)
	
	order by Fecha
	
end

GO