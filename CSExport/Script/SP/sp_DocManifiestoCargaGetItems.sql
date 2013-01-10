if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaGetItems]

go

/*

sp_DocManifiestoCargaGetItems 1

*/
create procedure sp_DocManifiestoCargaGetItems (
  @@mfc_id int
)
as

begin

  select   ManifiestoCargaItem.*, 
          case when pr_nombreventa<>'' then pr_nombreventa
                    else                    pr_nombrecompra
          end as pr_nombreventa, 
          ccos_nombre,
          un_nombre

  from   ManifiestoCargaItem
        inner join Producto               on ManifiestoCargaItem.pr_id = Producto.pr_id
        left  join Unidad                 on Producto.un_id_venta = unidad.un_id
        left  join centrocosto as ccos     on ManifiestoCargaItem.ccos_id = ccos.ccos_id
  where 
      mfc_id = @@mfc_id
  order by mfci_orden
end