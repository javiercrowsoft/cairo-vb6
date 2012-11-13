select fv.fv_id 
from facturaventa fv inner join asiento ast on fv.as_id = ast.as_id
                     inner join documento doc on ast.doc_id = doc.doc_id
where fv.emp_id <> doc.emp_id

select * from facturaventa where as_id is null and est_id <> 7

select * from facturaventa fv
where not exists(select * from asientoitem where as_id = fv.as_id)
and est_id <> 7
