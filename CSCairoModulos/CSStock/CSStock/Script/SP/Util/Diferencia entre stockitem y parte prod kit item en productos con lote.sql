select

ppk.ppk_id,

(select sum(ppki_cantidad*prk_cantidad)
from parteprodkititem ppki 
inner join productokit prk on ppki.prfk_id = prk.prfk_id and pr_id_item in (select pr_id from producto where pr_llevanrolote <> 0)
where ppk_id = ppk.ppk_id
) as kit,
(select sum(sti_ingreso)
from stockitem sti where ppk.st_id2 = sti.st_id and sti.pr_id in (select pr_id from producto where pr_llevanrolote <> 0)
) as stock


from parteprodkit ppk 
where

exists(
select * 
from parteprodkititem ppki 
inner join productokit prk on ppki.prfk_id = prk.prfk_id and pr_id_item in (select pr_id from producto where pr_llevanrolote <> 0)
where ppk_id = ppk.ppk_id
)
and
(select sum(ppki_cantidad*prk_cantidad)
from parteprodkititem ppki 
inner join productokit prk on ppki.prfk_id = prk.prfk_id and pr_id_item in (select pr_id from producto where pr_llevanrolote <> 0)
where ppk_id = ppk.ppk_id
)>
(select sum(sti_ingreso)
from stockitem sti where ppk.st_id2 = sti.st_id and sti.pr_id in (select pr_id from producto where pr_llevanrolote <> 0)
)
