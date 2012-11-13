--select * from bancoconciliacion where bcoc_id = 13

select *, bcoci_debe-bcoci_haber as importe
from bancoconciliacionitem 
where asi_id not in (select asi_id from asientoitem) and bcoc_id = 13
order by importe


-----------------------------------------------------------------------------------------------


select as_fecha,as_nrodoc, as_doc_cliente,doct_id_cliente,doc_id_cliente,id_cliente,
       asi_debe-asi_haber as importe
from asiento ast inner join asientoitem asi on ast.as_id = asi.as_id and asi.cue_id = 510
								 left join cheque cheq on asi.cheq_id = cheq.cheq_id
where 
	ast.as_id in (
								select asi.as_id 
								from asientoitem asi left join cheque cheq on asi.cheq_id = cheq.cheq_id
								where asi.cue_id = 510 
									and asi_id not in (
																			select asi_id from bancoconciliacionitem where bcoc_id = 13
																		) 
									and isnull(cheq_fecha2,as_fecha) <= '20080407'--2008-04-07 00:00:00.000

						)
	and isnull(cheq_fecha2,as_fecha) <= '20080407'--2008-04-07 00:00:00.000
order by importe 