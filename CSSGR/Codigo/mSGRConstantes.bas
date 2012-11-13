Attribute VB_Name = "mSGRConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mSGRConstantes
' 01-12-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

Public Const c_img_task = 1

' constantes

Public Const csPreVtaCobranzaContado = 16024
Public Const csPreVtaEditPriceFac = 16016
Public Const csPreVtaModifyAplic = 16014
Public Const csEstado = 4005

Public Const c_MainIniFile = "Cairo.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public Enum csETablesVentas
  csFacturaVenta = 16001
  csRemitoVenta = 16002
  csPresupuestoVenta = 16004
End Enum

' Cuenta
Public Const csTCuenta                           As String = "Cuenta"
Public Const cscCueId                            As String = "cue_id"
Public Const cscCueNombre                        As String = "cue_nombre"

' Cuenta Grupo
Public Const csTCuentaGrupo                      As String = "CuentaGrupo"
Public Const cscCuegId                           As String = "cueg_id"
Public Const cscCuegTipo                         As String = "cueg_tipo"

Public Const cscCuecId                           As String = "cuec_id"

' Socio Form
Public Const csTSocioForm                              As String = "SocioForm"
Public Const cscSocfId                                 As String = "socf_id"
Public Const cscSocfNombre                             As String = "socf_nombre"
Public Const cscSocfCodigo                             As String = "socf_codigo"
Public Const cscSocfDescrip                            As String = "socf_descrip"

' Socio Form Item
Public Const csTSocioFormItem                          As String = "SocioFormItem"
Public Const cscSocfiId                                As String = "socfi_id"

'Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCodigo                              As String = "cli_codigo"
Public Const cscCliDescrip                             As String = "cli_descrip"
Public Const cscCliContacto                            As String = "cli_contacto"
Public Const cscCliRazonsocial                         As String = "cli_razonsocial"
Public Const cscCliCuit                                As String = "cli_cuit"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"
Public Const cscCliCodpostal                           As String = "cli_codpostal"
Public Const cscCliLocalidad                           As String = "cli_localidad"
Public Const cscCliCalle                               As String = "cli_calle"
Public Const cscCliCallenumero                         As String = "cli_callenumero"
Public Const cscCliPiso                                As String = "cli_piso"
Public Const cscCliDepto                               As String = "cli_depto"
Public Const cscCliTel                                 As String = "cli_tel"
Public Const cscCliFax                                 As String = "cli_fax"
Public Const cscCliEmail                               As String = "cli_email"
Public Const cscCliWeb                                 As String = "cli_web"
Public Const cscCliYahoo                               As String = "cli_yahoo"
Public Const cscCliMessanger                           As String = "cli_messanger"

Public Const csTProvincia                       As String = "Provincia"
Public Const cscProId                           As String = "pro_id"
Public Const cscProNombre                       As String = "pro_nombre"

