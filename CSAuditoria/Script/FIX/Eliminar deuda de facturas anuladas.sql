delete facturaventadeuda where fv_id in (
select fv_id from facturaventa fv
where est_id = 7 
	and exists(select * from facturaventadeuda where fv_id = fv.fv_id)
)

delete facturacompradeuda where fc_id in (
select fc_id from facturacompra fc
where est_id = 7 
	and exists(select * from facturacompradeuda where fc_id = fc.fc_id)
)


update facturaventaitem set fvi_pendiente =0, fvi_pendientepklst = 0 where fv_id in (
	select fv_id from facturaventa where est_id = 7
)

update facturacompraitem set fci_pendiente =0 where fc_id in (
	select fc_id from facturacompra where est_id = 7
)

/*

para chequear

select fv_id from facturaventa fv
where est_id = 7 
	and exists(select * from facturaventapago where fv_id = fv.fv_id)

select fc_id from facturacompra fc
where est_id = 7 
	and exists(select * from facturacomprapago where fc_id = fc.fc_id)
*/