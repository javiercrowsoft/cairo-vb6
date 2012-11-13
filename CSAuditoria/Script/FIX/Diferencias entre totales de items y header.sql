select fv_ivari,fv_descuento1,fv_descuento2 from facturaventa where fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El IVA de esta factura no coincide con la suma%' and doct_id in (1,7,9))
select sum(fvi_ivari) from facturaventaitem where  fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El IVA de esta factura no coincide con la suma%' and doct_id in (1,7,9))

select fv_neto,fv_descuento1,fv_descuento2 from facturaventa where  fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El neto de esta factura no coincide con la suma de los netos de sus items%' and doct_id in (1,7,9))
select sum(fvi_neto) from facturaventaitem where  fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El neto de esta factura no coincide con la suma de los netos de sus items%' and doct_id in (1,7,9))

select fv_total,fv_descuento1,fv_descuento2 from facturaventa where  fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El total de esta factura no coincide con la suma de los totales de sus items%' and doct_id in (1,7,9))
select sum(fvi_importe) from facturaventaitem where  fv_id in (select comp_id from auditoriaitem where audi_descrip like '%El total de esta factura no coincide con la suma de los totales de sus items%' and doct_id in (1,7,9))