Attribute VB_Name = "mVentaConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mVentaConstantes
' 06-01-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mVentaConstantes"

' Wizard
Public Const c_Wiz_Key_ResultTitle = "RESULTT"
Public Const c_Wiz_Key_Result = "RESULT"
Public Const c_Wiz_Key_Cliente = "CLIENT"

Public Const c_Wiz_Key_Doc = "DOC"
Public Const c_Wiz_Key_Deposito = "DEP"
Public Const c_Wiz_Key_Remitos = "REMITOS"
Public Const c_Wiz_Key_Todos = "TODOS"
Public Const c_Wiz_Key_OnlySelected = "ONLYSEL" ' Edit From ListDoc

Public Const c_Wiz_Key_Items = "ITEMS"
Public Const c_Wiz_Key_TodosItems = "TODOS-ITEMS"
Public Const c_Wiz_Key_LPAplyAll = "LPALL" 'lp
Public Const c_Wiz_Key_LPAplyZero = "LPZERO" 'lp

Public Const c_Wiz_Key_Total = "Total"
Public Const c_Wiz_Key_TotalItems = "TotalItems"
Public Const c_Wiz_Key_Pendiente = "Pendiente"

Public Const c_Wiz_Key_Fecha = "Fecha"
Public Const c_Wiz_Key_FechaIva = "FechaIVA"
Public Const c_Wiz_Key_Cliente2 = "Cliente"
Public Const c_Wiz_Key_Sucursal = "Sucursal"
Public Const c_Wiz_Key_CondicionPago = "Condición de Pago"
Public Const c_Wiz_Key_Observaciones = "Observaciones"
Public Const c_Wiz_Key_Comprobante = "Comprobante"
Public Const c_Wiz_Key_RvComprobante = "Remito"
Public Const c_Wiz_Key_Legajo = "Legajo"
Public Const c_Wiz_Key_CentroCosto = "Centro de Costo"
Public Const c_Wiz_Key_ListaPrecio = "LP" 'lp
Public Const c_Wiz_Key_ListaPrecio2 = "Lista de Precio"
Public Const c_Wiz_Key_ListaDescuento = "Lista de Descuento"
Public Const c_Wiz_Key_Desc1 = "Desc. 1"
Public Const c_Wiz_Key_Desc2 = "Desc. 2"

Public Const c_ClienteDataAdd = "ClienteDataAdd"

' Descuento
'
Public Const KW_DESCUENTO1                  As Integer = 520
Public Const KW_DESCUENTO2                  As Integer = 521


Public Const c_Wiz_Key_Vendedor = "Vendedor" 'lp
Public Const c_Wiz_Key_Cotizacion = "Cotizacion" 'lp
Public Const c_Wiz_Key_Origen = "Origen" 'lp
Public Const c_Wiz_Key_Destino = "Destino" 'lp
Public Const c_Wiz_Key_Transporte = "Transporte"
Public Const c_Wiz_Key_SucCliente = "Sucursal del Cliente"
Public Const c_Wiz_Key_Retiro = "Retiro"
Public Const c_Wiz_Key_Guia = "Guia"
Public Const c_Wiz_Key_Chofer = "Chofer"
Public Const c_Wiz_Key_Camion = "Camion"
Public Const c_Wiz_Key_CamionSemi = "Semi"
Public Const c_Wiz_Key_Destinatario = "Destinatario"
Public Const c_Wiz_Key_OrdenCompra = "Orden de Compra"

Public Const c_Wiz_Key_Pedidos = "PEDIDOS"
Public Const c_Wiz_Key_PackingList = "PACKINGLIST"

Public Const c_Wiz_Key_Proyectos = "PROYECTOS"
Public Const c_Wiz_Key_Horas = "HORAS"
Public Const c_Wiz_Key_TodosHoras = "TODOS-HORAS"
Public Const c_Wiz_Key_TotalHoras = "TotalHoras"


' Rama
Public Const cscRamNombre                       As String = "ram_nombre"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscDocRvDesdePv                          As String = "doc_rv_desde_pv"
Public Const cscDocRvDesdeOs                          As String = "doc_rv_desde_os"
Public Const cscDocTipoFactura                        As String = "doc_tipofactura"
Public Const cscDocIdRemito                           As String = "doc_id_remito"
Public Const cscDocIdStock                            As String = "doc_id_stock"
Public Const cscDocGeneraRemito                       As String = "doc_generaremito"
Public Const cscDocMueveStock                         As String = "doc_muevestock"
Public Const cscDocRvBom                              As String = "doc_rv_bom"
Public Const cscDocFvSinPercepcion                    As String = "doc_fv_sinpercepcion"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"
Public Const cscCliCuit                                As String = "cli_cuit"
Public Const cscliCodigoComunidad                      As String = "cli_codigoComunidad"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"
Public Const cscCpgEsLibre                            As String = "cpg_eslibre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Vendedor
Public Const csTVendedor                         As String = "Vendedor"
Public Const cscVenId                            As String = "ven_id"
Public Const cscVenNombre                        As String = "ven_nombre"

' Zona
Public Const csTZona                             As String = "Zona"
Public Const cscZonId                            As String = "zon_id"
Public Const cscZonNombre                        As String = "zon_nombre"

