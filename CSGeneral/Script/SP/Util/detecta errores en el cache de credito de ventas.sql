select sum(case doct_id when 7 then -fv_total else fv_total end) 
from facturaventa 
where cli_id = 2 and est_id <> 7

select sum(cobz_total) 
from cobranza 
where cli_id = 2 and est_id <> 7

select sum(862655.391396-814944.579000)

exec sp_infoClienteSaldo 2,1,2

select * from clientecachecredito 
where doct_id in (1,7,9) and id not in (select fv_id from facturaventa where fv_pendiente <> 0 and est_id <> 7 and cli_id = 2)
and cli_id = 2

select * from clientecachecredito 
where doct_id in (13) and id not in (select cobz_id from cobranza where cobz_pendiente <> 0 and est_id <> 7 and cli_id = 2)
and cli_id = 2

-- sp_DocFacturaVentaSetPendiente

select fv_fecha,fv_descrip,fv_id,fv_pendiente,clicc_importe,abs(isnull(clicc_importe,0) - fv_pendiente) 
from facturaventa fv left join clientecachecredito cc on cc.doct_id =1 and fv.fv_id = cc.id
where fv.cli_id = 2
and abs(isnull(clicc_importe,0) - fv_pendiente) > 0.01

select cobz_fecha,cobz_descrip,cobz_id,cobz_pendiente,clicc_importe,abs(isnull(clicc_importe,0) - cobz_pendiente) 
from cobranza cobz left join clientecachecredito cc on cobz.doct_id = cc.doct_id and cobz.cobz_id = cc.id
where cobz_pendiente <> 0 and est_id <> 7 
and abs(cobz_pendiente)>0.01
and abs(isnull(clicc_importe,0) - cobz_pendiente) > 0.01
and cobz.cli_id = 2

select sum(862655.391396-814944.579000)

select sum(case when doct_id in (7,13) then clicc_importe else clicc_importe end)
from clientecachecredito where cli_id = 2 and doct_id in (1,7,9,13)

select 47710.812396-47039.360000

exec sp_infoClienteSaldo 2,1,2

select             cli_deudapedido        ,
                  cli_deudaremito        ,
                  cli_deudapackinglist  ,
                  cli_deudamanifiesto    ,
                  cli_deudactacte        ,
                  cli_deudadoc          ,
                  cli_deudatotal        
from cliente where cli_id = 2

select 5905.890840  +216816.650000  +270433.370840

select   cobz.cobz_id, 
         cobz_pendiente, 
        abs(sum(isnull(fvcobz_importe,0))-cobz_total),
        abs(abs(cobz_pendiente) - abs(sum(isnull(fvcobz_importe,0))-cobz_total))

from cobranza cobz left join facturaventacobranza fvc on fvc.cobz_id = cobz.cobz_id
group by cobz.cobz_id, cobz_pendiente, cobz_total
having abs(abs(cobz_pendiente) - abs(sum(isnull(fvcobz_importe,0))-cobz_total)) > 0.01


select cobz_fecha,cobz_descrip,cobz_id,cobz_pendiente,clicc_importe,abs(isnull(clicc_importe,0) - cobz_pendiente) 
from cobranza cobz left join clientecachecredito cc on cobz.doct_id = cc.doct_id and cobz.cobz_id = cc.id
where abs(cobz_pendiente) > 0.01 and est_id <> 7 
  and cc.id is null

select fv_fecha,fv_descrip,fv_id,fv_pendiente,clicc_importe,abs(isnull(clicc_importe,0) - fv_pendiente) 
from facturaventa fv left join clientecachecredito cc on fv.doct_id = cc.doct_id and fv.fv_id = cc.id
where abs(fv_pendiente)> 0.01 and est_id <> 7 
  and cc.id is null

select sum(fv_pendiente)
from facturaventa fv left join clientecachecredito cc on fv.doct_id = cc.doct_id and fv.fv_id = cc.id
where abs(fv_pendiente)> 0.01 and est_id <> 7 
  and cc.id is null
  and fv.cli_id = 2

select sum(clicc_importe) from clientecachecredito where cli_id = 2 and clicc_importe < 0 and doct_id in (7,9)