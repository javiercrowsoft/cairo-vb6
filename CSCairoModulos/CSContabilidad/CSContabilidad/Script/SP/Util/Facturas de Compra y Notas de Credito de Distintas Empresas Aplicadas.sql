select * from facturacompra fc 

inner join documento doc on fc.doc_id = doc.doc_id
inner join facturacompranotacredito fcnc on fc.fc_id = fcnc.fc_id_factura
inner join facturacompra nc on fcnc.fc_id_notacredito = nc.fc_id
inner join documento docnc on nc.doc_id = docnc.doc_id

where doc.emp_id <> docnc.emp_id