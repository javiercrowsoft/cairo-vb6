Attribute VB_Name = "mExportConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mExportConstantes
' 28-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Rama
Public Const cscRamNombre                       As String = "ram_nombre"

' Imagenes
Public Const c_img_task = 1

Public Const c_MenuMain = "C&omercio Exterior"

' constantes
Private Const C_Module = "mExportConstantes"

' Aduana
Public Const csTAduana                                As String = "Aduana"
Public Const cscAduId                                 As String = "adu_id"
Public Const cscAduNombre                             As String = "adu_nombre"
Public Const cscAduCodigo                             As String = "adu_codigo"
Public Const cscAduDescrip                            As String = "adu_descrip"

' Pais
Public Const cscPaId                                  As String = "pa_id"
Public Const cscPaNombre                              As String = "pa_nombre"

' Embarque
Public Const csTEmbarque                              As String = "Embarque"
Public Const cscEmbId                                 As String = "emb_id"
Public Const cscEmbNombre                             As String = "emb_nombre"
Public Const cscEmbCodigo                             As String = "emb_codigo"
Public Const cscEmbDescrip                            As String = "emb_descrip"
Public Const cscEmbFecha                              As String = "emb_fecha"

' Puerto
Public Const csTPuerto                                As String = "Puerto"
Public Const cscPueId                                 As String = "pue_id"
Public Const cscPueIdOrigen                           As String = "pue_id_origen"
Public Const cscPueIdDestino                          As String = "pue_id_destino"
Public Const cscPueNombre                             As String = "pue_nombre"

' Deposito Logico
Public Const csTDepositoLogico                        As String = "DepositoLogico"
Public Const cscDeplId                                As String = "depl_id"
Public Const cscDeplNombre                            As String = "depl_nombre"
Public Const cscDeplIdOrigen                          As String = "depl_id_origen"
Public Const cscDeplIdDestino                         As String = "depl_id_destino"

' Barco
Public Const csTBarco                                 As String = "Barco"
Public Const cscBarcId                                As String = "barc_id"
Public Const cscBarcNombre                            As String = "barc_nombre"

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Talonario
Public Const cscTaId                                   As String = "ta_id"

' Banco
Public Const csTBanco                                 As String = "Banco"
Public Const cscBcoId                                 As String = "bco_Id"
Public Const cscBcoNombre                             As String = "bco_nombre"

' Legajo
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscDocTipoPackingList                    As String = "doc_tipopackinglist"
Public Const cscDocMueveStock                         As String = "doc_muevestock"

' Documento Tipo
Public Const cscDoctId                                 As String = "doct_id"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Lista Precios
Public Const cscLpId                                   As String = "lp_id"
Public Const cscLpNombre                               As String = "lp_nombre"

' Lista de Descuentos
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"

' Permiso Embarque
Public Const csTPermisoEmbarque                        As String = "PermisoEmbarque"
Public Const cscPembId                                 As String = "pemb_id"
Public Const cscPembNumero                             As String = "pemb_numero"
Public Const cscPembNrodoc                             As String = "pemb_nrodoc"
Public Const cscPembDescrip                            As String = "pemb_descrip"
Public Const cscPembFirmado                            As String = "pemb_firmado"
Public Const cscPembFecha                              As String = "pemb_fecha"
Public Const cscPembCotizacion                         As String = "pemb_cotizacion"
Public Const cscPembTotal                              As String = "pemb_total"
Public Const cscPembTotalOrigen                        As String = "pemb_totalorigen"

' Permiso Embarque TMP
Public Const csTPermisoEmbarqueTMP                     As String = "PermisoEmbarqueTMP"
Public Const cscPembTMPId                              As String = "pembTMP_id"

' Permiso Embarque Item
Public Const csTPermisoEmbarqueItem                     As String = "PermisoEmbarqueItem"
Public Const cscPembiId                                 As String = "pembi_id"
Public Const cscPembiOrden                              As String = "pembi_orden"
Public Const cscPembiCantidad                           As String = "pembi_cantidad"
Public Const cscPembiFobOrigen                          As String = "pembi_foborigen"
Public Const cscPembiFobTotalOrigen                     As String = "pembi_fobtotalorigen"
Public Const cscPembiFob                                As String = "pembi_fob"
Public Const cscPembiFobTotal                           As String = "pembi_fobtotal"
Public Const cscPembiDescrip                            As String = "pembi_descrip"

' Permiso Embarque Item
Public Const csTPermisoEmbarqueItemTMP                  As String = "PermisoEmbarqueItemTMP"
Public Const cscpembiTMPId                              As String = "pembiTMP_id"

