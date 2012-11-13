/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de ordenes de pago
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9982]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9982]

/*

select * from documento where doct_id = 1

select * from facturaventa

[DC_CSC_VEN_9982] 1,2,12

*/

go
create procedure DC_CSC_VEN_9982 (

  @@us_id    		int,

	@@numero      int,
	@@doc_id      int

)as 
begin

  set nocount on

	declare @as_id int
	declare @fv_id int

	if not exists(select * from Documento where doc_id = @@doc_id and doct_id in(1,7,9)) begin

		select 1 as aux_id, 'El documento no es valido' as Infor, '' as dummy_col
		return

	end

	select @fv_id = fv_id, @as_id = as_id from FacturaVenta where fv_numero = @@numero

	if @fv_id is not null begin

		if @as_id is not null
			update Asiento set doc_id_cliente = @@doc_id where as_id = @as_id

		update FacturaVenta set doc_id = @@doc_id where fv_id = @fv_id
		select 1 as aux_id, 'La factura fue modificada' as Infor, '' as dummy_col

	end else begin

		select 1 as aux_id, 'No existe una factura con el numero ' + convert(varchar, @@numero) as Infor, '' as dummy_col

	end
end
go
 