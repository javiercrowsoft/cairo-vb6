select  
  fv_id,
  doct_id,
  fv_fecha,
  fv_nrodoc,
  fv_pendiente,
  isnull((select sum(clicc_importe) from clientecachecredito where id = fv.fv_id and doct_id in (1,3,7)),0)

from facturaventa fv
where 

case doct_id when 7 then -fv_pendiente else fv_pendiente end

<> isnull((select sum(clicc_importe) from clientecachecredito where id = fv.fv_id and doct_id in (1,7,9)),0)

/*
-- select * from clientecachecredito where id = 18475 and doct_id in (1,3,7)

select * from facturaVentadeuda where fv_id = 32916
select fv_total,* from facturaVenta where fv_id = 32916
select * from facturaVentapago where fv_id = 32916
*/