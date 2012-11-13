if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaMover]

/*

sp_DocManifiestoCargaMover 2,1,7 -- FIRST
sp_DocManifiestoCargaMover 3,2,7 -- PREVIOUS
sp_DocManifiestoCargaMover 4,1,7 -- NEXT
sp_DocManifiestoCargaMover 5,1,7 -- LAST

*/

go
create procedure sp_DocManifiestoCargaMover (
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
																										    select mfc_id from ManifiestoCarga 
                                                        where mfc_numero = (
																																	select min(mfc_numero) from ManifiestoCarga 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select mfc_id from ManifiestoCarga 
                                                        where mfc_numero = (
																																	select max(mfc_numero) from ManifiestoCarga 
                                                                  where doc_id = @@DocId 
																																			and mfc_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select mfc_id from ManifiestoCarga 
                                                        where mfc_numero = (
																																	select min(mfc_numero) from ManifiestoCarga 
                                                                  where doc_id = @@DocId 
                                                                      and mfc_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select mfc_id from ManifiestoCarga 
                                                        where mfc_numero = (
																																	select max(mfc_numero) from ManifiestoCarga 
                                                                  where doc_id = @@DocId
																																)

																								end
end