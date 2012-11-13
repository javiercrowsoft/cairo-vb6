if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraGetItems]

go

/*

PedidoCompra                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pc_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
PedidoCompra                 reemplazar por el nombre de la tabla ej PedidoVenta
pc_id                     reemplazar por el campo ID ej. pv_id
del pedido de compra                  reemplazar por el texto de error ej. del pedido de venta
pr_nombreCompra        reemplazar por el nombre del campo producto Ej. pr_nombreventa o pr_nombrecompra

sp_DocPedidoCompraGetItems 1

*/
create procedure sp_DocPedidoCompraGetItems (
	@@pc_id int
)
as

begin

	select 	PedidoCompraItem.*, 
					pr_nombreCompra, 
					tri.ti_porcentaje as iva_ri_porcentaje,
					trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre

	from 	PedidoCompraItem
				inner join Producto 							on PedidoCompraItem.pr_id = Producto.pr_id
        inner join Unidad 								on Producto.un_id_compra = unidad.un_id
				left join tasaimpositiva as tri  	on producto.ti_id_ivaricompra  = tri.ti_id
				left join tasaimpositiva as trni 	on producto.ti_id_ivarnicompra = trni.ti_id
        left join centrocosto as ccos 		on PedidoCompraItem.ccos_id = ccos.ccos_id
	where 
			pc_id = @@pc_id

end