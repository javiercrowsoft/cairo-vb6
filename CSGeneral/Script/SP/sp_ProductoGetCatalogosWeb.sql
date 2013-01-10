if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetCatalogosWeb]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetCatalogosWeb]

/*

 sp_ProductoGetCatalogosWeb 0

*/

go
create procedure sp_ProductoGetCatalogosWeb (
  @@pr_id     int
)
as

begin

  set nocount on

  select 
         catwi_id,
         catw.catw_id,
         catw_nombre

  from CatalogoWeb catw left join CatalogoWebItem catwi  on  catw.catw_id = catwi.catw_id
                                                        and catwi.pr_id = @@pr_id

  order by catw_nombre
end

go