if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListMover]

/*

sp_DocPackingListMover 2,1,7 -- FIRST
sp_DocPackingListMover 3,2,7 -- PREVIOUS
sp_DocPackingListMover 4,1,7 -- NEXT
sp_DocPackingListMover 5,1,7 -- LAST

*/

go
create procedure sp_DocPackingListMover (
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
																										    select pklst_id from PackingList 
                                                        where pklst_numero = (
																																	select min(pklst_numero) from PackingList 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select pklst_id from PackingList 
                                                        where pklst_numero = (
																																	select max(pklst_numero) from PackingList 
                                                                  where doc_id = @@DocId 
																																			and pklst_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select pklst_id from PackingList 
                                                        where pklst_numero = (
																																	select min(pklst_numero) from PackingList 
                                                                  where doc_id = @@DocId 
                                                                      and pklst_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select pklst_id from PackingList 
                                                        where pklst_numero = (
																																	select max(pklst_numero) from PackingList 
                                                                  where doc_id = @@DocId
																																)

																								end
end