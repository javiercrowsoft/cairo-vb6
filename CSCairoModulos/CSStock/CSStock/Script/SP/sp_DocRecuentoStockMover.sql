if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockMover]

/*

RecuentoStock                   reemplazar por el nombre del documento Ej. PedidoVenta
@@rs_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
RecuentoStock                 reemplazar por el nombre de la tabla ej PedidoVenta
rs_id                     reemplazar por el campo ID ej. pv_id
del recuento de stock                  reemplazar por el texto de error ej. del pedido de venta
rs_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocRecuentoStockMover 2,1,7 -- FIRST
sp_DocRecuentoStockMover 3,2,7 -- PREVIOUS
sp_DocRecuentoStockMover 4,1,7 -- NEXT
sp_DocRecuentoStockMover 5,1,7 -- LAST

*/

go
create procedure sp_DocRecuentoStockMover (
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
                                                        select rs_id from RecuentoStock 
                                                        where rs_numero = (
                                                                  select min(rs_numero) from RecuentoStock 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select rs_id from RecuentoStock 
                                                        where rs_numero = (
                                                                  select max(rs_numero) from RecuentoStock 
                                                                  where doc_id = @@DocId 
                                                                      and rs_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select rs_id from RecuentoStock 
                                                        where rs_numero = (
                                                                  select min(rs_numero) from RecuentoStock 
                                                                  where doc_id = @@DocId 
                                                                      and rs_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select rs_id from RecuentoStock 
                                                        where rs_numero = (
                                                                  select max(rs_numero) from RecuentoStock 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end