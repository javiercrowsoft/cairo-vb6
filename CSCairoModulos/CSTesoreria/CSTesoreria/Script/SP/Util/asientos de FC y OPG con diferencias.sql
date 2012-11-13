-- dame los asientos de facturas donde no coincide el total de la factura con el total del haber del asiento

select fc.doct_id,fc_id, fc_fecha, fc_total, sum(asi_haber),fc_importedesc1,fc_importedesc2 
from facturacompra fc left join asientoitem asi on fc.as_id = asi.as_id
group by fc_id, fc_fecha, fc_total,fc_importedesc1,fc_importedesc2,fc.doct_id
having abs((fc_total+fc_importedesc1+fc_importedesc2) - sum(asi_haber)) >0.015

select * from facturacompra where est_id = 7 and as_id is not null

select * from facturacompra where est_id <> 7 and as_id is null

-- dame los asientos de ordenes de pago donde no coincide el total de la orden con el total del haber del asiento

select opg_id, opg_fecha, opg_total, sum(asi_haber) 
from ordenpago opg left join asientoitem asi on opg.as_id = asi.as_id
group by opg_id, opg_fecha, opg_total
having abs(opg_total - sum(asi_haber)) >0.015

select * from ordenpago where est_id = 7 and as_id is not null

select * from ordenpago where est_id <> 7 and as_id is null

-- dame los asientos de cobranzas donde no coincide el total de la cobranza con el total del haber del asiento

select cobz_id, cobz_fecha, cobz_total, sum(asi_haber) 
from cobranza cobz left join asientoitem asi on cobz.as_id = asi.as_id
group by cobz_id, cobz_fecha, cobz_total
having abs(cobz_total - sum(asi_haber)) >0.015

select * from cobranza where est_id = 7 and as_id is not null

select * from cobranza where est_id <> 7 and as_id is null

-- dame los asientos de facturas de venta donde no coincide el total de la factura con el total del haber del asiento

select fv_id, fv_fecha, fv_total, sum(asi_haber), fv_importedesc1, fv_importedesc2 
from facturaventa fv left join asientoitem asi on fv.as_id = asi.as_id
group by fv_id, fv_fecha, fv_total, fv_importedesc1, fv_importedesc2 
having abs(fv_total + fv_importedesc1 +  fv_importedesc2 - sum(asi_haber)) >0.015

select * from facturaventa where est_id = 7 and as_id is not null

select * from facturaventa where est_id <> 7 and as_id is null

-- dame los asientos de movimientos de fondo donde no coincide el total de el movimiento con el total del haber del asiento

select mf_id, mf_fecha, mf_total, sum(asi_haber) 
from movimientofondo mf left join asientoitem asi on mf.as_id = asi.as_id
group by mf_id, mf_fecha, mf_total
having abs(mf_total - sum(asi_haber)) >0.015

select * from movimientofondo where est_id = 7 and as_id is not null

select * from movimientofondo where est_id <> 7 and as_id is null

-- dame los asientos de depositos bancarios donde no coincide el total de el deposito con el total del haber del asiento

select dbco_id, dbco_fecha, dbco_total, sum(asi_haber) 
from depositobanco dbco left join asientoitem asi on dbco.as_id = asi.as_id
group by dbco_id, dbco_fecha, dbco_total
having abs(dbco_total - sum(asi_haber)) >0.015

select * from depositobanco where est_id = 7 and as_id is not null

select * from depositobanco where est_id <> 7 and as_id is null

-- dame los asientos de depositos de cupones donde no coincide el total de el deposito con el total del haber del asiento

select dcup_id, dcup_fecha, dcup_total, sum(asi_haber) 
from depositocupon dcup left join asientoitem asi on dcup.as_id = asi.as_id
group by dcup_id, dcup_fecha, dcup_total
having abs(dcup_total - sum(asi_haber)) >0.015

select * from depositocupon where est_id = 7 and as_id is not null

select * from depositocupon where est_id <> 7 and as_id is null

-- dame los asientos de resolucion de cupones donde no coincide el total de la resolucion con el total del haber del asiento

select rcup_id, rcup_fecha, rcup_total, sum(asi_haber) 
from resolucioncupon rcup left join asientoitem asi on rcup.as_id = asi.as_id
group by rcup_id, rcup_fecha, rcup_total
having abs(rcup_total - sum(asi_haber)) >0.015

select * from resolucioncupon where est_id = 7 and as_id is not null

select * from resolucioncupon where est_id <> 7 and as_id is null
