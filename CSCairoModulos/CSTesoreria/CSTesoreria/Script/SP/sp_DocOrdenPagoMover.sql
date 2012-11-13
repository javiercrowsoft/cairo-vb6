if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoMover]

/*

*/

go
create procedure sp_DocOrdenPagoMover (
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
																										    select opg_id from OrdenPago 
                                                        where opg_numero = (
																																	select min(opg_numero) from OrdenPago 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select opg_id from OrdenPago 
                                                        where opg_numero = (
																																	select max(opg_numero) from OrdenPago 
                                                                  where doc_id = @@DocId 
																																			and opg_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select opg_id from OrdenPago 
                                                        where opg_numero = (
																																	select min(opg_numero) from OrdenPago 
                                                                  where doc_id = @@DocId 
                                                                      and opg_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select opg_id from OrdenPago 
                                                        where opg_numero = (
																																	select max(opg_numero) from OrdenPago 
                                                                  where doc_id = @@DocId
																																)

																								end
end