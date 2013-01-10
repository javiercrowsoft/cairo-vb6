if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCMover]

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
NOMBRE_CAMPO_NUMERO          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocNOMBRE_DOCMover 2,1,7 -- FIRST
sp_DocNOMBRE_DOCMover 3,2,7 -- PREVIOUS
sp_DocNOMBRE_DOCMover 4,1,7 -- NEXT
sp_DocNOMBRE_DOCMover 5,1,7 -- LAST

*/

go
create procedure sp_DocNOMBRE_DOCMover (
  @@MoveTo        smallint,
  @@currNro      int,
  @@DocId        int
)
as

begin

  declare @MSG_DOC_FIRST       smallint 
  declare @MSG_DOC_PREVIOUS   smallint
  declare @MSG_DOC_NEXT       smallint
  declare @MSG_DOC_LAST       smallint

  set @MSG_DOC_FIRST = 101
  set @MSG_DOC_PREVIOUS = 102
  set @MSG_DOC_NEXT = 103
  set @MSG_DOC_LAST = 104

  if            @@MoveTo = @MSG_DOC_FIRST        begin
                                                        select NOMBRE_CAMPO_id from NOMBRE_TABLA 
                                                        where NOMBRE_CAMPO_NUMERO = (
                                                                  select min(NOMBRE_CAMPO_NUMERO) from NOMBRE_TABLA 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select NOMBRE_CAMPO_id from NOMBRE_TABLA 
                                                        where NOMBRE_CAMPO_NUMERO = (
                                                                  select max(NOMBRE_CAMPO_NUMERO) from NOMBRE_TABLA 
                                                                  where doc_id = @@DocId 
                                                                      and NOMBRE_CAMPO_NUMERO < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select NOMBRE_CAMPO_id from NOMBRE_TABLA 
                                                        where NOMBRE_CAMPO_NUMERO = (
                                                                  select min(NOMBRE_CAMPO_NUMERO) from NOMBRE_TABLA 
                                                                  where doc_id = @@DocId 
                                                                      and NOMBRE_CAMPO_NUMERO > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select NOMBRE_CAMPO_id from NOMBRE_TABLA 
                                                        where NOMBRE_CAMPO_NUMERO = (
                                                                  select max(NOMBRE_CAMPO_NUMERO) from NOMBRE_TABLA 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end