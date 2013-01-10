/*
    select * from asiento ast where as_id in
    (
    select as_id from facturacompra where fc_id in (
    select fc_id from facturacompraitem where to_id = 2
    ) and doct_id <> 8 and fc_total > 0
    )
    and exists(select * from asientoitem where as_id = ast.as_id and asi_tipo <> 0)

*/

update asientoitem set asi_tipo = 2 where asi_id in 
(
select asi_id from asientoitem where as_id in(
select as_id from facturacompra where fc_id in (
select fc_id from facturacompraitem where to_id = 2
) and doct_id <> 8 and fc_total > 0
) and asi_haber <> 0
)

/*
    select * from asiento ast where as_id in
    (
    select as_id from facturacompra where fc_id in (
    select fc_id from facturacompraitem where to_id = 2
    ) and doct_id = 8 and fc_total > 0
    )
    and exists(select * from asientoitem where as_id = ast.as_id and asi_tipo <> 0)

*/


update asientoitem set asi_tipo = 2 where asi_id in 
(
select asi_id from asientoitem where as_id in(
select as_id from facturacompra where fc_id in (
select fc_id from facturacompraitem where to_id = 2
) and doct_id = 8 and fc_total > 0
) and asi_debe <> 0
)