' Socio
Public Const csTSocio                                 As String = "Socio"
Public Const cscSocId                                 As String = "soc_id"
Public Const cscSocFecha                              As String = "soc_fecha"
Public Const cscSocActividad                          As String = "soc_actividad"
Public Const cscSocMicapgba                           As String = "soc_micapgba"
Public Const cscSocMiinterior                         As String = "soc_miinterior"
Public Const cscSocMeproducto1                        As String = "soc_meproducto1"
Public Const cscSocMeproducto2                        As String = "soc_meproducto2"
Public Const cscSocMeproducto3                        As String = "soc_meproducto3"
Public Const cscSocMeproducto4                        As String = "soc_meproducto4"
Public Const cscSocMeproducto5                        As String = "soc_meproducto5"
Public Const cscSocCdiczaopporcentaje                 As String = "soc_cdiczaopporcentaje"
Public Const cscSocCdiczaopplazo                      As String = "soc_cdiczaopplazo"
Public Const cscSocClientecf                          As String = "soc_clientecf"
Public Const cscSocClienteatom                        As String = "soc_clienteatom"
Public Const cscSocClienteconc                        As String = "soc_clienteconc"
Public Const cscSocCodvtaContadoDias                  As String = "soc_codvta_contado_dias"
Public Const cscSocCodvtaContadoPorc                  As String = "soc_codvta_contado_porc"
Public Const cscSocCodvtaCtacteDias                   As String = "soc_codvta_ctacte_dias"
Public Const cscSocCodvtaCtactePorc                   As String = "soc_codvta_ctacte_porc"
Public Const cscSocCodvtaDocumentosDias               As String = "soc_codvta_documentos_dias"
Public Const cscSocCodvtaDocumentosPorc               As String = "soc_codvta_documentos_porc"
Public Const cscSocCodvtaTarjetaDias                  As String = "soc_codvta_tarjeta_dias"
Public Const cscSocCodvtaTarjetaPorc                  As String = "soc_codvta_tarjeta_porc"
Public Const cscSocEmpleadocom                        As String = "soc_empleadocom"
Public Const cscSocEmpleadoadmin                      As String = "soc_empleadoadmin"
Public Const cscSocEmpleadoprod                       As String = "soc_empleadoprod"
Public Const cscSocCostompminombre                    As String = "soc_costompminombre"
Public Const cscSocCostompmiporc                      As String = "soc_costompmiporc"
Public Const cscSocCostompmenombre                    As String = "soc_costompmenombre"
Public Const cscSocCostompmeporc                      As String = "soc_costompmeporc"
Public Const cscSocCostomomi                          As String = "soc_costomomi"
Public Const cscSocCostomome                          As String = "soc_costomome"
Public Const cscSocCostomifabricacion                 As String = "soc_costomifabricacion"
Public Const cscSocCostomefabricacion                 As String = "soc_costomefabricacion"
Public Const cscSocCapacidadplena                     As String = "soc_capacidadplena"
Public Const cscSocCapacidadactual                    As String = "soc_capacidadactual"
Public Const cscSocCapacidadutilizada                 As String = "soc_capacidadutilizada"
Public Const cscSocEstacoferta                        As String = "soc_estacoferta"
Public Const cscSocEstacdemanda                       As String = "soc_estacdemanda"
Public Const cscSocIniactividades                     As String = "soc_iniactividades"
Public Const cscSocCantpersonal                       As String = "soc_cantpersonal"
Public Const cscSocLibrorubricado                     As String = "soc_librorubricado"
Public Const cscSocAltafirmante                       As String = "soc_altafirmante"
Public Const cscSocCargofirmante                      As String = "soc_cargofirmante"

' Zona
Public Const csTZona                            As String = "Zona"
Public Const cscZonId                           As String = "zon_id"
Public Const cscZonNombre                       As String = "zon_nombre"

' Empresa Cliente
Public Const csTEmpresaCliente                        As String = "EmpresaCliente"
Public Const cscEmpCliId                              As String = "empcli_id"

' Contacto
Public Const csTContacto                               As String = "Contacto"
Public Const cscContId                                 As String = "cont_id"
Public Const cscContNombre                             As String = "cont_nombre"
Public Const cscContCodigo                             As String = "cont_codigo"
Public Const cscContDescrip                            As String = "cont_descrip"
Public Const cscContTel                                As String = "cont_tel"
Public Const cscContCelular                            As String = "cont_celular"
Public Const cscContEmail                              As String = "cont_email"
Public Const cscContCargo                              As String = "cont_cargo"
Public Const cscContDireccion                          As String = "cont_direccion"

' Socio Accionista
Public Const csTSocioAccionista                        As String = "SocioAccionista"
Public Const cscSocaId                                 As String = "soca_id"
Public Const cscSocaNombre                             As String = "soca_nombre"
Public Const cscSocaCuit                               As String = "soca_cuit"
Public Const cscSocaParticipacion                      As String = "soca_participacion"

' Socio Balance
Public Const csTSocioBalance                           As String = "SocioBalance"
Public Const cscSocbId                                 As String = "socb_id"
Public Const cscSocbFecha                              As String = "socb_fecha"
Public Const cscSocbNombre                             As String = "socb_nombre"
Public Const cscSocbTotalactivo                        As String = "socb_totalactivo"
Public Const cscSocbTotalpasivo                        As String = "socb_totalpasivo"
Public Const cscSocbTotalcapital                       As String = "socb_totalcapital"
Public Const cscSocbTotalactivosup                     As String = "socb_totalactivosup"
Public Const cscSocbTotalpasivosup                     As String = "socb_totalpasivosup"
Public Const cscSocbTotalcapitalsup                    As String = "socb_totalcapitalsup"
Public Const cscSocbIngresoshonorarios                 As String = "socb_ingresoshonorarios"
Public Const cscSocbIngresosrentas                     As String = "socb_ingresosrentas"
Public Const cscSocbIngresosotros                      As String = "socb_ingresosotros"
Public Const cscSocbEgresosnombre1                     As String = "socb_egresosnombre1"
Public Const cscSocbEgresosimporte1                    As String = "socb_egresosimporte1"
Public Const cscSocbEgresosnombre2                     As String = "socb_egresosnombre2"
Public Const cscSocbEgresosimporte2                    As String = "socb_egresosimporte2"
Public Const cscSocbFirmadopor                         As String = "socb_firmadopor"
Public Const cscSocbDni                                As String = "socb_dni"