' RemitoVenta
Public Const csTRemitoVenta                          As String = "RemitoVenta"
Public Const cscRvId                                 As String = "rv_id"
Public Const cscRvNumero                             As String = "rv_numero"
Public Const cscRvNrodoc                             As String = "rv_nrodoc"
Public Const cscRvDescrip                            As String = "rv_descrip"
Public Const cscRvFecha                              As String = "rv_fecha"
Public Const cscRvFechaentrega                       As String = "rv_fechaentrega"
Public Const cscRvNeto                               As String = "rv_neto"
Public Const cscRvIvari                              As String = "rv_ivari"
Public Const cscRvIvarni                             As String = "rv_ivarni"
Public Const cscRvSubtotal                           As String = "rv_subtotal"
Public Const cscRvTotal                              As String = "rv_total"
Public Const cscRvPendiente                          As String = "rv_pendiente"
Public Const cscRvFirmado                            As String = "rv_firmado"
Public Const cscRvDescuento1                         As String = "rv_descuento1"
Public Const cscRvDescuento2                         As String = "rv_descuento2"
Public Const cscRvImportedesc1                       As String = "rv_importedesc1"
Public Const cscRvImportedesc2                       As String = "rv_importedesc2"
Public Const cscRvCotizacion                         As String = "rv_cotizacion"
Public Const cscRvRetiro                             As String = "rv_retiro"
Public Const cscRvGuia                               As String = "rv_guia"
Public Const cscRvDestinatario                       As String = "rv_destinatario"
Public Const cscRvOrdenCompra                        As String = "rv_ordencompra"

' RemitoVentaTMP
Public Const csTRemitoVentaTMP                       As String = "RemitoVentaTMP"
Public Const cscRvTMPId                              As String = "rvTMP_id"

' Lista de Precios
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

' Lista de Descuentos
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' RemitoVentaItem
Public Const csTRemitoVentaItem                       As String = "RemitoVentaItem"
Public Const cscRviId                                 As String = "rvi_id"
Public Const cscRviOrden                              As String = "rvi_orden"
Public Const cscRviCantidad                           As String = "rvi_cantidad"
Public Const cscRviCantidadaremitir                   As String = "rvi_cantidadaremitir"
Public Const cscRviPendiente                          As String = "rvi_pendiente"
Public Const cscRviPendientefac                       As String = "rvi_pendientefac"
Public Const cscRviDescrip                            As String = "rvi_descrip"
Public Const cscRviPrecio                             As String = "rvi_precio"
Public Const cscRviPrecioUsr                          As String = "rvi_precioUsr"
Public Const cscRviPrecioLista                        As String = "rvi_precioLista"
Public Const cscRviDescuento                          As String = "rvi_descuento"
Public Const cscRviNeto                               As String = "rvi_neto"
Public Const cscRviIvari                              As String = "rvi_ivari"
Public Const cscRviIvarni                             As String = "rvi_ivarni"
Public Const cscRviIvariporc                          As String = "rvi_ivariporc"
Public Const cscRviIvarniporc                         As String = "rvi_ivarniporc"
Public Const cscRviImporte                            As String = "rvi_importe"

' Producto
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombreCompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreVenta                        As String = "pr_Nombreventa"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"
Public Const cscCueidventa                           As String = "cue_id_venta"
Public Const cscPrLlevaNroSerie                      As String = "pr_llevanroserie"
Public Const cscPrLlevaNroLote                       As String = "pr_llevanrolote"
Public Const cscPrLoteFifo                           As String = "pr_lotefifo"
Public Const cscPrEskit                              As String = "pr_eskit"
Public Const cscPrIdKit                              As String = "pr_id_kit"
Public Const cscPrIdItem                             As String = "pr_id_item"
Public Const cscCcosIdVenta                          As String = "ccos_id_venta"
Public Const cscPrPorcInternoV                       As String = "pr_porcinternov"

' Producto BOM
Public Const cscPbmId                                As String = "pbm_id"
Public Const cscPbmNombre                            As String = "pbm_nombre"

' Producto BOM Item
Public Const cscPbmiCantidad                         As String = "pbmi_cantidad"
Public Const cscPbmiTemp                             As String = "pbmi_temp"

' Producto BOM Elaborado
Public Const cscPbmeCantidad                         As String = "pbme_cantidad"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

' RemitoVentaTMP
Public Const csTRemitoVentaItemTMP              As String = "RemitoVentaItemTMP"
Public Const cscRviTMPId                        As String = "rviTMP_id"

' Items Borrados de Remito de venta
Public Const csTRemitoVentaItemBorradoTMP             As String = "RemitoVentaItemBorradoTMP"
Public Const cscRvibTMPId                             As String = "rvibTMP_id"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

' Talonario
Public Const cscTaId                            As String = "ta_id"

