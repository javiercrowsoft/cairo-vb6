if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueMover]

/*

sp_DocPermisoEmbarqueMover 2,1,7 -- FIRST
sp_DocPermisoEmbarqueMover 3,2,7 -- PREVIOUS
sp_DocPermisoEmbarqueMover 4,1,7 -- NEXT
sp_DocPermisoEmbarqueMover 5,1,7 -- LAST

*/

go
create procedure sp_DocPermisoEmbarqueMover (
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
                                                        select pemb_id from PermisoEmbarque 
                                                        where pemb_numero = (
                                                                  select min(pemb_numero) from PermisoEmbarque 
                                                                  where doc_id = @@DocId
                                                                )
                                                end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
                                                        select pemb_id from PermisoEmbarque 
                                                        where pemb_numero = (
                                                                  select max(pemb_numero) from PermisoEmbarque 
                                                                  where doc_id = @@DocId 
                                                                      and pemb_numero < @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
                                                        select pemb_id from PermisoEmbarque 
                                                        where pemb_numero = (
                                                                  select min(pemb_numero) from PermisoEmbarque 
                                                                  where doc_id = @@DocId 
                                                                      and pemb_numero > @@currNro 
                                                                )

                                                end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
                                                        select pemb_id from PermisoEmbarque 
                                                        where pemb_numero = (
                                                                  select max(pemb_numero) from PermisoEmbarque 
                                                                  where doc_id = @@DocId
                                                                )

                                                end
end