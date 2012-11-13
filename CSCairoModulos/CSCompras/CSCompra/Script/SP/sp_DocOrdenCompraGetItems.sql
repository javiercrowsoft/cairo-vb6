if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraGetItems]

go

/*

OrdenCompra                   reemplazar por el nombre del documento Ej. OrdenVenta
@@oc_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
OrdenCompra                 reemplazar por el nombre de la tabla ej OrdenVenta
oc_id                     reemplazar por el campo ID ej. pv_id
de la orden de compra                  reemplazar por el texto de error ej. de la orden de venta
pr_nombreCompra        reemplazar por el nombre del campo producto Ej. pr_nombreventa o pr_nombrecompra

sp_DocOrdenCompraGetItems 1

*/
create procedure sp_DocOrdenCompraGetItems (
	@@oc_id int
)
as

begin

	select 	OrdenCompraItem.*, 
					pr_nombreCompra, 
					tri.ti_porcentaje as iva_ri_porcentaje,
					trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre

	from 	OrdenCompraItem
				inner join Producto 							on OrdenCompraItem.pr_id = Producto.pr_id
        inner join Unidad 								on Producto.un_id_compra = unidad.un_id
				left join tasaimpositiva as tri  	on producto.ti_id_ivaricompra  = tri.ti_id
				left join tasaimpositiva as trni 	on producto.ti_id_ivarnicompra = trni.ti_id
        left join centrocosto as ccos 		on OrdenCompraItem.ccos_id = ccos.ccos_id
	where 
			oc_id = @@oc_id

end