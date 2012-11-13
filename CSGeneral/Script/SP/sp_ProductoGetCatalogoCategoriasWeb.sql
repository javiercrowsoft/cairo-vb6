if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetCatalogoCategoriasWeb]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetCatalogoCategoriasWeb]

/*

 sp_ProductoGetCatalogoCategoriasWeb 0

*/

go
create procedure sp_ProductoGetCatalogoCategoriasWeb (
	@@pr_id 		int
)
as

begin

	set nocount on

  select 
         catwci_id,
				 catwci_posicion,
				 catwc.catwc_id,
         catwc_nombre

  from CatalogoWebCategoria catwc 
					left join CatalogoWebCategoriaItem catwci	on  catwc.catwc_id = catwci.catwc_id
																												and catwci.pr_id = @@pr_id

end

go