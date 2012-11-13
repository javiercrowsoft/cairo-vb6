Attribute VB_Name = "mTesoreriaConstantes"
Option Explicit
'--------------------------------------------------------------------------------
' mTesoreriaConstantes
' 02-02-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mTesoreriaConstantes"

Public Const c_filter_cuentas_de_caja = " and cue_id not in (select cue_id_trabajo from cajacuenta)"

' Rama
Public Const cscRamNombre                             As String = "ram_nombre"

' DepositoBanco
Public Const csTDepositoBanco                         As String = "DepositoBanco"
Public Const cscDbcoId                                As String = "dbco_id"
Public Const cscDbcoNumero                            As String = "dbco_numero"
Public Const cscDbcoNrodoc                            As String = "dbco_nrodoc"
Public Const cscDbcoDescrip                           As String = "dbco_descrip"
Public Const cscDbcoFecha                             As String = "dbco_fecha"
Public Const cscDbcoCotizacion                        As String = "dbco_cotizacion"
Public Const cscDbcoTotal                             As String = "dbco_total"
Public Const cscDbcoTotalorigen                       As String = "dbco_totalorigen"
Public Const cscDbcoGrabarasiento                     As String = "dbco_grabarasiento"
Public Const cscDbcoFirmado                           As String = "dbco_firmado"

' DepositoBancoTMP
Public Const csTDepositoBancoTMP                      As String = "DepositoBancoTMP"
Public Const cscDbcoTMPId                             As String = "dbcoTMP_id"

' DepositoBancoItem
Public Const csTDepositoBancoItem                     As String = "DepositoBancoItem"
Public Const cscDbcoiId                               As String = "dbcoi_id"
Public Const cscDbcoiOrden                            As String = "dbcoi_orden"
Public Const cscDbcoiImporte                          As String = "dbcoi_importe"
Public Const cscDbcoiImporteorigen                    As String = "dbcoi_importeorigen"
Public Const cscDbcoiDescrip                          As String = "dbcoi_descrip"
Public Const cscDbcoiTipo                             As String = "dbcoi_tipo"

' DepositoBancoItemTMP
Public Const csTDepositoBancoItemTMP                  As String = "DepositoBancoItemTMP"
Public Const cscDbcoiTMPId                            As String = "dbcoiTMP_id"
Public Const cscDbcoiTMPCheque                        As String = "dbcoiTMP_cheque"
Public Const cscDbcoiTMPFechaCobro                    As String = "dbcoiTMP_fechacobro"
Public Const cscDbcoiTMPFechaVto                      As String = "dbcoiTMP_fechavto"

' DepositoBancoItemBorradoTMP
Public Const csTDepositoBancoItemBorradoTMP           As String = "DepositoBancoItemBorradoTMP"
Public Const cscDbcoibTMPId                           As String = "dbcoibTMP_Id"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Tipos de Documento
Public Const cscDoctId                                As String = "doct_id"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Talonario
Public Const cscTaId                                  As String = "ta_id"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"

'Proveedor
Public Const csTProveedor                              As String = "Proveedor"
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvNombre                             As String = "prov_nombre"

' CentroCosto
Public Const csTCentroCosto                            As String = "CentroCosto"
Public Const cscCcosId                                 As String = "ccos_id"
Public Const cscCcosNombre                             As String = "ccos_nombre"

' Cobrador
Public Const csTCobrador                              As String = "Cobrador"
Public Const cscCobId                                 As String = "cob_id"
Public Const cscCobNombre                             As String = "cob_nombre"

' Cobranza
Public Const csTCobranza                               As String = "Cobranza"
Public Const cscCobzId                                 As String = "cobz_id"
Public Const cscCobzNumero                             As String = "cobz_numero"
Public Const cscCobzNrodoc                             As String = "cobz_nrodoc"
Public Const cscCobzDescrip                            As String = "cobz_descrip"
Public Const cscCobzFecha                              As String = "cobz_fecha"
Public Const cscCobzNeto                               As String = "cobz_neto"
Public Const cscCobzOtros                              As String = "cobz_otros"
Public Const cscCobzTotal                              As String = "cobz_total"
Public Const cscCobzPendiente                          As String = "cobz_pendiente"
Public Const cscCobzCotizacion                         As String = "cobz_cotizacion"
Public Const cscCobzGrabarAsiento                      As String = "cobz_grabarAsiento"
Public Const cscCobzFirmado                            As String = "cobz_firmado"
Public Const cscCobzHojaRuta                           As String = "cobz_hojaruta"

