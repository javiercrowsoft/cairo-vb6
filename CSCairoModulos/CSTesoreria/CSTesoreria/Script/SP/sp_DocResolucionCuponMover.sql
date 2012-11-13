if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponMover]

/*

sp_DocResolucionCuponMover 2,1,7 -- FIRST
sp_DocResolucionCuponMover 3,2,7 -- PREVIOUS
sp_DocResolucionCuponMover 4,1,7 -- NEXT
sp_DocResolucionCuponMover 5,1,7 -- LAST

*/

go
create procedure sp_DocResolucionCuponMover (
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
																										    select rcup_id from ResolucionCupon 
                                                        where rcup_numero = (
																																	select min(rcup_numero) from ResolucionCupon 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select rcup_id from ResolucionCupon 
                                                        where rcup_numero = (
																																	select max(rcup_numero) from ResolucionCupon 
                                                                  where doc_id = @@DocId 
																																			and rcup_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select rcup_id from ResolucionCupon 
                                                        where rcup_numero = (
																																	select min(rcup_numero) from ResolucionCupon 
                                                                  where doc_id = @@DocId 
                                                                      and rcup_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select rcup_id from ResolucionCupon 
                                                        where rcup_numero = (
																																	select max(rcup_numero) from ResolucionCupon 
                                                                  where doc_id = @@DocId
																																)

																								end
end