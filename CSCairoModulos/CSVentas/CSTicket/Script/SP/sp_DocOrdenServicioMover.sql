if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioMover]

/*


*/

go
create procedure sp_DocOrdenServicioMover (
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
                                                        select os_id from OrdenServicio 
                                                        where os_numero = (
                                                                  select min(os_numero) from OrdenServicio 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select os_id from OrdenServicio 
                                                        where os_numero = (
                                                                  select max(os_numero) from OrdenServicio 
                                                                  where doc_id = @@DocId 
                                                                      and os_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select os_id from OrdenServicio 
                                                        where os_numero = (
                                                                  select min(os_numero) from OrdenServicio 
                                                                  where doc_id = @@DocId 
                                                                      and os_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select os_id from OrdenServicio 
                                                        where os_numero = (
                                                                  select max(os_numero) from OrdenServicio 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end