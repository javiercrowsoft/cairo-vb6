Attribute VB_Name = "mTicketConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mTicketConstantes
' 17-11-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mTicketConstantes"

Public Const csPreVtaModifyAplic = 16014

Public Const c_ClienteDataAdd = "ClienteDataAdd"

' Legajo
Public Const csLegajo = 15001

Public Enum csMenuEnum
  csMenuConfig = 2999
  csMenuProyecto = 2998
End Enum

Public Enum csETablesTask
  csContacto = 2001
  csPrioridad = 2003
  csTareaEstado = 2004
  csProyecto = 2005
  csHora = 2006
  cstblTarea = 2007
  csProyectoItem = 2008
  csObjetivo = 2009
  csAgenda = 2010
End Enum

' OrdenServicio
Public Const csTOrdenServicio                        As String = "OrdenServicio"
Public Const cscOsId                                 As String = "os_id"
Public Const cscOsNumero                             As String = "os_numero"
Public Const cscOsNrodoc                             As String = "os_nrodoc"
Public Const cscOsDescrip                            As String = "os_descrip"
Public Const cscOsFecha                              As String = "os_fecha"
Public Const cscOsHora                               As String = "os_hora"
Public Const cscOsFechaentrega                       As String = "os_fechaentrega"
Public Const cscOsNeto                               As String = "os_neto"
Public Const cscOsIvari                              As String = "os_ivari"
Public Const cscOsIvarni                             As String = "os_ivarni"
Public Const cscOsTotal                              As String = "os_total"
Public Const cscOsSubtotal                           As String = "os_subtotal"
Public Const cscOsPendiente                          As String = "os_pendiente"
Public Const cscOsDescuento1                         As String = "os_descuento1"
Public Const cscOsDescuento2                         As String = "os_descuento2"
Public Const cscOsImportedesc1                       As String = "os_importedesc1"
Public Const cscOsImportedesc2                       As String = "os_importedesc2"
Public Const cscOsFirmado                            As String = "os_firmado"
Public Const cscOsCotizacion                         As String = "os_cotizacion"

Public Const cscUsIdTecnico                          As String = "us_id_tecnico"

' Tareas
Public Const cscTarId                                As String = "tar_id"
Public Const cscTarNombre                            As String = "tar_nombre"

' Contacto
Public Const csTContacto                             As String = "Contacto"
Public Const cscContId                               As String = "cont_id"
Public Const cscContNombre                           As String = "cont_nombre"
Public Const cscContTel                              As String = "cont_tel"
Public Const cscContCelular                          As String = "cont_celular"
Public Const cscContCiudad                           As String = "cont_ciudad"

' Ciudad
Public Const csTCiudad                               As String = "Ciudad"
Public Const cscCiuId                                As String = "ciu_id"
Public Const cscCiuNombre                            As String = "ciu_nombre"

' OrdenServicioTMP
Public Const csTOrdenServicioTMP                     As String = "OrdenServicioTMP"
Public Const cscOsTMPId                              As String = "osTMP_id"

' OrdenServicioItem
Public Const csTOrdenServicioItem                     As String = "OrdenServicioItem"
Public Const cscOsiId                                 As String = "osi_id"
Public Const cscOsiOrden                              As String = "osi_orden"
Public Const cscOsiCantidad                           As String = "osi_cantidad"
Public Const cscOsiCantidadaremitir                   As String = "osi_cantidadaremitir"
Public Const cscOsiPendiente                          As String = "osi_pendiente"
Public Const cscOsiDescrip                            As String = "osi_descrip"
Public Const cscOsiPrecio                             As String = "osi_precio"
Public Const cscOsiPrecioUsr                          As String = "osi_precioUsr"
Public Const cscOsiPrecioLista                        As String = "osi_precioLista"
Public Const cscOsiDescuento                          As String = "osi_descuento"
Public Const cscOsiNeto                               As String = "osi_neto"
Public Const cscOsiIvari                              As String = "osi_ivari"
Public Const cscOsiIvarni                             As String = "osi_ivarni"
Public Const cscOsiIvariporc                          As String = "osi_ivariporc"
Public Const cscOsiIvarniporc                         As String = "osi_ivarniporc"
Public Const cscOsiImporte                            As String = "osi_importe"

' OrdenServicioItemTMP
Public Const csTOrdenServicioItemTMP                  As String = "OrdenServicioItemTMP"
Public Const cscOsiTMPId                              As String = "osiTMP_id"

