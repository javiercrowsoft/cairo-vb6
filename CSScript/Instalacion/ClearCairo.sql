set nocount on


-- Para controlar mirar los comentarios de abajo

exec sp_tmpdelete

update ProductoNumeroSerie set prsk_id = null, stl_id = null

go 
delete ProductoSerieKitItem
go
delete ProductoSerieKitItemTMP
go
delete ProductoSerieKitBorradoTMP
go
delete ProductoSerieKitTMP
go
delete ProductoSerieKit

go
delete ordenremitoventa

update productonumeroserie set ppk_id = null
go
delete parteprodkititema
go
delete parteprodkititemaTMP

go
delete EncuestaPreguntaItem
go
delete EncuestaDepartamento
go
delete EncuestaPregunta
go
delete EncuestaRespuesta
go
delete EncuestaWebSeccion
go
delete Encuesta

update permiso set modifico = 1
update talonario set modifico = 1

update reporte set modifico = 1, us_id = 1
update informe set modifico = 1
update arbol set modifico = 1
update rama set modifico = 1
update usuario set prs_id=null

go
delete ClienteCuentaGrupo

update facturacompra set st_id = null
update facturaventa set st_id = null
update remitocompra set st_id = null
update remitoventa set st_id = null
update recuentostock set st_id1 = null, st_id2= null
update parteprodkit set st_id1 = null, st_id2= null
update importaciontemp set st_id = null

update depositobanco set as_id = null
update movimientofondo set as_id = null
update facturacompra set as_id = null
update facturaventa set as_id = null
update cobranza set as_id = null
update ordenpago set as_id = null

go
delete asientoitem
go
delete asiento

update cheque set mf_id = null
go
delete movimientofondoitem
go
delete movimientofondo

go
delete depositobancoitem
go
delete depositobanco

go
delete RetencionItem
go
delete Retencion

go
delete presupuestopedidoventa
go
delete presupuestoventaitem
go
delete presupuestoventa

go
delete pedidoventaitem
go
delete pedidoventa


go
delete recuentostockitem
go
delete recuentostock

go
delete ProductoBOMElaborado
go
delete ProductoBOMItemA
go
delete ProductoBOMItem
go
delete ProductoBOM
go
delete ImportacionTempGarantia
go
delete ImportacionTempItem
go
delete ImportacionTemp
go
delete garantia

go
delete productokititema
go
delete productokit
go
delete productoformulakit
go
delete stockcache
go
delete usuarioempresa

go
delete ProductoKitItemA
update cliente set trans_id = null
update transporte set prov_id = null
update cliente set ven_id = null
update vendedor set us_id = null
update producto set rub_id = null
update tarea set rub_id = null
update alarma set rub_id = null

go
delete persona
go
delete reporteformulario where doc_id is not null
go
delete parteprodkititem
go
delete parteprodkit
go
delete stockitemkit
go
delete stockitem
update remitoventa set st_id_consumoTemp = null, st_id_consumo = null, st_id_producido = null
update ordenservicio set st_id = null
update partereparacion set st_id = null
update stockproveedor set st_id = null
update stockcliente set st_id = null
go
delete stock
go
delete documentofirma
go
delete TipoOperacionCuentaGrupo
update documento set cueg_id = null
update producto set cueg_id_compra = null, cueg_id_venta = null
go
delete cuentagrupo
go
delete productokit
update remitoventaitem set stl_id = null
update facturaventaitem set stl_id = null
update remitocompraitem set stl_id = null
update facturacompraitem set stl_id = null
go
delete stocklote
update tarea set prns_id = null
go
delete remitoventaitem
go
delete ParteReparacionitem
go
delete ParteReparacion
go
delete OrdenServicioSerie
go
delete OrdenServicioItem
go
delete productonumeroserie
go
delete ProductoCliente
go
delete producto

go
delete rubrotablaitem
go
delete rubrotabla
go
delete rubro

