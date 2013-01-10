if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenProdKitGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenProdKitGetItems]

go

/*

sp_DocOrdenProdKitGetItems 7003

*/
create procedure sp_DocOrdenProdKitGetItems (
  @@opk_id int
)
as

begin

  set nocount on

  select   OrdenProdKitItem.*, 
          pr_nombrecompra, 
          pr_eskit,
          un_nombre,
          prfk_nombre

  from   OrdenProdKitItem
        inner join Producto                 on OrdenProdKitItem.pr_id     = Producto.pr_id
        inner join ProductoFormulaKit prfk  on OrdenProdKitItem.prfk_id   = prfk.prfk_id
        inner join Unidad                   on Producto.un_id_stock       = unidad.un_id

  where 
          opk_id     = @@opk_id
    and    pr_eskit   <> 0

  order by opki_orden

end