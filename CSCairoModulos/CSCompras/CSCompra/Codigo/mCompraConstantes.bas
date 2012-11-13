Attribute VB_Name = "mComprasConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mComprasConstantes
' 06-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mComprasConstantes"

' Wizard
Public Const c_Wiz_Key_Fecha = "Fecha"
Public Const c_Wiz_Key_FechaIva = "Fecha IVA"
Public Const c_Wiz_Key_FechaVto = "Fecha VTO"
Public Const c_Wiz_Key_Proveedor = "PROV"
Public Const c_Wiz_Key_Proveedor2 = "Proveedor"
Public Const c_Wiz_Key_Sucursal = "Sucursal"
Public Const c_Wiz_Key_CondicionPago = "Condición de Pago"
Public Const c_Wiz_Key_Observaciones = "Observaciones"
Public Const c_Wiz_Key_Comprobante = "Comprobante"
Public Const c_Wiz_Key_Legajo = "Legajo"
Public Const c_Wiz_Key_CentroCosto = "Centro de Costo"
Public Const c_Wiz_Key_ListaPrecio = "Lista de Precio"
Public Const c_Wiz_Key_ListaDescuento = "Lista de Descuento"
Public Const c_Wiz_Key_Cotizacion = "Cotización"
Public Const c_Wiz_Key_CotizacionProv = "Cotización Proveedor"
Public Const c_Wiz_Key_TipoComprobante = "TIPOCOMP"
Public Const c_Wiz_Key_Doc = "DOC"
Public Const c_Wiz_Key_ResultTitle = "RESULTT"
Public Const c_Wiz_Key_Result = "RESULT"
Public Const c_Wiz_Key_Usuario = "US"
Public Const c_Wiz_Key_Deposito = "DEP"
Public Const c_Wiz_Key_Todos = "TODOS"
Public Const c_Wiz_Key_Pedidos = "PEDIDOS"
Public Const c_Wiz_Key_Remitos = "REMITOS"
Public Const c_Wiz_Key_Ordenes = "ORDENES"
Public Const c_Wiz_Key_Items = "ITEMS"
Public Const c_Wiz_Key_TodosItems = "TODOS-ITEMS"
Public Const c_Wiz_Key_Total = "Total"
Public Const c_Wiz_Key_TotalItems = "TotalItems"
Public Const c_Wiz_Key_Pendiente = "Pendiente"
Public Const c_Wiz_Key_OnlySelected = "ONLYSEL" ' Edit From ListDoc

Public Const KW_DOC_ID                      As Integer = 320
Public Const KW_PROV_ID                     As Integer = 340
Public Const KW_CPG_ID                      As Integer = 360

Public Const c_ProveedorDataAdd = "ProveedorDataAdd"

' Rama
Public Const cscRamNombre                       As String = "ram_nombre"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' CentroCosto
Public Const csTCentroCosto                            As String = "CentroCosto"
Public Const cscCcosId                                 As String = "ccos_id"
Public Const cscCcosNombre                             As String = "ccos_nombre"

' Legajo
Public Const csLegajo = 15001

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_id"
Public Const cscLgjTitulo                             As String = "lgj_titulo"
Public Const cscLgjCodigo                             As String = "lgj_codigo"

'Proveedor
Public Const csTProveedor                              As String = "Proveedor"
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvNombre                             As String = "prov_nombre"
Public Const cscProvCatFiscal                          As String = "prov_catfiscal"
Public Const cscProvCuit                               As String = "prov_cuit"

' Lista de Precios
Public Const csTListaPrecio                          As String = "ListaPrecio"
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscDocIdRemito                           As String = "doc_id_remito"
Public Const cscDocIdStock                            As String = "doc_id_stock"
Public Const cscDocGeneraRemito                       As String = "doc_generaremito"
Public Const cscDocMueveStock                         As String = "doc_muevestock"
Public Const cscDocRcDesdeOc                          As String = "doc_rc_desde_oc"
Public Const cscDocTipoFactura                        As String = "doc_tipofactura"
Public Const cscDocTipoOrdenCompra                    As String = "doc_tipoordencompra"
Public Const cscDocRcDespachoImpo                     As String = "doc_rc_despachoimpo"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' Lista de Descuentos
Public Const csTListaDescuento                        As String = "ListaDescuento"
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"
Public Const cscCpgEsLibre                            As String = "cpg_eslibre"

