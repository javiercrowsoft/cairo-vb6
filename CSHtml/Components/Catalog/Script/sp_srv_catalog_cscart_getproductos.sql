if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_cscart_getproductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_cscart_getproductos]

go
/*

	update producto set modificado = getdate() where exists (select * from CatalogoWebItem where pr_id = producto.pr_id and catw_id = 3)

	update producto set modificado = getdate() where pr_codigo = 'q2612a'

	select pr_activoweb from producto where pr_codigo = '08668'

	exec sp_srv_catalog_cscart_getproductos 3

	sp_srv_catalog_cscart_getproductos 3

*/

create procedure sp_srv_catalog_cscart_getproductos (
	@@catw_id int
)

as

begin

	set nocount on

	exec sp_srv_catalog_cscart_getproductos_cliente @@catw_id

end