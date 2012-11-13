select 

	prov_id,
	prov_nombre,
	prov_codigo,

		prov_deudaorden
	+	prov_deudaremito
	+	prov_deudactacte,
	(select sum(case doct_id when 16 then -provcc_importe else provcc_importe end) from proveedorCacheCredito where prov_id = prov.prov_id)

from

	proveedor prov

where 


		prov_deudaorden
	+	prov_deudaremito
	+	prov_deudactacte

<>

isnull((select sum(case doct_id when 16 then -provcc_importe else provcc_importe end) from proveedorCacheCredito where prov_id = prov.prov_id),0)


-- select * from proveedorCacheCredito where prov_id = 6
-- 
-- select * from proveedorCacheCredito where provcc_importe<0 and doct_id = 1
-- select doct_id,* from facturaventa where fv_id in 
-- (select id from proveedorCacheCredito where provcc_importe<0 and doct_id = 1)