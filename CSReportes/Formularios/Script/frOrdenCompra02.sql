--select * from ordencompra

select 
      OC.*,
      PROV.prov_nombre,
      cp.cpg_nombre,
      suc.suc_nombre

from ordenCompra OC inner join Proveedor PROV    on OC.prov_id = PROV.prov_id
                    inner join CondicionPago CP  on CP.cpg_id  = OC.cpg_id  
                    inner join Sucursal suc  on Suc.suc_id  = OC.suc_id  