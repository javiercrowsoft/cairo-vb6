select sti_id from stockitem sti inner join Remitoventa rv on rv.st_id = sti.st_id
inner join producto pr on sti.pr_id = pr.pr_id and pr_esrepuesto <> 0
inner join documento doc on rv.doc_id = doc.doc_id and doc_rv_desde_os <> 0