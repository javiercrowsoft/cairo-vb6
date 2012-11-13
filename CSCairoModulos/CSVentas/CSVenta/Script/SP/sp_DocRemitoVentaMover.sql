if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaMover]

/*

RemitoVenta                   reemplazar por el nombre del documento Ej. PedidoVenta
@@rv_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
RemitoVenta                 reemplazar por el nombre de la tabla ej PedidoVenta
rv_id                     reemplazar por el campo ID ej. pv_id
del remito de venta                  reemplazar por el texto de error ej. del pedido de venta
rv_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocRemitoVentaMover 2,1,7 -- FIRST
sp_DocRemitoVentaMover 3,2,7 -- PREVIOUS
sp_DocRemitoVentaMover 4,1,7 -- NEXT
sp_DocRemitoVentaMover 5,1,7 -- LAST

*/

go
create procedure sp_DocRemitoVentaMover (
	@@MoveTo 			 smallint,
  @@currNro      int,
  @@DocId        int
)
as

begin

  declare @MSG_DOC_FIRST 		  smallint 
  declare @MSG_DOC_PREVIOUS 	smallint
  declare @MSG_DOC_NEXT 			smallint
  declare @MSG_DOC_LAST 			smallint

  set @MSG_DOC_FIRST = 101
  set @MSG_DOC_PREVIOUS = 102
  set @MSG_DOC_NEXT = 103
  set @MSG_DOC_LAST = 104

	if 					 @@MoveTo = @MSG_DOC_FIRST        begin
																										    select rv_id from RemitoVenta 
                                                        where rv_numero = (
																																	select min(rv_numero) from RemitoVenta 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select rv_id from RemitoVenta 
                                                        where rv_numero = (
																																	select max(rv_numero) from RemitoVenta 
                                                                  where doc_id = @@DocId 
																																			and rv_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select rv_id from RemitoVenta 
                                                        where rv_numero = (
																																	select min(rv_numero) from RemitoVenta 
                                                                  where doc_id = @@DocId 
                                                                      and rv_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select rv_id from RemitoVenta 
                                                        where rv_numero = (
																																	select max(rv_numero) from RemitoVenta 
                                                                  where doc_id = @@DocId
																																)

																								end
end