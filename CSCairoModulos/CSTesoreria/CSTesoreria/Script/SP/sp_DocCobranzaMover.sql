if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaMover]

/*

Cobranza                   reemplazar por el nombre del documento Ej. PedidoVenta
@@cobz_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
Cobranza                 reemplazar por el nombre de la tabla ej PedidoVenta
cobz_id                     reemplazar por el campo ID ej. pv_id
de la cobranza                  reemplazar por el texto de error ej. del pedido de venta
cobz_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documentotipo
 select * from documento where doct_id = 13

sp_DocCobranzaMover 101,1,17 -- FIRST
sp_DocCobranzaMover 102,2,17 -- PREVIOUS
sp_DocCobranzaMover 103,1,17 -- NEXT
sp_DocCobranzaMover 104,1,17 -- LAST

*/

go
create procedure sp_DocCobranzaMover (
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
                                                        select cobz_id from Cobranza 
                                                        where cobz_numero = (
                                                                  select min(cobz_numero) from Cobranza 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select cobz_id from Cobranza 
                                                        where cobz_numero = (
                                                                  select max(cobz_numero) from Cobranza 
                                                                  where doc_id = @@DocId 
                                                                      and cobz_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select cobz_id from Cobranza 
                                                        where cobz_numero = (
                                                                  select min(cobz_numero) from Cobranza 
                                                                  where doc_id = @@DocId 
                                                                      and cobz_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select cobz_id from Cobranza 
                                                        where cobz_numero = (
                                                                  select max(cobz_numero) from Cobranza 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end