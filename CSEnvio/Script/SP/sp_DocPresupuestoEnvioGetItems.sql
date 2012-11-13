if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioGetItems]

go

/*

PresupuestoEnvio                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pree_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
PresupuestoEnvio                 reemplazar por el nombre de la tabla ej PedidoVenta
pree_id                     reemplazar por el campo ID ej. pv_id
del presupuesto                  reemplazar por el texto de error ej. del pedido de venta
pr_nombreventa        reemplazar por el nombre del campo producto Ej. pr_nombreventa o pr_nombrecompra

sp_columns PresupuestoEnvioItem

sp_DocPresupuestoEnvioGetItems 1

*/
create procedure sp_DocPresupuestoEnvioGetItems (
	@@pree_id int
)
as

begin

	select 	PresupuestoEnvioItem.*, 
					pr_nombreventa, 
					tri.ti_porcentaje as iva_ri_porcentaje,
					trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre,
          pueOrigen.pue_nombre as Origen,
          pueDestino.pue_nombre as Destino,
          trans_nombre

	from 	PresupuestoEnvioItem
				inner join Producto 							on PresupuestoEnvioItem.pr_id = Producto.pr_id
        inner join Unidad 								on Producto.un_id_venta = unidad.un_id
				left join tasaimpositiva as tri  	on producto.ti_id_ivariventa  = tri.ti_id
				left join tasaimpositiva as trni 	on producto.ti_id_ivarniventa = trni.ti_id
        left join centrocosto as ccos 		on PresupuestoEnvioItem.ccos_id = ccos.ccos_id
        left join puerto as pueOrigen     on PresupuestoEnvioItem.pue_id_Origen = pueOrigen.pue_id
        left join puerto as pueDestino    on PresupuestoEnvioItem.pue_id_destino = pueDestino.pue_id
        left join transporte              on PresupuestoEnvioItem.trans_id = transporte.trans_id
	where 
			pree_id = @@pree_id

	order by preei_orden
end