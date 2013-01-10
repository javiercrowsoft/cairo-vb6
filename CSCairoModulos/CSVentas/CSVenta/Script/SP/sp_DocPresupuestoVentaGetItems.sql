if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaGetItems]

go

/*

sp_DocPresupuestoVentaGetItems 1

*/
create procedure sp_DocPresupuestoVentaGetItems (
  @@prv_id int
)
as

begin

  select   PresupuestoVentaItem.*, 
          pr_nombreventa, 
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre

  from   PresupuestoVentaItem
        inner join Producto               on PresupuestoVentaItem.pr_id = Producto.pr_id
        inner join Unidad                 on Producto.un_id_venta = unidad.un_id
        left join tasaimpositiva as tri    on producto.ti_id_ivariventa  = tri.ti_id
        left join tasaimpositiva as trni   on producto.ti_id_ivarniventa = trni.ti_id
        left join centrocosto as ccos     on PresupuestoVentaItem.ccos_id = ccos.ccos_id
  where 
      prv_id = @@prv_id

  order by prvi_orden
end