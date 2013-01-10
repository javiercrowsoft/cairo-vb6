select fc_id, 
       fc_total, 
        isnull((select sum(fcd_importe) from facturacompradeuda where fc_id = fc.fc_id),0)
       +isnull((select sum(fcp_importe) from facturacomprapago  where fc_id = fc.fc_id),0)

from facturacompra fc

where exists (select * from facturacompradeuda where fc_id = fc.fc_id)
   or exists (select * from facturacomprapago where fc_id = fc.fc_id)

group by 

fc_id, fc_total

having 

abs(fc_total-(
        isnull((select sum(fcd_importe) from facturacompradeuda where fc_id = fc.fc_id),0)
       +isnull((select sum(fcp_importe) from facturacomprapago  where fc_id = fc.fc_id),0)))>0.01