' CobranzaTMP
Public Const csTCobranzaTMP                            As String = "CobranzaTMP"
Public Const cscCobzTMPId                              As String = "cobzTMP_id"

' CobranzaItem
Public Const csTCobranzaItem                            As String = "CobranzaItem"
Public Const cscCobziId                                 As String = "cobzi_id"
Public Const cscCobziOrden                              As String = "cobzi_orden"
Public Const cscCobziOtroTipo                           As String = "cobzi_otroTipo"
Public Const cscCobziImporte                            As String = "cobzi_importe"
Public Const cscCobziImporteOrigen                      As String = "cobzi_importeOrigen"
Public Const cscCobziDescrip                            As String = "cobzi_descrip"
Public Const cscCobziPorcRetencion                      As String = "cobzi_porcRetencion"
Public Const cscCobziFechaRetencion                     As String = "cobzi_fechaRetencion"
Public Const cscCobziNroRetencion                       As String = "cobzi_nroRetencion"
Public Const cscCobziTipo                               As String = "cobzi_tipo"
Public Const cscCobziTarjetaTipo                        As String = "cobzi_tarjetaTipo"

' CobranzaItemTMP
Public Const csTCobranzaItemTMP                         As String = "CobranzaItemTMP"
Public Const cscCobziTMPId                              As String = "cobziTMP_id"
Public Const cscCobziTMPCheque                          As String = "cobziTMP_cheque"
Public Const cscCobziTMPChequera                        As String = "cobziTMP_chequera"
Public Const cscCobziTMPCupon                           As String = "cobziTMP_cupon"
Public Const cscCobziTMPFechaCobro                      As String = "cobziTMP_fechaCobro"
Public Const cscCobziTMPFechaVto                        As String = "cobziTMP_fechaVto"
Public Const cscCobziTMPTitular                         As String = "cobziTMP_titular"
Public Const cscCobziTMPAutorizacion                    As String = "cobziTMP_autorizacion"
Public Const cscCobziTMPNroTarjeta                      As String = "cobziTMP_nroTarjeta"
Public Const cscCobziTMPPropio                          As String = "cobziTMP_propio"

' CobranzaItemBorradoTMP
Public Const csTCobranzaItemBorradoTMP                  As String = "CobranzaItemBorradoTMP"
Public Const cscCobzibTMPId                             As String = "cobzibTMP_Id"

' Banco
Public Const csTBanco                            As String = "Banco"
Public Const cscBcoId                            As String = "bco_id"
Public Const cscBcoNombre                        As String = "bco_nombre"

' Chequera
Public Const csTChequera                              As String = "Chequera"
Public Const cscChqId                                 As String = "chq_id"
Public Const cscChqCodigo                             As String = "chq_codigo"

' Cheque
Public Const csTCheque                                 As String = "Cheque"
Public Const cscCheqId                                 As String = "cheq_id"
Public Const cscCheqNumero                             As String = "cheq_numero"
Public Const cscCheqNumeroDoc                          As String = "cheq_numerodoc"
Public Const cscCheqImporte                            As String = "cheq_importe"
Public Const cscCheqImporteOrigen                      As String = "cheq_importeOrigen"
Public Const cscCheqTipo                               As String = "cheq_tipo"
Public Const cscCheqFechaVto                           As String = "cheq_fechaVto"
Public Const cscCheqFechaCobro                         As String = "cheq_fechaCobro"
Public Const cscCheqDescrip                            As String = "cheq_descrip"
Public Const cscCheqFcImporte1                         As String = "cheq_fc_importe1"
Public Const cscCheqFcImporte2                         As String = "cheq_fc_importe2"
Public Const cscCheqFvImporte                          As String = "cheq_fv_importe"
Public Const cscCheqFechaRechazo                       As String = "cheq_fechaRechazo"
Public Const cscCheqRechazado                          As String = "cheq_rechazado"
Public Const cscFcIdNd1                                As String = "fc_id_nd1"
Public Const cscFcIdNd2                                As String = "fc_id_nd2"
Public Const cscFvIdNd                                 As String = "fv_id_nd"

