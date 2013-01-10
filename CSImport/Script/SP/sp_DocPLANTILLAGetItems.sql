if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCGetItems]

go

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
CAMPO_NOMBRE_PRODUCTO        reemplazar por el nombre del campo producto Ej. pr_nombreventa o pr_nombrecompra
CAMPO_ORDEN                  reemplazar por el nombre del campo orden Ej. pvi_orden
sp_DocNOMBRE_DOCGetItems 1

*/
create procedure sp_DocNOMBRE_DOCGetItems (
  PARAM_ID int
)
as

begin

  select   NOMBRE_TABLAItem.*, 
          CAMPO_NOMBRE_PRODUCTO, 
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre

  from   NOMBRE_TABLAItem
        inner join Producto               on NOMBRE_TABLAItem.pr_id = Producto.pr_id
        inner join Unidad                 on Producto.un_id_venta = unidad.un_id
        left join tasaimpositiva as tri    on producto.ti_id_ivariventa  = tri.ti_id
        left join tasaimpositiva as trni   on producto.ti_id_ivarniventa = trni.ti_id
        left join centrocosto as ccos     on NOMBRE_TABLAItem.ccos_id = ccos.ccos_id
  where 
      CAMPO_ID = PARAM_ID
  order by CAMPO_ORDEN
end