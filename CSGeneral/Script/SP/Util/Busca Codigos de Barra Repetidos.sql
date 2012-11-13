select pr_codigobarra 
from producto 
where pr_codigobarra <> '' 
group by pr_codigobarra having count(*)>1