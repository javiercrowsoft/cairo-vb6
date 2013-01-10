if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteChartVentas2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteChartVentas2]

/*

select cli_id from facturaventa where fv_fecha > '20060601'
sp_infoClienteChartVentas '',1,28
sp_infoClienteChartProductos 1,1,34
*/

go
create procedure sp_infoClienteChartVentas2 (
  @@us_id        int,
  @@emp_id       int,
  @@cli_id       int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  declare @fDesde datetime
  declare @dias   int

  set @fDesde = dateadd(m,-5,getdate())
  set @dias = datepart(d,@fDesde)
  set @dias = @dias-1
  if @dias > 0 set @fDesde = dateadd(d,-@dias,@fDesde)

  select   datepart(yyyy,fv_fecha)    as Anio, 
          datepart(m,fv_fecha)      as Mes,
          sum(case when doct_id = 7 then -fv_neto else fv_neto end)               
                                    as Total

  from FacturaVenta fv 

  where cli_id = @@cli_id 
    and fv_fecha >= @fDesde
    and est_id <> 7

  group by datepart(yyyy,fv_fecha), datepart(m,fv_fecha)

  order by datepart(yyyy,fv_fecha), datepart(m,fv_fecha)

end
go