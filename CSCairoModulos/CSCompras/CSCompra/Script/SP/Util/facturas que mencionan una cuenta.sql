select * from facturacompra where as_id in (select as_id from asientoitem where cue_id = 263)

select cue_id from cuenta where cue_nombre like '%venta de racla%'