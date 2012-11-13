select 
arb_id+242 as arb_id,
arb_nombre,
modificado,
creado,
tbl_Id,
modifico
from arbol where arb_id = 180
/n
select 
ram_id+81850 as ram_id,
ram_nombre,
arb_id+242 as arb_id,
modificado,
creado,
modifico,
case when ram_id_padre is null then null when ram_id_padre = 0 then 0 else ram_id_padre+81850 end as ram_id_padre,
ram_orden
from rama where arb_id = 180
order by isnull(ram_id_padre,0),ram_orden
/n
select 
hoja_id+100112 as hoja_id,
id,
modificado,
creado,
modifico,
ram_id+81850 as ram_id,
arb_id+242 as arb_id
from hoja where arb_id = 180

--sp_col hoja