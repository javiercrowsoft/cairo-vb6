if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaMover]

/*
 select * from Presupuestoventa
 select * from Presupuestoventaitem
 select * from documento where doct_id = 5
sp_DocPresupuestoVentaMover 2,1,7 -- FIRST
sp_DocPresupuestoVentaMover 3,2,7 -- PREVIOUS
sp_DocPresupuestoVentaMover 4,1,7 -- NEXT
sp_DocPresupuestoVentaMover 5,1,7 -- LAST

*/

go
create procedure sp_DocPresupuestoVentaMover (
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
                                                        select prv_id from PresupuestoVenta 
                                                        where prv_numero = (
                                                                  select min(prv_numero) from PresupuestoVenta 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select prv_id from PresupuestoVenta 
                                                        where prv_numero = (
                                                                  select max(prv_numero) from PresupuestoVenta 
                                                                  where doc_id = @@DocId 
                                                                      and prv_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select prv_id from PresupuestoVenta 
                                                        where prv_numero = (
                                                                  select min(prv_numero) from PresupuestoVenta 
                                                                  where doc_id = @@DocId 
                                                                      and prv_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select prv_id from PresupuestoVenta 
                                                        where prv_numero = (
                                                                  select max(prv_numero) from PresupuestoVenta 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end