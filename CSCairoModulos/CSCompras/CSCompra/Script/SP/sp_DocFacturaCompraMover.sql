if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraMover]

/*

sp_DocFacturaCompraMover 2,1,7 -- FIRST
sp_DocFacturaCompraMover 3,2,7 -- PREVIOUS
sp_DocFacturaCompraMover 4,1,7 -- NEXT
sp_DocFacturaCompraMover 5,1,7 -- LAST

*/

go
create procedure sp_DocFacturaCompraMover (
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
                                                        select fc_id from FacturaCompra 
                                                        where fc_numero = (
                                                                  select min(fc_numero) from FacturaCompra 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select fc_id from FacturaCompra 
                                                        where fc_numero = (
                                                                  select max(fc_numero) from FacturaCompra 
                                                                  where doc_id = @@DocId 
                                                                      and fc_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select fc_id from FacturaCompra 
                                                        where fc_numero = (
                                                                  select min(fc_numero) from FacturaCompra 
                                                                  where doc_id = @@DocId 
                                                                      and fc_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select fc_id from FacturaCompra 
                                                        where fc_numero = (
                                                                  select max(fc_numero) from FacturaCompra 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end