'Clearing
Public Const csTClearing                         As String = "Clearing"
Public Const cscCleId                            As String = "cle_id"
Public Const cscCleNombre                        As String = "cle_nombre"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjTitulo                             As String = "lgj_Titulo"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"

' Cuenta
Public Const csTCuenta                                As String = "Cuenta"
Public Const cscCueId                                 As String = "cue_id"
Public Const cscCueNombre                             As String = "cue_nombre"

' Tarjeta de Credito
Public Const cscCueIdPresentado                 As String = "cue_id_presentado"
Public Const cscCueIdBanco                      As String = "cue_id_banco"
Public Const cscCueIdEnCartera                  As String = "cue_id_encartera"
Public Const cscCueIdRechazo                    As String = "cue_id_rechazo"
Public Const cscCueIdComision                   As String = "cue_id_comision"

' CuentaCategoria
Public Const csTCuentaCategoria                  As String = "CuentaCategoria"
Public Const cscCuecId                           As String = "cuec_id"

' Monedas
Public Const csTMoneda                           As String = "Moneda"
Public Const cscMonId                            As String = "mon_id"
Public Const cscMonNombre                        As String = "mon_nombre"

' Tarjeta Credito Cupon
Public Const csTTarjetaCreditoCupon                    As String = "TarjetaCreditoCupon"
Public Const cscTjccId                                 As String = "tjcc_id"
Public Const cscTjccNumero                             As String = "tjcc_numero"
Public Const cscTjccNumeroDoc                          As String = "tjcc_numerodoc"
Public Const cscTjccDescrip                            As String = "tjcc_descrip"
Public Const cscTjccFechavto                           As String = "tjcc_fechavto"
Public Const cscTjccNroTarjeta                         As String = "tjcc_nroTarjeta"
Public Const cscTjccNroAutorizacion                    As String = "tjcc_nroAutorizacion"
Public Const cscTjccTitular                            As String = "tjcc_titular"
Public Const cscTjccImporte                            As String = "tjcc_importe"
Public Const cscTjccImporteOrigen                      As String = "tjcc_importeOrigen"

' TarjetaCredito
Public Const csTTarjetaCredito                   As String = "TarjetaCredito"
Public Const cscTjcId                            As String = "tjc_id"
Public Const cscTjcNombre                        As String = "tjc_nombre"
Public Const cscTjcComision                      As String = "tjc_comision"

' Tarjeta Credito Cuota
Public Const cscTjccuId                          As String = "tjccu_id"
Public Const cscTjccuCantidad                    As String = "tjccu_cantidad"
Public Const cscTjccuComision                    As String = "tjccu_comision"

' Tabla legajo
Public Const csLegajo                           As Integer = 15001

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"

' FacturaVenta
Public Const csTFacturaVenta                    As String = "FacturaVenta"
Public Const cscFvId                            As String = "fv_id"
Public Const cscFvNumero                        As String = "fv_numero"
Public Const cscFvNrodoc                        As String = "fv_nrodoc"
Public Const cscFvDescrip                       As String = "fv_descrip"
Public Const cscFvFecha                         As String = "fv_fecha"
Public Const cscFvTotal                         As String = "fv_total"
Public Const cscFvTotalOrigen                   As String = "fv_totalorigen"
Public Const cscFvPendiente                     As String = "fv_pendiente"
Public Const cscFvCotizacion                    As String = "fv_cotizacion"

' FacturaVentaDeuda
Public Const cscFvdId                           As String = "fvd_id"
Public Const cscFvdFecha                        As String = "fvd_fecha"
Public Const cscFvdPendiente                    As String = "fvd_pendiente"

' FacturaVentaPago
Public Const cscFvpId                           As String = "fvp_id"
Public Const cscFvpFecha                        As String = "fvp_fecha"
Public Const cscFvpImporte                      As String = "fvp_importe"

' FacturaVentaCobranza
Public Const csTFacturaVentaCobranzaTMP         As String = "FacturaVentaCobranzaTMP"
Public Const cscFvCobzImporte                   As String = "fvcobz_importe"
Public Const cscFvCobzTMPid                     As String = "fvcobzTMP_id"
Public Const cscFvCobzId                        As String = "fvcobz_id"
Public Const cscFvCobzImporteOrigen             As String = "fvcobz_importeOrigen"
Public Const cscFvCobzCotizacion                As String = "fvcobz_cotizacion"