' RemitoCompra
Public Const csTRemitoCompra                         As String = "RemitoCompra"
Public Const cscRcId                                 As String = "rc_id"
Public Const cscRcNumero                             As String = "rc_numero"
Public Const cscRcNrodoc                             As String = "rc_nrodoc"
Public Const cscRcDescrip                            As String = "rc_descrip"
Public Const cscRcFecha                              As String = "rc_fecha"
Public Const cscRcFechaentrega                       As String = "rc_fechaentrega"
Public Const cscRcNeto                               As String = "rc_neto"
Public Const cscRcIvari                              As String = "rc_ivari"
Public Const cscRcIvarni                             As String = "rc_ivarni"
Public Const cscRcTotal                              As String = "rc_total"
Public Const cscRcSubtotal                           As String = "rc_subtotal"
Public Const cscRcPendiente                          As String = "rc_pendiente"
Public Const cscRcDescuento1                         As String = "rc_descuento1"
Public Const cscRcDescuento2                         As String = "rc_descuento2"
Public Const cscRcImportedesc1                       As String = "rc_importedesc1"
Public Const cscRcImportedesc2                       As String = "rc_importedesc2"
Public Const cscRcFirmado                            As String = "rc_firmado"
Public Const cscRcCotizacion                         As String = "rc_cotizacion"

' RemitoCompraTMP
Public Const csTRemitoCompraTMP                      As String = "RemitoCompraTMP"
Public Const cscRcTMPId                              As String = "rcTMP_id"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' RemitoCompraItem
Public Const csTRemitoCompraItem                      As String = "RemitoCompraItem"
Public Const cscRciId                                 As String = "rci_id"
Public Const cscRciOrden                              As String = "rci_orden"
Public Const cscRciCantidad                           As String = "rci_cantidad"
Public Const cscRciCantidadaremitir                   As String = "rci_cantidadaremitir"
Public Const cscRciPendiente                          As String = "rci_pendiente"
Public Const cscRciPendientefac                       As String = "rci_pendientefac"
Public Const cscRciDescrip                            As String = "rci_descrip"
Public Const cscRciPrecio                             As String = "rci_precio"
Public Const cscRciPrecioUsr                          As String = "rci_precioUsr"
Public Const cscRciPrecioLista                        As String = "rci_precioLista"
Public Const cscRciDescuento                          As String = "rci_descuento"
Public Const cscRciNeto                               As String = "rci_neto"
Public Const cscRciIvari                              As String = "rci_ivari"
Public Const cscRciIvarni                             As String = "rci_ivarni"
Public Const cscRciIvariporc                          As String = "rci_ivariporc"
Public Const cscRciIvarniporc                         As String = "rci_ivarniporc"
Public Const cscRciImporte                            As String = "rci_importe"

' RemitoCompraItemTMP
Public Const csTRemitoCompraItemTMP                   As String = "RemitoCompraItemTMP"
Public Const cscRciTMPId                              As String = "rciTMP_id"

' RemitoCompraItemBorradoTMP
Public Const csTRemitoCompraItemBorradoTMP            As String = "RemitoCompraItemBorradoTMP"
Public Const cscRcibTMPId                             As String = "rcibTMP_id"

'Producto
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombrecompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreventa                        As String = "pr_Nombreventa"
Public Const cscPrTiIdRiCompra                       As String = "ti_id_ivariCompra"
Public Const cscPrTiIdRniCompra                      As String = "ti_id_ivarniCompra"
Public Const cscCueidCompra                          As String = "cue_id_compra"
Public Const cscPrLlevaStock                         As String = "pr_llevastock"
Public Const cscPrLlevaNroSerie                      As String = "pr_llevanroserie"
Public Const cscPrLlevaNroLote                       As String = "pr_llevanrolote"
Public Const cscPrEskit                              As String = "pr_eskit"
Public Const cscPrIdItem                             As String = "pr_id_item"
Public Const cscPrPorcInternoC                       As String = "pr_porcinternoc"
Public Const cscCcosIdCompra                         As String = "ccos_id_compra"

' Producto Numero Serie
Public Const csTProductoNumeroSerie                    As String = "ProductoNumeroSerie"
Public Const cscPrnsId                                 As String = "prns_id"
Public Const cscPrnsCodigo                             As String = "prns_codigo"
Public Const cscPrnsDescrip                            As String = "prns_descrip"
Public Const cscPrnsFechavto                           As String = "prns_fechavto"

' Remito Compra Item Serie
Public Const csTRemitoCompraItemSerieTMP               As String = "RemitoCompraItemSerieTMP"
Public Const cscRcisTMPId                              As String = "rcisTMP_id"
Public Const cscRcisOrden                              As String = "rcis_orden"

' Remito Compra Item Serie
Public Const csTRemitoCompraItemSerieBTMP              As String = "RemitoCompraItemSerieBTMP"
Public Const cscRcisbTMPId                             As String = "rcisbTMP_id"

