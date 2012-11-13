select p.pr_id,pr_nombrecompra, prns_id,prns_codigo,p.creado
from productonumeroserie p inner join producto pr on p.pr_id = pr.pr_id
where not exists (select prns_id from stockitem where prns_id = p.prns_id)
order by pr_nombrecompra

-- select pr_nombrecompra,p.* from productonumeroserie p inner join producto pr on p.pr_id = pr.pr_id
-- where prns_codigo = '3390873'

-- select * from producto where pr_id = 676