' FacturaVentaNotaCredito
Public Const csTFacturaVentaNotaCredito         As String = "FacturaVentaNotaCredito"
Public Const cscFvNcImporte                     As String = "fvnc_importe"
Public Const cscFvNcId                          As String = "fvnc_id"
Public Const cscFvIdNotaCredito                 As String = "fv_id_notacredito"
Public Const cscFvIdFactura                     As String = "fv_id_factura"
Public Const cscFvdIdNotaCredito                As String = "fvd_id_notacredito"
Public Const cscFvdIdFactura                    As String = "fvd_id_factura"
Public Const cscFvpIdNotaCredito                As String = "fvp_id_notacredito"
Public Const cscFvpIdFactura                    As String = "fvp_id_factura"

' FacturaVentaNotaCreditoTMP
Public Const csTFacturaVentaNotaCreditoTMP      As String = "FacturaVentaNotaCreditoTMP"
Public Const cscFvNcTMPid                       As String = "fvncTMP_id"

' FacturaVentaTMP
Public Const csTFacturaVentaTMP                  As String = "FacturaVentaTMP"
Public Const cscFvTMPId                          As String = "fvTMP_id"

' FacturaVenta
Public Const cscFvFechaentrega                  As String = "fv_fechaentrega"
Public Const cscFvNeto                          As String = "fv_neto"
Public Const cscFvIvari                         As String = "fv_ivari"
Public Const cscFvIvarni                        As String = "fv_ivarni"
Public Const cscFvSubtotal                      As String = "fv_subtotal"
Public Const cscFvGrabarAsiento                 As String = "fv_grabarasiento"

' FacturaVentaItem
Public Const cscFviId                                 As String = "fvi_id"
Public Const cscFviOrden                              As String = "fvi_orden"
Public Const cscFviCantidad                           As String = "fvi_cantidad"
Public Const cscFviPrecio                             As String = "fvi_precio"
Public Const cscFviPrecioUsr                          As String = "fvi_precioUsr"
Public Const cscFviNeto                               As String = "fvi_neto"
Public Const cscFviIvari                              As String = "fvi_ivari"
Public Const cscFviIvariporc                          As String = "fvi_ivariporc"
Public Const cscFviImporte                            As String = "fvi_importe"
Public Const cscCueIdIvaRI                            As String = "cue_id_IvaRI"

' FacturaVentaItemTMP
Public Const csTFacturaVentaItemTMP                   As String = "FacturaVentaItemTMP"
Public Const cscFviTMPId                              As String = "fviTMP_id"

' Producto
Public Const cscPrId                                 As String = "pr_id"
Public Const cscCueidventa                           As String = "cue_id_venta"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"

' OrdenPago
Public Const csTOrdenPago                             As String = "OrdenPago"
Public Const cscOpgId                                 As String = "opg_id"
Public Const cscOpgNumero                             As String = "opg_numero"
Public Const cscOpgNrodoc                             As String = "opg_nrodoc"
Public Const cscOpgDescrip                            As String = "opg_descrip"
Public Const cscOpgFecha                              As String = "opg_fecha"
Public Const cscOpgNeto                               As String = "opg_neto"
Public Const cscOpgOtros                              As String = "opg_otros"
Public Const cscOpgTotal                              As String = "opg_total"
Public Const cscOpgPendiente                          As String = "opg_pendiente"
Public Const cscOpgCotizacion                         As String = "opg_cotizacion"
Public Const cscOpgGrabarAsiento                      As String = "opg_grabarAsiento"
Public Const cscOpgFirmado                            As String = "opg_firmado"

' OrdenPagoTMP
Public Const csTOrdenPagoTMP                          As String = "OrdenPagoTMP"
Public Const cscOpgTMPId                              As String = "opgTMP_id"

