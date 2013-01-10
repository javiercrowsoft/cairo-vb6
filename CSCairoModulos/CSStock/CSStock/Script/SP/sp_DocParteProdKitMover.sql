if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitMover]

/*

ParteProdKit                   reemplazar por el nombre del documento Ej. PedidoVenta
@@ppk_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
ParteProdKit                 reemplazar por el nombre de la tabla ej PedidoVenta
ppk_id                     reemplazar por el campo ID ej. pv_id
del recuento de stock                  reemplazar por el texto de error ej. del pedido de venta
ppk_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocParteProdKitMover 2,1,7 -- FIRST
sp_DocParteProdKitMover 3,2,7 -- PREVIOUS
sp_DocParteProdKitMover 4,1,7 -- NEXT
sp_DocParteProdKitMover 5,1,7 -- LAST

*/

go
create procedure sp_DocParteProdKitMover (
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
                                                        select ppk_id from ParteProdKit 
                                                        where ppk_numero = (
                                                                  select min(ppk_numero) from ParteProdKit 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select ppk_id from ParteProdKit 
                                                        where ppk_numero = (
                                                                  select max(ppk_numero) from ParteProdKit 
                                                                  where doc_id = @@DocId 
                                                                      and ppk_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select ppk_id from ParteProdKit 
                                                        where ppk_numero = (
                                                                  select min(ppk_numero) from ParteProdKit 
                                                                  where doc_id = @@DocId 
                                                                      and ppk_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select ppk_id from ParteProdKit 
                                                        where ppk_numero = (
                                                                  select max(ppk_numero) from ParteProdKit 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end