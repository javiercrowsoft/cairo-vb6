/*
---------------------------------------------------------------------
Nombre: Ranking de venta por Sucursal
---------------------------------------------------------------------
*/


select 
		emp_nombre,
    suc_nombre,
    suc_codigo,
    mon_nombre,
    sum(fv_neto) as Neto,
    sum(fv_ivari) as IvaRI,
    sum(fv_total) as Importe,
    sum(fv_totalOrigen) as Origen



from sucursal s inner join FacturaVenta      fv     on s.suc_id     = fv.suc_id
                inner join Moneda            mon    on fv.mon_id    = mon.mon_id
								inner join Empresa           emp    on fv.emp_id    = emp.emp_id

group by     
			emp_nombre,
      suc_nombre,
      suc_codigo,
      mon_nombre

order by Neto