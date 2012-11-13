----------------------------------------------------------------
-- la op y la factura son de distintas empresas
--

select * from facturacompra fc 

inner join documento doc on fc.doc_id = doc.doc_id
inner join facturacompraordenpago fcopg on fc.fc_id = fcopg.fc_id
inner join ordenpago opg on fcopg.opg_id = opg.opg_id
inner join documento docopg on opg.doc_id = docopg.doc_id
inner join asiento ast

where doc.emp_id <> docopg.emp_id

----------------------------------------------------------------
-- el asiento no coincide en la op
--
select opg_fecha, opg_id, opg_total, opg_total - abs(sum(asi_debe-asi_haber)) as diferencia

from ordenpago opg left join asiento ast on opg.as_id = ast.as_id
									 left join asientoitem asi on ast.as_id = asi.as_id
									 left join cuenta cue on asi.cue_id = cue.cue_id
where cuec_id = 8
	and opg.est_id <> 7

group by opg_id, opg_total, opg_fecha 

having abs(opg_total - abs(sum(isnull(asi_debe-asi_haber,0))))> 0.01

order by opg_fecha

----------------------------------------------------------------
-- el asiento no coincide en la fc
--
select fc_fecha, fc_id, fc_total, fc_total - abs(sum(asi_debe-asi_haber)) as diferencia

from facturacompra fc left join asiento ast on fc.as_id = ast.as_id
									 left join asientoitem asi on ast.as_id = asi.as_id
									 left join cuenta cue on asi.cue_id = cue.cue_id
where cuec_id = 8
	and fc.est_id <> 7

group by fc_id, fc_total, fc_fecha 

having abs(fc_total - abs(sum(isnull(asi_debe-asi_haber,0))))> 0.01

order by fc_fecha

----------------------------------------------------------------
-- la orden de pago y la factura no afectan a la misma cuenta de acreedor
--
select fc_fecha, fc_nrodoc, opg_fecha, opg_nrodoc, cue.cue_nombre, cueo.cue_nombre from facturacompra fc 

inner join documento doc on fc.doc_id = doc.doc_id
inner join facturacompraordenpago fcopg on fc.fc_id = fcopg.fc_id
inner join ordenpago opg on fcopg.opg_id = opg.opg_id
inner join documento docopg on opg.doc_id = docopg.doc_id

left join asiento ast on fc.as_id = ast.as_id
left join asientoitem asi on ast.as_id = asi.as_id
left join cuenta cue on asi.cue_id = cue.cue_id

left join asiento asto on opg.as_id = asto.as_id
left join asientoitem asio on asto.as_id = asio.as_id
left join cuenta cueo on asio.cue_id = cueo.cue_id

where cue.cuec_id = 8 and cueo.cuec_id = 8
	and fc.est_id <> 7
	and opg.est_id <> 7
	and cue.cue_id <> cueo.cue_id

----------------------------------------------------------------
-- Cuentas en las que imputan las ordenes de pago
--
select opg_fecha, opg_nrodoc, cue.cue_nombre 
from ordenpago opg left join asiento ast on opg.as_id = ast.as_id
									 left join asientoitem asi on ast.as_id = asi.as_id
									 left join cuenta cue on asi.cue_id = cue.cue_id
where cuec_id = 8
	and opg.est_id <> 7

order by cue_nombre, opg_fecha

----------------------------------------------------------------
-- Ordenes de pago sin cuenta de acreedor
--
select opg_fecha, opg_nrodoc
from ordenpago opg 
where not exists(
				select * 
				from asiento ast left join asientoitem asi on ast.as_id = asi.as_id
												 left join cuenta cue on asi.cue_id = cue.cue_id
				where cuec_id = 8
					and opg.as_id = ast.as_id
	)
	and opg.est_id <> 7

----------------------------------------------------------------
-- Facturas de compra sin cuenta de acreedor
--
select fc_fecha, fc_nrodoc, doc_nombre, cpg_nombre, fc_pendiente, fc_totalcomercial
from facturacompra fc inner join documento doc on fc.doc_id = doc.doc_id
										  inner join condicionpago cpg on fc.cpg_id = cpg.cpg_id
where not exists(
				select * 
				from asiento ast left join asientoitem asi on ast.as_id = asi.as_id
												 left join cuenta cue on asi.cue_id = cue.cue_id
				where cuec_id = 8
					and fc.as_id = ast.as_id
	)
	and fc.est_id <> 7
	and fc_totalcomercial <> 0
order by fc_fecha


-- Con total comercial cuando son de fondo fijo (esto esta mal)
--
select fc_fecha, fc_nrodoc, doc_nombre, cpg_nombre, fc_pendiente, fc_totalcomercial
from facturacompra fc inner join documento doc on fc.doc_id = doc.doc_id
										  inner join condicionpago cpg on fc.cpg_id = cpg.cpg_id
where not exists(
				select * 
				from asiento ast left join asientoitem asi on ast.as_id = asi.as_id
												 left join cuenta cue on asi.cue_id = cue.cue_id
				where cuec_id = 8
					and fc.as_id = ast.as_id
	)
	and fc.est_id <> 7
	and fc_totalcomercial <> 0
	and doc.emp_id = 1

	and fc_fechavto < '20090430'
order by fc_fecha

-- Con total comercial distinto a fc_total (y por ende distinto a lo contabilizado)
--
select 

fc_fecha, fc_nrodoc, doc_nombre, cpg_nombre, fc_pendiente, fc_totalcomercial, fc_total, sum(asi_debe-asi_haber) as contabilidad
from facturacompra fc inner join documento doc on fc.doc_id = doc.doc_id
										  inner join condicionpago cpg on fc.cpg_id = cpg.cpg_id

									 left join asiento ast on fc.as_id = ast.as_id
									 left join asientoitem asi on ast.as_id = asi.as_id
									 left join cuenta cue on asi.cue_id = cue.cue_id

where fc.est_id <> 7
	and doc.emp_id = 1
	and fc_totalcomercial <> fc_total
	and fc_totalcomercial <> 0
	and fc_fecha >= '20080501'
	and cuec_id = 8

group by 

fc_fecha, fc_nrodoc, doc_nombre, cpg_nombre, fc_pendiente, fc_totalcomercial, fc_total

order by fc_fecha

-- Con lo contabilizado distinto a total comercial
--
select 

fc_fecha, fc_fechavto, fc_nrodoc, doc_nombre, cpg_nombre, fc_pendiente, fc_totalcomercial, fc_total, sum(asi_debe-asi_haber) as contabilidad
from facturacompra fc inner join documento doc on fc.doc_id = doc.doc_id
										  inner join condicionpago cpg on fc.cpg_id = cpg.cpg_id

									 left join asiento ast on fc.as_id = ast.as_id
									 left join asientoitem asi on ast.as_id = asi.as_id
									 left join cuenta cue on asi.cue_id = cue.cue_id

where fc.est_id <> 7
	and doc.emp_id = 1
	and fc_fecha >= '20080501'
	and cuec_id = 8

group by 

fc_fecha, fc_fechavto, fc_nrodoc, doc_nombre, cpg_nombre, fc_pendiente, fc_totalcomercial, fc_total

having abs(fc_totalcomercial - abs(isnull(sum(asi_debe-asi_haber),0)))> 0.01

order by fc_fecha

----------------------------------------------------------------
-- Notas de credito o debito con totalcomercial en cero (fondo fijo o debito automatico)
--
select * from facturacompra where fc_totalcomercial = 0 and doct_id in (8,10) and est_id <> 7