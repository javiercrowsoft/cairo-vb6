if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorChartCompras2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorChartCompras2]

/*

select prov_id from facturaCompra where fc_fecha > '20060601'
sp_infoProveedorChartCompras '',1,28
sp_infoProveedorChartProductos 1,1,34
*/

go
create procedure sp_infoProveedorChartCompras2 (
  @@us_id        int,
  @@emp_id       int,
  @@prov_id      int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  declare @fDesde datetime
  declare @dias   int

  set @fDesde = dateadd(d,-180,getdate())
  set @dias = datepart(d,@fDesde)
  set @dias = @dias-1
  if @dias > 0 set @fDesde = dateadd(d,-@dias,@fDesde)

  select   datepart(yyyy,fc_fecha)    as Anio, 
          datepart(m,fc_fecha)      as Mes,
          sum(case when doct_id = 8 then -fc_neto else fc_neto end)               
                                    as Total

  from FacturaCompra fc 

  where prov_id = @@prov_id 
    and fc_fecha >= @fDesde
    and est_id <> 7

  group by datepart(yyyy,fc_fecha), datepart(m,fc_fecha)

  order by datepart(yyyy,fc_fecha), datepart(m,fc_fecha)

end
go