' Permiso Embarque Item
Public Const csTPermisoEmbarqueItemBorradoTMP           As String = "PermisoEmbarqueItemBorradoTMP"
Public Const cscpembibTMPId                             As String = "pembibTMP_id"

' Producto
Public Const cscPrId                                    As String = "pr_id"
Public Const cscPrNombreventa                           As String = "pr_nombreventa"
Public Const cscPrTiIdRiVenta                           As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                          As String = "ti_id_ivarniventa"
Public Const cscCueidventa                              As String = "cue_id_venta"
Public Const cscPrPesoTotal                             As String = "pr_pesototal"
Public Const cscPrPesoNeto                              As String = "pr_pesoneto"
Public Const cscPrGrupoExpo                             As String = "pr_grupoexpo"
Public Const cscUnIdPeso                                As String = "un_id_peso"
Public Const cscPrNombrecompra                          As String = "pr_Nombrecompra"
Public Const cscPrTiIdRiCompra                          As String = "ti_id_ivariCompra"
Public Const cscPrTiIdRniCompra                         As String = "ti_id_ivarniCompra"
Public Const cscCueidCompra                             As String = "cue_id_compra"
Public Const cscPrLlevaStock                            As String = "pr_llevastock"
Public Const cscPrLlevaNroSerie                         As String = "pr_llevanroserie"

' Unidad
Public Const cscUnNombre                                As String = "un_nombre"

' Manifiesto de Carga TMP
Public Const csTManifiestoCargaTMP                    As String = "ManifiestoCargaTMP"
Public Const cscMfcTMPId                              As String = "mfcTMP_id"

' Manifiesto de Carga
Public Const csTManifiestoCarga                       As String = "ManifiestoCarga"
Public Const cscMfcId                                 As String = "mfc_id"
Public Const cscMfcNumero                             As String = "mfc_numero"
Public Const cscMfcNrodoc                             As String = "mfc_nrodoc"
Public Const cscMfcFecha                              As String = "mfc_fecha"
Public Const cscMfcFechaDoc                           As String = "mfc_fechadoc"
Public Const cscMfcHoraPartida                        As String = "mfc_horapartida"
Public Const cscMfcChasis                             As String = "mfc_chasis"
Public Const cscMfcAcoplado                           As String = "mfc_acoplado"
Public Const cscMfcDescrip                            As String = "mfc_descrip"
Public Const cscMfcFirmado                            As String = "mfc_firmado"
Public Const cscMfcCantidad                           As String = "mfc_cantidad"

' Manifiesto de Carga Item
Public Const csTManifiestoCargaItemTMP                 As String = "ManifiestoCargaItemTMP"
Public Const cscMfcITMPId                              As String = "mfciTMP_id"

' Manifiesto de Carga Item
Public Const csTManifiestoCargaItemBorradoTMP          As String = "ManifiestoCargaItemBorradoTMP"
Public Const cscMfcIbTMPId                             As String = "mfcibTMP_id"

' Manifiesto de Carga Item
Public Const csTManifiestoCargaItem                    As String = "ManifiestoCargaItem"
Public Const cscMfciId                                 As String = "mfci_id"
Public Const cscMfciOrden                              As String = "mfci_orden"
Public Const cscMfciCantidad                           As String = "mfci_cantidad"
Public Const cscMfciPallets                            As String = "mfci_pallets"
Public Const cscMfciNropallet                          As String = "mfci_nropallet"
Public Const cscMfciDescrip                            As String = "mfci_descrip"
Public Const cscMfcipendiente                          As String = "mfci_pendiente"

' Transporte
Public Const csTTransporte                              As String = "Transporte"
Public Const cscTransId                                 As String = "trans_id"
Public Const cscTransNombre                             As String = "trans_nombre"

'Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"

' Chofer
Public Const csTChofer                                As String = "Chofer"
Public Const cscChofId                                 As String = "chof_id"
Public Const cscChofNombre                             As String = "chof_nombre"

' ContraMarca
Public Const csTContraMarca                            As String = "ContraMarca"
Public Const cscCMarcId                                As String = "cmarc_id"
Public Const cscCMarcNombre                            As String = "cmarc_nombre"

' Packing List TMP
Public Const csTPackingListTMP                          As String = "PackingListTMP"
Public Const cscPklstTMPId                              As String = "pklstTMP_id"