' FacturaVenta
Public Const csTFacturaVenta                    As String = "FacturaVenta"
Public Const cscFvId                            As String = "fv_id"
Public Const cscFvNumero                        As String = "fv_numero"
Public Const cscFvNrodoc                        As String = "fv_nrodoc"
Public Const cscFvDescrip                       As String = "fv_descrip"
Public Const cscFvFecha                         As String = "fv_fecha"
Public Const cscFvFechaentrega                  As String = "fv_fechaentrega"
Public Const cscFvFechaVto                      As String = "fv_fechaVto"
Public Const cscFvFechaIva                      As String = "fv_fechaIva"
Public Const cscFvNeto                          As String = "fv_neto"
Public Const cscFvIvari                         As String = "fv_ivari"
Public Const cscFvIvarni                        As String = "fv_ivarni"
Public Const cscFvInternos                      As String = "fv_internos"
Public Const cscFvSubtotal                      As String = "fv_subtotal"
Public Const cscFvTotal                         As String = "fv_total"
Public Const cscFvTotalOrigen                   As String = "fv_totalorigen"
Public Const cscFvPendiente                     As String = "fv_pendiente"
Public Const cscFvFirmado                       As String = "fv_firmado"
Public Const cscFvDescuento1                    As String = "fv_descuento1"
Public Const cscFvDescuento2                    As String = "fv_descuento2"
Public Const cscFvImportedesc1                  As String = "fv_importedesc1"
Public Const cscFvImportedesc2                  As String = "fv_importedesc2"
Public Const cscFvGrabarAsiento                 As String = "fv_grabarasiento"
Public Const cscFvCotizacion                    As String = "fv_cotizacion"
Public Const cscFvCai                           As String = "fv_cai"
Public Const cscFvTotalPercepciones             As String = "fv_totalpercepciones"
Public Const cscFvOrdenCompra                   As String = "fv_ordencompra"
Public Const cscFvCAE                           As String = "fv_cae"

' FacturaVentaTMP
Public Const csTFacturaVentaTMP                  As String = "FacturaVentaTMP"
Public Const cscFvTMPId                          As String = "fvTMP_id"

' FacturaVentaItem
Public Const csTFacturaVentaItem                      As String = "FacturaVentaItem"
Public Const cscFviId                                 As String = "fvi_id"
Public Const cscFviOrden                              As String = "fvi_orden"
Public Const cscFviCantidad                           As String = "fvi_cantidad"
Public Const cscFviCantidadaremitir                   As String = "fvi_cantidadaremitir"
Public Const cscFviPendiente                          As String = "fvi_pendiente"
Public Const cscFviDescrip                            As String = "fvi_descrip"
Public Const cscFviPrecio                             As String = "fvi_precio"
Public Const cscFviPrecioUsr                          As String = "fvi_precioUsr"
Public Const cscFviPrecioLista                        As String = "fvi_precioLista"
Public Const cscFviDescuento                          As String = "fvi_descuento"
Public Const cscFviNeto                               As String = "fvi_neto"
Public Const cscFviIvari                              As String = "fvi_ivari"
Public Const cscFviIvarni                             As String = "fvi_ivarni"
Public Const cscFviInternos                           As String = "fvi_internos"
Public Const cscFviIvariporc                          As String = "fvi_ivariporc"
Public Const cscFviIvarniporc                         As String = "fvi_ivarniporc"
Public Const cscFviInternosPorc                       As String = "fvi_internosporc"
Public Const cscFviImporteOrigen                      As String = "fvi_importeorigen"
Public Const cscFviImporte                            As String = "fvi_importe"
Public Const cscCueIdIvaRI                            As String = "cue_id_IvaRI"
Public Const cscCueIdIvaRNI                           As String = "cue_id_IvaRNI"
Public Const cscFviNoStock                            As String = "fvi_nostock"

' FacturaVentaItemTMP
Public Const csTFacturaVentaItemTMP                   As String = "FacturaVentaItemTMP"
Public Const cscFviTMPId                              As String = "fviTMP_id"

' FacturaVentaItemBarradoTMP
Public Const csTFacturaVentaItemBorradoTMP            As String = "FacturaVentaItemBorradoTMP"
Public Const cscFvibTMPId                             As String = "fvibTMP_id"

' FacturaVentaPercepcion
Public Const csTFacturaVentaPercepcion                   As String = "FacturaVentaPercepcion"
Public Const cscFvPercId                                 As String = "fvperc_id"
Public Const cscFvPercOrden                              As String = "fvperc_orden"
Public Const cscFvPercBase                               As String = "fvperc_base"
Public Const cscFvPercPorcentaje                         As String = "fvperc_porcentaje"
Public Const cscFvPercImporte                            As String = "fvperc_importe"
Public Const cscFvPercOrigen                             As String = "fvperc_origen"
Public Const cscFvPercDescrip                            As String = "fvperc_descrip"

' FacturaVentaPercepcion TMP
Public Const csTFacturaVentaPercepcionTMP               As String = "FacturaVentaPercepcionTMP"
Public Const cscFvPercTMPId                             As String = "fvpercTMP_id"

' FacturaVentaPercepcion Borrado TMP
Public Const csTFacturaVentaPercepcionBorradoTMP         As String = "FacturaVentaPercepcionBorradoTMP"
Public Const cscFvPercbTMPId                             As String = "fvpercbTMP_id"

' Cuenta
Public Const csTCuenta                                As String = "Cuenta"
Public Const cscCueId                                 As String = "cue_id"
Public Const cscCueNombre                             As String = "cue_nombre"

' Moneda
Public Const csTMoneda                                As String = "Moneda"
Public Const cscMonId                                 As String = "Mon_id"
Public Const cscMonNombre                             As String = "Mon_nombre"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjTitulo                             As String = "lgj_Titulo"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"

'Provincia
Public Const cscProIdOrigen                           As String = "pro_id_origen"
Public Const cscProIdDestino                          As String = "pro_id_destino"

' Iva
Public Const cscbIvaRi                                As String = "bIvaRi"
Public Const cscbIvaRni                               As String = "bIvaRni"

' Legajo
Public Const csLegajo = 15001

' Pedido Remito Venta TMP
Public Const csTPedidoRemitoVentaTMP                  As String = "PedidoRemitoVentaTMP"
Public Const cscPvRvTMPid                             As String = "pvrvTMP_id"

