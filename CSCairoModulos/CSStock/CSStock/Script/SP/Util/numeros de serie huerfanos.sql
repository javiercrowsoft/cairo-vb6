select pr_nombrecompra, ps.prns_id, ps.creado
from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id
where not exists (select * from stockitem where prns_id = ps.prns_id)
