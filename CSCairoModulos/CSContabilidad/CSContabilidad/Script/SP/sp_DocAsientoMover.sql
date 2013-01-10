if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoMover]

/*
 select * from Asiento
 select * from Asientoitem
 select * from documento where doct_id = 5
sp_DocAsientoMover 2,1,7 -- FIRST
sp_DocAsientoMover 3,2,7 -- PREVIOUS
sp_DocAsientoMover 4,1,7 -- NEXT
sp_DocAsientoMover 5,1,7 -- LAST

*/

go
create procedure sp_DocAsientoMover (
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
                                                        select as_id from Asiento 
                                                        where as_numero = (
                                                                  select min(as_numero) from Asiento 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select as_id from Asiento 
                                                        where as_numero = (
                                                                  select max(as_numero) from Asiento 
                                                                  where doc_id = @@DocId 
                                                                      and as_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select as_id from Asiento 
                                                        where as_numero = (
                                                                  select min(as_numero) from Asiento 
                                                                  where doc_id = @@DocId 
                                                                      and as_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select as_id from Asiento 
                                                        where as_numero = (
                                                                  select max(as_numero) from Asiento 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end