' Pedido Remito Venta
Public Const csTPedidoRemitoVenta                  As String = "PedidoRemitoVenta"
Public Const cscPvRvId                             As String = "pvrv_id"
Public Const cscPvRvCantidad                       As String = "pvrv_cantidad"

' Pedido Factura Venta TMP
Public Const csTPedidoFacturaVentaTMP                 As String = "PedidoFacturaVentaTMP"
Public Const cscPvFvTMPId                             As String = "pvfvTMP_id"

' Pedido Factura Venta
Public Const csTPedidoFacturaVenta                 As String = "PedidoFacturaVenta"
Public Const cscPvFvId                             As String = "pvfv_id"
Public Const cscPvFvCantidad                       As String = "pvfv_cantidad"

' Remito Factura Venta TMP
Public Const csTRemitoFacturaVentaTMP                 As String = "RemitoFacturaVentaTMP"
Public Const cscRvFvTMPId                             As String = "rvfvTMP_id"

' Hora
Public Const cscHoraId                                 As String = "hora_id"
Public Const cscHoraHoras                              As String = "hora_horas"
Public Const cscHoraMinutos                            As String = "hora_minutos"
Public Const cscHoraPendiente                          As String = "hora_pendiente"
Public Const cscHoraImporte                            As String = "hora_importe"
Public Const cscHoraTitulo                             As String = "hora_titulo"

Public Const cscHoraIvariporc                          As String = "hora_ivariporc"
Public Const cscHoraIvarniporc                         As String = "hora_ivarniporc"

' ProyctoPrecio
Public Const cscProypId                                As String = "proyp_id"
Public Const cscProypPrecio                            As String = "proyp_precio"
Public Const cscProypPrecioIva                         As String = "proyp_precioIva"

' Hora Factura Venta TMP
Public Const csTHoraFacturaVentaTMP                   As String = "HoraFacturaVentaTMP"
Public Const cscHoraFvTMPId                           As String = "horafvTMP_id"

' Hora Factura Venta
Public Const csTHoraFacturaVenta                      As String = "HoraFacturaVenta"
Public Const cscHoraFvId                              As String = "horafv_id"
Public Const cscHoraFvCantidad                        As String = "horafv_cantidad"

' Proyecto
Public Const csTProyecto                               As String = "Proyecto"
Public Const cscProyId                                 As String = "proy_id"
Public Const cscProyNombre                             As String = "proy_nombre"
Public Const cscProyDescrip                            As String = "proy_descrip"

' Remito Factura Venta TMP
Public Const csTRemitoDevolucionVentaTMP              As String = "RemitoDevolucionVentaTMP"
Public Const cscRvDvTMPId                             As String = "rvdvTMP_id"
Public Const cscRvDvId                                As String = "rvdv_id"
Public Const cscRvDvCantidad                          As String = "rvdv_cantidad"
Public Const cscRviIdDevolucion                       As String = "rvi_id_devolucion"
Public Const cscRviIdRemito                           As String = "rvi_id_remito"

' Remito Factura Venta
Public Const csTRemitoFacturaVenta                 As String = "RemitoFacturaVenta"
Public Const cscRvFvId                             As String = "rvfv_id"
Public Const cscRvFvCantidad                       As String = "rvfv_cantidad"

' Packing List Factura Venta TMP
Public Const csTPackingListFacturaVentaTMP         As String = "PackingListFacturaVentaTMP"
Public Const cscPklstFvTMPId                       As String = "pklstfvTMP_id"

' Packing List Factura Venta
Public Const csTPackingListFacturaVenta            As String = "PackingListFacturaVenta"
Public Const cscPklstFvId                          As String = "pklstfv_id"
Public Const cscPklstFvCantidad                    As String = "pklstfv_cantidad"

' Packing List
Public Const csTPackingList                             As String = "PackingList"
Public Const cscPklstId                                 As String = "pklst_id"
Public Const cscPklstNumero                             As String = "pklst_numero"
Public Const cscPklstNrodoc                             As String = "pklst_nrodoc"
Public Const cscPklstFecha                              As String = "pklst_fecha"
Public Const cscPklstDescrip                            As String = "pklst_descrip"
Public Const cscPklstTotal                              As String = "pklst_total"

' Packing List Item
Public Const cscPklstiId                                 As String = "pklsti_id"
Public Const cscPklstiCantidad                           As String = "pklsti_cantidad"
Public Const cscPklstiPendientefac                       As String = "pklsti_pendientefac"
Public Const cscPklstiDescrip                            As String = "pklsti_descrip"
Public Const cscPklstiPrecio                             As String = "pklsti_precio"
Public Const cscPklstiPrecioUsr                          As String = "pklsti_precioUsr"
Public Const cscPklstiPrecioLista                        As String = "pklsti_precioLista"
Public Const cscPklstiDescuento                          As String = "pklsti_descuento"
Public Const cscPklstiIvariporc                          As String = "pklsti_ivariporc"
Public Const cscPklstiIvarniporc                         As String = "pklsti_ivarniporc"
Public Const cscPklstiImporte                            As String = "pklsti_importe"

' Stock
Public Const csTDepositoLogico                       As String = "DepositoLogico"
Public Const cscDeplIdOrigen                         As String = "depl_id_origen"
Public Const cscDeplIdDestino                        As String = "depl_id_destino"
Public Const cscDeplId                               As String = "depl_id"
Public Const cscDeplIdTemp                           As String = "depl_id_temp"
Public Const cscDeplNombre                           As String = "depl_nombre"
Public Const cscDepfId                               As String = "depf_id"

