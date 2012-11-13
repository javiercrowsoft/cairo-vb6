select
distinct
sti_id,
pr_nombrecompra,
ppk_fecha,
ppk.ppk_id,
ppki_id,
ppki_cantidad,
sti_ingreso,
sti_salida

from parteprodkit ppk inner join parteprodkititem ppki on ppk.ppk_id = ppki.ppk_id
inner join productokit prk on ppki.prfk_id = prk.prfk_id and pr_id_item in (2063)
inner join stockitem sti on ppk.st_id2 = sti.st_id and sti.pr_id in (2063)
inner join producto pr on sti.pr_id = pr.pr_id

where ppk.ppk_id in (

select

ppk.ppk_id

from parteprodkit ppk 
where

exists(
select * 
from parteprodkititem ppki 
inner join productokit prk on ppki.prfk_id = prk.prfk_id and pr_id_item in (2063)
where ppk_id = ppk.ppk_id
)
and
(select sum(ppki_cantidad*prk_cantidad)
from parteprodkititem ppki 
inner join productokit prk on ppki.prfk_id = prk.prfk_id and pr_id_item in (2063)
where ppk_id = ppk.ppk_id
)>
(select sum(sti_ingreso)
from stockitem sti where ppk.st_id2 = sti.st_id and sti.pr_id in (2063)
)

--group by ppk.ppk_id,ppki_cantidad*prk_cantidad having sum(sti_ingreso) <> ppki_cantidad*prk_cantidad

)
and sti_ingreso = 0 and sti_salida = 0
order by ppk.ppk_id,ppki_id,sti_ingreso, sti_salida