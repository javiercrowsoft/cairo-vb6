select as_fecha, asi.as_id, sum(asi_debe)-sum(asi_haber) 
from asientoitem asi inner join asiento ast on asi.as_id = ast.as_id
group by asi.as_id, as_fecha
having abs(sum(asi_debe)-sum(asi_haber))>0.02

select * from asientoitem asi where not exists(select * from cuenta where cue_id = asi.cue_id)
select * from cuenta where cue_codigo = '111100'
select * from asiento where as_id in (82023,
82061,
85789
)
update asientoitem set cue_id = 153 where asi_id in (341270,
341421,
353308
)
