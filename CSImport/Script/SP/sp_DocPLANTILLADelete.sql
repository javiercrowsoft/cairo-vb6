if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCDelete]

go
/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. el pedido de venta

 sp_DocNOMBRE_DOCDelete 93
*/

create procedure sp_DocNOMBRE_DOCDelete (
  PARAM_ID int
)
as

begin

  set nocount on

  begin transaction

  exec sp_DocNOMBRE_DOCSetCredito PARAM_ID,1
  if @@error <> 0 goto ControlError

  delete NOMBRE_TABLAItem where CAMPO_ID = PARAM_ID
  if @@error <> 0 goto ControlError

  delete NOMBRE_TABLA where CAMPO_ID = PARAM_ID
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar TEXTO_ERROR. sp_DocNOMBRE_DOCDelete.', 16, 1)
  rollback transaction  

end