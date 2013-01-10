select * from producto p where pr_secompra <>0 and pr_eskit <> 0
and (      exists(select * from facturacompraitem where pr_id = p.pr_id) 
      or   exists(select * from remitocompraitem where pr_id = p.pr_id)
    )

select * from remitocompra where rc_id in (
select rc_id from remitocompraitem where pr_id in (
select pr_id from producto p where pr_secompra <>0 and pr_eskit <> 0
and (  exists(select * from remitocompraitem where pr_id = p.pr_id)
    )
)
)and st_id is not null

select * from facturacompra where fc_id in (
select fc_id from facturacompraitem where pr_id in (
select pr_id from producto p where pr_secompra <>0 and pr_eskit <> 0
and (   exists(select * from facturacompraitem where pr_id = p.pr_id) 
    )
)
)and st_id is not null