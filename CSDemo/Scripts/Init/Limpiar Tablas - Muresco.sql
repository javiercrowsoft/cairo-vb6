delete UsuarioDepartamento
delete StockItemKit
delete stockcache
delete stockitem

delete productokit
update producto set marc_id = null
update proveedor set zon_id = null
update cobranzaitem set cheq_id = null
update cheque set cobz_id = null

delete PermisoEmbarqueItemBorradoTMP
delete PermisoEmbarqueItemTMP
delete PermisoEmbarqueTMP
delete PermisoEmbarqueItem
delete PermisoEmbarque
delete Aduana
delete AFIPCampo
delete AFIPRegistro
delete AFIPArchivo
delete AFIPEsquema
delete AFIPParametro
delete Alsa

delete PedidoCompraItemBorradoTMP
delete PedidoCompraItemTMP
delete PedidoCompraTMP
delete PedidoFacturaVentaTMP
delete PedidoPackingListTMP
delete PedidoRemitoVentaTMP
delete PedidoVentaItemBorradoTMP
delete PedidoVentaItemTMP
delete PedidoVentaTMP

delete pedidoremitocompra
delete PedidoRemitoVenta
delete PedidoCompraItem
delete PedidoCompra
delete PedidoFacturaVenta
delete PedidoPackingList
delete PedidoVentaItem
delete PedidoVenta

delete RemitoCompraItemSerieTMP
delete RemitoCompraItemBorradoTMP
delete RemitoCompraItemTMP
delete RemitoCompraTMP
delete RemitoFacturaCompra
delete RemitoCompraItem
delete RemitoCompra

delete RemitoVentaItemSerieTMP
delete RemitoFacturaVentaTMP
delete RemitoVentaItemBorradoTMP
delete RemitoVentaItemTMP
delete RemitoVentaTMP
delete RemitoFacturaVenta
delete RemitoVentaItem
delete RemitoVenta

delete FacturaCompraPercepcion
delete FacturaCompraOtro
delete FacturaCompraNotaCredito
delete FacturaCompraAsiento
delete FacturaCompraOrdenPago
delete FacturaCompraDeuda
delete FacturaCompraPago
delete FacturaCompraItem
delete FacturaCompra
delete FacturaCompraItemBorradoTMP
delete FacturaCompraItemTMP
delete FacturaCompraNotaCreditoTMP
delete FacturaCompraOrdenPagoTMP
delete FacturaCompraOtroBorradoTMP
delete FacturaCompraOtroTMP
delete FacturaCompraPercepcionBorradoTMP
delete FacturaCompraPercepcionTMP
delete FacturaCompraTMP
delete PackingListFacturaVenta
delete PackingListItem
delete PackingList
delete PackingListFacturaVentaTMP
delete PackingListItemBorradoTMP
delete PackingListItemTMP
delete PackingListTMP
delete FacturaVentaAsiento
delete FacturaVentaCobranza
delete FacturaVentaNotaCredito
delete FacturaVentaDeuda
delete FacturaVentaPago
delete FacturaVentaItem
delete FacturaVenta
delete FacturaVentaCobranzaTMP
delete FacturaVentaItemBorradoTMP
delete FacturaVentaItemTMP
delete FacturaVentaNotaCreditoTMP
delete FacturaVentaTMP
delete MovimientoFondoRendicion
delete MovimientoFondoAsiento
delete MovimientoFondoDeuda
delete MovimientoFondoItem
delete MovimientoFondo
delete MovimientoFondoPago
delete MovimientoFondoItemBorradoTMP
delete MovimientoFondoItemTMP
delete MovimientoFondoRendicionTMP
delete MovimientoFondoTMP
delete CobranzaItem
delete OrdenPagoItem
delete CobranzaAsiento
delete Cobranza
delete CobranzaItemTMP
delete CobranzaTMP
delete OrdenPagoAsiento
delete OrdenPago
delete OrdenPagoItemTMP
delete OrdenPagoTMP
delete AsientoItemBorradoTMP
delete AsientoItemTMP
delete AsientoTMP
delete AsientoItem
delete Asiento
delete Aviso
delete ManifiestoCargaItem
delete ManifiestoCarga
delete ManifiestoCargaItemBorradoTMP
delete ManifiestoCargaItemTMP
delete ManifiestoCargaTMP
delete Embarque
delete Barco
delete Calibradora
delete Calidad
delete Camion
delete CDRomArchivo
delete CDRomCarpeta
delete CDRom
delete CentroCosto
delete cheque
delete Chequera
delete Chofer
delete Puerto
delete Ciudad
delete Clearing