' Packing List
Public Const csTPackingList                             As String = "PackingList"
Public Const cscPklstId                                 As String = "pklst_id"
Public Const cscPklstNumero                             As String = "pklst_numero"
Public Const cscPklstNrodoc                             As String = "pklst_nrodoc"
Public Const cscPklstFecha                              As String = "pklst_fecha"
Public Const cscPklstFechaEntrega                       As String = "pklst_fechaentrega"
Public Const cscPklstFechadoc                           As String = "pklst_fechadoc"
Public Const cscPklstCantidad                           As String = "pklst_cantidad"
Public Const cscPklstMarca                              As String = "pklst_marca"
Public Const cscPklstPallets                            As String = "pklst_pallets"
Public Const cscPklstPendiente                          As String = "pklst_pendiente"
Public Const cscPklstDescrip                            As String = "pklst_descrip"
Public Const cscPklstFirmado                            As String = "pklst_firmado"
Public Const cscPklstNeto                               As String = "pklst_neto"
Public Const cscPklstIvari                              As String = "pklst_ivari"
Public Const cscPklstIvarni                             As String = "pklst_ivarni"
Public Const cscPklstSubtotal                           As String = "pklst_subtotal"
Public Const cscPklstTotal                              As String = "pklst_total"
Public Const cscPklstDescuento1                         As String = "pklst_descuento1"
Public Const cscPklstDescuento2                         As String = "pklst_descuento2"
Public Const cscPklstImportedesc1                       As String = "pklst_importedesc1"
Public Const cscPklstImportedesc2                       As String = "pklst_importedesc2"

' Packing List Item TMP
Public Const csTPackingListItemTMP                      As String = "PackingListItemTMP"
Public Const cscPklstiTMPId                             As String = "pklstiTMP_id"

' Packing List Item borrado
Public Const csTPackingListItemBorradoTMP               As String = "PackingListItemBorradoTMP"
Public Const cscPklstibTMPId                            As String = "pklstibTMP_id"

' Packing List Item
Public Const csTPackingListItem                          As String = "PackingListItem"
Public Const cscPklstiId                                 As String = "pklsti_id"
Public Const cscPklstiOrden                              As String = "pklsti_orden"
Public Const cscPklstiCantidad                           As String = "pklsti_cantidad"
Public Const cscPklstiPendiente                          As String = "pklsti_pendiente"
Public Const cscPklstiPendientefac                       As String = "pklsti_pendientefac"
Public Const cscPklstiPallets                            As String = "pklsti_pallets"
Public Const cscPklstiSeguro                             As String = "pklsti_seguro"
Public Const cscPklstiDescrip                            As String = "pklsti_descrip"
Public Const cscPklstiPrecio                             As String = "pklsti_precio"
Public Const cscPklstiPrecioUsr                          As String = "pklsti_precioUsr"
Public Const cscPklstiPrecioLista                        As String = "pklsti_precioLista"
Public Const cscPklstiDescuento                          As String = "pklsti_descuento"
Public Const cscPklstiNeto                               As String = "pklsti_neto"
Public Const cscPklstiIvari                              As String = "pklsti_ivari"
Public Const cscPklstiIvarni                             As String = "pklsti_ivarni"
Public Const cscPklstiIvariporc                          As String = "pklsti_ivariporc"
Public Const cscPklstiIvarniporc                         As String = "pklsti_ivarniporc"
Public Const cscPklstiImporte                            As String = "pklsti_importe"
Public Const cscPklstiCajaDesde                          As String = "pklsti_cajadesde"
Public Const cscPklstiCajaHasta                          As String = "pklsti_cajahasta"
Public Const cscPklstiPesoNeto                           As String = "pklsti_pesoneto"
Public Const cscPklstiPesoTotal                          As String = "pklsti_pesototal"
Public Const cscPklstiGrupoExpo                          As String = "pklsti_grupoexpo"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

' Legajo
Public Const csLegajo = 15001

' Moneda
Public Const csTMoneda                                As String = "Moneda"
Public Const cscMonId                                 As String = "Mon_id"
Public Const cscMonNombre                             As String = "Mon_nombre"

' Proveedor
Public Const csTProveedor                             As String = "Proveedor"
Public Const cscProvId                                As String = "prov_id"
Public Const cscProvNombre                            As String = "prov_nombre"

' Pedidos de Venta
Public Const cscPvId                                  As String = "pv_id"
Public Const cscPvNumero                              As String = "pv_numero"
Public Const cscPvNrodoc                              As String = "pv_nrodoc"
Public Const cscPvDescrip                             As String = "pv_descrip"
Public Const cscPvFecha                               As String = "pv_fecha"
Public Const cscPvTotal                               As String = "pv_total"

