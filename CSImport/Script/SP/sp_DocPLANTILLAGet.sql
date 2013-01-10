if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCGet]

go

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
TABLA_CLIENTE_PROVEEDOR        reemplazar por Cliente o Proveedor segun el circuito
CAMPO_CLIENTE_PROVEEDOR        reemplazar por cli_ o prov_ segun el circuito

exec sp_DocNOMBRE_DOCEditableGet 57, 7, 0, '',1
sp_DocNOMBRE_DOCGet 57,7
select max(pv_numero) from NOMBRE_TABLA
select pv_id from NOMBRE_TABLA where XX_numero = 57
*/

create procedure sp_DocNOMBRE_DOCGet (
  PARAM_ID int,
  @@us_id int
)
as

begin

declare @bEditable tinyint
declare @editMsg   varchar(255)

  exec sp_DocNOMBRE_DOCEditableGet PARAM_ID, @@us_id, @bEditable out, @editMsg out

  select 
      NOMBRE_TABLA.*,
      CAMPO_TABLA_CLIENTE_PROVEEDOR_PROVEEDORnombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      editable = @bEditable,
      editMsg = @editMsg
  
  from 
      NOMBRE_TABLA inner join documento      on NOMBRE_TABLA.doc_id  = documento.doc_id
                   inner join condicionpago  on NOMBRE_TABLA.cpg_id  = condicionpago.cpg_id
                   inner join estado         on NOMBRE_TABLA.est_id  = estado.est_id
                   inner join sucursal       on NOMBRE_TABLA.suc_id  = sucursal.suc_id
                   inner join TABLA_CLIENTE_PROVEEDOR        on NOMBRE_TABLA.CAMPO_TABLA_CLIENTE_PROVEEDOR_PROVEEDORid  = TABLA_CLIENTE_PROVEEDOR.CAMPO_TABLA_CLIENTE_PROVEEDOR_PROVEEDORid
                   left join centrocosto     on NOMBRE_TABLA.ccos_id = centrocosto.ccos_id
                   left join listaprecio     on NOMBRE_TABLA.lp_id   = listaprecio.lp_id
                   left join listadescuento  on NOMBRE_TABLA.ld_id   = listadescuento.ld_id

  where CAMPO_ID = PARAM_ID

end