' OrdenPagoItem
Public Const csTOrdenPagoItem                          As String = "OrdenPagoItem"
Public Const cscOpgiId                                 As String = "opgi_id"
Public Const cscOpgiOrden                              As String = "opgi_orden"
Public Const cscOpgiOtroTipo                           As String = "opgi_otroTipo"
Public Const cscOpgiImporte                            As String = "opgi_importe"
Public Const cscOpgiImporteOrigen                      As String = "opgi_importeOrigen"
Public Const cscOpgiDescrip                            As String = "opgi_descrip"
Public Const cscOpgiPorcRetencion                      As String = "opgi_porcRetencion"
Public Const cscOpgiFechaRetencion                     As String = "opgi_fechaRetencion"
Public Const cscOpgiNroRetencion                       As String = "opgi_nroRetencion"
Public Const cscOpgiTipo                               As String = "opgi_tipo"

' OrdenPagoItemTMP
Public Const csTOrdenPagoItemTMP                       As String = "OrdenPagoItemTMP"
Public Const cscOpgiTMPId                              As String = "opgiTMP_id"
Public Const cscOpgiTMPCheque                          As String = "opgiTMP_cheque"
Public Const cscOpgiTMPCupon                           As String = "opgiTMP_cupon"
Public Const cscOpgiTMPFechaCobro                      As String = "opgiTMP_fechaCobro"
Public Const cscOpgiTMPFechaVto                        As String = "opgiTMP_fechaVto"
Public Const cscOpgiTMPTitular                         As String = "opgiTMP_titular"
Public Const cscOpgiTMPAutorizacion                    As String = "opgiTMP_autorizacion"
Public Const cscOpgiTMPNroTarjeta                      As String = "opgiTMP_nroTarjeta"

' OrdenPagoItemBorradoTMP
Public Const csTOrdenPagoItemBorradoTMP                As String = "OrdenPagoItemBorradoTMP"
Public Const cscOpgibTMPId                             As String = "OpgibTMP_Id"

'///////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////
' FacturaCompra
Public Const csTFacturaCompra                   As String = "FacturaCompra"
Public Const cscFcId                            As String = "fc_id"
Public Const cscFcNumero                        As String = "fc_numero"
Public Const cscFcNrodoc                        As String = "fc_nrodoc"
Public Const cscFcDescrip                       As String = "fc_descrip"
Public Const cscFcFecha                         As String = "fc_fecha"
Public Const cscFcTotal                         As String = "fc_total"
Public Const cscFcTotalOrigen                   As String = "fc_totalorigen"
Public Const cscFcPendiente                     As String = "fc_pendiente"
Public Const cscFcCotizacion                    As String = "fc_cotizacion"

' FacturaCompraDeuda
Public Const cscFcdId                           As String = "fcd_id"
Public Const cscFcdFecha                        As String = "fcd_fecha"
Public Const cscFcdPendiente                    As String = "fcd_pendiente"

' FacturaCompraPago
Public Const cscFcpId                           As String = "fcp_id"
Public Const cscFcpFecha                        As String = "fcp_fecha"
Public Const cscFcpImporte                      As String = "fcp_importe"

' FacturaCompraCobranza
Public Const csTFacturaCompraOrdenPagoTMP      As String = "FacturaCompraOrdenPagoTMP"
Public Const cscFcOpgImporte                   As String = "fcopg_importe"
Public Const cscFcOpgTMPid                     As String = "fcopgTMP_id"
Public Const cscFcOpgId                        As String = "fcopg_id"
Public Const cscFcOpgImporteOrigen             As String = "fcopg_importeOrigen"
Public Const cscFcOpgCotizacion                As String = "fcopg_cotizacion"

' FacturaCompraNotaCredito
Public Const csTFacturaCompraNotaCredito        As String = "FacturaCompraNotaCredito"
Public Const cscFcNcImporte                     As String = "fcnc_importe"
Public Const cscFcNcId                          As String = "fcnc_id"
Public Const cscFcIdNotaCredito                 As String = "fc_id_notacredito"
Public Const cscFcIdFactura                     As String = "fc_id_factura"
Public Const cscFcdIdNotaCredito                As String = "fcd_id_notacredito"
Public Const cscFcdIdFactura                    As String = "fcd_id_factura"
Public Const cscFcpIdNotaCredito                As String = "fcp_id_notacredito"
Public Const cscFcpIdFactura                    As String = "fcp_id_factura"

