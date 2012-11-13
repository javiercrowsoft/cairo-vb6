--select sum(
--case when doct_id =7 then -fvi_importe else fvi_importe end) 
select cli_nombre,fv_nrodoc,fv_fecha
from (facturaventaitem fvi inner join facturaventa fv on fvi.fv_id= fv.fv_id and fv_fecha between '20060601' and '20060630')
																	 inner join producto pr on fvi.pr_id = pr.pr_id 
																	 inner join tasaimpositiva ti on pr.ti_id_ivariventa = ti.ti_id
																	 inner join cliente cli on fv.cli_id = cli.cli_id


where 

				ti_nombre like '%iva ventas exento%'
and			fvi_ivari = 0 and est_id <> 7
and emp_id = 2