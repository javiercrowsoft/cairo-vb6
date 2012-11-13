delete hoja where 
id in (select id from hoja group by ram_id,id having count(*) > 1)
and ram_id in (select ram_id from hoja group by ram_id,id having count(*) > 1)