if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGetItems]

go

/*

sp_DocPackingListGetItems 1

*/
create procedure sp_DocPackingListGetItems (
  @@pklst_id int
)
as

begin

  select   PackingListItem.*, 
          pr_nombreventa, 
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          u.un_nombre,
          up.un_nombre as unidadPeso

  from   PackingListItem
        inner join Producto               on PackingListItem.pr_id = Producto.pr_id
        inner join Unidad u                on Producto.un_id_venta = u.un_id
        left join Unidad up                on Producto.un_id_peso = up.un_id
        left join tasaimpositiva as tri    on producto.ti_id_ivariventa  = tri.ti_id
        left join tasaimpositiva as trni   on producto.ti_id_ivarniventa = trni.ti_id
        left join centrocosto as ccos     on PackingListItem.ccos_id = ccos.ccos_id
  where 
      pklst_id = @@pklst_id

  order by pklsti_orden
end