' FacturaCompraNotaCreditoTMP
Public Const csTFacturaCompraNotaCreditoTMP     As String = "FacturaCompraNotaCreditoTMP"
Public Const cscFcNcTMPid                       As String = "fvncTMP_id"

' FacturaCompraTMP
Public Const csTFacturaCompraTMP                 As String = "FacturaCompraTMP"
Public Const cscFcTMPId                          As String = "fcTMP_id"

' FacturaCompra
Public Const cscFcFechaentrega                  As String = "fc_fechaentrega"
Public Const cscFcNeto                          As String = "fc_neto"
Public Const cscFcIvari                         As String = "fc_ivari"
Public Const cscFcIvarni                        As String = "fc_ivarni"
Public Const cscFcSubtotal                      As String = "fc_subtotal"
Public Const cscFcGrabarAsiento                 As String = "fc_grabarasiento"

' FacturaCompraItem
Public Const cscFciId                                 As String = "fci_id"
Public Const cscFciOrden                              As String = "fci_orden"
Public Const cscFciCantidad                           As String = "fci_cantidad"
Public Const cscFciPrecio                             As String = "fci_precio"
Public Const cscFciNeto                               As String = "fci_neto"
Public Const cscFciIvari                              As String = "fci_ivari"
Public Const cscFciIvariporc                          As String = "fci_ivariporc"
Public Const cscFciImporte                            As String = "fci_importe"

' FacturaCompraItemTMP
Public Const csTFacturaCompraItemTMP                  As String = "FacturaCompraItemTMP"
Public Const cscFciTMPId                              As String = "fciTMP_id"

' Movimiento de Fondos TMP
Public Const csTMovimientoFondoTMP                    As String = "MovimientoFondoTMP"
Public Const cscMfTMPId                               As String = "mfTMP_id"

' Movimiento de Fondos
Public Const csTMovimientoFondo                       As String = "MovimientoFondo"
Public Const cscMfId                                  As String = "mf_id"
Public Const cscMfNumero                              As String = "mf_numero"
Public Const cscMfNrodoc                              As String = "mf_nrodoc"
Public Const cscMfDescrip                             As String = "mf_descrip"
Public Const cscMfFecha                               As String = "mf_fecha"
Public Const cscMfTotal                               As String = "mf_total"
Public Const cscMfTotalorigen                         As String = "mf_totalorigen"
Public Const cscMfPendiente                           As String = "mf_pendiente"
Public Const cscMfFirmado                             As String = "mf_firmado"
Public Const cscMfGrabarasiento                       As String = "mf_grabarasiento"
Public Const cscMfCotizacion                          As String = "mf_cotizacion"

' Movimiento de Fondos Item MTP
Public Const csTMovimientoFondoItemTMP                As String = "MovimientoFondoItemTMP"
Public Const cscMfiTMPId                              As String = "mfiTMP_id"
Public Const cscMfiTMPCheque                          As String = "mfiTMP_cheque"
Public Const cscMfiTMPFechaCobro                      As String = "mfiTMP_FechaCobro"
Public Const cscMfiTMPFechaVto                        As String = "mfiTMP_FechaVto"

' Movimiento de Fondos Item Borrado MTP
Public Const csTMovimientoFondoItemBorradoTMP         As String = "MovimientoFondoItemBorradoTMP"
Public Const cscMfibTMPId                             As String = "mfibTMP_id"

' Movimiento de Fondos Item
Public Const csTMovimientoFondoItem                   As String = "MovimientoFondoItem"
Public Const cscMfiId                                 As String = "mfi_id"
Public Const cscMfiOrden                              As String = "mfi_orden"
Public Const cscMfiDescrip                            As String = "mfi_descrip"
Public Const cscMfiImporte                            As String = "mfi_importe"
Public Const cscMfiImporteOrigen                      As String = "mfi_importeorigen"
Public Const cscMfiImporteOrigenHaber                 As String = "mfi_importeorigenHaber"
Public Const cscMfiTipo                               As String = "mfi_tipo"
Public Const cscCueIdDebe                             As String = "cue_id_debe"
Public Const cscCueIdHaber                            As String = "cue_id_haber"


