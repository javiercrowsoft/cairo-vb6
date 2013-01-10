-- select * from cuenta where cue_nombre like '%acreedo%'
-- select * from proveedor where prov_nombre like '%galicia%'

select distinct ast.as_numero,ast.as_doc_cliente,as_fecha,emp_nombre --sp_col asiento
from asiento ast inner join asientoitem asi on ast.as_id = asi.as_id 
                 inner join documento doc on ast.doc_id = doc.doc_id
                 inner join empresa emp on doc.emp_id = emp.emp_id
where cue_id in (423,141,143)
and exists(select as_id from facturacompra where prov_id = 380 and as_id = ast.as_id)
and as_fecha > '20060101'