' OrdenServicioItemBorradoTMP
Public Const csTOrdenServicioItemBorradoTMP           As String = "OrdenServicioItemBorradoTMP"
Public Const cscOsibTMPId                             As String = "osibTMP_id"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"
Public Const cscCliTel                                 As String = "cli_tel"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscDocIdStock                            As String = "doc_id_stock"
Public Const cscDocMueveStock                         As String = "doc_muevestock"
Public Const cscDocObjectEdit                         As String = "doc_object_edit"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' CentroCosto
Public Const csTCentroCosto                            As String = "CentroCosto"
Public Const cscCcosId                                 As String = "ccos_id"
Public Const cscCcosNombre                             As String = "ccos_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Lista de Precios
Public Const csTListaPrecio                          As String = "ListaPrecio"
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

' Lista de Descuentos
Public Const csTListaDescuento                        As String = "ListaDescuento"
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"
Public Const cscCpgEsLibre                            As String = "cpg_eslibre"

' Stock
Public Const csTDepositoLogico                       As String = "DepositoLogico"
Public Const cscDeplIdOrigen                         As String = "depl_id_origen"
Public Const cscDeplIdDestino                        As String = "depl_id_destino"
Public Const cscDeplId                               As String = "depl_id"
Public Const cscDeplNombre                           As String = "depl_nombre"
Public Const cscDepfId                               As String = "depf_id"

' StockLote
Public Const csTStockLote                             As String = "StockLote"
Public Const cscStlId                                 As String = "stl_id"
Public Const cscStlCodigo                             As String = "stl_codigo"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_id"
Public Const cscLgjTitulo                             As String = "lgj_titulo"
Public Const cscLgjCodigo                             As String = "lgj_codigo"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Moneda
Public Const csTMoneda                                As String = "Moneda"
Public Const cscMonId                                 As String = "Mon_id"
Public Const cscMonNombre                             As String = "Mon_nombre"

' Producto
Public Const csTProducto                             As String = "Producto"
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombreCompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreventa                        As String = "pr_Nombreventa"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"
Public Const cscPrLlevaNroLote                       As String = "pr_llevanrolote"
Public Const cscPrEskit                              As String = "pr_eskit"
Public Const cscPrIdItem                             As String = "pr_id_item"
Public Const cscPrLlevaStock                         As String = "pr_llevastock"
Public Const cscPrLlevaNroSerie                      As String = "pr_llevanroserie"
Public Const cscPrLoteFifo                           As String = "pr_lotefifo"
'Public Const cscPrEskit                              As String = "pr_eskit"
'Public Const cscPrIdKit                              As String = "pr_id_kit"
'Public Const cscPrIdItem                             As String = "pr_id_item"

' Unidad
Public Const cscUnId                                  As String = "un_id"
Public Const cscUnNombre                              As String = "un_nombre"

' Producto Numero Serie
Public Const csTProductoNumeroSerie                    As String = "ProductoNumeroSerie"
Public Const cscPrnsId                                 As String = "prns_id"
Public Const cscPrnsCodigo                             As String = "prns_codigo"
Public Const cscPrnsCodigo2                            As String = "prns_codigo2"
Public Const cscPrnsCodigo3                            As String = "prns_codigo3"
Public Const cscPrnsCodigo4                            As String = "prns_codigo4"
Public Const cscPrnsCodigo5                            As String = "prns_codigo5"
Public Const cscPrnsDescrip                            As String = "prns_descrip"
Public Const cscPrnsFechavto                           As String = "prns_fechavto"

' Stock
Public Const cscStId                                  As String = "st_id"

' Iva
Public Const cscbIvaRi                                As String = "bIvaRi"
Public Const cscbIvaRni                               As String = "bIvaRni"

' TasaImpositiva
Public Const cscTiId                                  As String = "ti_id"
Public Const cscTiNombre                              As String = "ti_nombre"
Public Const cscTiPorcentaje                          As String = "ti_porcentaje"

' Orden Servicio Item Serie
Public Const csTOrdenServicioItemSerieTMP              As String = "OrdenServicioItemSerieTMP"
Public Const cscOsisTMPId                              As String = "osisTMP_id"
Public Const cscOsisOrden                              As String = "osis_orden"

' Orden Servicio Item Serie
Public Const csTOrdenServicioItemSerieBTMP             As String = "OrdenServicioItemSerieBTMP"
Public Const cscOsisbTMPId                             As String = "osisbTMP_id"

' Remitos
Public Const cscRvId                                   As String = "rv_id"
Public Const cscRvRetiro                               As String = "rv_retiro"
Public Const cscRvGuia                                 As String = "rv_guia"

' Items de Remito
Public Const cscRviId                                  As String = "rvi_id"

