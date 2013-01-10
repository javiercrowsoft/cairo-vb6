if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionMover]

/*

*/

go
create procedure sp_DocParteReparacionMover (
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
                                                        select prp_id from ParteReparacion 
                                                        where prp_numero = (
                                                                  select min(prp_numero) from ParteReparacion 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select prp_id from ParteReparacion 
                                                        where prp_numero = (
                                                                  select max(prp_numero) from ParteReparacion 
                                                                  where doc_id = @@DocId 
                                                                      and prp_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select prp_id from ParteReparacion 
                                                        where prp_numero = (
                                                                  select min(prp_numero) from ParteReparacion 
                                                                  where doc_id = @@DocId 
                                                                      and prp_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select prp_id from ParteReparacion 
                                                        where prp_numero = (
                                                                  select max(prp_numero) from ParteReparacion 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end