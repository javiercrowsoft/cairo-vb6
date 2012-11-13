select fc.fc_id,fc_nrodoc,fc_fecha,fc_totalpercepciones, sum(fcperc_importe) from facturacompra fc left join facturacomprapercepcion fcperc on fc.fc_id = fcperc.fc_id
group by fc.fc_id,fc_totalpercepciones,fc_nrodoc,fc_fecha
having fc_totalpercepciones <> isnull(sum(fcperc_importe),0)

/*
update facturacompra set fc_totalpercepciones = 0 where fc_id in 
(
select fc.fc_id from facturacompra fc left join facturacomprapercepcion fcperc on fc.fc_id = fcperc.fc_id
where fc.fc_id <> 9058
group by fc.fc_id,fc_totalpercepciones,fc_nrodoc,fc_fecha
having fc_totalpercepciones <> isnull(sum(fcperc_importe),0)
)
*/