delete ClientePercepcion
delete ClienteCacheCredito
update cliente set ld_id = null, lp_id = null
delete ListaDescuentoCliente
delete ListaDescuentoProveedor
delete ListaDescuentoItem
delete ListaDescuento
delete ListaPrecioCliente
delete ListaPrecioProveedor
delete ListaPrecioItem
delete ListaPrecio
delete usuarioempresa
delete Hora
delete Tarea
delete Objetivo
delete ProyectoItem
delete Proyecto
delete Legajo
delete LegajoTipo
delete ClienteSucursal
delete ClienteCuentaGrupo
-- delete Cliente
delete Cobrador
delete Colmena
delete ProveedorCacheCredito
delete ProveedorCAI
delete ProveedorCuentaGrupo
delete ProveedorRetencion
delete ConfiguracionCalibradora
delete ContraMarca

delete depositobancoitemborradotmp
delete depositobancoitemtmp
delete DepositoBancoTMP
delete depositobancoitem
delete DepositoBanco



delete Cheque

delete RecuentoStockitemTMP
delete RecuentoStockTMP
delete RecuentoStockitem
delete RecuentoStock
delete importaciontempgarantiatmp
delete importaciontempgarantia
delete ImportacionTempItemTMP
delete ImportacionTempTMP
delete ImportacionTempItem
delete ImportacionTemp
delete StockItem
delete Stock
delete StockItemTMP
delete StockTMP
delete ProductoNumeroSerie
-- delete DepositoLogico
-- delete DepositoFisico
delete Direccion
delete DocumentoDigital
delete DocumentoFirma
delete Especie
delete FeriadoBancario
delete FRETSolicitudParticular
delete Historia
delete Id
delete Leyenda
delete Maquina
delete Marca
delete MonedaItem
delete PercepcionItem
delete Percepcion
delete PercepcionTipo


delete ReglaLiquidacion
delete Reina
delete RendicionItem
delete Rendicion
delete RendicionItemTMP
delete RendicionTMP
delete RetencionItem
delete Retencion
delete RetencionTipo
delete rptArbolRamaHoja
-- delete producto
delete Rubro
delete RubroTablaItem
delete RubroTabla
delete producto where rubti_id1 is not null
update Talonario set ta_ultimonro=0
delete TarjetaCreditoCupon
delete TarjetaCredito
delete TmpStringToTable
delete Transporte
delete garantia
-- delete proveedor
delete Zona

update moneda set modifico = 1
update talonario set modifico = 1
update cuentacategoria set modifico = 1
update sucursal set modifico = 1
update unidad set modifico = 1


update informe set modifico = 1

update arbol set modifico = 1
update rama set modifico = 1
update rol set modifico = 1
update hoja set modifico = 1
update permiso set modifico = 1
delete usuariorol where us_id <> 1
update provincia set modifico = 1

update cuenta set modifico = 1
update documento set modifico = 1
update condicionpago set modifico = 1
update proveedor set modifico = 1
update tasaimpositiva set modifico = 1