' DepositoCupon
Public Const csTDepositoCupon                         As String = "DepositoCupon"
Public Const cscDcupId                                As String = "dcup_id"
Public Const cscDcupNumero                            As String = "dcup_numero"
Public Const cscDcupNrodoc                            As String = "dcup_nrodoc"
Public Const cscDcupDescrip                           As String = "dcup_descrip"
Public Const cscDcupFecha                             As String = "dcup_fecha"
Public Const cscDcupTotal                             As String = "dcup_total"
Public Const cscDcupGrabarasiento                     As String = "dcup_grabarasiento"
Public Const cscDcupFirmado                           As String = "dcup_firmado"

' DepositoCuponTMP
Public Const csTDepositoCuponTMP                      As String = "DepositoCuponTMP"
Public Const cscDcupTMPId                             As String = "dcupTMP_id"

' DepositoCuponItem
Public Const csTDepositoCuponItem                     As String = "DepositoCuponItem"
Public Const cscDcupiId                               As String = "dcupi_id"
Public Const cscDcupiOrden                            As String = "dcupi_orden"
Public Const cscDcupiImporte                          As String = "dcupi_importe"
Public Const cscDcupiImporteorigen                    As String = "dcupi_importeorigen"
Public Const cscDcupiDescrip                          As String = "dcupi_descrip"

' DepositoCuponItemTMP
Public Const csTDepositoCuponItemTMP                  As String = "DepositoCuponItemTMP"
Public Const cscDcupiTMPId                            As String = "dcupiTMP_id"

' DepositoCuponItemBorradoTMP
Public Const csTDepositoCuponItemBorradoTMP           As String = "DepositoCuponItemBorradoTMP"
Public Const cscDcupibTMPId                           As String = "dcupibTMP_Id"

'/////////////////////////////////////////////////////////////////////////////////

' ResolucionCupon
Public Const csTResolucionCupon                       As String = "ResolucionCupon"
Public Const cscRcupId                                As String = "rcup_id"
Public Const cscRcupNumero                            As String = "rcup_numero"
Public Const cscRcupNrodoc                            As String = "rcup_nrodoc"
Public Const cscRcupDescrip                           As String = "rcup_descrip"
Public Const cscRcupFecha                             As String = "rcup_fecha"
Public Const cscRcupTotal                             As String = "rcup_total"
Public Const cscRcupGrabarasiento                     As String = "rcup_grabarasiento"
Public Const cscRcupFirmado                           As String = "rcup_firmado"

' ResolucionCuponTMP
Public Const csTResolucionCuponTMP                    As String = "ResolucionCuponTMP"
Public Const cscRcupTMPId                             As String = "rcupTMP_id"

' ResolucionCuponItem
Public Const csTResolucionCuponItem                   As String = "ResolucionCuponItem"
Public Const cscRcupiId                               As String = "rcupi_id"
Public Const cscRcupiOrden                            As String = "rcupi_orden"
Public Const cscRcupiImporte                          As String = "rcupi_importe"
Public Const cscRcupiImporteOrigen                    As String = "rcupi_importeorigen"
Public Const cscRcupiDescrip                          As String = "rcupi_descrip"
Public Const cscRcupiRechazado                        As String = "rcupi_rechazado"
Public Const cscRcupiCuota                            As String = "rcupi_cuota"
Public Const cscRcupiComision                         As String = "rcupi_comision"

' ResolucionCuponItemTMP
Public Const csTResolucionCuponItemTMP                As String = "ResolucionCuponItemTMP"
Public Const cscRcupiTMPId                            As String = "rcupiTMP_id"

' ResolucionCuponItemBorradoTMP
Public Const csTResolucionCuponItemBorradoTMP         As String = "ResolucionCuponItemBorradoTMP"
Public Const cscRcupibTMPId                           As String = "rcupibTMP_Id"

' Retencion
Public Const cscRetId                                 As String = "ret_id"
Public Const cscRetNombre                             As String = "ret_nombre"

' Asiento
Public Const cscAsId                                  As String = "as_id"

