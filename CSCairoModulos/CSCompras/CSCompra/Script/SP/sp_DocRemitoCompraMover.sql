if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraMover]

/*

RemitoCompra                   reemplazar por el nombre del documento Ej. PedidoVenta
@@rc_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
RemitoCompra                 reemplazar por el nombre de la tabla ej PedidoVenta
rc_id                     reemplazar por el campo ID ej. pv_id
rc_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocRemitoCompraMover 2,1,7 -- FIRST
sp_DocRemitoCompraMover 3,2,7 -- PREVIOUS
sp_DocRemitoCompraMover 4,1,7 -- NEXT
sp_DocRemitoCompraMover 5,1,7 -- LAST

*/

go
create procedure sp_DocRemitoCompraMover (
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
                                                        select rc_id from RemitoCompra 
                                                        where rc_numero = (
                                                                  select min(rc_numero) from RemitoCompra 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select rc_id from RemitoCompra 
                                                        where rc_numero = (
                                                                  select max(rc_numero) from RemitoCompra 
                                                                  where doc_id = @@DocId 
                                                                      and rc_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select rc_id from RemitoCompra 
                                                        where rc_numero = (
                                                                  select min(rc_numero) from RemitoCompra 
                                                                  where doc_id = @@DocId 
                                                                      and rc_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select rc_id from RemitoCompra 
                                                        where rc_numero = (
                                                                  select max(rc_numero) from RemitoCompra 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end