' Cliente Sucursal
Public Const cscClisId                               As String = "clis_id"
Public Const cscClisNombre                           As String = "clis_nombre"

' Proveedor
Public Const cscProvId                               As String = "prov_id"
Public Const cscProvNombre                           As String = "prov_nombre"

' Producto Numero Serie
Public Const csTProductoNumeroSerie                    As String = "ProductoNumeroSerie"
Public Const cscPrnsId                                 As String = "prns_id"
Public Const cscPrnsCodigo                             As String = "prns_codigo"
Public Const cscPrnsDescrip                            As String = "prns_descrip"
Public Const cscPrnsFechavto                           As String = "prns_fechavto"

' Remito Venta Item Serie
Public Const csTRemitoVentaItemSerieTMP                As String = "RemitoVentaItemSerieTMP"
Public Const cscRvisTMPId                              As String = "rvisTMP_id"
Public Const cscRvisOrden                              As String = "rvis_orden"

' Remito Venta Item Insumo
Public Const csTRemitoVentaItemInsumoTMP               As String = "RemitoVentaItemInsumoTMP"
Public Const cscRviiTMPId                              As String = "rviiTMP_id"
Public Const cscRviiTMPCantidad                        As String = "rviiTMP_cantidad"
Public Const cscRviiTMPCantidadAux                     As String = "rviiTMP_cantidadAux"
Public Const cscRviiTMPTemp                            As String = "rviiTMP_temp"

' Factura Venta Item Serie
Public Const csTFacturaVentaItemSerieTMP               As String = "FacturaVentaItemSerieTMP"
Public Const cscFvisTMPId                              As String = "fvisTMP_id"
Public Const cscFvisOrden                              As String = "fvis_orden"

' Transporte
Public Const csTTransporte                             As String = "Transporte"
Public Const cscTransId                                As String = "trans_id"
Public Const cscTransNombre                            As String = "trans_nombre"

' Tipo Operacion
Public Const cscToId                                   As String = "to_id"
Public Const cscToNombre                               As String = "to_nombre"

' StockLote
Public Const csTStockLote                             As String = "StockLote"
Public Const cscStlId                                 As String = "stl_id"
Public Const cscStlCodigo                             As String = "stl_codigo"

' Asiento
Public Const cscAsId                                  As String = "as_id"
Public Const cscAsNrodoc                              As String = "as_nrodoc"
Public Const cscAsDocCliente                          As String = "as_doc_cliente"
Public Const cscAsFecha                               As String = "as_fecha"

' Stock
Public Const cscStId                                  As String = "st_id"
Public Const cscStIdConsumo                           As String = "st_id_consumo"
Public Const cscStIdConsumoTemp                       As String = "st_id_consumoTemp"
Public Const cscStIdProducido                         As String = "st_id_producido"

' Presupuesto de Venta
Public Const csTPresupuestoVentaTMP                    As String = "PresupuestoVentaTMP"
Public Const cscPrvTMPId                               As String = "prvtmp_id"
Public Const csTPresupuestoVenta                       As String = "presupuestoVenta"
Public Const cscPrvId                                  As String = "prv_id"
Public Const cscPrvNumero                              As String = "prv_numero"
Public Const cscPrvNrodoc                              As String = "prv_nrodoc"
Public Const cscPrvDescrip                             As String = "prv_descrip"
Public Const cscPrvFecha                               As String = "prv_fecha"
Public Const cscPrvFechaentrega                        As String = "prv_fechaentrega"
Public Const cscPrvFirmado                             As String = "prv_firmado"
Public Const cscPrvNeto                                As String = "prv_neto"
Public Const cscPrvIvari                               As String = "prv_ivari"
Public Const cscPrvIvarni                              As String = "prv_ivarni"
Public Const cscPrvTotal                               As String = "prv_total"
Public Const cscPrvSubTotal                            As String = "prv_subtotal"
Public Const cscPrvDescuento1                          As String = "prv_descuento1"
Public Const cscPrvDescuento2                          As String = "prv_descuento2"
Public Const cscPrvImporteDesc1                        As String = "prv_importedesc1"
Public Const cscPrvImporteDesc2                        As String = "prv_importedesc2"

' PresupuestoVentaItem
Public Const csTPresupuestoVentaItemTMP                As String = "PresupuestoVentaItemTMP"
Public Const cscPrviTMPId                              As String = "prvitmp_id"
Public Const csTPresupuestoVentaItem                   As String = "PresupuestoVentaItem"
Public Const cscPrviId                                 As String = "prvi_id"
Public Const cscPrviOrden                              As String = "prvi_orden"
Public Const cscPrviCantidad                           As String = "prvi_cantidad"
Public Const cscPrviCantidadaremitir                   As String = "prvi_cantidadaremitir"
Public Const cscPrviDescrip                            As String = "prvi_descrip"
Public Const cscPrviPrecio                             As String = "prvi_precio"
Public Const cscPrviNeto                               As String = "prvi_neto"
Public Const cscPrviIvari                              As String = "prvi_ivari"
Public Const cscPrviIvarni                             As String = "prvi_ivarni"
Public Const cscPrviIvariPorc                          As String = "prvi_ivariporc"
Public Const cscPrviIvarniPorc                         As String = "prvi_ivarniporc"
Public Const cscPrviImporte                            As String = "prvi_importe"
Public Const cscPrviPrecioUsr                          As String = "prvi_precioUsr"
Public Const cscPrviPrecioLista                        As String = "prvi_precioLista"
Public Const cscPrviDescuento                          As String = "prvi_descuento"
Public Const cscPrviPendiente                          As String = "prvi_pendiente"
Public Const cscPrviPendientePklst                     As String = "prvi_pendientepklst"