' Socio Balance Item
Public Const csTSocioBalanceItem                        As String = "SocioBalanceItem"
Public Const cscSocbiId                                 As String = "socbi_id"
Public Const cscSocbiMoneda1                            As String = "socbi_moneda1"
Public Const cscSocbiMoneda2                            As String = "socbi_moneda2"
Public Const cscSocbiDeclarado                          As String = "socbi_declarado"
Public Const cscSocbiImporte                            As String = "socbi_importe"
Public Const cscSocbiDescrip                            As String = "socbi_descrip"
Public Const cscSocbiDestino                            As String = "socbi_destino"
Public Const cscSocbiLocalidad                          As String = "socbi_localidad"

' Socio Balance Tipo
Public Const csTSocioBalanceTipo                        As String = "SocioBalanceTipo"
Public Const cscSocbtId                                 As String = "socbt_id"
Public Const cscSocbtNombre                             As String = "socbt_nombre"
Public Const cscSocbtOrden                              As String = "socbt_orden"
Public Const cscSocbtTipo                               As String = "socbt_tipo"
Public Const cscSocbtGrupo                              As String = "socbt_grupo"
Public Const cscSocbtSubtipo                            As String = "socbt_subtipo"

' Socio Cliente
Public Const csTSocioCliente                            As String = "SocioCliente"
Public Const cscSocclId                                 As String = "soccl_id"
Public Const cscSocclNombre                             As String = "soccl_nombre"
Public Const cscSocclFactporc                           As String = "soccl_factporc"

' Socio Competencia
Public Const csTSocioCompetencia                       As String = "SocioCompetencia"
Public Const cscSoccId                                 As String = "socc_id"
Public Const cscSoccNombre                             As String = "socc_nombre"
Public Const cscSoccMercadoporc                        As String = "socc_mercadoporc"
Public Const cscSoccDescrip                            As String = "socc_descrip"

' Socio Deuda Banco
Public Const csTSocioDeudaBanco                         As String = "SocioDeudaBanco"
Public Const cscSocdbId                                 As String = "socdb_id"
Public Const cscSocdbImporte                            As String = "socdb_importe"
Public Const cscSocdbTipooperacion                      As String = "socdb_tipooperacion"
Public Const cscSocdbGarantia                           As String = "socdb_garantia"

' Socio Empresa
Public Const csTSocioEmpresa                           As String = "SocioEmpresa"
Public Const cscSoceId                                 As String = "soce_id"
Public Const cscSoceEmpresa                            As String = "soce_empresa"
Public Const cscSoceCuit                               As String = "soce_cuit"
Public Const cscSoceVinculacion                        As String = "soce_vinculacion"
Public Const cscSoceParticipacion                      As String = "soce_participacion"
Public Const cscSoceTipo                               As String = "soce_tipo"

' Socio Inmueble
Public Const csTSocioInmueble                           As String = "SocioInmueble"
Public Const cscSocinId                                 As String = "socin_id"
Public Const cscSocinDireccion                          As String = "socin_direccion"
Public Const cscSocinDestino                            As String = "socin_destino"
Public Const cscSocinSuptotal                           As String = "socin_suptotal"
Public Const cscSocinSupcubierta                        As String = "socin_supcubierta"
Public Const cscSocinGravamen                           As String = "socin_gravamen"
Public Const cscSocinGravamenvalor                      As String = "socin_gravamenvalor"

' Socio Item
Public Const csTSocioItem                              As String = "SocioItem"
Public Const cscSociId                                 As String = "soci_id"
Public Const cscSociNombre                             As String = "soci_nombre"
Public Const cscSociDocumento                          As String = "soci_documento"
Public Const cscSociCargo                              As String = "soci_cargo"
Public Const cscSociEssocio                            As String = "soci_essocio"
Public Const cscSociParticipacion                      As String = "soci_participacion"

