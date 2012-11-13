if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioMover]

/*

PresupuestoEnvio                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pree_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
PresupuestoEnvio                 reemplazar por el nombre de la tabla ej PedidoVenta
pree_id                     reemplazar por el campo ID ej. pv_id
del presupuesto                  reemplazar por el texto de error ej. del pedido de venta
pree_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocPresupuestoEnvioMover 2,1,7 -- FIRST
sp_DocPresupuestoEnvioMover 3,2,7 -- PREVIOUS
sp_DocPresupuestoEnvioMover 4,1,7 -- NEXT
sp_DocPresupuestoEnvioMover 5,1,7 -- LAST

*/

go
create procedure sp_DocPresupuestoEnvioMover (
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
																										    select pree_id from PresupuestoEnvio 
                                                        where pree_numero = (
																																	select min(pree_numero) from PresupuestoEnvio 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select pree_id from PresupuestoEnvio 
                                                        where pree_numero = (
																																	select max(pree_numero) from PresupuestoEnvio 
                                                                  where doc_id = @@DocId 
																																			and pree_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select pree_id from PresupuestoEnvio 
                                                        where pree_numero = (
																																	select min(pree_numero) from PresupuestoEnvio 
                                                                  where doc_id = @@DocId 
                                                                      and pree_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select pree_id from PresupuestoEnvio 
                                                        where pree_numero = (
																																	select max(pree_numero) from PresupuestoEnvio 
                                                                  where doc_id = @@DocId
																																)

																								end
end