' Items Borrados de Presupuesto de venta
Public Const csTPresupuestoVentaItemBorradoTMP         As String = "PresupuestoVentaItemBorradoTMP"
Public Const cscPrvibTMPId                             As String = "prvibTMP_id"

' Presupuesto Pedido Venta
Public Const csTPresupuestoPedidoVenta              As String = "PresupuestoPedidoVenta"
Public Const cscPrvPvId                             As String = "prvpv_id"
Public Const cscPrvPvCantidad                       As String = "prvpv_cantidad"

' Presupuesto Pedido Venta TMP
Public Const csTPresupuestoPedidoVentaTMP              As String = "PresupuestoPedidoVentaTMP"
Public Const cscPrvPvTMPId                             As String = "prvpvTMP_id"

' Presupuesto Devolucion Venta TMP
Public Const csTPresupuestoDevolucionVentaTMP          As String = "PresupuestoDevolucionVentaTMP"
Public Const cscPrvDvTMPId                             As String = "prvdvTMP_id"
Public Const cscPrvDvId                                As String = "prvdv_id"
Public Const cscPrvDvCantidad                          As String = "prvdv_cantidad"
Public Const cscPrviIdDevolucion                       As String = "prvi_id_devolucion"
Public Const cscPrviIdPresupuesto                      As String = "prvi_id_presupuesto"

' Pedidos de Venta
Public Const csTPedidoVentaTMP                        As String = "PedidoVentaTMP"
Public Const cscPvTMPId                               As String = "pvtmp_id"
Public Const csTPedidoVenta                           As String = "PedidoVenta"
Public Const cscPvId                                  As String = "pv_id"
Public Const cscPvNumero                              As String = "pv_numero"
Public Const cscPvNrodoc                              As String = "pv_nrodoc"
Public Const cscPvDescrip                             As String = "pv_descrip"
Public Const cscPvFecha                               As String = "pv_fecha"
Public Const cscPvFechaentrega                        As String = "pv_fechaentrega"
Public Const cscPvFirmado                             As String = "pv_firmado"
Public Const cscPvNeto                                As String = "pv_neto"
Public Const cscPvIvari                               As String = "pv_ivari"
Public Const cscPvIvarni                              As String = "pv_ivarni"
Public Const cscPvTotal                               As String = "pv_total"
Public Const cscPvSubTotal                            As String = "pv_subtotal"
Public Const cscPvDescuento1                          As String = "pv_descuento1"
Public Const cscPvDescuento2                          As String = "pv_descuento2"
Public Const cscPvImporteDesc1                        As String = "pv_importedesc1"
Public Const cscPvImporteDesc2                        As String = "pv_importedesc2"
Public Const cscPvOrdenCompra                         As String = "pv_ordencompra"
Public Const cscPvDestinatario                        As String = "pv_destinatario"

' Items Borrados de pedidos de venta
Public Const csTPedidoVentaItemBorradoTMP             As String = "PedidoVentaItemBorradoTMP"
Public Const cscPvibTMPId                             As String = "pvibTMP_id"

' Items de Pedidos de Venta
Public Const csTPedidoVentaItemTMP                    As String = "PedidoVentaItemTMP"
Public Const cscPviTMPId                              As String = "pvitmp_id"
Public Const csTPedidoVentaItem                       As String = "PedidoVentaItem"
Public Const cscPviId                                 As String = "pvi_id"
Public Const cscPviOrden                              As String = "pvi_orden"
Public Const cscPviCantidad                           As String = "pvi_cantidad"
Public Const cscPviCantidadaremitir                   As String = "pvi_cantidadaremitir"
Public Const cscPviDescrip                            As String = "pvi_descrip"
Public Const cscPviPrecio                             As String = "pvi_precio"
Public Const cscPviNeto                               As String = "pvi_neto"
Public Const cscPviIvari                              As String = "pvi_ivari"
Public Const cscPviIvarni                             As String = "pvi_ivarni"
Public Const cscPviIvariPorc                          As String = "pvi_ivariporc"
Public Const cscPviIvarniPorc                         As String = "pvi_ivarniporc"
Public Const cscPviImporte                            As String = "pvi_importe"
Public Const cscPviPrecioUsr                          As String = "pvi_precioUsr"
Public Const cscPviPrecioLista                        As String = "pvi_precioLista"
Public Const cscPviDescuento                          As String = "pvi_descuento"
Public Const cscPviPendiente                          As String = "pvi_pendiente"
Public Const cscPviPendientePklst                     As String = "pvi_pendientepklst"

' Deposito
Public Const cscRamIdStock                            As String = "ram_id_stock"
Public Const cscRamaStock                             As String = "ramastock"

' OrdenServicio
Public Const cscOsId                                 As String = "os_id"
Public Const cscOsNumero                             As String = "os_numero"
Public Const cscOsNrodoc                             As String = "os_nrodoc"
Public Const cscOsFecha                              As String = "os_fecha"
Public Const cscOsTotal                              As String = "os_total"
Public Const cscOsDescrip                            As String = "os_descrip"

