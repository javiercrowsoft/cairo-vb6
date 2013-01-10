if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockClienteMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockClienteMover]

/*
 select * from StockCliente
 select * from StockClienteitem
 select * from documento where doct_id = 5
sp_DocStockClienteMover 2,1,7 -- FIRST
sp_DocStockClienteMover 3,2,7 -- PREVIOUS
sp_DocStockClienteMover 4,1,7 -- NEXT
sp_DocStockClienteMover 5,1,7 -- LAST

*/

go
create procedure sp_DocStockClienteMover (
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
                                                        select stcli_id from StockCliente 
                                                        where stcli_numero = (
                                                                  select min(stcli_numero) from StockCliente 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select stcli_id from StockCliente 
                                                        where stcli_numero = (
                                                                  select max(stcli_numero) from StockCliente 
                                                                  where doc_id = @@DocId 
                                                                      and stcli_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select stcli_id from StockCliente 
                                                        where stcli_numero = (
                                                                  select min(stcli_numero) from StockCliente 
                                                                  where doc_id = @@DocId 
                                                                      and stcli_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select stcli_id from StockCliente 
                                                        where stcli_numero = (
                                                                  select max(stcli_numero) from StockCliente 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end