select ps.pr_id, prns_id, pr_nombrecompra, prns_codigo from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id where exists(select * from stockitem where prns_id = ps.prns_id and pr_id <> ps.pr_id)

/*

select pr_nombrecompra from producto where pr_id = 601


select * from stockitem where prns_id = 1101

update productonumeroserie set pr_id = 623, pr_id_kit = 623 where prns_id = 2033


update stockitem set pr_id_kit = ps.pr_id, pr_id = ps.pr_id from productonumeroserie ps 
where stockitem.prns_id = ps.prns_id and ps.prns_id = 1230

*/