' Orden Remito Venta TMP
Public Const csTOrdenRemitoVentaTMP                   As String = "OrdenRemitoVentaTMP"
Public Const cscOsRvTMPid                             As String = "osrvTMP_id"

' Orden Remito Venta
Public Const csTOrdenRemitoVenta                      As String = "OrdenRemitoVenta"
Public Const cscOsRvId                                As String = "osrv_id"
Public Const cscOsRvCantidad                          As String = "osrv_cantidad"

' Proyecto
Public Const csTProyecto                               As String = "Proyecto"
Public Const cscProyId                                 As String = "proy_id"
Public Const cscProyNombre                             As String = "proy_nombre"
Public Const cscProyCodigo                             As String = "proy_codigo"

' Alarma
Public Const csTAlarma                               As String = "Alarma"
Public Const cscAlId                                 As String = "al_id"
Public Const cscAlNombre                             As String = "al_nombre"
Public Const cscAlCodigo                             As String = "al_codigo"
Public Const cscAlDescrip                            As String = "al_descrip"
Public Const cscAlDiatipo                            As String = "al_diatipo"
Public Const cscAlHorasxDia                          As String = "al_horasxdia"

' Cliente Sucursal
Public Const cscClisId                               As String = "clis_id"
Public Const cscClisNombre                           As String = "clis_nombre"

' Cliente Sucursal
Public Const csTRubro                                As String = "Rubro"
Public Const cscRubId                                As String = "rub_id"
Public Const cscRubNombre                            As String = "rub_nombre"

' Alarma Fechas
Public Const csTAlarmaFecha                           As String = "AlarmaFecha"
Public Const cscAlfId                                 As String = "alf_id"
Public Const cscAlfFecha                              As String = "alf_fecha"
Public Const cscAlfDesdehora                          As String = "alf_desdehora"
Public Const cscAlfDesdeminuto                        As String = "alf_desdeminuto"
Public Const cscAlfHastahora                          As String = "alf_hastahora"
Public Const cscAlfHastaminuto                        As String = "alf_hastaminuto"

' Alarma Mensual
Public Const csTAlarmaDiaMes                           As String = "AlarmaDiaMes"
Public Const cscAldmId                                 As String = "aldm_id"
Public Const cscAldmActivo                             As String = "aldm_activo"
Public Const cscAldmDia                                As String = "aldm_dia"
Public Const cscAldmDesdehora                          As String = "aldm_desdehora"
Public Const cscAldmDesdeminuto                        As String = "aldm_desdeminuto"
Public Const cscAldmHastahora                          As String = "aldm_hastahora"
Public Const cscAldmHastaminuto                        As String = "aldm_hastaminuto"

' Alarma Semanal
Public Const csTAlarmaDiaSemana                        As String = "AlarmaDiaSemana"
Public Const cscAldsId                                 As String = "alds_id"
Public Const cscAldsDia                                As String = "alds_dia"
Public Const cscAldsActivo                             As String = "alds_activo"
Public Const cscAldsDesdehora                          As String = "alds_desdehora"
Public Const cscAldsDesdeminuto                        As String = "alds_desdeminuto"
Public Const cscAldsHastahora                          As String = "alds_hastahora"
Public Const cscAldsHastaminuto                        As String = "alds_hastaminuto"

' Prioridad
Public Const csTPrioridad                              As String = "Prioridad"
Public Const cscPrioId                                 As String = "prio_id"
Public Const cscPrioNombre                             As String = "prio_nombre"

' Incidente Tipo
Public Const csTIncidenteTipo                          As String = "IncidenteTipo"
Public Const cscInctId                                 As String = "inct_id"
Public Const cscInctNombre                             As String = "inct_nombre"

' Incidente Apertura
Public Const csTIncidenteApertura                      As String = "IncidenteApertura"
Public Const cscIncaId                                 As String = "inca_id"
Public Const cscIncaNombre                             As String = "inca_nombre"

' Usuario - Tarea - ProductoNumeroSerie
Public Const cscUsIdResponsable                       As String = "us_id_responsable"
Public Const cscUsIdAsignador                         As String = "us_id_asignador"
Public Const cscUsIdalta                              As String = "us_id_alta"

' Tarea Estados
Public Const csTTareaEstado                             As String = "TareaEstado"
Public Const cscTarestId                                As String = "tarest_id"
Public Const cscTarestNombre                            As String = "tarest_nombre"