' Factura Compra Item Serie
Public Const csTFacturaCompraItemSerieTMP              As String = "FacturaCompraItemSerieTMP"
Public Const cscFcisTMPId                              As String = "fcisTMP_id"
Public Const cscFcisOrden                              As String = "fcis_orden"

' Factura Compra Item Serie
Public Const csTFacturaCompraItemSerieBTMP             As String = "FacturaCompraItemSerieBTMP"
Public Const cscFcisbTMPId                             As String = "fcisbTMP_id"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

' Talonario
Public Const cscTaId                            As String = "ta_id"

' PedidoCompra
Public Const csTPedidoCompra                     As String = "PedidoCompra"
Public Const cscPcId                             As String = "pc_id"
Public Const cscPcNumero                         As String = "pc_numero"
Public Const cscPcNrodoc                         As String = "pc_nrodoc"
Public Const cscPcDescrip                        As String = "pc_descrip"
Public Const cscPcFecha                          As String = "pc_fecha"
Public Const cscPcFechaentrega                   As String = "pc_fechaentrega"
Public Const cscPcNeto                           As String = "pc_neto"
Public Const cscPcIvari                          As String = "pc_ivari"
Public Const cscPcIvarni                         As String = "pc_ivarni"
Public Const cscPcTotal                          As String = "pc_total"
Public Const cscPcSubtotal                       As String = "pc_subtotal"
Public Const cscPcPendiente                      As String = "pc_pendiente"
Public Const cscPcFirmado                        As String = "pc_firmado"

' PedidoCompraTMP
Public Const csTPedidoCompraTMP                   As String = "PedidoCompraTMP"
Public Const cscPcTMPId                           As String = "pcTMP_id"

' PedidoCompraItem
Public Const csTPedidoCompraItem                  As String = "PedidoCompraItem"
Public Const cscPciId                             As String = "pci_id"
Public Const cscPciOrden                          As String = "pci_orden"
Public Const cscPciCantidad                       As String = "pci_cantidad"
Public Const cscPciCantidadaremitir               As String = "pci_cantidadaremitir"
Public Const cscPciDescrip                        As String = "pci_descrip"
Public Const cscPciPrecio                         As String = "pci_precio"
Public Const cscPciPrecioUsr                      As String = "pci_precioUsr"
Public Const cscPciPrecioLista                    As String = "pci_precioLista"
Public Const cscPciNeto                           As String = "pci_neto"
Public Const cscPciIvari                          As String = "pci_ivari"
Public Const cscPciIvarni                         As String = "pci_ivarni"
Public Const cscPciImporte                        As String = "pci_importe"
Public Const cscPciIvariPorc                      As String = "pci_ivariporc"
Public Const cscPciIvarniPorc                     As String = "pci_ivarniporc"
Public Const cscPciPendiente                      As String = "pci_pendiente"

' PedidoCompraItemTMP
Public Const csTPedidoCompraItemTMP               As String = "PedidoCompraItemTMP"
Public Const cscPciTMPId                          As String = "pciTMP_id"

' PedidoCompraItemBorradoTMP
Public Const csTPedidoCompraItemBorradoTMP        As String = "PedidoCompraItemBorradoTMP"
Public Const cscPcibTMPId                         As String = "pcibTMP_id"

' Pedido Devolucion Compra TMP
Public Const csTPedidoDevolucionCompraTMP            As String = "PedidoDevolucionCompraTMP"
Public Const cscPcDcTMPId                            As String = "pcdcTMP_id"
Public Const cscPcDcId                               As String = "pcdc_id"
Public Const cscPcDcCantidad                         As String = "pcdc_cantidad"
Public Const cscPciIdDevolucion                      As String = "pci_id_devolucion"
Public Const cscPciIdPedido                          As String = "pci_id_pedido"

