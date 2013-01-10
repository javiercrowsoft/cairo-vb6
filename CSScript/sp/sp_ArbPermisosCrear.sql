if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbPermisosCrear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbPermisosCrear]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ArbPermisosCrear.sql
' Objetivo: Crear el arbol de permisos
'-----------------------------------------------------------------------------------------
*/

/*

select * from arbol order by arb_id

sp_ArbPermisosCrear
sp_columns prestacion
alter table prestacion alter column pre_grupo varchar(255) not null
alter table prestacion alter column pre_grupo1 varchar(255) not null
alter table prestacion alter column pre_grupo2 varchar(255) not null
alter table prestacion alter column pre_grupo3 varchar(255) not null
alter table prestacion alter column pre_grupo4 varchar(255) not null
alter table prestacion alter column pre_grupo5 varchar(255) not null
alter table prestacion alter column pre_nombre varchar(255) not null
alter table rama alter column ram_nombre varchar(255) not null

select * from prestacion where pre_nombre like '%aplicacion%'

*/
create Procedure sp_ArbPermisosCrear

as

begin

  set nocount on

  update prestacion set pre_grupo = '', pre_grupo3 = '', pre_grupo4 = '' where pre_id < 16020000

  update prestacion set pre_nombre = 'Modificar Aplicación de Tesoreria' where pre_id = 18013  
  update prestacion set pre_nombre = 'Modificar Aplicación de Ventas' where pre_id = 16014  
  update prestacion set pre_nombre = 'Modificar Aplicación de Compras' where pre_id = 17020  
  update prestacion set pre_nombre = 'Modificar Aplicación de Exportación' where pre_id = 22026

  update prestacion set pre_nombre = 'Listar Usuarios'where pre_id = 10
  update prestacion set pre_nombre = 'Agregar Usuarios' where pre_id = 11
  update prestacion set pre_nombre = 'Modificar Usuarios' where pre_id = 12
  update prestacion set pre_nombre = 'Eliminar Usuarios' where pre_id = 13
  update prestacion set pre_nombre = 'Listar Roles' where pre_id = 14
  update prestacion set pre_nombre = 'Agregar Roles' where pre_id = 15
  update prestacion set pre_nombre = 'Modificar Roles' where pre_id = 16
  update prestacion set pre_nombre = 'Eliminar Roles' where pre_id = 17
  update prestacion set pre_nombre = 'Listar Arboles' where pre_id = 1
  update prestacion set pre_nombre = 'Listar Arboles' where pre_id = 2
  update prestacion set pre_nombre = 'Listar Arboles' where pre_id = 3
  update prestacion set pre_nombre = 'Listar Ramas' where pre_id = 4
  update prestacion set pre_nombre = 'Listar Ramas' where pre_id = 5
  update prestacion set pre_nombre = 'Listar Ramas' where pre_id = 6
  update prestacion set pre_nombre = 'Listar Ramas' where pre_id = 7

  update prestacion set pre_nombre = 'Editar Configuración General', pre_grupo2='General' where pre_id = 1156
  update prestacion set pre_nombre = 'Editar Configuración General de Ventas', pre_grupo2='Ventas' where pre_id = 1173
  update prestacion set pre_grupo2='Ventas' where pre_id = 1998
  update prestacion set pre_grupo2='Ventas' where pre_id = 1996

  update prestacion set pre_nombre = 'Editar Configuración General de Tesoreria', pre_grupo2='Tesoreria' where pre_id = 1174

  update prestacion set pre_nombre = 'Editar Configuración General de Compras', pre_grupo2='Compras' where pre_id = 1175
  update prestacion set pre_grupo2='Compras' where pre_id = 1997

  update prestacion set pre_nombre = 'Editar Configuración General de Stock', pre_grupo2='Stock' where pre_id = 1999
  update prestacion set pre_nombre = 'Editar Configuración General de Envios', pre_grupo2='Envios' where pre_id = 15009
  update prestacion set pre_nombre = 'Editar Configuración General de Exportación', pre_grupo2='Exportación' where pre_id = 22037

  update prestacion set pre_nombre = 'Editar Configuración General de Servicios', pre_grupo2='Servicios' where pre_id = 1979
  update prestacion set pre_nombre = 'Editar Configuración General de Contabilidad', pre_grupo2='Contabilidad' where pre_id = 1988


  update prestacion set pre_nombre = 'Editar Contactos Publicos' where pre_id = 2024
  update prestacion set pre_nombre = 'Agregar Reglas de Liquidación' where pre_id = 1060
  update prestacion set pre_nombre = 'Editar Reglas de Liquidación' where pre_id = 1061
  update prestacion set pre_nombre = 'Borrar Reglas de Liquidación' where pre_id = 1062
  update prestacion set pre_nombre = 'Listar Reglas de Liquidación' where pre_id = 1063
  update prestacion set pre_nombre = 'Agregar Condiciónes de Pago' where pre_id = 1148
  update prestacion set pre_nombre = 'Editar Condiciónes de Pago' where pre_id = 1149
  update prestacion set pre_nombre = 'Borrar Condiciónes de Pago' where pre_id = 1150
  update prestacion set pre_nombre = 'Listar Condiciónes de Pago' where pre_id = 1151
  update prestacion set pre_nombre = 'Agregar Articulos' where pre_id = 1076
  update prestacion set pre_nombre = 'Editar Articulos' where pre_id = 1077
  update prestacion set pre_nombre = 'Borrar Articulos' where pre_id = 1078
  update prestacion set pre_nombre = 'Listar Articulos' where pre_id = 1079
  update prestacion set pre_nombre = 'Conceder Permisos' where pre_id = 8
  update prestacion set pre_nombre = 'Quitar Permisos' where pre_id = 9
  update prestacion set pre_nombre = 'Listar Permisos' where pre_id = 10
  update prestacion set pre_nombre = 'Procesar Proceso de Importación' where pre_id = 23005

  update prestacion set pre_grupo2 = 'Sistema' where pre_nombre like '%sysmodulo%' and pre_id < 1000
  update prestacion set pre_grupo2 = 'Sistema' where pre_nombre like '%tabla%' and pre_id < 1000
  update prestacion set pre_grupo2 = 'Seguridad' where pre_nombre like '%Usuarios' and pre_id < 1000
  update prestacion set pre_grupo2 = 'Seguridad' where pre_nombre like '%Roles' and pre_id < 1000
  update prestacion set pre_grupo2 = 'Arboles' where pre_nombre like '%Arboles' and pre_id < 1000
  update prestacion set pre_grupo2 = 'Arboles' where pre_nombre like '%Ramas' and pre_id < 1000

  update prestacion set pre_grupo2 = 'AFIP' where pre_nombre like '%afip%' and pre_id between 6000 and 6999
  update prestacion set pre_grupo2 = 'AFIP' where pre_nombre like '%proveedor%' and pre_id between 8000 and 8999
  update prestacion set pre_grupo2 = 'AFIP' where pre_nombre like '%cais%' and pre_id between 8000 and 8999

  update prestacion set pre_grupo2 = 'Contabilidad' where pre_nombre like '%cuenta%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Contabilidad' where pre_nombre like '%tasas%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Contabilidad' where pre_nombre like '%centro de costo%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Contabilidad' where pre_nombre like '%circuito con%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Contabilidad' where pre_nombre like '%percepcion%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Contabilidad' where pre_nombre like '%retencion%' and pre_id between 1000 and 1999

  update prestacion set pre_grupo2 = 'Documentos' where pre_nombre like '%talonario%' and pre_id between 4000 and 4999
  update prestacion set pre_grupo2 = 'Documentos' where pre_nombre like '%documento%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Documentos' where pre_nombre like '%fechas de control%' and pre_id between 4000 and 4999
  update prestacion set pre_grupo2 = 'Documentos' where pre_nombre like '%documento%' and pre_id between 4000 and 4999

  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%gasto%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%banco%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%moneda%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%tipo de operación%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%condiciones de pago%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%clearing%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%chequera%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Tesoreria' where pre_nombre like '%tarjeta de credito%' and pre_id between 1000 and 1999

  update prestacion set pre_grupo2 = 'Stock' where pre_nombre like '%deposito%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Stock' where pre_nombre like '%trans%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Stock' where pre_nombre like '%chofer%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Stock' where pre_nombre like '%camion%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Stock' where pre_nombre like '%Lote de Stock%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Stock' where pre_nombre like '%Números de Serie%' and pre_id between 1000 and 1999

  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%vendedor%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%cliente%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%sucursal cliente%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%zona%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%reglas de liq%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%cobrador%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%contacto%' and pre_id between 2000 and 2999
  update prestacion set pre_grupo2 = 'Ventas' where pre_nombre like '%importar%remitos%' and pre_id between 1000 and 1999

  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%escala%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%unidades%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%rubro%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%articulos%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%precio%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%marca%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%embalaje%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%calidad%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%descuento%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Articulos' where pre_nombre like '%formula%kit%' and pre_id between 1000 and 1999

  update prestacion set pre_grupo2 = 'Compras' where pre_nombre like '%Proveedor%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'General' where pre_nombre like '%pais%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'General' where pre_nombre like '%provincia%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'General' where pre_nombre like '%ciudad%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'General' where pre_nombre like '%idioma%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'General' where pre_nombre like '%leyenda%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'General' where pre_nombre like '%lenguaje%' and pre_id between 14001 and 14999

  update prestacion set pre_grupo2 = 'Empresa' where pre_nombre like '%empresa%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Empresa' where pre_nombre like '%sucursal' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Empresa' where pre_nombre like '%departamento%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Empresa' where pre_nombre like '%persona%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Empresa' where pre_nombre like '%del usuario' and pre_id between 1000 and 1999

  update prestacion set pre_grupo2 = 'Informes' where pre_nombre like '%informe%' and pre_id between 7000 and 7999
  update prestacion set pre_grupo2 = 'Informes' where pre_nombre like '%reporte%' and pre_id between 7000 and 7999
  update prestacion set pre_grupo2 = 'Informes' where pre_nombre like '%parametro%' and pre_id between 7000 and 7999

  update prestacion set pre_grupo2 = 'Seguridad' where pre_nombre like '%Permisos%' and pre_id < 1000

  update prestacion set pre_grupo2 = 'Apicultura' where pre_nombre like '%alsa%' and pre_id between 11000 and 11999
  update prestacion set pre_grupo2 = 'Apicultura' where pre_nombre like '%reina%' and pre_id between 11000 and 11999
  update prestacion set pre_grupo2 = 'Apicultura' where pre_nombre like '%colmena%' and pre_id between 11000 and 11999
  update prestacion set pre_grupo2 = 'Apicultura' where pre_nombre like '%medicamento%' and pre_id between 11000 and 11999

  update prestacion set pre_grupo2 = 'Proyectos' where pre_nombre like '%tarea%' and pre_id between 2000 and 2999
  update prestacion set pre_grupo2 = 'Proyectos' where pre_nombre like '%estado%' and pre_id between 2000 and 2999
  update prestacion set pre_grupo2 = 'Proyectos' where pre_nombre like '%proyecto%' and pre_id between 2000 and 2999
  update prestacion set pre_grupo2 = 'Proyectos' where pre_nombre like '%horas%' and pre_id between 2000 and 2999
  update prestacion set pre_grupo2 = 'Proyectos' where pre_nombre like '%prioridad%' and pre_id between 2000 and 2999

  update prestacion set pre_grupo2 = 'UTHGRA' where pre_id between 32000 and 32999
  update prestacion set pre_grupo2 = 'SGR' where pre_id between 33000 and 33999

  update prestacion set pre_grupo2 = 'Proyectos' where pre_id between 16000000 and 17000000
  update prestacion set pre_grupo3 = '(*) Proyectos' where pre_id between 16000000 and 17000000

  update prestacion set pre_grupo2 = 'CDTeka' where pre_nombre like '%cdrom%' and pre_id between 5000 and 5999

  update prestacion set pre_grupo2 = 'Producción' where pre_nombre like '%maquina%' and pre_id between 13000 and 13999
  update prestacion set pre_grupo2 = 'Producción' where pre_nombre like '%B.O.M.%' and pre_id between 13000 and 13999

  update prestacion set pre_grupo2 = 'Muresco' where pre_nombre like '%muresco%' and pre_id between 24000 and 24999

  update prestacion set pre_grupo2 = 'Internet' where pre_nombre like '%webarticulo%' and pre_id between 1000 and 1999
  update prestacion set pre_grupo2 = 'Internet' where pre_nombre like '%agenda%' and pre_id between 2000 and 2999


  update prestacion set pre_grupo1 = 'Configuración'
  update prestacion set pre_grupo1 = 'Informes' where pre_id >= 1000000 and pre_id <= 15000000

  update prestacion set pre_grupo2 = inf_modulo from informe where prestacion.pre_id = informe.pre_id and prestacion.pre_id >= 1000000

  update prestacion set pre_grupo4 = inf_modulo from informe 
  where prestacion.pre_id = informe.pre_id
  and exists(select pre_id from informe where pre_id = prestacion.pre_id)

  update prestacion set pre_grupo1 = 'Departamentos' where pre_id >= 15000000 and pre_id <= 15010000
  update prestacion set pre_grupo1 = 'Agendas' where pre_id >= 15010001 and pre_id <= 15020000

  update prestacion set pre_grupo1 = 'Documento' where pre_id >= 15020001 and pre_id <= 16020000
  
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=3000 and pre_id <=3999 
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=16000 and pre_id <=16999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=28000 and pre_id <=28999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=17000 and pre_id <=17999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=18000 and pre_id <=18999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=15000 and pre_id <=15999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=19000 and pre_id <=19999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=20000 and pre_id <=20999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=21000 and pre_id <=21999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=22000 and pre_id <=22999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=23000 and pre_id <=23999

  update prestacion set pre_grupo1 = 'Documento' where pre_id >=35000 and pre_id <=35999
  update prestacion set pre_grupo1 = 'Documento' where pre_id >=37000 and pre_id <=37999

  update prestacion set pre_grupo2 = 'Ventas'                 where pre_id >=3000 and pre_id <=3999 
  update prestacion set pre_grupo2 = 'Ventas'                 where pre_id >=16000 and pre_id <=16999
  update prestacion set pre_grupo2 = 'Ventas'                 where pre_id >=28000 and pre_id <=28999
  update prestacion set pre_grupo2 = 'Compras'                where pre_id >=17000 and pre_id <=17999
  update prestacion set pre_grupo2 = 'Tesoreria'              where pre_id >=18000 and pre_id <=18999
  update prestacion set pre_grupo2 = 'Envio'                  where pre_id >=15000 and pre_id <=15999
  update prestacion set pre_grupo2 = 'Contabilidad'           where pre_id >=19000 and pre_id <=19999
  update prestacion set pre_grupo2 = 'Stock'                  where pre_id >=20000 and pre_id <=20999
  update prestacion set pre_grupo2 = 'Implementacion'         where pre_id >=21000 and pre_id <=21999
  update prestacion set pre_grupo2 = 'Comercio Exterior'       where pre_id >=22000 and pre_id <=22999
  update prestacion set pre_grupo2 = 'Importación'             where pre_id >=23000 and pre_id <=23999
  update prestacion set pre_grupo2 = 'Personal'               where pre_id >=35000 and pre_id <=35999
  update prestacion set pre_grupo2 = 'Institutos Educativos'   where pre_id >=37000 and pre_id <=37999

  update prestacion set pre_grupo2 = 'Ventas'             where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (1,3,5,7,9,11,22,24,39,42,43)
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Compras'             where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (2,4,6,8,10,12,23,25,35,36,37,38,40)
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Tesoreria'           where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (13,16,17,26,27,32,33)
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Envio'               where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id = 18
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Contabilidad'        where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id = 15
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Stock'              where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (14,28,30,34)
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Comercio Exterior'  where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (19,20,21,29)
                                                                          )
                                                                        )


  update prestacion set pre_grupo2 = 'Ventas'             where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (5,22)
                                                                          )
                                                                        )

  update prestacion set pre_grupo2 = 'Personal'    where pre_id >= 15020001 and pre_id <= 16020000
                                                            and exists(select * from Documento 
                                                                       where
                                                                          (     pre_id_new        = prestacion.pre_id
                                                                          or    pre_id_edit        = prestacion.pre_id
                                                                          or    pre_id_delete      = prestacion.pre_id
                                                                          or    pre_id_list        = prestacion.pre_id
                                                                          or    pre_id_anular      = prestacion.pre_id
                                                                          or    pre_id_desanular  = prestacion.pre_id
                                                                          or    pre_id_aplicar    = prestacion.pre_id
                                                                          or    pre_id_print      = prestacion.pre_id
                                                                          )
                                                                          and
                                                                          (
                                                                                doct_id in (47)
                                                                          )
                                                                        )


  update prestacion set pre_grupo3 = '(*)Docs - ' + emp_nombre
  from empresa emp inner join documento doc on emp.emp_id = doc.emp_id
   where pre_id >= 15020001 and pre_id <= 16020000
    and (      pre_id = pre_id_new 
          or  pre_id = pre_id_edit
          or  pre_id = pre_id_delete
          or  pre_id = pre_id_list
          or  pre_id = pre_id_anular
          or  pre_id = pre_id_desanular
          or  pre_id = pre_id_aplicar
          or  pre_id = pre_id_print)
  
  update prestacion set pre_grupo4 = replace(pre_nombre,'eliminar ','') 
  where pre_nombre like '%eliminar%' 
    and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'renombrar ','') 
  where pre_nombre like '%renombrar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'conceder ','') 
  where pre_nombre like '%conceder%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'quitar ','') 
  where pre_nombre like '%quitar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'modificar ','') 
  where pre_nombre like '%modificar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'agregar ','') 
  where pre_nombre like '%agregar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'editar ','') 
  where pre_nombre like '%editar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'listar ','') 
  where pre_nombre like '%listar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'borrar ','') 
  where pre_nombre like '%borrar%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'anular ','') 
  where pre_nombre like '%anular%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'des-anular ','') 
  where pre_nombre like '%des-anular%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'desanular ','') 
  where pre_nombre like '%desanular%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'des anular ','') 
  where pre_nombre like '%des anular%'
  and pre_id <= 16020000

  update prestacion set pre_grupo4 = replace(pre_nombre,'imprimir ','') 
  where pre_nombre like '%imprimir%'
  and pre_id <= 16020000
  
  update prestacion set pre_grupo4 = replace(pre_nombre,'cargar ','') where pre_nombre like '%cargar%'
  update prestacion set pre_grupo4 = replace(pre_nombre,'buscar ','') where pre_nombre like '%buscar%'
  update prestacion set pre_grupo4 = replace(pre_nombre,'procesar ','') where pre_nombre like '%procesar%'
  update prestacion set pre_grupo4 = replace(pre_nombre,'importar ','') where pre_nombre like '%importar%'

  update prestacion set pre_grupo4 = '' where (pre_id >= 26000 and pre_id <= 26999)

  update prestacion set pre_grupo4 = '' where pre_id >= 9999999 and pre_id <= 15020000

  update prestacion set pre_grupo4 = 'Noticias'   where pre_id >= 15000000 and pre_id <= 15020001 and pre_nombre like '%Noticias%'
  update prestacion set pre_grupo4 = 'Documentos' where pre_id >= 15000000 and pre_id <= 15020001 and pre_nombre like '%Documentos%'
  update prestacion set pre_grupo4 = 'Tareas'     where pre_id >= 15000000 and pre_id <= 15020001 and pre_nombre like '%Tareas%'
  update prestacion set pre_grupo4 = 'Agenda'     where pre_id >= 15000000 and pre_id <= 15020001 and pre_nombre like '%Agenda%'

  update prestacion set pre_grupo4 = doc_nombre
  from Documento 

  where pre_id >= 15020001 and pre_id <= 16020000
    and
        (     pre_id_new        = prestacion.pre_id
        or    pre_id_edit        = prestacion.pre_id
        or    pre_id_delete      = prestacion.pre_id
        or    pre_id_list        = prestacion.pre_id
        or    pre_id_anular      = prestacion.pre_id
        or    pre_id_desanular  = prestacion.pre_id
        or    pre_id_aplicar    = prestacion.pre_id
        or    pre_id_print      = prestacion.pre_id
        )

  update prestacion set pre_grupo1 = 'Configuración' where pre_id in (21001,
                                                                      21002,
                                                                      21003,
                                                                      21004,
                                                                      21005,
                                                                      21006,
                                                                      23001,
                                                                      23002,
                                                                      23003,
                                                                      23004,
                                                                      23005)

  update prestacion set pre_grupo4 = 'Remito de Ventas' where pre_id = 16015  -- Editar Precios en Remito de Venta
  update prestacion set pre_grupo4 = 'Factura de Ventas' where pre_id = 16016  -- Editar Precios en Factura de Venta
  update prestacion set pre_grupo4 = 'Presupuesto de ventas' where pre_id = 16023  -- Editar Precios en Presupuesto de Venta
  update prestacion set pre_grupo4 = 'Remito de Compra' where pre_id = 17039  -- Editar Precios en Remito de Compra
  update prestacion set pre_grupo4 = 'Factura de Compra' where pre_id = 17040  -- Editar Precios en Factura de Compra
  update prestacion set pre_grupo4 = 'Pedido de Compra' where pre_id = 17041  -- Editar Precios en Pedido de Compra
  update prestacion set pre_grupo4 = 'Orden de Compra' where pre_id = 17042  -- Editar Precios en Orden de Compra
  update prestacion set pre_grupo4 = 'Orden de Servicio' where pre_id = 28006  -- Editar Precios en Orden de Servicio
  update prestacion set pre_grupo4 = 'Parte de Reparacion' where pre_id = 28017  -- Editar Precios en Parte de Reparacion

  declare @arb_id int
  declare @ram_id int
  
  set @arb_id = 1
  set @ram_id = 1

  update rama set ram_id_padre = 1 where arb_id = 1 and ram_id <> 0 and ram_id <> 1
  delete hoja where arb_id = 1
  delete rama where arb_id = 1 and ram_id_padre = 1

  declare c_rama insensitive cursor for select pre_grupo1 from prestacion group by pre_grupo1 order by pre_grupo1
  open c_rama

  declare @ram_nombre varchar(500)
  declare @ram_id_padre int
  declare @orden int

  set @ram_id_padre = @ram_id
  set @orden = 1

  fetch next from c_rama into @ram_nombre
  while @@fetch_status = 0 begin

    if @ram_nombre = '' set @ram_nombre = 'Configuración'

    set @orden = @orden + 1

    exec SP_DBGetNewId 'Rama','ram_id',@ram_id out, 0
    insert into Rama (
                        ram_id,
                        ram_nombre,
                        arb_id,
                        modificado,
                        creado,
                        modifico,
                        ram_id_padre,
                        ram_orden
                      )
              values (
                        @ram_id,
                        @ram_nombre,
                        @arb_id,
                        getdate(),
                        getdate(),
                        1,
                        @ram_id_padre,
                        @orden
                      )


    ----------------------------------------------------------------------------------------------------------------

      declare c_rama2 insensitive cursor for select pre_grupo2 from prestacion where pre_grupo1 = @ram_nombre group by pre_grupo2 order by pre_grupo2
      open c_rama2
    
      declare @ram_nombre2      varchar(500)
      declare @ram_id_padre2    int
      declare @orden2           int
    
      set @ram_id_padre2 = @ram_id

      set @orden2 = 1
    
      fetch next from c_rama2 into @ram_nombre2
      while @@fetch_status = 0 begin
    
        if @ram_nombre2 <> '' begin
    
          set @orden2 = @orden2 + 1    

          exec SP_DBGetNewId 'Rama','ram_id',@ram_id out, 0
          insert into Rama (
                              ram_id,
                              ram_nombre,
                              arb_id,
                              modificado,
                              creado,
                              modifico,
                              ram_id_padre,
                              ram_orden
                            )
                    values (
                              @ram_id,
                              @ram_nombre2,
                              @arb_id,
                              getdate(),
                              getdate(),
                              1,
                              @ram_id_padre2,
                              @orden2
                            )
    
        end          

        ------------------------------------------------------------------------------------------------------------

        if exists(select pre_grupo3 from prestacion where pre_grupo2 = @ram_nombre2 and pre_grupo3 <> '')
        begin

          declare c_rama3 insensitive cursor for 

                  select pre_grupo3 from prestacion 
                  where     pre_grupo2 = @ram_nombre2 
                        and  not (@ram_nombre = 'Configuración' and pre_grupo3 like '(*)Docs -%')
                        and  not (@ram_nombre = 'Informes' and pre_grupo3 like '(*)Docs -%')
                        and  not (@ram_nombre = 'Informes' and pre_grupo3 = '(*) Proyectos')
                  group by pre_grupo3 
                  order by pre_grupo3

          open c_rama3
        
          declare @ram_nombre3      varchar(500)
          declare @ram_id_padre3    int
          declare @orden3           int
        
          set @ram_id_padre3 = @ram_id
    
          set @orden3 = 100
        
          fetch next from c_rama3 into @ram_nombre3
          while @@fetch_status = 0 begin
          
            if @ram_nombre3 <> '' begin
            
              set @orden3 = @orden3 + 1    
            
              exec SP_DBGetNewId 'Rama','ram_id',@ram_id out, 0
              insert into Rama (
                                  ram_id,
                                  ram_nombre,
                                  arb_id,
                                  modificado,
                                  creado,
                                  modifico,
                                  ram_id_padre,
                                  ram_orden
                                )
                        values (
                                  @ram_id,
                                  @ram_nombre3,
                                  @arb_id,
                                  getdate(),
                                  getdate(),
                                  1,
                                  @ram_id_padre3,
                                  @orden3
                                )
            
            end          
    
            --------------------------------------------------------------------------------------------------------
            exec sp_ArbPermisosCrear2 @ram_nombre,@ram_nombre2,@ram_nombre3,@ram_id,@arb_id
          
            fetch next from c_rama3 into @ram_nombre3
          end
        
          close c_rama3
          deallocate c_rama3

        end else begin

            exec sp_ArbPermisosCrear2 @ram_nombre,@ram_nombre2,'',@ram_id,@arb_id

        end
         ------------------------------------------------------------------------------------------------------------
    
        fetch next from c_rama2 into @ram_nombre2
      end
    
      close c_rama2
      deallocate c_rama2

    ----------------------------------------------------------------------------------------------------------------
    

    fetch next from c_rama into @ram_nombre
  end

  close c_rama
  deallocate c_rama

  update Prestacion set pre_nombre = inf_nombre +  ' ['+ inf_codigo + ']' 
  from Informe inf
  where exists (select pre_id from Informe where pre_id = Prestacion.pre_id)
    and Prestacion.pre_id = inf.pre_id

end