' ParteReparacion
Public Const csTParteReparacion                       As String = "ParteReparacion"
Public Const cscPrpId                                 As String = "prp_id"
Public Const cscPrpNumero                             As String = "prp_numero"
Public Const cscPrpNrodoc                             As String = "prp_nrodoc"
Public Const cscPrpDescrip                            As String = "prp_descrip"
Public Const cscPrpFecha                              As String = "prp_fecha"
Public Const cscPrpFechaentrega                       As String = "prp_fechaentrega"
Public Const cscPrpNeto                               As String = "prp_neto"
Public Const cscPrpIvari                              As String = "prp_ivari"
Public Const cscPrpIvarni                             As String = "prp_ivarni"
Public Const cscPrpSubtotal                           As String = "prp_subtotal"
Public Const cscPrpTotal                              As String = "prp_total"
Public Const cscPrpDescuento1                         As String = "prp_descuento1"
Public Const cscPrpDescuento2                         As String = "prp_descuento2"
Public Const cscPrpImportedesc1                       As String = "prp_importedesc1"
Public Const cscPrpImportedesc2                       As String = "prp_importedesc2"
Public Const cscPrpCotizacion                         As String = "prp_cotizacion"
Public Const cscPrpTipo                               As String = "prp_tipo"
Public Const cscPrpEstado                             As String = "prp_estado"

' ParteReparacionTMP
Public Const csTParteReparacionTMP                    As String = "ParteReparacionTMP"
Public Const cscPrpTMPId                              As String = "prpTMP_id"

' ParteReparacionItem
Public Const csTParteReparacionItem                    As String = "ParteReparacionItem"
Public Const cscPrpiId                                 As String = "prpi_id"
Public Const cscPrpiOrden                              As String = "prpi_orden"
Public Const cscPrpiCantidad                           As String = "prpi_cantidad"
Public Const cscPrpiDescrip                            As String = "prpi_descrip"
Public Const cscPrpiPrecio                             As String = "prpi_precio"
Public Const cscPrpiPrecioUsr                          As String = "prpi_precioUsr"
Public Const cscPrpiPrecioLista                        As String = "prpi_precioLista"
Public Const cscPrpiDescuento                          As String = "prpi_descuento"
Public Const cscPrpiNeto                               As String = "prpi_neto"
Public Const cscPrpiIvari                              As String = "prpi_ivari"
Public Const cscPrpiIvarni                             As String = "prpi_ivarni"
Public Const cscPrpiIvariporc                          As String = "prpi_ivariporc"
Public Const cscPrpiIvarniporc                         As String = "prpi_ivarniporc"
Public Const cscPrpiImporte                            As String = "prpi_importe"

' ParteReparacionTMP
Public Const csTParteReparacionItemTMP                 As String = "ParteReparacionItemTMP"
Public Const cscPrpiTMPId                              As String = "prpiTMP_id"

' Items Borrados de Parte de Reparacion
Public Const csTParteReparacionItemBorradoTMP          As String = "ParteReparacionItemBorradoTMP"
Public Const cscPrpibTMPId                             As String = "prpibTMP_id"

' Parte de Reparacion Item Serie
Public Const csTParteReparacionItemSerieTMP            As String = "ParteReparacionItemSerieTMP"
Public Const cscPrpisTMPId                             As String = "prpisTMP_id"
Public Const cscPrpisOrden                             As String = "prpis_orden"

' Alarma Item
Public Const csTAlarmaItem                            As String = "AlarmaItem"
Public Const cscAliId                                 As String = "ali_id"
Public Const cscAliNombre                             As String = "ali_nombre"
Public Const cscAliTiempo                             As String = "ali_tiempo"
Public Const cscAliTiempotipo                         As String = "ali_tiempotipo"
Public Const cscAliLaboral                            As String = "ali_laboral"
Public Const cscAliTiempodesde                        As String = "ali_tiempodesde"
Public Const cscAliSecuencia                          As String = "ali_secuencia"
Public Const cscAliObligatorioremito                  As String = "ali_obligatorioremito"
Public Const cscAliObligatoriofactura                 As String = "ali_obligatoriofactura"
Public Const cscAliAlarma1                            As String = "ali_alarma1"
Public Const cscAliAlarmatipo1                        As String = "ali_alarmatipo1"
Public Const cscAliAlarma2                            As String = "ali_alarma2"
Public Const cscAliAlarmatipo2                        As String = "ali_alarmatipo2"

Public Const cscAliTipo                               As String = "ali_tipo"

Public Const cscMailIdInicio                          As String = "mail_id_inicio"
Public Const cscMailIdAlarma1                         As String = "mail_id_alarma1"
Public Const cscMailIdAlarma2                         As String = "mail_id_alarma2"
Public Const cscMailIdFinalizado                      As String = "mail_id_finalizado"
Public Const cscMailIdVencido                         As String = "mail_id_vencido"

