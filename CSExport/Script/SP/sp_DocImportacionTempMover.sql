if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempMover]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempMover]

/*

ImportacionTemp                   reemplazar por el nombre del documento Ej. PedidoVenta
@@impt_id                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
ImportacionTemp                 reemplazar por el nombre de la tabla ej PedidoVenta
impt_id                     reemplazar por el campo ID ej. pv_id
impt_numero          reemplazar por el nombre del campo numero pv_numero

 select * from pedidoventa
 select * from pedidoventaitem
 select * from documento where doct_id = 5
sp_DocImportacionTempMover 2,1,7 -- FIRST
sp_DocImportacionTempMover 3,2,7 -- PREVIOUS
sp_DocImportacionTempMover 4,1,7 -- NEXT
sp_DocImportacionTempMover 5,1,7 -- LAST

*/

go
create procedure sp_DocImportacionTempMover (
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
																										    select impt_id from ImportacionTemp 
                                                        where impt_numero = (
																																	select min(impt_numero) from ImportacionTemp 
                                                                  where doc_id = @@DocId
																																)
																								end
  else if      @@MoveTo = @MSG_DOC_PREVIOUS     begin
																										    select impt_id from ImportacionTemp 
                                                        where impt_numero = (
																																	select max(impt_numero) from ImportacionTemp 
                                                                  where doc_id = @@DocId 
																																			and impt_numero < @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_NEXT         begin
																										    select impt_id from ImportacionTemp 
                                                        where impt_numero = (
																																	select min(impt_numero) from ImportacionTemp 
                                                                  where doc_id = @@DocId 
                                                                      and impt_numero > @@currNro 
																																)

																								end
  else if      @@MoveTo = @MSG_DOC_LAST         begin
																										    select impt_id from ImportacionTemp 
                                                        where impt_numero = (
																																	select max(impt_numero) from ImportacionTemp 
                                                                  where doc_id = @@DocId
																																)

																								end
end