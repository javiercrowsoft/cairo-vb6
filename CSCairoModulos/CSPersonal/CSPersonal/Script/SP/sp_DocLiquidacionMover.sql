if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionMover]

/*

sp_DocLiquidacionMover 2,1,7 -- FIRST
sp_DocLiquidacionMover 3,2,7 -- PREVIOUS
sp_DocLiquidacionMover 4,1,7 -- NEXT
sp_DocLiquidacionMover 5,1,7 -- LAST

*/

go
create procedure sp_DocLiquidacionMover (
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
																										    select liq_id from Liquidacion 
                                                        where liq_numero = (
																																	select min(liq_numero) from Liquidacion 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select liq_id from Liquidacion 
                                                        where liq_numero = (
																																	select max(liq_numero) from Liquidacion 
                                                                  where doc_id = @@DocId 
																																			and liq_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select liq_id from Liquidacion 
                                                        where liq_numero = (
																																	select min(liq_numero) from Liquidacion 
                                                                  where doc_id = @@DocId 
                                                                      and liq_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select liq_id from Liquidacion 
                                                        where liq_numero = (
																																	select max(liq_numero) from Liquidacion 
                                                                  where doc_id = @@DocId
																																)

																								end
end