' Mail
Public Const csTMail                                  As String = "Mail"
Public Const cscMailId                                As String = "mail_id"
Public Const cscMailNombre                            As String = "mail_nombre"
Public Const cscMailCodigo                            As String = "mail_codigo"
Public Const cscMailDescrip                           As String = "mail_descrip"
Public Const cscMailEmailTo                           As String = "mail_emailTo"
Public Const cscMailEmailCc                           As String = "mail_emailCc"
Public Const cscMailTipo                              As String = "mail_tipo"

' Mail Item
Public Const csTMailItem                              As String = "MailItem"
Public Const cscMailiId                               As String = "maili_id"
Public Const cscMailiEmail                            As String = "maili_email"
Public Const cscMailiTiempo                           As String = "maili_tiempo"
Public Const cscMailiTiempotipo                       As String = "maili_tiempotipo"

' Tipo de Alarma Item
Public Const csTAlarmaItemTipo                         As String = "AlarmaItemTipo"
Public Const cscAlitId                                 As String = "alit_id"
Public Const cscAlitNombre                             As String = "alit_nombre"
Public Const cscAlitCodigo                             As String = "alit_codigo"
Public Const cscAlitDescrip                            As String = "alit_descrip"

' Departamento
Public Const cscDptoNombre                             As String = "dpto_nombre"
Public Const cscDptoId                                 As String = "dpto_id"

' Zona
Public Const cscZonId                                  As String = "zon_id"
Public Const cscZonNombre                              As String = "zon_nombre"

' Tipo de Falla
Public Const csTEquipoTipoFalla                        As String = "EquipoTipoFalla"
Public Const cscEtfId                                  As String = "etf_id"
Public Const cscEtfNombre                              As String = "etf_nombre"
Public Const cscEtfCodigo                              As String = "etf_codigo"
Public Const cscEtfDescrip                             As String = "etf_descrip"

' Detalle de Equipo
Public Const csTEquipoDetalle                         As String = "EquipoDetalle"
Public Const cscEdId                                  As String = "ed_id"
Public Const cscEdNombre                              As String = "ed_nombre"
Public Const cscEdCodigo                              As String = "ed_codigo"
Public Const cscEdDescrip                             As String = "ed_descrip"

' Detalle de Equipo Item
Public Const csTEquipoDetalleItem                     As String = "EquipoDetalleItem"
Public Const cscEdiId                                 As String = "edi_id"
Public Const cscEdiNombre                             As String = "edi_nombre"
Public Const cscEdiOrden                              As String = "edi_orden"
Public Const cscEdiTipo                               As String = "edi_tipo"
Public Const cscEdiSqlstmt                            As String = "edi_sqlstmt"
Public Const cscEdiDefault                            As String = "edi_default"

' Tabla
Public Const cscTblId                                 As String = "tbl_id"
Public Const cscTblNombre                             As String = "tbl_nombre"

' Orden Servicio Serie (Detalle de Equipo)
Public Const csTOrdenServicioSerie                    As String = "OrdenServicioSerie"
Public Const cscOssId                                 As String = "oss_id"
Public Const cscOssValor                              As String = "oss_valor"

' Orden Servicio Serie (Detalle de Equipo)
Public Const csTOrdenServicioSerieTMP                 As String = "OrdenServicioSerieTMP"
Public Const cscOssTMPId                              As String = "ossTMP_id"

' Proveedor
Public Const csTProveedor                             As String = "Proveedor"
Public Const cscProvId                                As String = "prov_id"
Public Const cscProvNombre                            As String = "prov_nombre"

' Transporte
Public Const csTTransporte                            As String = "Transporte"
Public Const cscTransId                               As String = "trans_id"
Public Const cscTransNombre                           As String = "trans_nombre"

' ParteDiario
Public Const csTParteDiario                           As String = "ParteDiario"
Public Const cscPtdId                                 As String = "ptd_id"
Public Const cscPtdNumero                             As String = "ptd_numero"
Public Const cscPtdTitulo                             As String = "ptd_titulo"
Public Const cscPtdDescrip                            As String = "ptd_descrip"

' Stock Proveedor
Public Const csTStockProveedor                           As String = "StockProveedor"
Public Const cscStProvId                                 As String = "stprov_id"
Public Const cscStProvNumero                             As String = "stprov_numero"
Public Const cscStProvNrodoc                             As String = "stprov_nrodoc"
Public Const cscStProvDescrip                            As String = "stprov_descrip"
Public Const cscStProvFecha                              As String = "stprov_fecha"

