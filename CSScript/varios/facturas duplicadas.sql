select emp_nombre,cli_nombre,fv_nrodoc,fv_fecha,fv_total 
from facturaventa fv  inner join documento d on fv.doc_id = d.doc_id 
                      inner join empresa e on d.emp_id = e.emp_id
                      inner join cliente c on fv.cli_id = c.cli_id

where fv_nrodoc in (

select fv_nrodoc from facturaventa fv inner join documento d on fv.doc_id = d.doc_id

group by fv_nrodoc,fv.emp_id having count(*)>1)