' OrdenServicioItem
Public Const cscOsiId                                 As String = "osi_id"
Public Const cscOsiCantidad                           As String = "osi_cantidad"
Public Const cscOsiCantidadaremitir                   As String = "osi_cantidadaremitir"
Public Const cscOsiPrecio                             As String = "osi_precio"
Public Const cscOsiPendiente                          As String = "osi_pendiente"
Public Const cscOsiImporte                            As String = "osi_importe"
Public Const cscOsiDescrip                            As String = "osi_descrip"
Public Const cscOsiPrecioUsr                          As String = "osi_precioUsr"
Public Const cscOsiPrecioLista                        As String = "osi_precioLista"
Public Const cscOsiIvari                              As String = "osi_ivari"
Public Const cscOsiIvarni                             As String = "osi_ivarni"
Public Const cscOsiIvariporc                          As String = "osi_ivariporc"
Public Const cscOsiIvarniporc                         As String = "osi_ivarniporc"
Public Const cscOsiDescuento                          As String = "osi_descuento"

' Orden Remito Venta
Public Const cscOsRvId                                As String = "osrv_id"
Public Const cscOsRvCantidad                          As String = "osrv_cantidad"

' Orden Remito Venta TMP
Public Const csTOrdenRemitoVentaTMP                   As String = "OrdenRemitoVentaTMP"
Public Const cscOsRvTMPid                             As String = "osrvTMP_id"

' Percepcion
Public Const cscPercId                                  As String = "perc_id"
Public Const cscPercNombre                              As String = "perc_nombre"
Public Const cscPercImporteMinimo                       As String = "perc_importeminimo"

' Percepcion Categoria Fiscal
Public Const cscPercCatfBase                            As String = "perccatf_base"

' Percepcion Item
Public Const cscPerciImporteDesde                       As String = "perci_importedesde"
Public Const cscPerciImporteHasta                       As String = "perci_importehasta"
Public Const cscPerciPorcentaje                         As String = "perci_porcentaje"
Public Const cscPerciImportefijo                        As String = "perci_importefijo"

' Chofer
Public Const cscChofId                                  As String = "chof_id"
Public Const cscChofNombre                              As String = "chof_nombre"

' Contacto
Public Const cscContId                                  As String = "cont_id"
Public Const cscContNombre                              As String = "cont_nombre"

' Hoja de Ruta
Public Const csTHojaRuta                                As String = "HojaRuta"
Public Const cscHrId                                    As String = "hr_id"
Public Const cscHrNumero                                As String = "hr_numero"
Public Const cscHrNrodoc                                As String = "hr_nrodoc"
Public Const cscHrDescrip                               As String = "hr_descrip"
Public Const cscHrFecha                                 As String = "hr_fecha"
Public Const cscHrFechaentrega                          As String = "hr_fechaentrega"
Public Const cscHrTotal                                 As String = "hr_total"
Public Const cscHrPendiente                             As String = "hr_pendiente"
Public Const cscHrFirmado                               As String = "hr_firmado"
Public Const cscHrRecibidoEfectivo                      As String = "hr_recibidoefectivo"
Public Const cscHrRecibidoCheque                        As String = "hr_recibidocheque"
Public Const cscHrRecibidoCantCheque                    As String = "hr_recibidocantcheque"
Public Const cscHrRecibidoDescrip                       As String = "hr_recibidodescrip"
Public Const cscHrCumplida                              As String = "hr_cumplida"
Public Const cscHrFaltante                              As String = "hr_faltante"
Public Const cscHrSobrante                              As String = "hr_sobrante"
Public Const cscHrPorcTickets                           As String = "hr_porctickets"

Public Const cscFvIdFaltante                            As String = "fv_id_faltante"
Public Const cscMfIdSobrante                            As String = "mf_id_sobrante"
Public Const cscMfIdTickets                             As String = "mf_id_tickets"

' Hoja de Ruta Item
Public Const csTHojaRutaItem                          As String = "HojaRutaItem"
Public Const cscHriId                                 As String = "hri_id"
Public Const cscHriOrden                              As String = "hri_orden"
Public Const cscHriDescrip                            As String = "hri_descrip"
Public Const cscHriImporte                            As String = "hri_importe"
Public Const cscHriCobrado                            As String = "hri_cobrado"
Public Const cscHriACobrar                            As String = "hri_acobrar"
Public Const cscHriEfectivo                           As String = "hri_efectivo"
Public Const cscHriTickets                            As String = "hri_tickets"
Public Const cscHriTarjeta                            As String = "hri_tarjeta"
Public Const cscHriCheques                            As String = "hri_cheques"
Public Const cscHriAnulado                            As String = "hri_anulado"
Public Const cscHriRetenciones                        As String = "hri_retenciones"
Public Const cscHriNotascredito                       As String = "hri_notascredito"
Public Const cscHriOtros                              As String = "hri_otros"

' Persona
Public Const csTPersona                               As String = "Persona"
Public Const cscPrsId                                 As String = "prs_id"
Public Const cscPrsNombre                             As String = "prs_nombre"
Public Const cscPrsApellido                           As String = "prs_apellido"
Public Const cscPrsCodigo                             As String = "prs_codigo"

'Camion
Public Const csTCamion                                As String = "Camion"
Public Const cscCamId                                 As String = "cam_id"
Public Const cscCamCodigo                             As String = "cam_codigo"
Public Const cscCamDescrip                            As String = "cam_descrip"
Public Const cscCamPatente                            As String = "cam_patente"
Public Const cscCamPatentesemi                        As String = "cam_patentesemi"
Public Const cscCamTara                               As String = "cam_tara"
Public Const cscCamEsSemi                             As String = "cam_essemi"
Public Const cscCamIdSemi                             As String = "cam_id_semi"

