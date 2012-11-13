select * from tasaimpositiva where ti_nombre = 'IVA COMPRA 10.5'

select * from producto where ti_id_ivariventa=23

select distinct ti_id,ti_nombre from producto pr inner join tasaimpositiva ti on pr.ti_id_ivariventa = ti.ti_id

select ti_nombre,pr_nombreventa from producto pr inner join tasaimpositiva ti on pr.ti_id_ivariventa = ti.ti_id

where ti_id_ivariventa in (23,26,12,24,31,11)
