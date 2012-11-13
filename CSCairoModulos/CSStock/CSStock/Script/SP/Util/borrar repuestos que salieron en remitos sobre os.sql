/*
delete stockitem where sti_id in (
select sti_id
from stockitem sti inner join remitoventa rv on sti.st_id = rv.st_id
									 inner join producto pr    on sti.pr_id = pr.pr_id
									 inner join documento doc  on rv.doc_id = doc.doc_id
where pr_esrepuesto <> 0
	and doc_rv_desde_os <> 0
)
*/

select pr.pr_nombrecompra,sti_ingreso,rv_fecha 
from stockitem sti inner join remitoventa rv on sti.st_id = rv.st_id
									 inner join producto pr    on sti.pr_id = pr.pr_id
									 inner join documento doc  on rv.doc_id = doc.doc_id
where pr_esrepuesto <> 0
	and doc_rv_desde_os <> 0
