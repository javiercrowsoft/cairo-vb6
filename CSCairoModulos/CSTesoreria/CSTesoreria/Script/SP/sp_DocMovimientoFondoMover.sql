if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoMover]

/*

sp_DocMovimientoFondoMover 2,1,7 -- FIRST
sp_DocMovimientoFondoMover 3,2,7 -- PREVIOUS
sp_DocMovimientoFondoMover 4,1,7 -- NEXT
sp_DocMovimientoFondoMover 5,1,7 -- LAST

*/

go
create procedure sp_DocMovimientoFondoMover (
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
                                                        select mf_id from MovimientoFondo 
                                                        where mf_numero = (
                                                                  select min(mf_numero) from MovimientoFondo 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select mf_id from MovimientoFondo 
                                                        where mf_numero = (
                                                                  select max(mf_numero) from MovimientoFondo 
                                                                  where doc_id = @@DocId 
                                                                      and mf_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select mf_id from MovimientoFondo 
                                                        where mf_numero = (
                                                                  select min(mf_numero) from MovimientoFondo 
                                                                  where doc_id = @@DocId 
                                                                      and mf_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select mf_id from MovimientoFondo 
                                                        where mf_numero = (
                                                                  select max(mf_numero) from MovimientoFondo 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end