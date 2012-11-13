if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_getcatalogos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_getcatalogos]

go
/*

 sp_srv_catalog_getcatalogos 

*/

create procedure sp_srv_catalog_getcatalogos (

	@@bCatalgoCSCART tinyint = 0

)

as

begin

	set nocount on

	if @@bCatalgoCSCART <> 0 begin

		select * from CatalogoWeb where activo <> 0 and catw_cscart <> 0

	end else begin

		select * from CatalogoWeb where activo <> 0 and catw_cscart = 0

	end

end