if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoMover]

/*

sp_DocDepositoBancoMover 2,1,7 -- FIRST
sp_DocDepositoBancoMover 3,2,7 -- PREVIOUS
sp_DocDepositoBancoMover 4,1,7 -- NEXT
sp_DocDepositoBancoMover 5,1,7 -- LAST

*/

go
create procedure sp_DocDepositoBancoMover (
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
																										    select dbco_id from DepositoBanco 
                                                        where dbco_numero = (
																																	select min(dbco_numero) from DepositoBanco 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select dbco_id from DepositoBanco 
                                                        where dbco_numero = (
																																	select max(dbco_numero) from DepositoBanco 
                                                                  where doc_id = @@DocId 
																																			and dbco_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select dbco_id from DepositoBanco 
                                                        where dbco_numero = (
																																	select min(dbco_numero) from DepositoBanco 
                                                                  where doc_id = @@DocId 
                                                                      and dbco_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select dbco_id from DepositoBanco 
                                                        where dbco_numero = (
																																	select max(dbco_numero) from DepositoBanco 
                                                                  where doc_id = @@DocId
																																)

																								end
end