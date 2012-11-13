/*
---------------------------------------------------------------------
Nombre: Pedidos de venta pendientes por Producto (cantidad pendiente)
---------------------------------------------------------------------
*/

select 
    pr_nombreventa,
    pr_nombrecompra,
    pr_codigo,
    case 
      when pr_llevastock <> 0 then 'si'
      else 'no'
    end [lleva Stock], 
    sum(pvi_pendiente) Pendiente,
    emp_nombre,
    mon_nombre

from pedidoVenta pv inner join pedidoventaitem pvi on pv.pv_id  = pvi.pv_id
                    inner join producto        pro on pvi.pr_id = pro.pr_id
                    inner join documento   doc     on pv.doc_id  = doc.doc_id
                    inner join moneda      mon     on doc.mon_id = mon.mon_id
                    inner join empresa     emp     on doc.emp_id  = emp.emp_id

where pvi_pendiente > 0

		and pv.est_id <> 7

group by  
      pr_nombrecompra, 
      pr_llevastock,
      pr_codigo,
      pr_nombreventa,
      emp_nombre,
      mon_nombre