' FacturaCompra
Public Const csTFacturaCompra                   As String = "FacturaCompra"
Public Const cscFcId                            As String = "fc_id"
Public Const cscFcNumero                        As String = "fc_numero"
Public Const cscFcNrodoc                        As String = "fc_nrodoc"
Public Const cscFcDescrip                       As String = "fc_descrip"
Public Const cscFcFecha                         As String = "fc_fecha"
Public Const cscFcFechaentrega                  As String = "fc_fechaentrega"
Public Const cscFcFechaVto                      As String = "fc_fechavto"
Public Const cscFcFechaIva                      As String = "fc_fechaIva"
Public Const cscFcNeto                          As String = "fc_neto"
Public Const cscFcIvari                         As String = "fc_ivari"
Public Const cscFcIvarni                        As String = "fc_ivarni"
Public Const cscFcInternos                      As String = "fc_internos"
Public Const cscFcSubtotal                      As String = "fc_subtotal"
Public Const cscFcTotal                         As String = "fc_total"
Public Const cscFcTotalOrigen                   As String = "fc_totalorigen"
Public Const cscFcPendiente                     As String = "fc_pendiente"
Public Const cscFcFirmado                       As String = "fc_firmado"
Public Const cscFcDescuento1                    As String = "fc_descuento1"
Public Const cscFcDescuento2                    As String = "fc_descuento2"
Public Const cscFcImportedesc1                  As String = "fc_importedesc1"
Public Const cscFcImportedesc2                  As String = "fc_importedesc2"
Public Const cscFcGrabarAsiento                 As String = "fc_grabarasiento"
Public Const cscFcCotizacion                    As String = "fc_cotizacion"
Public Const cscFcCai                           As String = "fc_cai"
Public Const cscFcTotalOtros                    As String = "fc_totalotros"
Public Const cscFcTotalPercepciones             As String = "fc_totalpercepciones"
Public Const cscFcTipoComprobante               As String = "fc_tipocomprobante"
Public Const cscFcCotizacionProv                As String = "fc_cotizacionprov"

' FacturaCompraTMP
Public Const csTFacturaCompraTMP                 As String = "FacturaCompraTMP"
Public Const cscFcTMPId                          As String = "fcTMP_id"

' FacturaCompraItem
Public Const csTFacturaCompraItem                     As String = "FacturaCompraItem"
Public Const cscFciId                                 As String = "fci_id"
Public Const cscFciOrden                              As String = "fci_orden"
Public Const cscFciCantidad                           As String = "fci_cantidad"
Public Const cscFciCantidadaremitir                   As String = "fci_cantidadaremitir"
Public Const cscFciPendiente                          As String = "fci_pendiente"
Public Const cscFciDescrip                            As String = "fci_descrip"
Public Const cscFciPrecio                             As String = "fci_precio"
Public Const cscFciPrecioUsr                          As String = "fci_precioUsr"
Public Const cscFciPrecioLista                        As String = "fci_precioLista"
Public Const cscFciDescuento                          As String = "fci_descuento"
Public Const cscFciNeto                               As String = "fci_neto"
Public Const cscFciIvari                              As String = "fci_ivari"
Public Const cscFciIvarni                             As String = "fci_ivarni"
Public Const cscFciIvariporc                          As String = "fci_ivariporc"
Public Const cscFciIvarniporc                         As String = "fci_ivarniporc"

Public Const cscFciInternosPorc                       As String = "fci_internosporc"
Public Const cscFciInternos                           As String = "fci_internos"

Public Const cscFciImporteOrigen                      As String = "fci_importeorigen"
Public Const cscFciImporte                            As String = "fci_importe"
Public Const cscCueIdIvaRI                            As String = "cue_id_IvaRI"
Public Const cscCueIdIvaRNI                           As String = "cue_id_IvaRNI"

' FacturaCompraItemTMP
Public Const csTFacturaCompraItemTMP                  As String = "FacturaCompraItemTMP"
Public Const cscFciTMPId                              As String = "fciTMP_id"

' FacturaCompraOtroTMP
Public Const csTFacturaCompraOtroTMP                  As String = "FacturaCompraOtroTMP"
Public Const cscFcotTMPId                             As String = "fcotTMP_id"

' FacturaCompraOtro
Public Const csTFacturaCompraOtro                      As String = "FacturaCompraOtro"
Public Const cscFcotId                                 As String = "fcot_id"
Public Const cscFcotOrden                              As String = "fcot_orden"
Public Const cscFcotDebe                               As String = "fcot_debe"
Public Const cscFcotHaber                              As String = "fcot_haber"
Public Const cscFcotDescrip                            As String = "fcot_descrip"
Public Const cscFcotOrigen                             As String = "fcot_origen"

' csTFacturaCompraOtroBorradoTMP
Public Const csTFacturaCompraOtroBorradoTMP            As String = "FacturaCompraOtroBorradoTMP"
Public Const cscFcotbTMPId                             As String = "fcotbTMP_id"

' FacturaCompraItemBarradoTMP
Public Const csTFacturaCompraItemBorradoTMP           As String = "FacturaCompraItemBorradoTMP"
Public Const cscFcibTMPId                             As String = "fcibTMP_id"

'Provincia
Public Const cscProIdOrigen                           As String = "pro_id_origen"
Public Const cscProIdDestino                          As String = "pro_id_destino"

' Moneda
Public Const csTMoneda                                As String = "Moneda"
Public Const cscMonId                                 As String = "mon_id"
Public Const cscMonNombre                             As String = "mon_nombre"
Public Const cscMonSigno                              As String = "mon_signo"

