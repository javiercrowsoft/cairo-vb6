if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteProductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteProductos]

/*

sp_infoClienteProductos 1,1,34

*/

go
create procedure sp_infoClienteProductos (
  @@us_id         int,
  @@emp_id        int,
  @@cli_id        int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoClienteProductos2 @@us_id,
                                @@emp_id,
                                @@cli_id,
                                @@info_aux

end
go