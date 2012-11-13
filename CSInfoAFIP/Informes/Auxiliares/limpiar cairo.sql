--select * from sysmodulo
-- delete sysmodulo where sysm_id not in(
-- 41,
-- 42,
-- 1016,
-- 8002,
-- 8001,
-- 1007,
-- 1020,
-- 9001,
-- 6001
-- )
--select * from usuario



update afiparchivo set modifico = 7
update pais set modifico = 7
delete cliente
delete tarea
delete objetivo
delete proyectoitem
delete proyecto

update reporte set us_id = 7
update reporte set modifico = 7


update informe set modifico = 7
update informeparametro set modifico = 7

delete listadescuentocliente
delete clientesucursal
update arbol set modifico = 7
update cliente set modifico = 7
update afipregistro set modifico = 7
update rol set modifico = 7
update cuentacategoria set modifico = 7
update rama set modifico = 7
update afipesquema set modifico = 7
update tarjetacredito set modifico = 7
delete hora 
update usuariorol set modifico = 7
update arbol set modifico = 7
update permiso set modifico = 7
delete historia
update documentotipo set modifico = 7
update provincia set modifico = 7
--delete proveedor
update afipparametro set modifico = 7
update tasaimpositiva set modifico = 7
update moneda set modifico = 7
update hoja set modifico = 7
delete tarea
delete listaprecioitem
delete listapreciocliente
delete listaprecio
delete proveedorcai
delete usuario where us_id <> 7 