' Socio Producto
Public Const csTSocioProducto                          As String = "SocioProducto"
Public Const cscSocpId                                 As String = "socp_id"
Public Const cscSocpProducto                           As String = "socp_producto"
Public Const cscSocpMarca                              As String = "socp_marca"
Public Const cscSocpPropia                             As String = "socp_propia"
Public Const cscSocpTercero                            As String = "socp_tercero"
Public Const cscSocpFactporc                           As String = "socp_factporc"

' Socio Tarjeta
Public Const csTSocioTarjeta                           As String = "SocioTarjeta"
Public Const cscSoctId                                 As String = "soct_id"
Public Const cscSoctPorcentaje                         As String = "soct_porcentaje"
Public Const cscSoctCantcuotas                         As String = "soct_cantcuotas"

' Socio Venta Anual
Public Const csTSocioVentaAnual                         As String = "SocioVentaAnual"
Public Const cscSocvaId                                 As String = "socva_id"
Public Const cscSocvaAnio                               As String = "socva_anio"
Public Const cscSocvaEnero                              As String = "socva_enero"
Public Const cscSocvaFebrero                            As String = "socva_febrero"
Public Const cscSocvaMarzo                              As String = "socva_marzo"
Public Const cscSocvaAbril                              As String = "socva_abril"
Public Const cscSocvaMayo                               As String = "socva_mayo"
Public Const cscSocvaJunio                              As String = "socva_junio"
Public Const cscSocvaJulio                              As String = "socva_julio"
Public Const cscSocvaAgosto                             As String = "socva_agosto"
Public Const cscSocvaSeptiembre                         As String = "socva_septiembre"
Public Const cscSocvaOctubre                            As String = "socva_octubre"
Public Const cscSocvaNoviembre                          As String = "socva_noviembre"
Public Const cscSocvaDiciembre                          As String = "socva_diciembre"
Public Const cscSocvaTotal                              As String = "socva_total"

' Banco
Public Const csTBanco                                 As String = "Banco"
Public Const cscBcoId                                 As String = "bco_id"
Public Const cscBcoNombre                             As String = "bco_nombre"

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
Public Const cscFviIvariporc                          As String = "fvi_ivariporc"
Public Const cscFviIvarniporc                         As String = "fvi_ivarniporc"
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

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjTitulo                             As String = "lgj_Titulo"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"

'Provincia
Public Const cscProIdOrigen                           As String = "pro_id_origen"
Public Const cscProIdDestino                          As String = "pro_id_destino"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

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

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"
Public Const cscCpgEsLibre                            As String = "cpg_eslibre"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

' Tipo Operacion
Public Const cscToId                                   As String = "to_id"
Public Const cscToNombre                               As String = "to_nombre"

' Asiento
Public Const cscAsId                                  As String = "as_id"

' Iva
Public Const cscbIvaRi                                As String = "bIvaRi"
Public Const cscbIvaRni                               As String = "bIvaRni"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

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

' AFIPCodigoActividad
Public Const csTAFIPCodigoActividad                    As String = "AFIPCodigoActividad"
Public Const cscCodaId                                 As String = "coda_id"
Public Const cscCodaNombre                             As String = "coda_nombre"
Public Const cscCodaCodigo                             As String = "coda_codigo"
Public Const cscCodaDescrip                            As String = "coda_descrip"

' Actividad Comercial Tipo
Public Const csTActividadComercialTipo                As String = "ActividadComercialTipo"
Public Const cscActId                                 As String = "act_id"
Public Const cscActNombre                             As String = "act_nombre"
Public Const cscActCodigo                             As String = "act_codigo"

' Pais
Public Const cscPaId1                                 As String = "pa_id1"
Public Const cscPaId2                                 As String = "pa_id2"
Public Const cscPaId3                                 As String = "pa_id3"
Public Const cscPaId4                                 As String = "pa_id4"
Public Const cscPaId5                                 As String = "pa_id5"

' Moneda
Public Const csTMoneda                                As String = "Moneda"
Public Const cscMonId                                 As String = "Mon_id"
Public Const cscMonNombre                             As String = "Mon_nombre"

