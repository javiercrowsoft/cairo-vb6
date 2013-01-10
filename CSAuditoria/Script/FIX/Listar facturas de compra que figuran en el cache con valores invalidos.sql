select  
  fc_id,
  doct_id,
  fc_fecha,
  fc_nrodoc,
  fc_pendiente,
  isnull((select sum(provcc_importe) from proveedorcachecredito where id = fc.fc_id and doct_id in (1,3,7)),0)

from facturacompra fc
where 

case doct_id when 8 then -fc_pendiente else fc_pendiente end

<> isnull((select sum(provcc_importe) from proveedorcachecredito where id = fc.fc_id and doct_id in (2,8,10)),0)

/*
-- select * from proveedorcachecredito where id = 18475 and doct_id in (1,3,7)

select * from facturacompradeuda where fc_id = 32916
select fc_total,* from facturacompra where fc_id = 32916
select * from facturacomprapago where fc_id = 32916
*/