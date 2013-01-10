if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteChartVentas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteChartVentas]

/*

select cli_id from facturaventa where fv_fecha > '20060601'
sp_infoClienteChartVentas '',1,28
sp_infoClienteChartProductos 1,1,34
*/

go
create procedure sp_infoClienteChartVentas (
  @@us_id        int,
  @@emp_id       int,
  @@cli_id       int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoClienteChartVentas2 @@us_id,
                                  @@emp_id,
                                  @@cli_id,
                                  @@info_aux

end
go