' Items de Pedidos de Venta
Public Const cscPviId                                 As String = "pvi_id"
Public Const cscPviCantidad                           As String = "pvi_cantidad"
Public Const cscPviCantidadaremitir                   As String = "pvi_cantidadaremitir"
Public Const cscPviDescrip                            As String = "pvi_descrip"
Public Const cscPviPrecio                             As String = "pvi_precio"
Public Const cscPviPendiente                          As String = "pvi_pendiente"
Public Const cscPviIvariPorc                          As String = "pvi_ivariporc"
Public Const cscPviIvarniPorc                         As String = "pvi_ivarniporc"
Public Const cscPviImporte                            As String = "pvi_importe"
Public Const cscPviPrecioUsr                          As String = "pvi_precioUsr"
Public Const cscPviPrecioLista                        As String = "pvi_precioLista"
Public Const cscPviDescuento                          As String = "pvi_descuento"

' Pedido PackingList TMP
Public Const csTPedidoPackingListTMP                  As String = "PedidoPackingListTMP"
Public Const cscPvPklstTMPId                          As String = "pvpklstTMP_id"

' Pedido PackingList
Public Const csTPedidoPackingList                     As String = "PedidoPackingList"
Public Const cscPvPklstId                             As String = "pvpklst_id"
Public Const cscPvPklstCantidad                       As String = "PvPklst_cantidad"

' Garantia
Public Const csTGarantia                              As String = "Garantia"
Public Const cscGarId                                 As String = "gar_id"
Public Const cscGarCodigo                             As String = "gar_codigo"
Public Const cscGarNropoliza                          As String = "gar_nropoliza"
Public Const cscGarCodigoaduana                       As String = "gar_codigoaduana"
Public Const cscGarFecha                              As String = "gar_fecha"
Public Const cscGarFechainicio                        As String = "gar_fechainicio"
Public Const cscGarFechavto                           As String = "gar_fechavto"
Public Const cscGarDescrip                            As String = "gar_descrip"
Public Const cscGarMonto                              As String = "gar_monto"
Public Const cscGarCuota                              As String = "gar_cuota"
Public Const cscGarDiavtocuota                        As String = "gar_diavtocuota"

' ImportacionTemp
Public Const csTImportacionTemp                        As String = "ImportacionTemp"
Public Const cscImptId                                 As String = "impt_id"
Public Const cscImptNumero                             As String = "impt_numero"
Public Const cscImptNrodoc                             As String = "impt_nrodoc"
Public Const cscImptDescrip                            As String = "impt_descrip"
Public Const cscImptFecha                              As String = "impt_fecha"
Public Const cscImptFechaentrega                       As String = "impt_fechaentrega"
Public Const cscImptNeto                               As String = "impt_neto"
Public Const cscImptIvari                              As String = "impt_ivari"
Public Const cscImptIvarni                             As String = "impt_ivarni"
Public Const cscImptTotal                              As String = "impt_total"
Public Const cscImptSubtotal                           As String = "impt_subtotal"
Public Const cscImptPendiente                          As String = "impt_pendiente"
Public Const cscImptDescuento1                         As String = "impt_descuento1"
Public Const cscImptDescuento2                         As String = "impt_descuento2"
Public Const cscImptImportedesc1                       As String = "impt_importedesc1"
Public Const cscImptImportedesc2                       As String = "impt_importedesc2"
Public Const cscImptFirmado                            As String = "impt_firmado"
Public Const cscImptDespachonro                        As String = "impt_despachonro"
Public Const cscImptFechaoficial                       As String = "impt_fechaoficial"
Public Const cscImptSeguro                             As String = "impt_seguro"
Public Const cscImptFlete                              As String = "impt_flete"

' ImportacionTempTMP
Public Const csTImportacionTempTMP                     As String = "ImportacionTempTMP"
Public Const cscImptTMPId                              As String = "imptTMP_id"

