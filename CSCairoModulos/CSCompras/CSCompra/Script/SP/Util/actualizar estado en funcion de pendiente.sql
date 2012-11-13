select * from facturaventa where abs(fv_pendiente)<0.01 and est_id <> 5 and est_id <> 7 

select * from facturacompra where abs(fc_pendiente)<0.01 and est_id <> 5 and est_id <> 7

update 
select fv_id from facturaventa fv
where 
isnull((select sum(fvd_pendiente) from facturaventadeuda where fv_id = fv.fv_id),0)
<0.01 and est_id <> 5 and est_id <> 7



update facturacompra set est_id = 5 where fc_id in (
select fc_id from facturacompra fc
where 
isnull((select sum(fcd_pendiente) from facturacompradeuda where fc_id = fc.fc_id),0)
<0.01 and est_id <> 5 and est_id <> 7
)