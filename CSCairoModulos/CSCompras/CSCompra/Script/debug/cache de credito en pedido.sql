select * from proveedorcachecredito where doct_id = 6 and prov_id = 7

select pc_id,pc_pendiente,pc_fecha from pedidocompra where pc_id in (select id from proveedorcachecredito where doct_id = 6 and prov_id = 7)

select pc_id,   sum(pci_pendiente * (pci_importe / pci_cantidad)) from PedidoCompraItem 

where  pc_id in (select id from proveedorcachecredito where doct_id = 6 and prov_id = 7)

group by pc_id

select prov_deudapedido,prov_deudaremito,prov_deudactacte from proveedor where prov_id = 7

--------------------------------------------------------------------------------------------

select * from proveedorcachecredito where doct_id = 2 and prov_id = 7

select fc_id,fc_pendiente,fc_fecha from facturacompra where fc_id in (select id from proveedorcachecredito where doct_id = 2 and prov_id = 7)

select fc_id,   sum(fcd_pendiente) from facturacompraDeuda

where  fc_id in (select id from proveedorcachecredito where doct_id = 2 and prov_id = 7)

group by fc_id


select prov_deudapedido,prov_deudaremito,prov_deudactacte from proveedor where prov_id = 7

------------------------------------------------------------------------------------------

select * from proveedorcachecredito where doct_id = 4 and prov_id = 7

select rc_id,rc_pendiente,rc_fecha from remitocompra where rc_id in (select id from proveedorcachecredito where doct_id = 4 and prov_id = 7)

select rc_id,   sum(rci_pendiente * (rci_importe / rci_cantidad)) from remitoCompraItem 

where  rc_id in (select id from proveedorcachecredito where doct_id = 4 and prov_id = 7)

group by rc_id

select rc_id,   sum(rci_pendientefac * (rci_importe / rci_cantidad)) from remitoCompraItem 

where  rc_id in (select id from proveedorcachecredito where doct_id = 4 and prov_id = 7)

group by rc_id