' CashFlow
Public Const csTCashFlow                             As String = "CashFlow"
Public Const cscCfId                                 As String = "cf_id"
Public Const cscCfNombre                             As String = "cf_nombre"
Public Const cscCfFecha                              As String = "cf_fecha"
Public Const cscCfDescrip                            As String = "cf_descrip"
Public Const cscCfFechadesde                         As String = "cf_fechadesde"
Public Const cscCfFechahasta                         As String = "cf_fechahasta"
Public Const cscCfFechacheque                        As String = "cf_fechacheque"
Public Const cscCfFv                                 As String = "cf_fv"
Public Const cscCfRv                                 As String = "cf_rv"
Public Const cscCfPv                                 As String = "cf_pv"
Public Const cscCfFc                                 As String = "cf_fc"
Public Const cscCfRc                                 As String = "cf_rc"
Public Const cscCfOc                                 As String = "cf_oc"

' CashFlowItems
Public Const csTCashFlowItem                          As String = "CashFlowItem"
Public Const cscCfiId                                 As String = "cfi_id"
Public Const cscCfiFecha                              As String = "cfi_fecha"
Public Const cscCfiImporte                            As String = "cfi_importe"
Public Const cscCfiExcluir                            As String = "cfi_excluir"
Public Const cscCfiTipo                               As String = "cfi_tipo"
Public Const cscCompId                                As String = "comp_id"

' CashFlowParams
Public Const csTCashFlowParam                         As String = "CashFlowParam"
Public Const cscCfpId                                 As String = "cfp_id"

' BancoConciliacion
Public Const csTBancoConciliacion                      As String = "BancoConciliacion"
Public Const cscBcocId                                 As String = "bcoc_id"
Public Const cscBcocNumero                             As String = "bcoc_numero"
Public Const cscBcocFecha                              As String = "bcoc_fecha"
Public Const cscBcocFechaDesde                         As String = "bcoc_fechaDesde"
Public Const cscBcocFechaHasta                         As String = "bcoc_fechaHasta"
Public Const cscBcocSaldoInicialCont                   As String = "bcoc_saldoInicialCont"
Public Const cscBcocSaldoCont                          As String = "bcoc_saldoCont"
Public Const cscBcocSaldoInicialBco                    As String = "bcoc_saldoInicialBco"
Public Const cscBcocConciliadoBco                      As String = "bcoc_conciliadoBco"
Public Const cscBcocSaldoBco                           As String = "bcoc_saldoBco"
Public Const cscBcocSaldoInicialRech                   As String = "bcoc_saldoInicialRech"
Public Const cscBcocRechazado                          As String = "bcoc_rechazado"
Public Const cscBcocSaldoRech                          As String = "bcoc_saldoRech"
Public Const cscBcocSaldoInicialPendiente              As String = "bcoc_saldoInicialPendiente"
Public Const cscBcocPendiente                          As String = "bcoc_pendiente"
Public Const cscBcocSaldoPendiente                     As String = "bcoc_saldoPendiente"
Public Const cscBcocFechacheque                        As String = "bcoc_fechacheque"
Public Const cscBcocVerpendientes                      As String = "bcoc_verpendientes"
Public Const cscBcocDescrip                            As String = "bcoc_descrip"

' BancoConciliacionItem
Public Const csTBancoConciliacionItem                   As String = "BancoConciliacionItem"
Public Const cscBcociId                                 As String = "bcoci_id"
Public Const cscBcociDebe                               As String = "bcoci_debe"
Public Const cscBcociHaber                              As String = "bcoci_haber"
Public Const cscBcociFecha                              As String = "bcoci_fecha"
Public Const cscBcociEstado                             As String = "bcoci_estado"
Public Const cscBcociDescrip                            As String = "bcoci_descrip"
Public Const cscBcociSaldoCont                          As String = "bcoci_saldocont"
Public Const cscBcociSaldoBco                           As String = "bcoci_saldobco"

Public Const cscDoctIdCliente                           As String = "doct_id_cliente"
Public Const cscIdCliente                               As String = "id_cliente"

' Para Facturas en Retenciones y Cheques Rechazados
Public Const csFacturaCompra = 17001
Public Const csFacturaVenta = 16001

Public Const cscFcIdRet                                 As String = "fc_id_ret"
Public Const cscFvIdRet                                 As String = "fv_id_ret"

' Caja
Public Const csTCaja                                  As String = "Caja"
Public Const cscCjId                                  As String = "cj_id"
Public Const cscCjNombre                              As String = "cj_nombre"
Public Const cscCueIdFondos                           As String = "cue_id_fondos"
Public Const cscCueIdTrabajo                          As String = "cue_id_trabajo"

