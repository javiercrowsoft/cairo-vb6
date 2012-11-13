select 	fv_id, 
				fv_fecha, 
				fv_numero,  
				fv_total,
				(select sum(asi_debe) from asientoitem where as_id = fv.as_id),
				est_id

from facturaventa fv 
where abs(abs(fv_total) - (select sum(asi_debe) from asientoitem where as_id = fv.as_id))>0.05
	and est_id <> 7

	and doct_id <> 7 -- Sin notas de credito

	-- No hay descuentos
	--
	and not exists(select * 
                 from asientoitem asi inner join cuenta cue on asi.cue_id = cue.cue_id
                 where as_id = fv.as_id 
										and cuec_id <> 4 and asi_debe <> 0
								)

select 	fv_id, 
				fv_fecha, 
				fv_numero,  
				fv_total,
				(select sum(asi_debe) from asientoitem where as_id = fv.as_id),
				est_id

from facturaventa fv 
where abs(abs(fv_total) - (select sum(asi_debe) from asientoitem where as_id = fv.as_id))>0.05
	and est_id <> 7

	and doct_id = 7 -- Sin notas de credito

	-- No hay descuentos
	--
	and not exists(select * 
                 from asientoitem asi inner join cuenta cue on asi.cue_id = cue.cue_id
                 where as_id = fv.as_id 
										and cuec_id <> 4 and asi_haber <> 0
								)


select * from facturaventa fv
where not exists(select * 
                 from asientoitem asi inner join cuenta cue on asi.cue_id = cue.cue_id
                 where as_id = fv.as_id 
										and cuec_id = 4
								)
and est_id <> 7