go
delete tasaimpositiva
go
delete tarjetacreditocuota
go
delete tarjetacredito
go
delete percepciontipo
go
delete retenciontipo
go
delete cuenta
update tarea set ali_id = null
go
delete EquipoDetalleItem
go
delete EquipoDetalle
go
delete AlarmaFecha
go
delete AlarmaDiaMes
go
delete AlarmaDiaSemana
go
delete alarmaitem
go
delete alarma
go
delete departamento
go
delete OrdenRemitoCompra
go
delete PedidoOrdenCompra
go
delete OrdenFacturaCompra

go
delete empresaclientedeuda
go
delete empresaproveedordeuda
go
delete ListaDescuentoProveedor
go
delete ListaPrecioProveedor

go
delete cobranzaitem
go
delete ordenpagoitem
go
delete cheque
go
delete cobranza
go
delete RemitoFacturaCompra
go
delete remitocompraitem
go
delete facturacompraitem
go
delete facturacompralegajo
go
delete facturacompra
go
delete asientoitem
go
delete asiento

go
delete StockItem

go
delete StockCache
update tarea set cont_id = null
update OrdenServicio set cont_id = null
go
delete contacto
go
delete proyectoprecio

go
delete FacturaCompraOrdenPago
go
delete FacturaVentaCobranza

go
delete FacturaVentaNotaCredito
go
delete FacturaCompraNotaCredito

go
delete FacturaVentaDeuda
go
delete FacturaVentaPago

go
delete FacturaCompraDeuda
go
delete FacturaCompraPago

go
delete EmpresaCliente
go
delete ListaPrecioLista
go
delete PedidoVentaItemStock
go
delete RemitoFacturaVenta
go
delete PedidoOrdenCompra
go
delete ProyectoTareaEstado
go
delete UsuarioDepartamento
go
delete PedidoRemitoVenta
go
delete PedidoFacturaVenta

go
delete historia
go
delete pedidoventaitem
go
delete pedidoventa
go
delete facturaventaitem
go
delete FacturaVentaPercepcion
go
delete facturaventa
go
delete remitoventaitem
go
delete remitoventa

go
delete packinglistitem
go
delete packinglist

go
delete pedidocompraitem
go
delete pedidocompra
go
delete ordencompraitem
go
delete ordencompra
go
delete ordencompraitemborradotmp
go
delete ordencompraitemtmp
go
delete ordencompratmp


go
delete facturacompraitem
go
delete facturacompra
go
delete remitocompraitem
go
delete remitocompra
go
delete hora
update ordenservicioitem set tar_id = null
update ordenservicio set tar_id = null
go
delete tarea
go
delete pedidoventaitemtmp
go
delete pedidoventatmp
go
delete pedidoventaitem
go
delete pedidoventa
update proveedor set lp_id = null
go
delete listaprecioitem
go
delete listapreciocliente
update cliente set lp_id = null
update cliente set ld_id = null

update ordenservicio set clis_id = null
update proyecto set cli_id = null
update ordenservicio set proy_id = null
go
delete despachoimpcalculoitem
go
delete despachoimpcalculo
update cliente set us_id = null
update proveedor set us_id = null
update usuario set suc_id = null where us_id <> 1
update proveedor set ld_id = null
go
delete listaprecio
go
delete listadescuentoitem
go
delete listadescuento
go
delete listadescuentocliente
go
delete empresausuario
go
delete usuariorol where rol_id <> 1
go
delete permiso where rol_id <> 1
go
delete rol where rol_id <> 1
update arbol set modifico = 1
update cuentacategoria set modifico = 1
update rama set modifico = 1
update rol set modifico = 1
update historia set modifico = 1
update documentotipo set modifico = 1
update documento set modifico = 1
go
delete clientecachecredito
go
delete clientesucursal
go
delete ClientePercepcion