update Vuelo set modifico = 1 
update RecuentoStock set modifico = 1 
update ImportacionItem set modifico = 1 
update TareaEstado set modifico = 1 
update ClienteSucursal set modifico = 1 
update CobranzaTMP set modifico = 1 
update Embarque set modifico = 1 
update ManifiestoCarga set modifico = 1 
update ImportacionProceso set modifico = 1 
update AFIPRegistro set modifico = 1 
update RecuentoStockTMP set modifico = 1 
update Cobrador set modifico = 1 
update UsuarioEmpresa set modifico = 1 
update Informe set modifico = 1 
update Hora set modifico = 1 
update Importacion set modifico = 1 
update UsuarioRol set modifico = 1 
update Unidad set modifico = 1 
update Sucursal set modifico = 1 
update Proveedor set modifico = 1 
update Documento set modifico = 1 
update RemitoCompra set modifico = 1 
update ConfiguracionCalibradora set modifico = 1 
update RemitoVentaTMP set modifico = 1 
update DocumentoDigital set modifico = 1 
update Arbol set modifico = 1 
update CuentaGrupo set modifico = 1 
update PercepcionTipo set modifico = 1 
update ProyectoItem set modifico = 1 
update Usuario set modifico = 1 
update PedidoVenta set modifico = 1 
update ImportacionProcesoItem set modifico = 1 
update DepositoBanco set modifico = 1 
update ReporteFormulario set modifico = 1 
update TarjetaCredito set modifico = 1 
update DocumentoFirma set modifico = 1 
update ClienteCuentaGrupo set modifico = 1 
update Barco set modifico = 1 
update Puerto set modifico = 1 
update Garantia set modifico = 1 
update Calibradora set modifico = 1 
update MovimientoFondo set modifico = 1 
update Contacto set modifico = 1 
update Maquina set modifico = 1 
update Cobranza set modifico = 1 
update CuentaCategoria set modifico = 1 
update Rama set modifico = 1 
update StockTMP set modifico = 1 
update Stock set modifico = 1 
update Cuenta set modifico = 1 
update Calidad set modifico = 1 
update Zona set modifico = 1 
update Transporte set modifico = 1 
update Percepcion set modifico = 1 
update Marca set modifico = 1 
update PercepcionItem set modifico = 1 
update ReglaLiquidacion set modifico = 1 
update ProductoKit set modifico = 1 
update Hoja set modifico = 1 
update RemitoVenta set modifico = 1 
update RetencionItem set modifico = 1 
update ImportacionTemp set modifico = 1 
update Camion set modifico = 1 
update DepositoFisico set modifico = 1 
update RetencionTipo set modifico = 1 
update PedidoVentaTMP set modifico = 1 
update CDRom set modifico = 1 
update Rol set modifico = 1 
update Retencion set modifico = 1 
update RubroTabla set modifico = 1 
update DepositoBancoTMP set modifico = 1 
update Objetivo set modifico = 1 
update PackingList set modifico = 1 
update FacturaVenta set modifico = 1 
update DepositoLogico set modifico = 1 
update MovimientoFondoTMP set modifico = 1 
update Producto set modifico = 1 
update Direccion set modifico = 1 
update CircuitoContable set modifico = 1 
update RubroTablaItem set modifico = 1 
update CDRomArchivo set modifico = 1 
update ClientePercepcion set modifico = 1 
update FacturaVentaTMP set modifico = 1 
update ListaPrecioProveedor set modifico = 1 
update Cliente set modifico = 1 
update Pais set modifico = 1 
update ProveedorCAI set modifico = 1 
update Chofer set modifico = 1 
update ListaPrecioCliente set modifico = 1 
update Historia set modifico = 1 
update ProveedorRetencion set modifico = 1 
update ListaDescuentoProveedor set modifico = 1 
update PermisoEmbarque set modifico = 1 
update Lenguaje set modifico = 1 
update LenguajeItem set modifico = 1 
update Chequera set modifico = 1 
update ListaDescuentoCliente set modifico = 1 
update Moneda set modifico = 1 
update OrdenPago set modifico = 1 
update DocumentoTipo set modifico = 1 
update CDRomCarpeta set modifico = 1 
update ProductoNumeroSerie set modifico = 1 
update PedidoCompra set modifico = 1 
update ListaPrecio set modifico = 1 
update ImportacionTempTMP set modifico = 1 
update InformeOrders set modifico = 1 
update Tarea set modifico = 1 
update Escala set modifico = 1 
update InformeGroups set modifico = 1 
update Prioridad set modifico = 1 
update Rendicion set modifico = 1 
update Aviso set modifico = 1 
update Especie set modifico = 1 

update ParteDiarioTipo set modifico = 1 
update PackingListTMP set modifico = 1 
update InformeHiperlinks set modifico = 1 
update RendicionTMP set modifico = 1 
update Ciudad set modifico = 1 
update Departamento set modifico = 1 
update Banco set modifico = 1 
update PermisoEmbarqueTMP set modifico = 1 
update Configuracion set modifico = 1 
update MonedaItem set modifico = 1 
update Alsa set modifico = 1 
update Aduana set modifico = 1 
update InformeParametro set modifico = 1 
update Asiento set modifico = 1 
update ProveedorCuentaGrupo set modifico = 1 
update Estado set modifico = 1 
update ListaDescuento set modifico = 1 
update Clearing set modifico = 1 
update FacturaCompra set modifico = 1 
update AFIPArchivo set modifico = 1 
update Reporte set modifico = 1 
update RemitoCompraTMP set modifico = 1 
update FechaControlAcceso set modifico = 1 
update FeriadoBancario set modifico = 1 
update Legajo set modifico = 1 
update CentroCosto set modifico = 1 
update LegajoTipo set modifico = 1 
update AFIPCampo set modifico = 1 
update Colmena set modifico = 1 
update Rubro set modifico = 1 
update Talonario set modifico = 1 
update TasaImpositiva set modifico = 1 
update PedidoCompraTMP set modifico = 1 
update FacturaCompraTMP set modifico = 1 
update InformePermiso set modifico = 1 
update AFIPEsquema set modifico = 1 
update ContraMarca set modifico = 1 
update Provincia set modifico = 1 
update ListaDescuentoItem set modifico = 1 
update Vendedor set modifico = 1 
update CondicionPago set modifico = 1 
update IngresosBrutosCategoria set modifico = 1 
update ManifiestoCargaTMP set modifico = 1 
update ReporteParametro set modifico = 1 
update AFIPParametro set modifico = 1 
update Leyenda set modifico = 1 
update Reina set modifico = 1 
update OrdenPagoTMP set modifico = 1 
update AsientoTMP set modifico = 1 
update Permiso set modifico = 1 
update ListaPrecioItem set modifico = 1 
update Proyecto set modifico = 1 
delete reporteparametro
delete reporte
delete Usuario where us_id <> 1
delete usuariorol where rol_id <> 1
delete permiso where rol_id <> 1 and rol_id is not null
delete rol where rol_id <> 1


delete Vendedor
delete Vuelo
