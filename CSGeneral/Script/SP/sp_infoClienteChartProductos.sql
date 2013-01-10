if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteChartProductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteChartProductos]

/*

sp_infoClienteChartProductos 1,1,34

*/

go
create procedure sp_infoClienteChartProductos (
  @@us_id        int,
  @@emp_id       int,
  @@cli_id       int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoClienteChartProductos2 @@us_id,
                                     @@emp_id,
                                     @@cli_id,
                                     @@info_aux

end
go