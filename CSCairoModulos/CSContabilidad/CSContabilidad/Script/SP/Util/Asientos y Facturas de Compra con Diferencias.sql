select   fc_id, 
        fc_fecha, 
        fc_numero,  
        fc_total,
        (select sum(asi_debe) from asientoitem where as_id = fc.as_id),
        est_id

from facturacompra fc where abs(abs(fc_total) - (select sum(asi_debe) from asientoitem where as_id = fc.as_id))>0.05
--and fc_fecha = '20061109'