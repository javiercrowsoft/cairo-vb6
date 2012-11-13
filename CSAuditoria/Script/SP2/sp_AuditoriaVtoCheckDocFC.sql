-- Script de Chequeo de Integridad de:

-- 2 - Control de vencimientos FC y FV

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaVtoCheckDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaVtoCheckDocFC]

go

create procedure sp_AuditoriaVtoCheckDocFC (

	@@fc_id       int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @bError tinyint

	set @bError     = 0
	set @@bSuccess 	= 0
	set @@bErrorMsg = '@@ERROR_SP:'

	declare @doct_id      int
	declare @fc_nrodoc 		varchar(50) 
	declare @fc_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@fc_nrodoc  = fc_nrodoc,
						@fc_numero  = convert(varchar,fc_numero),
						@est_id     = est_id

	from FacturaCompra where fc_id = @@fc_id

	-- 1 Si esta anulado no tiene que tener deuda ni pendiente en items
	--
	if @est_id = 7 begin

		if exists(select * from FacturaCompraDeuda where fc_id = @@fc_id) begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'La factura esta anulada y posee deuda' + char(10)

		end

		if exists(select * from FacturaCompraPago where fc_id = @@fc_id) begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'La factura esta anulada y posee pagos' + char(10)

		end

		if exists(select * from FacturaCompraItem where fc_id = @@fc_id and fci_pendiente <> 0) begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'La factura esta anulada y posee pendiente en sus items' + char(10)

		end

	end else begin

		declare @fc_pendiente	decimal(18,6)
		declare @vto 					decimal(18,6)
		declare @deuda				decimal(18,6)
		declare @pagos      	decimal(18,6)
		declare @total      	decimal(18,6)

		select @deuda = sum (fcd_importe) from FacturaCompraDeuda where fc_id = @@fc_id
		select @pagos = sum (fcp_importe) from FacturaCompraPago  where fc_id = @@fc_id

		declare	@fc_descuento1    decimal(18, 6)
		declare	@fc_descuento2    decimal(18, 6)
	
		declare	@fc_totalotros    				decimal(18, 6)
		declare	@fc_totalpercepciones     decimal(18, 6)

	  select 
					  @fc_descuento1  				= fc_descuento1,
					  @fc_descuento2  				= fc_descuento2,
					  @fc_totalotros          = fc_totalotros,
					  @fc_totalpercepciones   = fc_totalpercepciones,
						@fc_pendiente						= fc_pendiente

		from FacturaCompra where fc_id = @@fc_id

		declare @fc_totaldeuda decimal(18,6)
	
		select @fc_totaldeuda = sum(fci_importe) 
		from FacturaCompraItem fci inner join TipoOperacion t on fci.to_id = t.to_id
		where fc_id = @@fc_id 
			and to_generadeuda <> 0
	
		set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento1) / 100)
		set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento2) / 100)
		set @fc_totaldeuda = @fc_totaldeuda + @fc_totalotros + @fc_totalpercepciones

		select @total = IsNull(@fc_totaldeuda,0)

		set @vto = IsNull(@deuda,0) + IsNull(@pagos,0)

		if abs(round(@vto - @total,2)) > 0.10 begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El total de la factura no coincide con el total de su deuda' + char(10)
																	  + 'Dif: ' + convert(varchar(50),round(@vto - @total,2),1) + char(10)
																		+ 'Total: ' +  convert(varchar(50),round(@total,2),1) + char(10)
																		+ 'Deuda: ' +  convert(varchar(50),round(@vto,2),1) + char(10)

		end

		select @deuda = sum (fcd_pendiente) from FacturaCompraDeuda where fc_id = @@fc_id

		if abs(round(@fc_pendiente - IsNull(@deuda,0),2)) > 0.10 begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El pendiente de la factura no coincide con el total de su deuda' + char(10)

		end

		if exists(select * from FacturaCompraDeuda fcd
							where abs(round(
												(fcd_pendiente + (		IsNull(
																								(select sum(fcopg_importe) from FacturaCompraOrdenPago 
																								 where fcd_id = fcd.fcd_id),0)
																						+	IsNull(
																							  (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
			                                           where 
			                                                 (fcd_id_factura     = fcd.fcd_id and @doct_id in (2,10))
			                                              or (fcd_id_notacredito = fcd.fcd_id and @doct_id = 8)
			                                          ),0)
																					) 
												)
												 - fcd_importe
												,2)) > 0.10

								and fc_id = @@fc_id
							)
		begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El importe de la deuda de esta factura no coincide con la suma de sus aplicaciones' + char(10)

		end

		if exists(select * from FacturaCompraPago fcp
							where abs(round(	fcp_importe   
															- (		IsNull(
																			(select sum(fcopg_importe) from FacturaCompraOrdenPago 
																			 where fcp_id = fcp.fcp_id),0)
																	+	IsNull(
																		  (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
                                       where 
                                             (fcp_id_factura     = fcp.fcp_id and @doct_id in (2,10))
                                          or (fcp_id_notacredito = fcp.fcp_id and @doct_id = 8)
                                      ),0)
																),2)) > 0.10 
								and fc_id = @@fc_id
							)
		begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El importe del pago de esta factura no coincide con la suma de sus aplicaciones' + char(10)

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO