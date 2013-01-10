if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockMover]

/*
 select * from Stock
 select * from Stockitem
 select * from documento where doct_id = 5
sp_DocStockMover 2,1,7 -- FIRST
sp_DocStockMover 3,2,7 -- PREVIOUS
sp_DocStockMover 4,1,7 -- NEXT
sp_DocStockMover 5,1,7 -- LAST

*/

go
create procedure sp_DocStockMover (
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
                                                        select st_id from Stock 
                                                        where st_numero = (
                                                                  select min(st_numero) from Stock 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select st_id from Stock 
                                                        where st_numero = (
                                                                  select max(st_numero) from Stock 
                                                                  where doc_id = @@DocId 
                                                                      and st_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select st_id from Stock 
                                                        where st_numero = (
                                                                  select min(st_numero) from Stock 
                                                                  where doc_id = @@DocId 
                                                                      and st_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select st_id from Stock 
                                                        where st_numero = (
                                                                  select max(st_numero) from Stock 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end