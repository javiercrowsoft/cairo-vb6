if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaMover]

/*
 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocPedidoVentaMover 2,1,7 -- FIRST
sp_DocPedidoVentaMover 3,2,7 -- PREVIOUS
sp_DocPedidoVentaMover 4,1,7 -- NEXT
sp_DocPedidoVentaMover 5,1,7 -- LAST

*/

go
create procedure sp_DocPedidoVentaMover (
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
                                                        select pv_id from PedidoVenta 
                                                        where pv_numero = (
                                                                  select min(pv_numero) from PedidoVenta 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select pv_id from PedidoVenta 
                                                        where pv_numero = (
                                                                  select max(pv_numero) from PedidoVenta 
                                                                  where doc_id = @@DocId 
                                                                      and pv_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select pv_id from PedidoVenta 
                                                        where pv_numero = (
                                                                  select min(pv_numero) from PedidoVenta 
                                                                  where doc_id = @@DocId 
                                                                      and pv_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select pv_id from PedidoVenta 
                                                        where pv_numero = (
                                                                  select max(pv_numero) from PedidoVenta 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end