/*

este reporte permite ver que cuentas de acreedores se usaron el circuito de compras

hay que terminarlo

faltan todos los parametros

se hizo para encontrar diferencias en salmax entre los totales de la cuenta corriente y

los mayores de las cuentas de proveedores

*/


select cue_nombre, sum(asi_debe-asi_haber) 

from asientoitem asi inner join cuenta cue on asi.cue_id = cue.cue_id

where 
asi_tipo = 2
and as_id in (

	select as_id from facturacompra where doc_id in (select doc_id from documento where cico_id in (1,3,7)))

group by cue_nombre


select cue_nombre, sum(asi_debe-asi_haber) 

from asientoitem asi inner join cuenta cue on asi.cue_id = cue.cue_id
										 inner join ordenpago opg on 			asi.as_id = opg.as_id
										 inner join ordenpagoitem opgi on opg.opg_id = opgi.opg_id
																									and opgi_tipo = 5
																									and asi.cue_id = opgi.cue_id

where 
 asi.as_id in (

	select as_id from ordenpago where doc_id in (select doc_id from documento where cico_id in (1,3,7)))

group by cue_nombre

--select * from ordenpagoitem