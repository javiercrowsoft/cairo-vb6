


select as_id     as comp_id, doct_id as doct_id, as_fecha     as Fecha, as_nrodoc     as Comprobante from asiento where as_fecha >getdate()
union all
select os_id     as comp_id, doct_id as doct_id, os_fecha     as Fecha, os_nrodoc     as Comprobante from ordenservicio where os_fecha >getdate() and est_id <> 7
union all
select rv_id     as comp_id, doct_id as doct_id, rv_fecha     as Fecha, rv_nrodoc     as Comprobante from remitoventa where rv_fecha >getdate() and est_id <> 7
union all
select fv_id     as comp_id, doct_id as doct_id, fv_fecha     as Fecha, fv_nrodoc     as Comprobante from facturaventa where fv_fecha >getdate() and est_id <> 7
union all
select pv_id     as comp_id, doct_id as doct_id, pv_fecha     as Fecha, pv_nrodoc     as Comprobante from pedidoventa where pv_fecha >getdate() and est_id <> 7
union all
select cobz_id   as comp_id, doct_id as doct_id, cobz_fecha   as Fecha, cobz_nrodoc   as Comprobante from cobranza where cobz_fecha >getdate() and est_id <> 7
union all
select opg_id   as comp_id, doct_id as doct_id, opg_fecha   as Fecha, opg_nrodoc     as Comprobante from ordenpago where opg_fecha >getdate() and est_id <> 7
union all
select rc_id     as comp_id, doct_id as doct_id, rc_fecha     as Fecha, rc_nrodoc     as Comprobante from remitocompra where rc_fecha >getdate() and est_id <> 7
union all
select fc_id     as comp_id, doct_id as doct_id, fc_fecha     as Fecha, fc_nrodoc     as Comprobante from facturacompra where fc_fecha >getdate() and est_id <> 7
union all
select pc_id     as comp_id, doct_id as doct_id, pc_fecha     as Fecha, pc_nrodoc     as Comprobante from pedidocompra where pc_fecha >getdate() and est_id <> 7
union all
select oc_id     as comp_id, doct_id as doct_id, oc_fecha     as Fecha, oc_nrodoc     as Comprobante from ordencompra where oc_fecha >getdate() and est_id <> 7
union all
select mf_id     as comp_id, doct_id as doct_id, mf_fecha     as Fecha, mf_nrodoc     as Comprobante from movimientofondo where mf_fecha >getdate() and est_id <> 7
union all
select dbco_id   as comp_id, doct_id as doct_id, dbco_fecha   as Fecha, dbco_nrodoc   as Comprobante from depositobanco where dbco_fecha >getdate() and est_id <> 7
union all
select rs_id     as comp_id, doct_id as doct_id, rs_fecha     as Fecha, rs_nrodoc     as Comprobante from recuentostock where rs_fecha >getdate()
union all
select ppk_id   as comp_id, doct_id as doct_id, ppk_fecha   as Fecha, ppk_nrodoc     as Comprobante from parteprodkit where ppk_fecha >getdate()
union all
select st_id     as comp_id, doct_id as doct_id, st_fecha     as Fecha, st_nrodoc     as Comprobante from stock where st_fecha >getdate()
union all
select dcup_id   as comp_id, doct_id as doct_id, dcup_fecha   as Fecha, dcup_nrodoc   as Comprobante from depositocupon where dcup_fecha >getdate() and est_id <> 7
union all
select rcup_id   as comp_id, doct_id as doct_id, rcup_fecha   as Fecha, rcup_nrodoc   as Comprobante from resolucioncupon where rcup_fecha >getdate() and est_id <> 7
union all
select stcli_id as comp_id, doct_id as doct_id, stcli_fecha as Fecha, stcli_nrodoc   as Comprobante from stockcliente where stcli_fecha >getdate()
union all
select stprov_id as comp_id, doct_id as doct_id, stprov_fecha as Fecha, stprov_nrodoc as Comprobante from stockproveedor where stprov_fecha >getdate()