go
delete ordenservicioitem
go
delete ordenservicio
update depositologico set cli_id = null
go
delete stockcliente
go
delete cliente
go
delete objetivo
go
delete proyectoitem
go
delete proyecto
update reporte set modifico = 1
update reporte set us_id = 1
update informe set modifico = 1
update documentofirma set modifico = 1
update documentofirma set us_id = 1
go
delete documentofirma where us_id <> 1
update informeparametro set modifico = 1
update tarjetacredito set modifico = 1
update afipesquema set modifico = 1
update afipparametro set modifico = 1
update tasaimpositiva set modifico = 1
update afipregistro set modifico = 1
update hoja set modifico = 1
update moneda set modifico = 1
update pais set modifico = 1
update afiparchivo set modifico = 1
update provincia set modifico = 1
go
delete proveedorcai
go
delete reina
go
delete retencion
go
delete empresaproveedor
go
delete proveedorcachecredito
go
delete percepcionitem
go
delete percepcion
go
delete chofer
go
delete camion
go
delete transporte
go
delete ProveedorRetencion
go
delete ProductoProveedor
go
delete stockproveedor 
update depositologico set prov_id = null
go
delete proveedor
go
delete vendedor
go
delete documento
go
delete gridviewcolumn
go
delete gridviewgrupo
go
delete gridviewformula
go
delete gridviewfiltro
go
delete gridviewformato
go
delete gridview
go
delete usuario where us_id <> 1


go
delete ordenpago
go
delete documento
go
delete talonario
go
delete configuracion where emp_id <> 1 and emp_id is not null
go
delete depositologico where depf_id >0
go
delete depositofisico where depf_id >0
go
delete empresa where emp_id <> 1
go
delete chequera
go
delete marca
go
delete calidad
update tarea set rub_id = null
go
delete rubrotablaitem
go
delete rubrotabla
go
delete zona
go
delete cobrador
go
delete reglaliquidacion
go
delete partediario
go
delete legajo
go
delete puerto
go
delete ciudad
go
delete contacto
go
delete centrocosto

go
delete condicionpagoitem where cpg_id = 6
go
delete condicionpagoitem where cpg_id = 7
go
delete condicionpago where cpg_id = 6
go
delete condicionpago where cpg_id = 7


exec sp_PrestacionClean

go
delete usuariorol where us_id = 66
go
delete sucursal where suc_id <> 1

go
delete documentodigital where dd_nombre <> 'LOGOCHICO##_1' and dd_nombre <> 'LOGOGRANDE##_1'

go
delete webarticulo

go
delete configuracion where cfg_aspecto not in (
'Version', 
'Grabar Asiento', 
'Decimales Cantidad', 
'Decimales Importe', 
'SP Stock', 
'Tipo Control Stock',
'Cobranza-Grabar Asiento', 
'DepositoBanco-Grabar Asiento',
'DepositoCupon-Grabar Asiento',
'MovimientoFondo-Grabar Asiento',
'OrdenPago-Grabar Asiento',
'Rendicion-Grabar Asiento',
'ResolucionCupon-Grabar Asiento',
'Tratamiento del Iva'
)

go
delete monedaitem

exec sp_iddelete

go
delete cdromarchivo
go
delete cdromcarpeta
go
delete cdrom


go
delete hoja where ram_id in (select ram_id from rama where ram_id_padre <> 0)
go
delete rama where ram_id_padre <> 0
update arbol set arb_nombre = tbl_nombre from tabla where arbol.tbl_id = tabla.tbl_id
update rama set ram_nombre = arb_nombre from arbol where rama.arb_id = arbol.arb_id and ram_id <> 0



/*

para control

--select 'select * from ' + name from sysobjects where xtype = 'u'

select * from cobranza
select * from ordenpago
select * from facturacompra
select * from facturaventa
select * from pedidoventa
select * from pedidocompra
select * from ordencompra
select * from remitocompra
select * from remitoventa
select * from movimientofondo
select * from depositobanco
select * from cheque
select * from stock
select * from parteprodkit
select * from recuentostock
select * from depositofisico
select * from depositologico
select * from departamento
select * from empresa
select * from usuario
select * from rol
select * from cliente
select * from proveedor
select * from cuenta
select * from cuentagrupo
select * from circuitocontable
select * from centrocosto
select * from marca
select * from packinglist
select * from documento
select * from producto
select * from productokit
*/