' ImportacionTempItem
Public Const csTImportacionTempItem                     As String = "ImportacionTempItem"
Public Const cscImptiId                                 As String = "impti_id"
Public Const cscImptiOrden                              As String = "impti_orden"
Public Const cscImptiCantidad                           As String = "impti_cantidad"
Public Const cscImptiCantidadaremitir                   As String = "impti_cantidadaremitir"
Public Const cscImptiPendiente                          As String = "impti_pendiente"
Public Const cscImptiPendientefac                       As String = "impti_pendientefac"
Public Const cscImptiDescrip                            As String = "impti_descrip"
Public Const cscImptiPrecio                             As String = "impti_precio"
Public Const cscImptiPrecioUsr                          As String = "impti_precioUsr"
Public Const cscImptiPrecioLista                        As String = "impti_precioLista"
Public Const cscImptiDescuento                          As String = "impti_descuento"
Public Const cscImptiNeto                               As String = "impti_neto"
Public Const cscImptiIvari                              As String = "impti_ivari"
Public Const cscImptiIvarni                             As String = "impti_ivarni"
Public Const cscImptiIvariporc                          As String = "impti_ivariporc"
Public Const cscImptiIvarniporc                         As String = "impti_ivarniporc"
Public Const cscImptiImporte                            As String = "impti_importe"
Public Const cscImptiSeguro                             As String = "impti_Seguro"
Public Const cscImptiFlete                              As String = "impti_Flete"

' ImportacionTempItemTMP
Public Const csTImportacionTempItemTMP                  As String = "ImportacionTempItemTMP"
Public Const cscImptiTMPId                              As String = "imptiTMP_id"

' ImportacionTempItemBorradoTMP
Public Const csTImportacionTempItemBorradoTMP           As String = "ImportacionTempItemBorradoTMP"
Public Const cscImptibTMPId                             As String = "imptibTMP_id"

' ImportacionTempGarantiaTMP
Public Const csTImportacionTempGarantiaTMP              As String = "ImportacionTempGarantiaTMP"
Public Const cscImptgTMPId                              As String = "imptgTMP_id"

' ImportacionTempGarantia
Public Const cscImptgId                                 As String = "imptg_id"
Public Const cscImptgOrden                              As String = "imptg_orden"

' Producto Numero Serie
Public Const csTProductoNumeroSerie                    As String = "ProductoNumeroSerie"
Public Const cscPrnsId                                 As String = "prns_id"
Public Const cscPrnsCodigo                             As String = "prns_codigo"
Public Const cscPrnsDescrip                            As String = "prns_descrip"
Public Const cscPrnsFechavto                           As String = "prns_fechavto"

' Remito Compra Item Serie
Public Const csTImportacionTempItemSerieTMP              As String = "ImportacionTempItemSerieTMP"
Public Const cscImptisTMPId                              As String = "imptisTMP_id"
Public Const cscImptisOrden                              As String = "imptis_orden"

' Manifiesto PackingList TMP
Public Const csTManifiestoPackingListTMP                 As String = "ManifiestoPackingListTMP"
Public Const cscMfcPklstTMPId                            As String = "mfcpklstTMP_id"
Public Const cscMfcPklstCantidad                         As String = "mfcpklst_cantidad"

' Manifiesto PackingList
Public Const cscMfcPklstId                               As String = "mfcpklst_id"

' FacturaVentaItem
Public Const cscFviId                                 As String = "fvi_id"

' Packing List Factura Venta TMP
Public Const csTPackingListFacturaVentaTMP         As String = "PackingListFacturaVentaTMP"
Public Const cscPklstFvTMPId                       As String = "pklstfvTMP_id"

' Packing List Factura Venta
Public Const csTPackingListFacturaVenta            As String = "PackingListFacturaVenta"
Public Const cscPklstFvId                          As String = "pklstfv_id"
Public Const cscPklstFvCantidad                    As String = "pklstfv_cantidad"

' Devolucion de Packing List
Public Const csTPackingListDevolucionTMP           As String = "PackingListDevolucion"
Public Const cscPklstDvTMPId                       As String = "pklstdvTMP_id"
Public Const cscPklstiIdDevolucion                 As String = "pklsti_id_devolucion"
Public Const cscPklstiIdPklst                      As String = "pklsti_id_pklst"
Public Const cscPklstDvCantidad                    As String = "pklstdv_cantidad"
Public Const cscPklstDvId                          As String = "pklstdv_id"

' MURESCO (Para poder sacarlo despues)
Public Const cscMURNroPedido                          As String = "MUR_NroPedido"

' Embalaje
Public Const cscEmblId                                 As String = "embl_id"
Public Const cscEmblNombre                             As String = "embl_nombre"
Public Const cscEmblCapacidad                          As String = "embl_capacidad"
Public Const cscEmblTara                               As String = "embl_tara"

Public Const csBarco = 12004
Public Const csPuerto = 12005
Public Const csContraMarca = 12006

' Stock
Public Const cscStId                                  As String = "st_id"

