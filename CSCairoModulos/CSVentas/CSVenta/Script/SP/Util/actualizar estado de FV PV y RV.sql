update facturaventa set est_id = 5 where fv_id in (
select fv_id from facturaventa where fv_pendiente < 0.01 and est_id <> 5 and est_id <> 7)

update pedidoventa set est_id = 5 where pv_id in (
select pv.pv_id from pedidoventa pv inner join pedidoventaitem pvi on pv.pv_id = pvi.pv_id
where pvi_pendiente < 0.01 and est_id <> 5 and est_id <> 7)

-- select pv.pv_id,pv_fecha,pvi_pendiente from pedidoventa pv inner join pedidoventaitem pvi on pv.pv_id = pvi.pv_id
-- where pvi_pendiente < 0.01 and est_id <> 5 and est_id <> 7

update remitoventa set est_id = 5 where rv_id in (
select rv.rv_id from remitoventa rv inner join remitoventaitem rvi on rv.rv_id = rvi.rv_id
where rvi_pendiente < 0.01 and est_id <> 5 and est_id <> 7)

-- select rv.rv_id,rv_fecha,rvi_pendiente from remitoventa rv inner join remitoventaitem rvi on rv.rv_id = rvi.rv_id
-- where rvi_pendiente < 0.01 and est_id <> 5 and est_id <> 7

