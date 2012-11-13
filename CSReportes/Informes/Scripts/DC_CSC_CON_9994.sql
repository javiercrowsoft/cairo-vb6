/*---------------------------------------------------------------------
Nombre: Modifica el documento de una Cobranza
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9994]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9994]

/*

select * from documento where doct_id = 13

select * from cobranza where doct_id = 13

[DC_CSC_CON_9994] 1,10,172

*/

go
create procedure DC_CSC_CON_9994 (

  @@us_id    		int,

	@@numero      int,
	@@doc_id      int

)as 
begin

  set nocount on

	declare @as_id int

	if not exists(select * from Documento where doc_id = @@doc_id and doct_id = 15) begin

		select 1 as aux_id, 'El documento no es valido' as Infor, '' as dummy_col
		return

	end

	select @as_id = as_id from Asiento where as_numero = @@numero

	if @as_id is not null begin

		update Asiento set doc_id = @@doc_id where as_id = @as_id
		select 1 as aux_id, 'El asiento fue modificado' as Infor, '' as dummy_col

	end else begin

		select 1 as aux_id, 'No existe un asiento con el numero ' + convert(varchar, @@numero) as Infor, '' as dummy_col

	end
end
go
 