set nocount on
delete Agenda where agn_id >1
go
delete Asiento
go
delete AsientoItem
go
delete AsientoItemBorradoTMP
go
delete AsientoItemTMP
go
delete AsientoTMP
go
delete Auditoria
go
delete AuditoriaItem
go
delete Aviso
go
delete ClienteCacheCredito
go
delete Cobranza
go
delete CobranzaAsiento
go
delete CobranzaItem
GO
delete cheque
go
delete CobranzaItemBorradoTMP
go
delete CobranzaItemTMP
go
delete CobranzaTMP
go
delete Colmena
go
delete CotizacionCompra
go
delete CotizacionCompraItem
go
delete CotizacionCompraItemBorradoTMP
go
delete CotizacionCompraItemTMP
go
delete CotizacionCompraTMP
go
delete CotizacionOrdenCompra
go
delete CotizacionOrdenCompraTMP
go
delete CotizacionPresupuestoCompra
go
delete CotizacionPresupuestoCompraTMP
go
delete DepositoBanco
go
delete DepositoBancoAsiento
go
delete DepositoBancoItem
go
delete DepositoBancoItemBorradoTMP
go
delete DepositoBancoItemTMP
go
delete DepositoBancoTMP
go
delete DepositoCupon
go
delete DepositoCuponAsiento
go
delete DepositoCuponItem
go
delete DepositoCuponItemBorradoTMP
go
delete DepositoCuponItemTMP
go
delete DepositoCuponTMP
go
delete DespachoImpCalculo
go
delete DespachoImpCalculoItem
go
delete EjercicioAsientoResumen
go
delete EjercicioContable
go
delete ExpoFacturaVenta
go
delete ExpoPackingList
go
delete FacturaCompra
go
delete FacturaCompraAsiento
go
delete FacturaCompraDeuda
go
delete FacturaCompraItem
go
delete FacturaCompraItemBorradoTMP
go
delete FacturaCompraItemSerieBTMP
go
delete FacturaCompraItemSerieTMP
go
delete FacturaCompraItemTMP
go
delete FacturaCompraLegajo
go
delete FacturaCompraLegajoBorradoTMP
go
delete FacturaCompraLegajoTMP
go
delete FacturaCompraNotaCredito
go
delete FacturaCompraNotaCreditoTMP
go
delete FacturaCompraOrdenPago
go
delete FacturaCompraOrdenPagoTMP
go
delete FacturaCompraOtro
go
delete FacturaCompraOtroBorradoTMP
go
delete FacturaCompraOtroTMP
go
delete FacturaCompraPago
go
delete FacturaCompraPercepcion
go
delete FacturaCompraPercepcionBorradoTMP
go
delete FacturaCompraPercepcionTMP
go
delete FacturaCompraTMP
go
delete FacturaVenta
go
delete FacturaVentaAsiento
go
delete FacturaVentaCobranza
go
delete FacturaVentaCobranzaTMP
go
delete FacturaVentaDeuda
go
delete FacturaVentaItem
go
delete FacturaVentaItemBorradoTMP
go
delete FacturaVentaItemSerieTMP
go
delete FacturaVentaItemTMP
go
delete FacturaVentaNotaCredito
go
delete FacturaVentaNotaCreditoTMP
go
delete FacturaVentaPago
go
delete FacturaVentaPercepcion
go
delete FacturaVentaPercepcionBorradoTMP
go
delete FacturaVentaPercepcionTMP
go
delete FacturaVentaTMP
go
delete Garantia
go
delete Gasto
go
delete Historia
go
delete HistoriaOperacion
go
delete Hora
go
delete HoraFacturaVenta
go
delete HoraFacturaVentaTMP
go
delete ImportacionTemp
go
delete ImportacionTempGarantia
go
delete ImportacionTempGarantiaTMP
go
delete ImportacionTempItem
go
delete ImportacionTempItemBorradoTMP
go
delete ImportacionTempItemSerieTMP
go
delete ImportacionTempItemTMP
go
delete ImportacionTempTMP
go
delete ManifiestoCarga
go
delete ManifiestoCargaItem
go
delete ManifiestoCargaItemBorradoTMP
go
delete ManifiestoCargaItemTMP
go
delete ManifiestoCargaTMP
go
delete ManifiestoPackingList
go
delete ManifiestoPackingListTMP
go
delete MovimientoFondo
go
delete MovimientoFondoAsiento
go
delete MovimientoFondoItem
go
delete MovimientoFondoItemBorradoTMP
go
delete MovimientoFondoItemTMP
go
delete MovimientoFondoTMP
go
delete OrdenCompra
go
delete OrdenCompraItem
go
delete OrdenCompraItemBorradoTMP
go
delete OrdenCompraItemTMP
go
delete OrdenCompraTMP
go
delete OrdenDevolucionCompra
go
delete OrdenDevolucionCompraTMP
go
delete OrdenFacturaCompra
go
delete OrdenFacturaCompraTMP
go
delete OrdenPago
go
delete OrdenPagoAsiento
go
delete OrdenPagoItem
go
delete OrdenPagoItemBorradoTMP
go
delete OrdenPagoItemTMP
go
delete OrdenPagoTMP
go
delete OrdenRemitoCompra
go
delete OrdenRemitoCompraTMP
go
delete OrdenRemitoVenta
go
delete OrdenRemitoVentaTMP
go
update tarea set os_id = null
go
delete OrdenServicio
go
delete OrdenServicioAlarmaTMP
go
delete OrdenServicioItem
go
delete OrdenServicioItemBorradoTMP
go
delete OrdenServicioItemSerieBTMP
go
delete OrdenServicioItemSerieTMP
go
delete OrdenServicioItemTMP
go
delete OrdenServicioSerie
go
delete OrdenServicioSerieTMP
go
delete OrdenServicioTMP
go
delete PackingList
go
delete PackingListDevolucion
go
delete PackingListDevolucionTMP
go
delete PackingListFacturaVenta
go
delete PackingListFacturaVentaTMP
go
delete PackingListItem
go
delete PackingListItemBorradoTMP
go
delete PackingListItemTMP
go
delete PackingListTMP
go
delete ParteDiario
go
update productonumeroserie set ppk_id = null
go
delete ParteProdKit
go
delete ParteProdKitItem
go
delete ParteProdKitItemA
go
delete ParteProdKitItemATMP
go
delete ParteProdKitItemBorradoTMP
go
delete ParteProdKitItemSerieTMP
go
delete ParteProdKitItemTMP
go
delete ParteProdKitTMP
go
delete ParteReparacion
go
delete ParteReparacionItem
go
delete ParteReparacionItemBorradoTMP
go
delete ParteReparacionItemSerieTMP
go
delete ParteReparacionItemTMP
go
delete ParteReparacionTMP
go
delete PedidoCompra
go
delete PedidoCompraItem
go
delete PedidoCompraItemBorradoTMP
go
delete PedidoCompraItemTMP
go
delete PedidoCompraTMP
go
delete PedidoCotizacionCompra
go
delete PedidoCotizacionCompraTMP
go
delete PedidoDevolucionCompra
go
delete PedidoDevolucionCompraTMP
go
delete PedidoDevolucionVenta
go
delete PedidoDevolucionVentaTMP
go
delete PedidoFacturaVenta
go
delete PedidoFacturaVentaTMP
go
delete PedidoOrdenCompra
go
delete PedidoOrdenCompraTMP
go
delete PedidoPackingList
go
delete PedidoPackingListTMP
go
delete PedidoRemitoVenta
go
delete PedidoRemitoVentaTMP
go
delete PedidoVenta
go
delete PedidoVentaItem
go
delete PedidoVentaItemBorradoTMP
go
delete PedidoVentaItemStock
go
delete PedidoVentaItemTMP
go
delete PedidoVentaTMP
go
delete PermisoEmbarque
go
delete PermisoEmbarqueItem
go
delete PermisoEmbarqueItemBorradoTMP
go
delete PermisoEmbarqueItemTMP
go
delete PermisoEmbarqueTMP
go
delete PresupuestoCompra
go
delete PresupuestoCompraItem
go
delete PresupuestoCompraItemBorradoTMP
go
delete PresupuestoCompraItemTMP
go
delete PresupuestoCompraTMP
go
delete PresupuestoDevolucionCompra
go
delete PresupuestoDevolucionCompraTMP
go
delete PresupuestoDevolucionVenta
go
delete PresupuestoDevolucionVentaTMP
go
delete PresupuestoEnvio
go
delete PresupuestoEnvioGasto
go
delete PresupuestoEnvioGastoBorradoTMP
go
delete PresupuestoEnvioGastoTMP
go
delete PresupuestoEnvioItem
go
delete PresupuestoEnvioItemBorradoTMP
go
delete PresupuestoEnvioItemTMP
go
delete PresupuestoEnvioTMP
go
delete PresupuestoPedidoVenta
go
delete PresupuestoPedidoVentaTMP
go
delete PresupuestoVenta
go
delete PresupuestoVentaItem
go
delete PresupuestoVentaItemBorradoTMP
go
delete PresupuestoVentaItemTMP
go
delete PresupuestoVentaTMP
go
update Tarea set prns_id = null
go
delete ProductoNumeroSerie
go
delete ProductoNumeroSerieAsinc
go
delete ProductoNumeroSerieHistoria
go
delete ProductoNumeroSerieServicio
go
update productonumeroserie set prsk_id = null
go
delete ProductoSerieKit
go
delete ProductoSerieKitBorradoTMP
go
delete ProductoSerieKitItem
go
delete ProductoSerieKitItemTMP
go
delete ProductoSerieKitTMP
go
delete ProveedorCacheCredito
go
update Alarma set proy_id = null
go
delete Proyecto
go
delete Objetivo
go
delete ProyectoItem
go
delete ProyectoPrecio
go
delete ProyectoTareaEstado
go
delete RecuentoStock
go
delete RecuentoStockItem
go
delete RecuentoStockItemSerieTMP
go
delete RecuentoStockItemTMP
go
delete RecuentoStockTMP
go
delete RemitoCompra
go
delete RemitoCompraItem
go
delete RemitoCompraItemBorradoTMP
go
delete RemitoCompraItemSerieBTMP
go
delete RemitoCompraItemSerieTMP
go
delete RemitoCompraItemTMP
go
delete RemitoCompraTMP
go
delete RemitoDevolucionCompra
go
delete RemitoDevolucionCompraTMP
go
delete RemitoDevolucionVenta
go
delete RemitoDevolucionVentaTMP
go
delete RemitoFacturaCompra
go
delete RemitoFacturaCompraTMP
go
delete RemitoFacturaVenta
go
delete RemitoFacturaVentaTMP
go
delete RemitoVenta
go
delete RemitoVentaItem
go
delete RemitoVentaItemBorradoTMP
go
delete RemitoVentaItemInsumoTMP
go
delete RemitoVentaItemSerieTMP
go
delete RemitoVentaItemTMP
go
delete RemitoVentaTMP
go
delete ResolucionCupon
go
delete ResolucionCuponAsiento
go
delete ResolucionCuponItem
go
delete ResolucionCuponItemBorradoTMP
go
delete ResolucionCuponItemTMP
go
delete ResolucionCuponTMP
go
delete rptArbolRamaHoja
go
delete SRV_AfipCuit
go
delete Stock
go
delete StockCache
go
delete StockCliente
go
delete StockClienteTMP
go
delete StockItem
go
delete StockItemKit
go
delete StockItemTMP
go
delete StockLote
go
delete StockProveedor
go
update facturacompra set as_id = null
go
update facturaventa set as_id = null
go
update movimientofondo set as_id = null
go
update depositobanco set as_id = null
go
delete StockProveedorTMP
go
delete StockTMP
go
delete StockValor
go
delete StockValorItem
go
delete Tarea
go
delete Tarifa
go
delete TarifaGasto
go
delete TarifaItem
go
delete TarjetaCreditoCupon
go
delete TmpStringToTable
go
delete webArticulo
go
delete webSeccion
go
delete EncuestaWebSeccion