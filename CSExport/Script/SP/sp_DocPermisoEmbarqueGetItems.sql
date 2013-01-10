if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueGetItems]

go

/*

sp_DocPermisoEmbarqueGetItems 1

*/
create procedure sp_DocPermisoEmbarqueGetItems (
  @@pemb_id int
)
as

begin

  select   PermisoEmbarqueItem.*, 
          pr_nombreventa, 
          un_nombre

  from   PermisoEmbarqueItem
        inner join Producto               on PermisoEmbarqueItem.pr_id = Producto.pr_id
        inner join Unidad                 on Producto.un_id_venta = unidad.un_id
  where 
      pemb_id = @@pemb_id
  order by pembi_orden
end