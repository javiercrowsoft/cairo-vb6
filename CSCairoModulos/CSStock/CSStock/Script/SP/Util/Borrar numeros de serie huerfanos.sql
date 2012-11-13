delete productonumeroserie where prns_id in (

select ps.prns_id
from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id and pr_eskit <> 0 and pr_id_kit is null
and not exists (select * from stockitem where prns_id = ps.prns_id)


)



delete stockcache where prns_id in (

select ps.prns_id
from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id and pr_eskit <> 0 and pr_id_kit is null
and not exists (select * from stockitem where prns_id = ps.prns_id)


)

