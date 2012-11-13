select  
	rv_id,
	doct_id,
	rv_fecha,
	rv_nrodoc,
	rv_pendiente,
	isnull((select sum(clicc_importe) from clientecachecredito where id = rv.rv_id and doct_id in (3,24)),0)

from remitoventa rv
where 

case doct_id when 24 then -rv_pendiente else rv_pendiente end

<> isnull((select sum(clicc_importe) from clientecachecredito where id = rv.rv_id and doct_id in(3,24)),0)

/*
-- select * from clientecachecredito where id = 2069 and doct_id in (3,24)

select rvi_pendientefac * (rvi_importe/rvi_cantidad) from remitoVentaItem where rv_id = 2069
select rv_pendiente,* from remitoVenta where rv_id = 2069
*/