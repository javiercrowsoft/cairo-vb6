select fc.fc_id,fc_nrodoc,fc_fecha,fc_totalotros, sum(fcot_debe-fcot_haber) from facturacompra fc left join facturacompraotro fcot on fc.fc_id = fcot.fc_id
group by fc.fc_id,fc_totalotros,fc_nrodoc,fc_fecha
having fc_totalotros <> isnull(sum(fcot_debe-fcot_haber),0)


/*
update facturacompra set fc_totalotros = 0 where fc_id in 
(
select fc.fc_id from facturacompra fc left join facturacompraotro fcot on fc.fc_id = fcot.fc_id
group by fc.fc_id,fc_totalotros,fc_nrodoc,fc_fecha
having fc_totalotros <> isnull(sum(fcot_debe-fcot_haber),0)
)
*/