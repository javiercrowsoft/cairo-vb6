/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9998]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9998]

/*
DC_CSC_COM_9998 1,'241','20080828',49.67
*/

go
create procedure DC_CSC_COM_9998 (

  @@us_id     int,
  @@fc_numero varchar(255),
  @@fcd_fecha datetime,
	@@importe   decimal(18,6)

)as 
begin
set nocount on

  set nocount on

	declare @fc_id int
	declare @fcd_id int
	declare @importe decimal(18,6)

	select @fc_id = fc_id from FacturaCompra where fc_numero = @@fc_numero

	if @fc_id is null begin

		select 1 as aux_id, 'No se encontro una factura con numero interno igual a ' + @@fc_numero + '.' as Info, '' as dummy_col

	end else begin

		if exists(select * from FacturaCompraOrdenPago where fcd_id in (select fcd_id from FacturaCompraDeuda where fc_id = @fc_id)) begin

			select 1 as aux_id, 'La factura posee aplicaciones, debe desaplicarla para poder modificar el vto.' as Info, '' as dummy_col

			return

		end

		if exists(select * from FacturaCompraNotaCredito where fc_id_factura = @fc_id or fc_id_notacredito = @fc_id) begin

			select 1 as aux_id, 'La factura posee aplicaciones, debe desaplicarla para poder modificar el vto.' as Info, '' as dummy_col

			return

		end

		select @fcd_id = fcd_id from FacturaCompraDeuda where fc_id = @fc_id and fcd_fecha = @@fcd_fecha

		if @fcd_id is null begin

			select 1 as aux_id, 'No se encontro un vencimiento con fecha igual a ' + convert(varchar,@@fcd_fecha,105) + '.' as Info, '' as dummy_col

		end else begin

			select @importe = fcd_importe from FacturaCompraDeuda where fcd_id = @fcd_id

			if abs(@importe - @@importe) > 20 begin

				select 1 as aux_id, 'La diferencia entre el importe y el vto original no puede ser mayor a 20 pesos.' as Info, '' as dummy_col

			end else begin

				update FacturaCompraDeuda 
					set fcd_importe 	= @@importe,
							fcd_pendiente = @@importe 
				where fcd_id = @fcd_id

				select 1 as aux_id, 'El importe del vencimiento fue modificado.' as Info, '' as dummy_col

			end

		end

	end

end
go