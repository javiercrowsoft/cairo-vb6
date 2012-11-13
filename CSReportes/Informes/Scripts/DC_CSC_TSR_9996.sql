/*---------------------------------------------------------------------
Nombre: Modifica el documento de una Orden de Pago
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9996]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9996]

/*

select * from documento where doct_id = 16

select * from ordenpago where doct_id = 16

[DC_CSC_TSR_9996] 1,4,22

*/

go
create procedure DC_CSC_TSR_9996 (

  @@us_id    		int,

	@@numero      int,
	@@doc_id      int

)as 
begin

  set nocount on

	declare @as_id int
	declare @opg_id int

	if not exists(select * from Documento where doc_id = @@doc_id and doct_id = 16) begin

		select 1 as aux_id, 'El documento no es valido' as Infor, '' as dummy_col
		return

	end

	select @opg_id = opg_id, @as_id = as_id from OrdenPago where opg_numero = @@numero

	if @opg_id is not null begin

		if @as_id is not null
			update Asiento set doc_id_cliente = @@doc_id where as_id = @as_id

		update OrdenPago set doc_id = @@doc_id where opg_id = @opg_id
		select 1 as aux_id, 'La orden de pago fue modificada' as Infor, '' as dummy_col

	end else begin

		select 1 as aux_id, 'No existe una orden de pago con el numero ' + convert(varchar, @@numero) as Infor, '' as dummy_col

	end
end
go
 