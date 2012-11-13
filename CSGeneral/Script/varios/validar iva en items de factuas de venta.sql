select fvi_neto * ti_porcentaje /100, fvi_ivari 
from FacturaVentaItem fvi inner join Producto p on fvi.pr_id = p.pr_id
                          inner join TasaImpositiva ti on p.ti_id_ivariventa = ti.ti_id
where round(fvi_neto * ti_porcentaje /100,2) <> round(fvi_ivari,2)

