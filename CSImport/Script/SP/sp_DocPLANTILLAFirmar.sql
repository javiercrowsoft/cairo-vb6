if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCFirmar]

go

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
CAMPO_FIRMADO                reemplazar por el campo pv_firmado

sp_DocNOMBRE_DOCFirmar 17,8

*/

create procedure sp_DocNOMBRE_DOCFirmar (
  PARAM_ID int,
  @@us_id int
)
as

begin

  -- Si esta firmado le quita la firma
  if exists(select CAMPO_FIRMADO from NOMBRE_TABLA where CAMPO_ID = PARAM_ID and CAMPO_FIRMADO <> 0)
    update NOMBRE_TABLA set CAMPO_FIRMADO = 0 where CAMPO_ID = PARAM_ID
  -- Sino lo firma
  else
    update NOMBRE_TABLA set CAMPO_FIRMADO = @@us_id where CAMPO_ID = PARAM_ID

  exec sp_DocNOMBRE_DOCSetEstado PARAM_ID

  select NOMBRE_TABLA.est_id,est_nombre 
  from NOMBRE_TABLA inner join Estado on NOMBRE_TABLA.est_id = Estado.est_id
  where CAMPO_ID = PARAM_ID
end