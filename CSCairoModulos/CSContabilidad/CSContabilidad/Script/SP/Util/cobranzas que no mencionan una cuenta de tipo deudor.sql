select * from cobranza cobz
where not exists(select * 
                 from asientoitem asi inner join cuenta cue on asi.cue_id = cue.cue_id
                 where as_id = cobz.as_id 
                    and cuec_id = 4
                )
and est_id <> 7

select sum(asi_debe) 
from asientoitem asi inner join facturaventa fv on asi.as_id = fv.as_id
                     inner join cuenta cue on asi.cue_id = cue.cue_id
where cuec_id <> 4
  and fv_fecha between '20060501' and '20070430'
  and fv.emp_id = 1
  and doct_id <> 7
  and est_id <> 7

select sum(asi_haber) 
from asientoitem asi inner join facturaventa fv on asi.as_id = fv.as_id
                     inner join cuenta cue on asi.cue_id = cue.cue_id
where cuec_id <> 4
  and fv_fecha between '20000501' and '20070430'
  and fv.emp_id = 1
  and doct_id = 7
  and est_id <> 7

-- select * from cuentacategoria