Attribute VB_Name = "mPedidoConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mPedidoConstantes
' 05-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPedidoConstantes"

Public Const c_ClienteDataAdd = "ClienteDataAdd"

' Rama
Public Const cscRamNombre                       As String = "ram_nombre"

Public Const csPreVtaModifyAplic = 16014
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
Public Const cscPvDestinatario                        As String = "pv_destinatario"
Public Const cscPvOrdenCompra                         As String = "pv_ordencompra"

' Cliente Sucursal
Public Const cscClisId                               As String = "clis_id"
Public Const cscClisNombre                           As String = "clis_nombre"

' Deposito
Public Const cscRamIdStock                            As String = "ram_id_stock"
Public Const cscRamaStock                             As String = "ramastock"

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
Public Const cscPviPendientePrv                       As String = "pvi_pendienteprv"

' Items Borrados de pedidos de venta
Public Const csTPedidoVentaItemBorradoTMP             As String = "PedidoVentaItemBorradoTMP"
Public Const cscPvibTMPId                             As String = "pvibTMP_id"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"

' Talonario
Public Const cscTaId                                  As String = "ta_id"

' Tipos de Documento
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDocPvDesdePrv                          As String = "doc_pv_desde_prv"

' Lista de Precios
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

' Lista de Descuentos
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

'Lista de Precios Items
Public Const cscLpiId                                 As String = "lpi_id"

'Producto
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombrecompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreventa                        As String = "pr_Nombreventa"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"
Public Const cscCcosIdVenta                          As String = "ccos_id_venta"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"

' Vendedor
Public Const csTVendedor                         As String = "Vendedor"
Public Const cscVenId                            As String = "ven_id"
Public Const cscVenNombre                        As String = "ven_nombre"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Iva
Public Const cscbIvaRi                                As String = "bIvaRi"
Public Const cscbIvaRni                               As String = "bIvaRni"

' Monedas
Public Const cscMonNombre                             As String = "Moneda"
Public Const cscMonId                                 As String = "mon_id"

' Remitos
Public Const cscRviId                                 As String = "rvi_id"

' PackingList
Public Const cscPklstiId                              As String = "pklsti_id"

' Presupuestos
Public Const cscPrviId                                As String = "prvi_id"

' Presupuesto Pedido Venta TMP
Public Const csTPresupuestoPedidoVentaTMP             As String = "PresupuestoPedidoVentaTMP"
Public Const cscPrvPvTMPid                            As String = "prvpvTMP_id"

' Presupuesto Pedido Venta
Public Const csTPresupuestoPedidoVenta              As String = "PresupuestoPedidoVenta"
Public Const cscPrvPvId                             As String = "prvpv_id"
Public Const cscPrvPvCantidad                       As String = "prvpv_cantidad"

' FacturaVenta
Public Const cscFviId                                 As String = "fvi_id"

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

' Pedido Devolucion Venta TMP
Public Const csTPedidoDevolucionVentaTMP              As String = "PedidoDevolucionVentaTMP"
Public Const cscPvDvTMPId                             As String = "pvdvTMP_id"
Public Const cscPvDvId                                As String = "pvdv_id"
Public Const cscPvDvCantidad                          As String = "pvdv_cantidad"
Public Const cscPviIdDevolucion                       As String = "pvi_id_devolucion"
Public Const cscPviIdPedido                           As String = "pvi_id_Pedido"

' Pedido Packing List
Public Const csTPedidoPackingListTMP                  As String = "PedidoPackingListTMP"
Public Const cscPvPklstTMPid                          As String = "pvpklstTMP_id"
Public Const cscPvPklstCantidad                       As String = "pvpklst_cantidad"
Public Const cscPvPklstId                             As String = "pvpklst_id"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjTitulo                             As String = "lgj_Titulo"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"

' Legajo
Public Const csLegajo = 15001

'Provincia
Public Const cscProIdOrigen                           As String = "pro_id_origen"
Public Const cscProIdDestino                          As String = "pro_id_destino"

' Transporte
Public Const csTTransporte                             As String = "Transporte"
Public Const cscTransId                                As String = "trans_id"
Public Const cscTransNombre                            As String = "trans_nombre"

' Chofer
Public Const cscChofId                                  As String = "chof_id"
Public Const cscChofNombre                              As String = "chof_nombre"

' Camion
Public Const cscCamId                                   As String = "cam_id"
Public Const cscCamPatente                              As String = "cam_patente"
Public Const cscCamPatenteSemi                          As String = "cam_patentesemi"
Public Const cscCamIdSemi                               As String = "cam_id_semi"