' ParteDiario
Public Const csTParteDiario                           As String = "ParteDiario"
Public Const cscPtdId                                 As String = "ptd_id"
Public Const cscPtdNumero                             As String = "ptd_numero"
Public Const cscPtdTitulo                             As String = "ptd_titulo"
Public Const cscPtdDescrip                            As String = "ptd_descrip"
Public Const cscPtdFechaini                           As String = "ptd_fechaini"
Public Const cscPtdFechafin                           As String = "ptd_fechafin"
Public Const cscPtdAlarma                             As String = "ptd_alarma"
Public Const cscPtdFinalizada                         As String = "ptd_finalizada"
Public Const cscPtdCumplida                           As String = "ptd_cumplida"
Public Const cscPtdRechazada                          As String = "ptd_rechazada"
Public Const cscPtdRecurrente                         As String = "ptd_recurrente"
Public Const cscPtdListausuariosId                    As String = "ptd_listausuariosId"
Public Const cscPtdVtoAviso                           As String = "ptd_vtoaviso"
Public Const cscPtdVtoCumplido                        As String = "ptd_vtocumplido"

Public Const cscPrnsGroupId                           As String = "prns_group_id"

' Caja
Public Const csTCaja                                  As String = "Caja"
Public Const cscCjId                                  As String = "cj_id"
Public Const cscCjNombre                              As String = "cj_nombre"
Public Const cscCueIdFondos                           As String = "cue_id_fondos"
Public Const cscCueIdTrabajo                          As String = "cue_id_trabajo"

' Movimiento Caja
Public Const csTMovimientoCaja                        As String = "MovimientoCaja"
Public Const cscMcjId                                 As String = "mcj_id"
Public Const cscMcjNumero                             As String = "mcj_numero"
Public Const cscMcjNrodoc                             As String = "mcj_nrodoc"
Public Const cscMcjDescrip                            As String = "mcj_descrip"
Public Const cscMcjFecha                              As String = "mcj_fecha"
Public Const cscMcjHora                               As String = "mcj_hora"
Public Const cscMcjTipo                               As String = "mcj_tipo"
Public Const cscMcjCerrada                            As String = "mcj_cerrada"
Public Const cscUsIdCajero                            As String = "us_id_cajero"

' Movimiento Caja Item
Public Const csTMovimientoCajaItem                     As String = "MovimientoCajaItem"
Public Const cscMcjiId                                 As String = "mcji_id"
Public Const cscMcjiOrden                              As String = "mcji_orden"
Public Const cscMcjiDescrip                            As String = "mcji_descrip"
Public Const cscMcjiImporte                            As String = "mcji_importe"
Public Const cscMcjiOrigen                             As String = "mcji_origen"
Public Const cscMcjiCotizacion                         As String = "mcji_cotizacion"

' Movimiento Caja Movimiento
Public Const csTMovimientoCajaMovimiento               As String = "MovimientoCajaMovimiento"
Public Const cscMcjmId                                 As String = "mcjm_id"
Public Const cscMcjmOrden                              As String = "mcjm_orden"
Public Const cscMcjmDescrip                            As String = "mcjm_descrip"
Public Const cscMcjmImporte                            As String = "mcjm_importe"

' Picking List
Public Const csTPickingList                           As String = "PickingList"
Public Const cscPklId                                 As String = "pkl_id"
Public Const cscPklNumero                             As String = "pkl_numero"
Public Const cscPklNrodoc                             As String = "pkl_nrodoc"
Public Const cscPklDescrip                            As String = "pkl_descrip"
Public Const cscPklFecha                              As String = "pkl_fecha"
Public Const cscPklFechaentrega                       As String = "pkl_fechaentrega"
Public Const cscPklNeto                               As String = "pkl_neto"
Public Const cscPklIvari                              As String = "pkl_ivari"
Public Const cscPklSubtotal                           As String = "pkl_subtotal"
Public Const cscPklTotal                              As String = "pkl_total"
Public Const cscPklPendiente                          As String = "pkl_pendiente"
Public Const cscPklFirmado                            As String = "pkl_firmado"
Public Const cscPklRecibidodescrip                    As String = "pkl_recibidodescrip"
Public Const cscPklCumplido                           As String = "pkl_cumplido"
Public Const cscPklFechadesde                         As String = "pkl_fechadesde"
Public Const cscPklFechahasta                         As String = "pkl_fechahasta"

' Picking List Pedido
Public Const csTPickingListPedido                     As String = "PickingListPedido"
Public Const cscPklpvId                               As String = "pklpv_id"
Public Const cscPklpvOrden                            As String = "pklpv_orden"
Public Const cscPklpvDescrip                          As String = "pklpv_descrip"

' Picking List Pedido Item
Public Const csTPickingListPedidoItem                    As String = "PickingListPedidoItem"
Public Const cscPklpviId                                 As String = "pklpvi_id"
Public Const cscPklpviOrden                              As String = "pklpvi_orden"
Public Const cscPklpviCantidad                           As String = "pklpvi_cantidad"
Public Const cscPklpviCantidadaremitir                   As String = "pklpvi_cantidadaremitir"
Public Const cscPklpviPendiente                          As String = "pklpvi_pendiente"
Public Const cscPklpviDescrip                            As String = "pklpvi_descrip"

' Hoja Ruta Cobranza Tipo
Public Const cscHrctId                                 As String = "hrct_id"
Public Const cscHrctNombre                             As String = "hrct_nombre"
