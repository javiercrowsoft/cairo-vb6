--select * from documentotipo

select * from clientecachecredito where doct_id = 5 and cli_id = 46

select pv_id,pv_pendiente,pv_fecha from pedidoventa where pv_id in (select id from clientecachecredito where doct_id = 5 and cli_id = 46)

select pv_id, 	sum(pvi_pendiente * (pvi_importe / pvi_cantidad)) from PedidoventaItem 

where  pv_id in (select id from clientecachecredito where doct_id = 5 and cli_id = 46)

group by pv_id

select cli_deudapedido,cli_deudaremito,cli_deudactacte from cliente where cli_id = 46

--------------------------------------------------------------------------------------------

select * from clientecachecredito where doct_id = 1 and cli_id = 46

select fv_id,fv_pendiente,fv_fecha from facturaventa where fv_id in (select id from clientecachecredito where doct_id = 1 and cli_id = 46)

select fv_id, 	sum(fvd_pendiente) from facturaventaDeuda

where  fv_id in (select id from clientecachecredito where doct_id = 1 and cli_id = 46)

group by fv_id


select cli_deudapedido,cli_deudaremito,cli_deudactacte from cliente where cli_id = 46

------------------------------------------------------------------------------------------

select * from clientecachecredito where doct_id = 3 and cli_id = 46

select rv_id,rv_pendiente,rv_fecha from remitoventa where rv_id in (select id from clientecachecredito where doct_id = 3 and cli_id = 46)

select rv_id, 	sum(rvi_pendiente * (rvi_importe / rvi_cantidad)) from remitoventaItem 

where  rv_id in (select id from clientecachecredito where doct_id = 3 and cli_id = 46)

group by rv_id

select rv_id, 	sum(rvi_pendientefac * (rvi_importe / rvi_cantidad)) from remitoventaItem 

where  rv_id in (select id from clientecachecredito where doct_id = 3 and cli_id = 46)

group by rv_id
