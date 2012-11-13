select fc_total,est_id,* from facturacompra where fc_id in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(2,8,10))
select * from facturacompradeuda where fc_id in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(2,8,10))
select sum(fcopg_importe) from facturacompraordenpago where fc_id in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(2,8,10))
select sum(fcnc_importe) from facturacompranotacredito 
where (fc_id_factura 		in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(2,8,10))

	or 
			fc_id_notacredito in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(2,8,10))
			)