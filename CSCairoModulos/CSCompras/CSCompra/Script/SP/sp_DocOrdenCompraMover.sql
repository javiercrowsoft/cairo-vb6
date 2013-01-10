if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraMover]

/*

OrdenCompra                   reemplazar por el nombre del documento Ej. OrdenVenta
@@oc_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
OrdenCompra                 reemplazar por el nombre de la tabla ej OrdenVenta
oc_id                     reemplazar por el campo ID ej. pv_id
de la orden de compras                  reemplazar por el texto de error ej. de la orden de venta
oc_numero          reemplazar por el nombre del campo numero pv_numero

 select * from Ordenventa
 select * from Ordenventaitem
 select * from documento where doct_id = 5
sp_DocOrdenCompraMover 2,1,7 -- FIRST
sp_DocOrdenCompraMover 3,2,7 -- PREVIOUS
sp_DocOrdenCompraMover 4,1,7 -- NEXT
sp_DocOrdenCompraMover 5,1,7 -- LAST

*/

go
create procedure sp_DocOrdenCompraMover (
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
                                                        select oc_id from OrdenCompra 
                                                        where oc_numero = (
                                                                  select min(oc_numero) from OrdenCompra 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select oc_id from OrdenCompra 
                                                        where oc_numero = (
                                                                  select max(oc_numero) from OrdenCompra 
                                                                  where doc_id = @@DocId 
                                                                      and oc_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select oc_id from OrdenCompra 
                                                        where oc_numero = (
                                                                  select min(oc_numero) from OrdenCompra 
                                                                  where doc_id = @@DocId 
                                                                      and oc_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select oc_id from OrdenCompra 
                                                        where oc_numero = (
                                                                  select max(oc_numero) from OrdenCompra 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end