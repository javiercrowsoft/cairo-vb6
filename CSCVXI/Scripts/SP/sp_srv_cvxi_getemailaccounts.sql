if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getemailaccounts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getemailaccounts]

go
/*

	update producto set modificado = getdate() where exists (select * from CatalogoWebItem where pr_id = producto.pr_id and catw_id = 3)

	update producto set modificado = getdate() where pr_codigo = 'q2612a'

	select pr_activoweb from producto where pr_codigo = '08668'

	exec sp_srv_cvxi_getemailaccounts 3

sp_srv_cvxi_getemailaccounts 3

*/

create procedure sp_srv_cvxi_getemailaccounts 

as

begin

	set nocount on

	select * from ComunidadInternetEmailAccount

end