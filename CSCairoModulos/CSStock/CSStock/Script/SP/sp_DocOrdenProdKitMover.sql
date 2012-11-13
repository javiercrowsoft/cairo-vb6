if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenProdKitMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenProdKitMover]

/*

*/

go
create procedure sp_DocOrdenProdKitMover (
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
																										    select opk_id from OrdenProdKit 
                                                        where opk_numero = (
																																	select min(opk_numero) from OrdenProdKit 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select opk_id from OrdenProdKit 
                                                        where opk_numero = (
																																	select max(opk_numero) from OrdenProdKit 
                                                                  where doc_id = @@DocId 
																																			and opk_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select opk_id from OrdenProdKit 
                                                        where opk_numero = (
																																	select min(opk_numero) from OrdenProdKit 
                                                                  where doc_id = @@DocId 
                                                                      and opk_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select opk_id from OrdenProdKit 
                                                        where opk_numero = (
																																	select max(opk_numero) from OrdenProdKit 
                                                                  where doc_id = @@DocId
																																)

																								end
end