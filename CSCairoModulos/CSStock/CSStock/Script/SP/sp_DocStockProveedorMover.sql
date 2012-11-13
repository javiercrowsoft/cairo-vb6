if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockProveedorMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockProveedorMover]

/*
 select * from StockProveedor
 select * from StockProveedoritem
 select * from documento where doct_id = 5
sp_DocStockProveedorMover 2,1,7 -- FIRST
sp_DocStockProveedorMover 3,2,7 -- PREVIOUS
sp_DocStockProveedorMover 4,1,7 -- NEXT
sp_DocStockProveedorMover 5,1,7 -- LAST

*/

go
create procedure sp_DocStockProveedorMover (
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
																										    select stprov_id from StockProveedor 
                                                        where stprov_numero = (
																																	select min(stprov_numero) from StockProveedor 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select stprov_id from StockProveedor 
                                                        where stprov_numero = (
																																	select max(stprov_numero) from StockProveedor 
                                                                  where doc_id = @@DocId 
																																			and stprov_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select stprov_id from StockProveedor 
                                                        where stprov_numero = (
																																	select min(stprov_numero) from StockProveedor 
                                                                  where doc_id = @@DocId 
                                                                      and stprov_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select stprov_id from StockProveedor 
                                                        where stprov_numero = (
																																	select max(stprov_numero) from StockProveedor 
                                                                  where doc_id = @@DocId
																																)

																								end
end