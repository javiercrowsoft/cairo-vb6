-- Script de Chequeo de Integridad de:

-- 2 - Control de vencimientos FC y FV

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaVtoValidateDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaVtoValidateDocFV]

go

create procedure sp_AuditoriaVtoValidateDocFV (

	@@fv_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
	declare @doct_id      int
	declare @fv_nrodoc 		varchar(50) 
	declare @fv_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@fv_nrodoc  = fv_nrodoc,
						@fv_numero  = convert(varchar,fv_numero),
						@est_id     = est_id

	from FacturaVenta where fv_id = @@fv_id

	-- 1 Si esta anulado no tiene que tener deuda ni pendiente en items
	--
	if @est_id = 7 begin

		if exists(select * from FacturaVentaDeuda where fv_id = @@fv_id) begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'La factura esta anulada y posee deuda '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

		if exists(select * from FacturaVentaPago where fv_id = @@fv_id) begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'La factura esta anulada y posee pagos '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

		if exists(select * from FacturaVentaItem where fv_id = @@fv_id and fvi_pendiente <> 0) begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'La factura esta anulada y posee pendiente en sus items '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

	end else begin

		declare @fv_pendiente	decimal(18,6)
		declare @vto 					decimal(18,6)
		declare @deuda				decimal(18,6)
		declare @pagos      	decimal(18,6)
		declare @total      	decimal(18,6)

		select @deuda = sum (fvd_importe) from FacturaVentaDeuda where fv_id = @@fv_id
		select @pagos = sum (fvp_importe) from FacturaVentaPago  where fv_id = @@fv_id

		declare	@fv_descuento1    decimal(18, 6)
		declare	@fv_descuento2    decimal(18, 6)

	  select 
					  @fv_descuento1  = fv_descuento1,
					  @fv_descuento2  = fv_descuento2,
						@fv_pendiente		= fv_pendiente

		from FacturaVenta where fv_id = @@fv_id

		declare @fv_totaldeuda decimal(18,6)
	
		select @fv_totaldeuda = sum(fvi_importe) 
		from FacturaVentaItem fvi inner join TipoOperacion t on fvi.to_id = t.to_id
		where fv_id = @@fv_id 
			and to_generadeuda <> 0
	
		set @fv_totaldeuda = @fv_totaldeuda - ((@fv_totaldeuda * @fv_descuento1) / 100)
		set @fv_totaldeuda = @fv_totaldeuda - ((@fv_totaldeuda * @fv_descuento2) / 100)

		select @total = IsNull(@fv_totaldeuda,0)

		set @vto = IsNull(@deuda,0) + IsNull(@pagos,0)

		if abs(round(@vto - @total,2))> 0.01 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El total de la factura no coincide con el total de su deuda '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

		select @deuda = sum (fvd_pendiente) from FacturaVentaDeuda where fv_id = @@fv_id

		if abs(round(@fv_pendiente - IsNull(@deuda,0),2)) > 0.01 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El pendiente de la factura no coincide con el total de su deuda '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

		if exists(select * from FacturaVentaDeuda fvd
							where abs (		round(
														(fvd_pendiente + (		IsNull(
																										(select sum(fvcobz_importe) from FacturaVentaCobranza 
																										 where fvd_id = fvd.fvd_id),0)
																								+	IsNull(
																									  (select sum(fvnc_importe)   from FacturaVentaNotaCredito 
					                                           where 
					                                                 (fvd_id_factura     = fvd.fvd_id and @doct_id in (1,9))
					                                              or (fvd_id_notacredito = fvd.fvd_id and @doct_id = 7)
					                                          ),0)
																							) 
														),2) 
													- round(fvd_importe,2)
												) > 0.01

								and fv_id = @@fv_id
							)
		begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El importe de la deuda de esta factura no coincide con la suma de sus aplicaciones '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

		if exists(select * from FacturaVentaPago fvp
							where	abs(	 round(fvp_importe,2)
											   - round(
														(		IsNull(
																	(select sum(fvcobz_importe) from FacturaVentaCobranza 
																	 where fvp_id = fvp.fvp_id),0)
															+	IsNull(
																  (select sum(fvnc_importe)   from FacturaVentaNotaCredito 
	                                 where 
	                                       (fvp_id_factura     = fvp.fvp_id and @doct_id in (1,9))
	                                    or (fvp_id_notacredito = fvp.fvp_id and @doct_id = 7)
	                                ),0)
														),2) 
												) > 0.01
								and fv_id = @@fv_id
							)
		begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El importe del pago de esta factura no coincide con la suma de sus aplicaciones '
	                                 + '(comp.:' + @fv_nrodoc + ' nro.: '+ @fv_numero + ')',
																	 3,
																	 2,
																	 @doct_id,
																	 @@fv_id
																	)
		end

	end

ControlError:

end
GO