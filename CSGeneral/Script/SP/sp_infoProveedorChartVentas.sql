if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorChartCompras]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorChartCompras]

/*

select prov_id from facturaCompra where fc_fecha > '20060601'
sp_infoProveedorChartCompras '',1,28
sp_infoProveedorChartProductos 1,1,34
*/

go
create procedure sp_infoProveedorChartCompras (
  @@us_id        int,
  @@emp_id       int,
  @@prov_id      int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoProveedorChartCompras2 @@us_id,
                                     @@emp_id,
                                     @@prov_id,
                                     @@info_aux

end
go