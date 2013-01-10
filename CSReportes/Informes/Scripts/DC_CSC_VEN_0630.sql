/*---------------------------------------------------------------------
Nombre: Analisis de Pedidos de Venta
---------------------------------------------------------------------*/
/*  

Para testear:

exec [DC_CSC_VEN_0630] 2,'20081101 00:00:00','20090323 00:00:00'

*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0630]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0630]
GO

create procedure DC_CSC_VEN_0630 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime

)as 
begin

set nocount on

  create table #t_dc_csc_ven_0630 (fecha datetime)

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

      insert into #t_dc_csc_ven_0630(fecha) values(@fecha)

    end
    set @fecha = dateadd(d,1,@fecha)

  end

  set datefirst @last_date

  select  
          cli.cli_id,
          convert(varchar(10),t.fecha,111)   as Fecha,
          cli_nombre                        as Cliente,
          cli_codigo                        as Codigo,
          sum(case when doct_id = 7 then -fv_total else fv_total end)
                                            as Vendido,
          sum(case when fv_id is not null then 1 else 0 end)
                                            as Facturas,
          case when cli.cli_id is not null then 1 else 0 end as Cantidad

  from   #t_dc_csc_ven_0630 t   
            left join Cliente cli on convert(varchar(10),t.fecha,111) = convert(varchar(10),cli.creado,111)
            left join FacturaVenta fv on cli.cli_id = fv.cli_id and fv.est_id <> 7

  group by

  cli.cli_id,
  convert(varchar(10),t.fecha,111),
  cli_nombre,
  cli_codigo
  
  order by Fecha
  
end

GO