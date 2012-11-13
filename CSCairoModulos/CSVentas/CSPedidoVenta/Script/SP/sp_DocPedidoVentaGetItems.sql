if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGetItems]

go

/*

sp_DocPedidoVentaGetItems 1

*/
create procedure sp_DocPedidoVentaGetItems (
	@@pv_id int
)
as

begin

	select 	PedidoVentaItem.*, 
					pr_nombreventa, 
					tri.ti_porcentaje as iva_ri_porcentaje,
					trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre

	from 	PedidoVentaItem
				inner join Producto 							on PedidoVentaItem.pr_id = Producto.pr_id
        inner join Unidad 								on Producto.un_id_venta = unidad.un_id
				left join tasaimpositiva as tri  	on producto.ti_id_ivariventa  = tri.ti_id
				left join tasaimpositiva as trni 	on producto.ti_id_ivarniventa = trni.ti_id
        left join centrocosto as ccos 		on PedidoVentaItem.ccos_id = ccos.ccos_id
	where 
			pv_id = @@pv_id

	order by pvi_orden
end