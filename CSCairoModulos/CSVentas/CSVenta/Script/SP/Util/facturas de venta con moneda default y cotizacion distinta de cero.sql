-- update facturaventa set fv_cotizacion = 0 where fv_id in (
-- select fv.fv_id from facturaventa fv inner join documento doc on fv.doc_id = doc.doc_id
-- 																 inner join moneda mon    on doc.mon_id = mon.mon_id
-- where fv_cotizacion <> 0 and mon_legal <> 0
-- )

select fv.mon_id,doc.mon_id,doc_nombre,doc.doc_id,fv_id,fv_fecha from facturaventa fv inner join documento doc on fv.doc_id = doc.doc_id
																 inner join moneda mon    on doc.mon_id = mon.mon_id
where fv_cotizacion <> 0 and mon_legal <> 0

-- select * from moneda where mon_legal <> 0