' Cuenta
Public Const csTCuenta                                As String = "Cuenta"
Public Const cscCueId                                 As String = "cue_id"
Public Const cscCueNombre                             As String = "cue_nombre"

' Iva
Public Const cscbIvaRi                                As String = "bIvaRi"
Public Const cscbIvaRni                               As String = "bIvaRni"

' FacturaCompraPercepcion
Public Const csTFacturaCompraPercepcion                  As String = "FacturaCompraPercepcion"
Public Const cscFcPercId                                 As String = "fcperc_id"
Public Const cscFcPercOrden                              As String = "fcperc_orden"
Public Const cscFcPercBase                               As String = "fcperc_base"
Public Const cscFcPercPorcentaje                         As String = "fcperc_porcentaje"
Public Const cscFcPercImporte                            As String = "fcperc_importe"
Public Const cscFcPercOrigen                             As String = "fcperc_origen"
Public Const cscFcPercDescrip                            As String = "fcperc_descrip"

' FacturaCompraLegajo
Public Const csTFacturaCompraLegajo                     As String = "FacturaCompraLegajo"
Public Const cscFcLgjId                                 As String = "fclgj_id"
Public Const cscFcLgjOrden                              As String = "fclgj_orden"
Public Const cscFcLgjImporte                            As String = "fclgj_importe"
Public Const cscFcLgjImporteOrigen                      As String = "fclgj_importeorigen"
Public Const cscFcLgjDescrip                            As String = "fclgj_descrip"

' FacturaCompraPercepcion TMP
Public Const csTFacturaCompraPercepcionTMP               As String = "FacturaCompraPercepcionTMP"
Public Const cscFcPercTMPId                              As String = "fcpercTMP_id"

' FacturaCompraLegajoTMP
Public Const csTFacturaCompraLegajoTMP                  As String = "FacturaCompraLegajoTMP"
Public Const cscFcLgjTMPId                              As String = "fclgjTMP_id"

' FacturaCompraPercepcion Borrado TMP
Public Const csTFacturaCompraPercepcionBorradoTMP        As String = "FacturaCompraPercepcionBorradoTMP"
Public Const cscFcPercbTMPId                             As String = "fcpercbTMP_id"

' FacturaCompraPercepcion Borrado TMP
Public Const csTFacturaCompraLegajoBorradoTMP            As String = "FacturaCompraLegajoBorradoTMP"
Public Const cscFcLgjbTMPId                              As String = "fclgjbTMP_id"

' Percepcion
Public Const cscPercId                                   As String = "perc_id"
Public Const cscPercNombre                               As String = "perc_nombre"

' Cliente
'Public Const csTCliente                                As String = "Cliente"
'Public Const cscCliId                                  As String = "cli_id"
'Public Const cscCliNombre                              As String = "cli_nombre"
'Public Const cscCliCatfiscal                           As String = "cli_catfiscal"

' Stock
Public Const cscDeplIdOrigen                         As String = "depl_id_origen"
Public Const cscDeplIdDestino                        As String = "depl_id_destino"
Public Const cscDeplId                               As String = "depl_id"
Public Const cscDeplNombre                           As String = "depl_nombre"

' StockLote
Public Const csTStockLote                             As String = "StockLote"
Public Const cscStlId                                 As String = "stl_id"
Public Const cscStlCodigo                             As String = "stl_codigo"

' Remito Factura Compra TMP
Public Const csTRemitoFacturaCompraTMP                As String = "RemitoFacturaCompraTMP"
Public Const cscRcFcTMPId                             As String = "rcfcTMP_id"

' Remito Factura Compra
Public Const csTRemitoFacturaCompra                As String = "RemitoFacturaCompra"
Public Const cscRcFcId                             As String = "rcfc_id"
Public Const cscRcFcCantidad                       As String = "rcfc_cantidad"

' Remito Factura Compra TMP
Public Const csTRemitoDevolucionCompraTMP             As String = "RemitoDevolucionCompraTMP"
Public Const cscRcDcTMPId                             As String = "rcdcTMP_id"
Public Const cscRcDcId                                As String = "rcdc_id"
Public Const cscRcDcCantidad                          As String = "rcdc_cantidad"
Public Const cscRciIdDevolucion                       As String = "rci_id_devolucion"
Public Const cscRciIdRemito                           As String = "rci_id_remito"

' Tipo Operacion
Public Const cscToId                                   As String = "to_id"
Public Const cscToNombre                               As String = "to_nombre"

