if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaMover]

/*

FacturaVenta                   reemplazar por el nombre del documento Ej. PedidoVenta
@@fv_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
FacturaVenta                 reemplazar por el nombre de la tabla ej PedidoVenta
fv_id                     reemplazar por el campo ID ej. pv_id
de la factura de venta                  reemplazar por el texto de error ej. del pedido de venta
fv_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocFacturaVentaMover 2,1,7 -- FIRST
sp_DocFacturaVentaMover 3,2,7 -- PREVIOUS
sp_DocFacturaVentaMover 4,1,7 -- NEXT
sp_DocFacturaVentaMover 5,1,7 -- LAST

sp_DocFacturaVentaMover 104,1,64

*/

go
create procedure sp_DocFacturaVentaMover (
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
                                                        select fv_id from FacturaVenta 
                                                        where fv_numero = (
                                                                  select min(fv_numero) from FacturaVenta 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select fv_id from FacturaVenta 
                                                        where fv_numero = (
                                                                  select max(fv_numero) from FacturaVenta 
                                                                  where doc_id = @@DocId 
                                                                      and fv_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select fv_id from FacturaVenta 
                                                        where fv_numero = (
                                                                  select min(fv_numero) from FacturaVenta 
                                                                  where doc_id = @@DocId 
                                                                      and fv_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select fv_id from FacturaVenta 
                                                        where fv_numero = (
                                                                  select max(fv_numero) from FacturaVenta 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end