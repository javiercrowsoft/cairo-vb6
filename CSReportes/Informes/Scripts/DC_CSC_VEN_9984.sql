/*---------------------------------------------------------------------
Nombre: Colocar el Estado en Pendiente de una Factura de Venta
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_VEN_9984 1, 09009

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9984]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9984]

go
create procedure DC_CSC_VEN_9984 (
	@@us_id 		int,

	@@fv_numero   int

)as 

begin

  set nocount on

	declare @fv_id int

	select @fv_id = fv_id from FacturaVenta where fv_numero = @@fv_numero

	if isnull(@fv_id,0) <> 0 begin

		Update facturaventa set est_id = 1 where fv_id = @fv_id

		select 1, 'El proceso termino con exito'as Info, 
							'Se modifico la siguiente factura' as Observaciones
		union
		select 1, 'Factura: ' + fv_nrodoc + ' del ' + convert(varchar(12),fv_fecha,102) as Info,
							fv_descrip as Observaciones
		from FacturaVenta 
		where fv_id = @fv_id

	end else begin

		select 1, 'No se encontro una factura con numero: ' + convert(varchar(50),@@fv_numero) as Info, 
							'El proceso no modifico datos' as Observaciones

	end

end
go