' OrdenCompra
Public Const csTOrdenCompra                      As String = "OrdenCompra"
Public Const cscOcId                             As String = "oc_id"
Public Const cscOcNumero                         As String = "oc_numero"
Public Const cscOcNrodoc                         As String = "oc_nrodoc"
Public Const cscOcDescrip                        As String = "oc_descrip"
Public Const cscOcFecha                          As String = "oc_fecha"
Public Const cscOcFechaentrega                   As String = "oc_fechaentrega"
Public Const cscOcNeto                           As String = "oc_neto"
Public Const cscOcIvari                          As String = "oc_ivari"
Public Const cscOcIvarni                         As String = "oc_ivarni"
Public Const cscOcTotal                          As String = "oc_total"
Public Const cscOcSubtotal                       As String = "oc_subtotal"
Public Const cscOcPendiente                      As String = "oc_pendiente"
Public Const cscOcDescuento1                     As String = "oc_descuento1"
Public Const cscOcDescuento2                     As String = "oc_descuento2"
Public Const cscOcImportedesc1                   As String = "oc_importedesc1"
Public Const cscOcImportedesc2                   As String = "oc_importedesc2"
Public Const cscOcFirmado                        As String = "oc_firmado"
Public Const cscOcOrdencompra                    As String = "oc_ordencompra"
Public Const cscOcPresupuesto                    As String = "oc_presupuesto"
Public Const cscOcMaquina                        As String = "oc_maquina"
Public Const cscOcMaquinanro                     As String = "oc_maquinanro"
Public Const cscOcMaquinamodelo                  As String = "oc_maquinamodelo"
Public Const cscOcFleteaereo                     As String = "oc_fleteaereo"
Public Const cscOcFletemaritimo                  As String = "oc_fletemaritimo"
Public Const cscOcFletecorreo                    As String = "oc_fletecorreo"
Public Const cscOcFletecamion                    As String = "oc_fletecamion"
Public Const cscOcFleteotros                     As String = "oc_fleteotros"

' OrdenCompraTMP
Public Const csTOrdenCompraTMP                    As String = "OrdenCompraTMP"
Public Const cscOcTMPId                           As String = "ocTMP_id"

' OrdenCompraItem
Public Const csTOrdenCompraItem                   As String = "OrdenCompraItem"
Public Const cscOciId                             As String = "oci_id"
Public Const cscOciOrden                          As String = "oci_orden"
Public Const cscOciCantidad                       As String = "oci_cantidad"
Public Const cscOciCantidadaremitir               As String = "oci_cantidadaremitir"
Public Const cscOciDescrip                        As String = "oci_descrip"
Public Const cscOciPrecio                         As String = "oci_precio"
Public Const cscOciPrecioUsr                      As String = "oci_precioUsr"
Public Const cscOciPrecioLista                    As String = "oci_precioLista"
Public Const cscOciDescuento                      As String = "oci_descuento"
Public Const cscOciNeto                           As String = "oci_neto"
Public Const cscOciIvari                          As String = "oci_ivari"
Public Const cscOciIvarni                         As String = "oci_ivarni"
Public Const cscOciImporte                        As String = "oci_importe"
Public Const cscOciIvariPorc                      As String = "oci_ivariporc"
Public Const cscOciIvarniPorc                     As String = "oci_ivarniporc"
Public Const cscOciPendiente                      As String = "oci_pendiente"
Public Const cscOciPendienteFac                   As String = "oci_pendientefac"

' OrdenCompraItemTMP
Public Const csTOrdenCompraItemTMP                As String = "OrdenCompraItemTMP"
Public Const cscOciTMPId                          As String = "ociTMP_id"

' OrdenCompraItemBorradoTMP
Public Const csTOrdenCompraItemBorradoTMP         As String = "OrdenCompraItemBorradoTMP"
Public Const cscOcibTMPId                         As String = "ocibTMP_id"

' Orden Factura Compra TMP
Public Const csTOrdenFacturaCompraTMP               As String = "OrdenFacturaCompraTMP"
Public Const cscOcFcTMPId                           As String = "ocfcTMP_id"

' Orden Factura Compra
Public Const csTOrdenFacturaCompra                  As String = "OrdenFacturaCompra"
Public Const cscOcFcId                              As String = "ocfc_id"
Public Const cscOcFcCantidad                        As String = "ocfc_cantidad"

' Devolucion Orden Compra TMP
Public Const csTOrdenDevolucionCompraTMP            As String = "OrdenDevolucionCompraTMP"
Public Const cscOcDcTMPId                           As String = "ocdcTMP_id"
Public Const cscOcDcId                              As String = "ocdc_id"
Public Const cscOcDcCantidad                        As String = "ocdc_cantidad"
Public Const cscOciIdDevolucion                     As String = "oci_id_devolucion"
Public Const cscOciIdOrden                          As String = "oci_id_Orden"

