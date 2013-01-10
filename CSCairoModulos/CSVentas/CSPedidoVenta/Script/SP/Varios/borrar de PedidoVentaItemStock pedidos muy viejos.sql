
/*
56.323. inflex
54.323. inflex

select * from producto where pr_nombreventa = 'Cilindro Inflex 56.323.200 IN72' 

*/
select pv_fecha, pv_nrodoc, cli_nombre, est_id 
from pedidoventa pv inner join cliente cli on pv.cli_id = cli.cli_id
where pv_id in (
    select pv_id from pedidoventaitemstock where pr_id = 1598
)
order by pv_fecha

/*

delete pedidoventaitemstock
where pv_id in (
    select pvis.pv_id 
    from pedidoventaitemstock pvis inner join pedidoventa pv on pvis.pv_id = pv.pv_id
    and pv_fecha < '20070501'
)


*/