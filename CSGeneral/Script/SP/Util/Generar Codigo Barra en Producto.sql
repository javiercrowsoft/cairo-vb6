select max(pr_id) from producto

update producto set pr_codigobarra = substring('0000',1,4-len(convert(varchar(4),pr_id)))+convert(varchar(4),pr_id) from producto