' Orden Remito Compra
Public Const csTOrdenRemitoCompra                  As String = "OrdenRemitoCompra"
Public Const cscOcRcId                             As String = "ocrc_id"
Public Const cscOcRcCantidad                       As String = "ocrc_cantidad"

' Orden Remito Compra TMP
Public Const csTOrdenRemitoCompraTMP                  As String = "OrdenRemitoCompraTMP"
Public Const cscOcRcTMPid                             As String = "ocrcTMP_id"

' Cotizacion
Public Const csTCotizacionCompra                      As String = "CotizacionCompra"
Public Const cscCotId                                 As String = "cot_id"
Public Const cscCotNumero                             As String = "cot_numero"
Public Const cscCotNrodoc                             As String = "cot_nrodoc"
Public Const cscCotDescrip                            As String = "cot_descrip"
Public Const cscCotFecha                              As String = "cot_fecha"
Public Const cscCotFechaentrega                       As String = "cot_fechaentrega"
Public Const cscCotNeto                               As String = "cot_neto"
Public Const cscCotIvari                              As String = "cot_ivari"
Public Const cscCotIvarni                             As String = "cot_ivarni"
Public Const cscCotSubtotal                           As String = "cot_subtotal"
Public Const cscCotTotal                              As String = "cot_total"
Public Const cscCotPendiente                          As String = "cot_pendiente"
Public Const cscCotFirmado                            As String = "cot_firmado"

' Cotizacion Item
Public Const csTCotizacionCompraItem                   As String = "CotizacionCompraItem"
Public Const cscCotiId                                 As String = "coti_id"
Public Const cscCotiOrden                              As String = "coti_orden"
Public Const cscCotiCantidad                           As String = "coti_cantidad"
Public Const cscCotiPendiente                          As String = "coti_pendiente"
Public Const cscCotiDescrip                            As String = "coti_descrip"
Public Const cscCotiPrecio                             As String = "coti_precio"
Public Const cscCotiPrecioUsr                          As String = "coti_precioUsr"
Public Const cscCotiPrecioLista                        As String = "coti_precioLista"
Public Const cscCotiDescuento                          As String = "coti_descuento"
Public Const cscCotiNeto                               As String = "coti_neto"
Public Const cscCotiIvari                              As String = "coti_ivari"
Public Const cscCotiIvarni                             As String = "coti_ivarni"
Public Const cscCotiIvariporc                          As String = "coti_ivariporc"
Public Const cscCotiIvarniporc                         As String = "coti_ivarniporc"
Public Const cscCotiImporte                            As String = "coti_importe"

' Presupuesto Compra
Public Const csTPresupuestoCompra                     As String = "PresupuestoCompra"
Public Const cscPrcId                                 As String = "prc_id"
Public Const cscPrcNumero                             As String = "prc_numero"
Public Const cscPrcNrodoc                             As String = "prc_nrodoc"
Public Const cscPrcDescrip                            As String = "prc_descrip"
Public Const cscPrcFecha                              As String = "prc_fecha"
Public Const cscPrcFechaentrega                       As String = "prc_fechaentrega"
Public Const cscPrcNeto                               As String = "prc_neto"
Public Const cscPrcIvari                              As String = "prc_ivari"
Public Const cscPrcIvarni                             As String = "prc_ivarni"
Public Const cscPrcSubtotal                           As String = "prc_subtotal"
Public Const cscPrcTotal                              As String = "prc_total"
Public Const cscPrcPendiente                          As String = "prc_pendiente"
Public Const cscPrcFirmado                            As String = "prc_firmado"
Public Const cscPrcDescuento1                         As String = "prc_descuento1"
Public Const cscPrcDescuento2                         As String = "prc_descuento2"
Public Const cscPrcImportedesc1                       As String = "prc_importedesc1"
Public Const cscPrcImportedesc2                       As String = "prc_importedesc2"

