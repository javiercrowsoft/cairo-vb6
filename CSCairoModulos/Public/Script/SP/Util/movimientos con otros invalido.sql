select emp_nombre,prov_nombre,fc_id,fc_fecha,fc_nrodoc,fc_numero,

fc_total ,( fc_neto +fc_ivari+fc_totalotros + fc_totalpercepciones)

 from facturacompra fc inner join proveedor prov on fc.prov_id = prov.prov_id
											 inner join documento doc  on fc.doc_id  = doc.doc_id
											 inner join empresa emp    on doc.emp_id = emp.emp_id

where abs(fc_total -( fc_neto +fc_ivari+fc_totalotros + fc_totalpercepciones))>0.01

A-0004-00008415 ok
A-0004-00008872 ok
A-0002-00006871 ok
A-0002-00004682 ok
A-1096-00008154 ok
A-0001-00000002 ok
