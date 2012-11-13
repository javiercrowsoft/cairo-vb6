select inf_codigo,inf_storedprocedure,inf_nombre,count(inf.inf_id)+1,(select count(name) from syscolumns where id = s.id)
from sysobjects s inner join informe inf on s.name = inf.inf_storedprocedure
                  left join informeparametro infp on inf.inf_id = infp.inf_id
group by 
inf_codigo,inf_storedprocedure,inf_nombre,s.id 
having count(infp.inf_id)+1 <> (select count(name) from syscolumns where id = s.id)
order by inf_codigo