' Presupuesto Compra Item
Public Const csTPresupuestoCompraItem                  As String = "PresupuestoCompraItem"
Public Const cscPrciId                                 As String = "prci_id"
Public Const cscPrciOrden                              As String = "prci_orden"
Public Const cscPrciCantidad                           As String = "prci_cantidad"
Public Const cscPrciCantidadaremitir                   As String = "prci_cantidadaremitir"
Public Const cscPrciPendiente                          As String = "prci_pendiente"
Public Const cscPrciPendientepklst                     As String = "prci_pendientepklst"
Public Const cscPrciDescrip                            As String = "prci_descrip"
Public Const cscPrciPrecio                             As String = "prci_precio"
Public Const cscPrciPrecioUsr                          As String = "prci_precioUsr"
Public Const cscPrciPrecioLista                        As String = "prci_precioLista"
Public Const cscPrciDescuento                          As String = "prci_descuento"
Public Const cscPrciNeto                               As String = "prci_neto"
Public Const cscPrciIvari                              As String = "prci_ivari"
Public Const cscPrciIvarni                             As String = "prci_ivarni"
Public Const cscPrciIvariporc                          As String = "prci_ivariporc"
Public Const cscPrciIvarniporc                         As String = "prci_ivarniporc"
Public Const cscPrciImporte                            As String = "prci_importe"

' Pedido Orden de Compra
Public Const csTPedidoOrdenCompra                      As String = "PedidoOrdenCompra"
Public Const cscPcOcId                                 As String = "pcoc_id"
Public Const cscPcOcCantidad                           As String = "pcoc_cantidad"

' Pedido Orden de Compra TMP
Public Const csTPedidoOrdenCompraTMP                   As String = "PedidoOrdenCompraTMP"
Public Const cscPcOcTMPId                              As String = "pcocTMP_id"

' Pedido Cotizacion Compra
Public Const csTPedidoCotizacionCompra                  As String = "PedidoCotizacionCompra"
Public Const cscPccotId                                 As String = "pccot_id"
Public Const cscPccotCantidad                           As String = "pccot_cantidad"

' Pedido Cotizacion Compra TMP
Public Const csTPedidoCotizacionCompraTMP               As String = "PedidoCotizacionCompraTMP"
Public Const cscPccotTMPId                              As String = "pccotTMP_id"

' Asiento
Public Const cscAsId                                  As String = "as_id"

' Stock
Public Const cscStId                                  As String = "st_id"

' Despacho Importacion Calculo
Public Const csTDespachoImpCalculo                    As String = "DespachoImpCalculo"
Public Const cscDicId                                 As String = "dic_id"
Public Const cscDicNumero                             As String = "dic_numero"
Public Const cscDicFecha                              As String = "dic_fecha"
Public Const cscDicTipo                               As String = "dic_tipo"
Public Const cscDicTitulo                             As String = "dic_titulo"
Public Const cscDicDescrip                            As String = "dic_descrip"
Public Const cscDicVia                                As String = "dic_via"
Public Const cscDicViaempresa                         As String = "dic_viaempresa"
Public Const cscDicFactura                            As String = "dic_factura"
Public Const cscDicCambio1                            As String = "dic_cambio1"
Public Const cscDicCambio2                            As String = "dic_cambio2"
Public Const cscDicPase                               As String = "dic_pase"
Public Const cscDicTotalgtos                          As String = "dic_totalgtos"
Public Const cscDicPorcfob                            As String = "dic_porcfob"
Public Const cscDicVar                                As String = "dic_var"
Public Const cscDicPorcfobfinal                       As String = "dic_porcfobfinal"
Public Const cscDicTotal                              As String = "dic_total"
Public Const cscDicTotalorigen                        As String = "dic_totalorigen"

Public Const cscMonId1                                As String = "mon_id1"
Public Const cscMonId2                                As String = "mon_id2"

' Despacho Importacion Calculo Item
Public Const csTDespachoImpCalculoItem                 As String = "DespachoImpCalculoItem"
Public Const cscDiciId                                 As String = "dici_id"
Public Const cscDiciCodigo                             As String = "dici_codigo"
Public Const cscDiciValor                              As String = "dici_valor"
Public Const cscDiciImporte                            As String = "dici_importe"
Public Const cscDiciPorc                               As String = "dici_porc"
Public Const cscDiciDescrip                            As String = "dici_descrip"

' Cliente
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"

' Despacho Importacion Calculo Posicion Arancelaria
Public Const csTDespachoImpPosicionArancel             As String = "DespachoImpCalculoPosicionArancel"
Public Const cscDicpId                                 As String = "dicp_id"
Public Const cscDicpDerechos                           As String = "dicp_derechos"
Public Const cscDicpEstadisticas                       As String = "dicp_estadisticas"
Public Const cscDicpIva                                As String = "dicp_iva"
Public Const cscDicpIva3431                            As String = "dicp_iva3431"
Public Const cscDicpGanancias                          As String = "dicp_ganancias"
Public Const cscDicpIgb                                As String = "dicp_igb"
Public Const cscDicpGastoenvio                         As String = "dicp_gastoenvio"

' PosicionArancel
Public Const cscPoarId                                 As String = "poar_id"
Public Const cscPoarNombre                             As String = "poar_nombre"
