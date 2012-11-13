-- select fc_fecha,fc.fc_id,fc_total, sum(fcd_importe) from facturacompra fc inner join facturacompradeuda fcd on fc.fc_id = fcd.fc_id
-- group by fc.fc_id, fc_total, fc_fecha having abs(sum(fcd_importe) - fc_total)>0.01
-- order by fc_fecha

/*

		select fc_fecha,fc.fc_id,fc_total,
								(select sum(fcd_importe) from facturacompradeuda where fc_id = fc.fc_id)
							,	IsNull(
								(select sum(fcp_importe) from facturacomprapago where fc_id = fc.fc_id), 0)
		
		from facturacompra fc 
		where abs(
							(
								(select sum(fcd_importe) from facturacompradeuda where fc_id = fc.fc_id)
							+	IsNull(
								(select sum(fcp_importe) from facturacomprapago where fc_id = fc.fc_id), 0)
							)
							- fc_total
							)>0.01
		and not 
		(
				 exists (select * from facturacompraordenpago where fc_id = fc.fc_id)
		or  exists (select * from facturacompranotacredito where fc_id_factura = fc.fc_id)
		or  exists (select * from facturacompranotacredito where fc_id_notacredito = fc.fc_id)
		)
		order by fc_fecha

*/

declare c_facturas insensitive cursor for 

								select fc_id,fc_descuento1,fc_descuento2,fc_totalotros,fc_totalpercepciones,
											 cpg_id,fc_fecha
								
								from facturacompra fc 
								where abs(
													(
														(select sum(fcd_importe) from facturacompradeuda where fc_id = fc.fc_id)
													+	IsNull(
														(select sum(fcp_importe) from facturacomprapago where fc_id = fc.fc_id), 0)
													)
													- (fc_total)
													)>0.01
								and not 
								(
										 exists (select * from facturacompraordenpago where fc_id = fc.fc_id)
								or  exists (select * from facturacompranotacredito where fc_id_factura = fc.fc_id)
								or  exists (select * from facturacompranotacredito where fc_id_notacredito = fc.fc_id)
								)
								order by fc_fecha
open c_facturas

	declare @fc_totaldeuda decimal(18,6)
	declare @fc_descuento1 decimal(18,6)
	declare @fc_descuento2 decimal(18,6)
	declare @fc_totalotros decimal(18,6)
	declare @fc_totalpercepciones decimal(18,6)
	declare @fc_id int
	declare @bSuccess tinyint
	declare @cpg_id int
	declare @fc_fecha datetime

	fetch next from c_facturas into @fc_id,@fc_descuento1,@fc_descuento2,@fc_totalotros,@fc_totalpercepciones,@cpg_id,@fc_fecha
	while @@fetch_status=0
	begin

			select @fc_totaldeuda = sum(fci_importe) 
			from FacturaCompraItem fci inner join TipoOperacion t on fci.to_id = t.to_id
			where fc_id = @fc_id 
				and to_generadeuda <> 0
		
			set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento1) / 100)
			set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento2) / 100)
			set @fc_totaldeuda = @fc_totaldeuda + @fc_totalotros + @fc_totalpercepciones
		
			exec sp_DocFacturaCompraSaveDeuda 			
																				@fc_id,
																				@cpg_id,
																				@fc_fecha,
																				@fc_totaldeuda,
																		    @bSuccess	out

		fetch next from c_facturas into @fc_id,@fc_descuento1,@fc_descuento2,@fc_totalotros,@fc_totalpercepciones,@cpg_id,@fc_fecha
	end

close c_facturas
deallocate c_facturas