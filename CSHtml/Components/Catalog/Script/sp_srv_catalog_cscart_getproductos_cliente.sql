if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_cscart_getproductos_cliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_cscart_getproductos_cliente]

go
/*

  exec sp_srv_catalog_cscart_getproductos_cliente 3

*/

create procedure sp_srv_catalog_cscart_getproductos_cliente (
  @@catw_id int
)

as

begin

  set nocount on

  exec sp_srv_catalog_cscart_getproductos_cairo @@catw_id

end