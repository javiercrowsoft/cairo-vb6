if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponMover]

/*

sp_DocDepositoCuponMover 2,1,7 -- FIRST
sp_DocDepositoCuponMover 3,2,7 -- PREVIOUS
sp_DocDepositoCuponMover 4,1,7 -- NEXT
sp_DocDepositoCuponMover 5,1,7 -- LAST

*/

go
create procedure sp_DocDepositoCuponMover (
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
																										    select dcup_id from DepositoCupon 
                                                        where dcup_numero = (
																																	select min(dcup_numero) from DepositoCupon 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select dcup_id from DepositoCupon 
                                                        where dcup_numero = (
																																	select max(dcup_numero) from DepositoCupon 
                                                                  where doc_id = @@DocId 
																																			and dcup_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select dcup_id from DepositoCupon 
                                                        where dcup_numero = (
																																	select min(dcup_numero) from DepositoCupon 
                                                                  where doc_id = @@DocId 
                                                                      and dcup_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select dcup_id from DepositoCupon 
                                                        where dcup_numero = (
																																	select max(dcup_numero) from DepositoCupon 
                                                                  where doc_id = @@DocId
																																)

																								end
end