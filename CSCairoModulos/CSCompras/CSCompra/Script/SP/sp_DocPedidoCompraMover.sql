if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraMover]

/*

PedidoCompra                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pc_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
PedidoCompra                 reemplazar por el nombre de la tabla ej PedidoVenta
pc_id                     reemplazar por el campo ID ej. pv_id
del pedido de compras                  reemplazar por el texto de error ej. del pedido de venta
pc_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocPedidoCompraMover 2,1,7 -- FIRST
sp_DocPedidoCompraMover 3,2,7 -- PREVIOUS
sp_DocPedidoCompraMover 4,1,7 -- NEXT
sp_DocPedidoCompraMover 5,1,7 -- LAST

*/

go
create procedure sp_DocPedidoCompraMover (
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
                                                        select pc_id from PedidoCompra 
                                                        where pc_numero = (
                                                                  select min(pc_numero) from PedidoCompra 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select pc_id from PedidoCompra 
                                                        where pc_numero = (
                                                                  select max(pc_numero) from PedidoCompra 
                                                                  where doc_id = @@DocId 
                                                                      and pc_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select pc_id from PedidoCompra 
                                                        where pc_numero = (
                                                                  select min(pc_numero) from PedidoCompra 
                                                                  where doc_id = @@DocId 
                                                                      and pc_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select pc_id from PedidoCompra 
                                                        where pc_numero = (
                                                                  select max(pc_numero) from PedidoCompra 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end