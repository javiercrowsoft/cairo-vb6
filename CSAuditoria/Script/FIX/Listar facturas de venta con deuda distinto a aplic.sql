select fv_total,est_id,* from facturaventa where fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(1,7,9))
select * from facturaventadeuda where fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(1,7,9))
select sum(fvcobz_importe) from facturaventacobranza where fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(1,7,9))
select sum(fvnc_importe) from facturaventanotacredito 
where (fv_id_factura 		in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(1,7,9))

	or 
			fv_id_notacredito in (select comp_id from auditoriaitem where audi_descrip like '%El importe de la deuda de esta factura no coincide con la suma%' and doct_id in(1,7,9))
			)