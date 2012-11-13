select 'pedidos',count(*) from pedidoventa where pv_fecha >= '20091201'
select 'ventas',cmiea_nombre,count(*) 

from comunidadinternetmail c inner join comunidadinternetemailaccount a on c.cmiea_id = a.cmiea_id
where cmie_body_html like '%has vendido%' or cmie_body_plain like '%has vendido%' 
group by cmiea_nombre

select 'respuestas',cmie_account,cmir_from,count(*) 
from comunidadinternetrespuesta r inner join comunidadinternetmail m on r.cmie_id = m.cmie_id
group by cmie_account,cmir_from

select 'mails', count(*) from comunidadinternetmail

--sp_col comunidadinternetmail

/*
--sp_col comunidadinternetmail

select cmiea_nombre, c.* 
from comunidadinternetmail c inner join comunidadinternetemailaccount a on c.cmiea_id = a.cmiea_id
where (cmie_body_html like '%has vendido%' or cmie_body_plain like '%has vendido%')
and not exists(select * from comunidadinternetrespuesta where cmie_id = c.cmie_id)
order by 1

select cmiea_nombre, c.* 
from comunidadinternetmail c inner join comunidadinternetemailaccount a on c.cmiea_id = a.cmiea_id
where (cmie_body_html like '%has vendido%' or cmie_body_plain like '%has vendido%')
and exists(select * from comunidadinternetrespuesta where cmie_id = c.cmie_id)
order by 1
*/