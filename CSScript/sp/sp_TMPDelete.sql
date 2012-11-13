if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TMPDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TMPDelete]

/*

sp_TMPDelete

*/

go
create procedure sp_TMPDelete 
as
begin
	set nocount on

	-- select 'delete ' + name from sysobjects where xtype='u' and name like '%tmp%' order by name
	
	delete AsientoItemBorradoTMP
	delete AsientoItemTMP
	delete AsientoTMP
	delete CobranzaItemBorradoTMP
	delete CobranzaItemTMP
	delete CobranzaTMP
	delete CotizacionCompraItemBorradoTMP
	delete CotizacionCompraItemTMP
	delete CotizacionCompraTMP
	delete CotizacionOrdenCompraTMP
	delete CotizacionPresupuestoCompraTMP
	delete DepositoBancoItemBorradoTMP
	delete DepositoBancoItemTMP
	delete DepositoBancoTMP
	delete DepositoCuponItemBorradoTMP
	delete DepositoCuponItemTMP
	delete DepositoCuponTMP
	delete FacturaCompraItemBorradoTMP
	delete FacturaCompraItemSerieBTMP
	delete FacturaCompraItemSerieTMP
	delete FacturaCompraItemTMP
	delete FacturaCompraLegajoBorradoTMP
	delete FacturaCompraLegajoTMP
	delete FacturaCompraNotaCreditoTMP
	delete FacturaCompraOrdenPagoTMP
	delete FacturaCompraOtroBorradoTMP
	delete FacturaCompraOtroTMP
	delete FacturaCompraPercepcionBorradoTMP
	delete FacturaCompraPercepcionTMP
	delete FacturaCompraTMP
	delete FacturaVentaCobranzaTMP
	delete FacturaVentaItemBorradoTMP
	delete FacturaVentaItemSerieTMP
	delete FacturaVentaItemTMP
	delete FacturaVentaNotaCreditoTMP
	delete FacturaVentaPercepcionBorradoTMP
	delete FacturaVentaPercepcionTMP
	delete FacturaVentaTMP
	delete HoraFacturaVentaTMP
	delete ManifiestoCargaItemBorradoTMP
	delete ManifiestoCargaItemTMP
	delete ManifiestoCargaTMP
	delete ManifiestoPackingListTMP
	delete MovimientoFondoItemBorradoTMP
	delete MovimientoFondoItemTMP
	delete MovimientoFondoTMP
	delete OrdenCompraItemBorradoTMP
	delete OrdenCompraItemTMP
	delete OrdenCompraTMP
	delete OrdenDevolucionCompraTMP
	delete OrdenFacturaCompraTMP
	delete OrdenPagoItemBorradoTMP
	delete OrdenPagoItemTMP
	delete OrdenPagoTMP
	delete OrdenRemitoCompraTMP
	delete OrdenRemitoVentaTMP
	delete OrdenServicioAlarmaTMP
	delete OrdenServicioItemBorradoTMP
	delete OrdenServicioItemSerieBTMP
	delete OrdenServicioItemSerieTMP
	delete OrdenServicioItemTMP
	delete OrdenServicioSerieTMP
	delete OrdenServicioTMP
	delete PackingListDevolucionTMP
	delete PackingListFacturaVentaTMP
	delete PackingListItemBorradoTMP
	delete PackingListItemTMP
	delete PackingListTMP
	delete ParteProdKitItemATMP
	delete ParteProdKitItemBorradoTMP
	delete ParteProdKitItemSerieTMP
	delete ParteProdKitItemTMP
	delete ParteProdKitTMP
	delete ParteReparacionItemBorradoTMP
	delete ParteReparacionItemSerieTMP
	delete ParteReparacionItemTMP
	delete ParteReparacionTMP
	delete PedidoCompraItemBorradoTMP
	delete PedidoCompraItemTMP
	delete PedidoCompraTMP
	delete PedidoCotizacionCompraTMP
	delete PedidoDevolucionCompraTMP
	delete PedidoDevolucionVentaTMP
	delete PedidoFacturaVentaTMP
	delete PedidoOrdenCompraTMP
	delete PedidoPackingListTMP
	delete PedidoRemitoVentaTMP
	delete PedidoVentaItemBorradoTMP
	delete PedidoVentaItemTMP
	delete PedidoVentaTMP
	delete PermisoEmbarqueItemBorradoTMP
	delete PermisoEmbarqueItemTMP
	delete PermisoEmbarqueTMP
	delete PresupuestoCompraItemBorradoTMP
	delete PresupuestoCompraItemTMP
	delete PresupuestoCompraTMP
	delete PresupuestoDevolucionCompraTMP
	delete PresupuestoDevolucionVentaTMP
	delete PresupuestoEnvioGastoBorradoTMP
	delete PresupuestoEnvioGastoTMP
	delete PresupuestoEnvioItemBorradoTMP
	delete PresupuestoEnvioItemTMP
	delete PresupuestoEnvioTMP
	delete PresupuestoPedidoVentaTMP
	delete PresupuestoVentaItemBorradoTMP
	delete PresupuestoVentaItemTMP
	delete PresupuestoVentaTMP
	delete ProductoSerieKitBorradoTMP
	delete ProductoSerieKitItemTMP
	delete ProductoSerieKitTMP
	delete RecuentoStockItemSerieTMP
	delete RecuentoStockItemTMP
	delete RecuentoStockTMP
	delete RemitoCompraItemBorradoTMP
	delete RemitoCompraItemSerieBTMP
	delete RemitoCompraItemSerieTMP
	delete RemitoCompraItemTMP
	delete RemitoCompraTMP
	delete RemitoDevolucionCompraTMP
	delete RemitoDevolucionVentaTMP
	delete RemitoFacturaCompraTMP
	delete RemitoFacturaVentaTMP
	delete RemitoVentaItemBorradoTMP
	delete RemitoVentaItemInsumoTMP
	delete RemitoVentaItemSerieTMP
	delete RemitoVentaItemTMP
	delete RemitoVentaTMP
	delete ResolucionCuponItemBorradoTMP
	delete ResolucionCuponItemTMP
	delete ResolucionCuponTMP
	delete StockClienteTMP
	delete StockItemTMP
	delete StockProveedorTMP
	delete StockTMP
	delete TmpStringToTable
	delete rptArbolRamaHoja

end
go