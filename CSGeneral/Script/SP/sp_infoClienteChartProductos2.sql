if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteChartProductos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteChartProductos2]

/*

sp_infoClienteChartProductos 1,1,34

*/

go
create procedure sp_infoClienteChartProductos2 (
  @@us_id        int,
  @@emp_id       int,
  @@cli_id       int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  declare @fDesde datetime

  set @fDesde = dateadd(d,-180,getdate())

  select   pr_nombreventa            as [Artículo],
          sum(case when doct_id = 7 then -fvi_neto else fvi_neto end)                            
                                    as Total

  from FacturaVenta fv inner join FacturaVentaItem fvi on fv.fv_id   = fvi.fv_id
                       inner join Producto pr          on fvi.pr_id  = pr.pr_id
  where cli_id = @@cli_id 
    and fv_fecha >= @fDesde
    and est_id <> 7

  group by pr_nombreventa

  order by sum(case when doct_id = 7 then -fvi_neto else fvi_neto end) desc, pr_nombreventa

end
go