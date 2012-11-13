Attribute VB_Name = "mEnvioConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mEnvioConstantes
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
Private Const C_Module = "mEnvioConstantes"

Public Const c_PTD_AVISO                        As String = "PTD_AVISOS"

' Rama
Public Const cscRamNombre                       As String = "ram_nombre"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"

' Proveedor
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvNombre                             As String = "prov_nombre"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjTitulo                             As String = "lgj_Titulo"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"
Public Const cscLgjDescrip                            As String = "lgj_Descrip"
Public Const cscLgjFecha                              As String = "lgj_Fecha"
Public Const cscLgjAta                                As String = "lgj_ata"
Public Const cscLgjHawbbl                             As String = "lgj_hawbbl"
Public Const cscLgjEtd                                As String = "lgj_etd"
Public Const cscLgjEta                                As String = "lgj_eta"
Public Const cscLgjMawbbl                             As String = "lgj_mawbbl"
Public Const cscLgjFob                                As String = "lgj_fob"
Public Const cscLgjGiro                               As String = "lgj_giro"
Public Const cscLgjFlete                              As String = "lgj_flete"

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
Public Const cscPtdPrivado                            As String = "ptd_privado"

' Usuario
Public Const cscusidResponsable                       As String = "us_id_responsable"
Public Const cscusidAsignador                         As String = "us_id_asignador"

' Contacto
Public Const csTContacto                               As String = "Contacto"
Public Const cscContId                                 As String = "cont_id"
Public Const cscContNombre                             As String = "cont_nombre"

' Tarea Estados
Public Const csTTareaEstado                             As String = "TareaEstado"
Public Const cscTarestId                                As String = "tarest_id"
Public Const cscTarestNombre                            As String = "tarest_nombre"

' Prioridad
Public Const csTPrioridad                              As String = "Prioridad"
Public Const cscPrioId                                 As String = "prio_id"
Public Const cscPrioNombre                             As String = "prio_nombre"

' Talonario
Public Const csTTalonario                            As String = "Talonario"
Public Const cscTaId                                 As String = "ta_id"
Public Const cscTaNombre                             As String = "ta_nombre"

' TipoTransporte
Public Const csTTipoTransporte                        As String = "TipoTransporte"
Public Const cscTtransId                              As String = "ttrans_id"
Public Const cscTtransNombre                          As String = "ttrans_nombre"
Public Const cscTtransCodigo                          As String = "ttrans_codigo"
Public Const cscTtransDescrip                         As String = "ttrans_descrip"

' Tarifa
Public Const csTTarifa                                As String = "Tarifa"
Public Const cscTrfId                                 As String = "trf_id"
Public Const cscTrfNombre                             As String = "trf_nombre"
Public Const cscTrfCodigo                             As String = "trf_codigo"
Public Const cscTrfFechaDesde                         As String = "trf_fechaDesde"
Public Const cscTrfFechaHasta                         As String = "trf_fechaHasta"
Public Const cscTrfDescrip                            As String = "trf_descrip"
Public Const cscTrfTipo                               As String = "trf_tipo"

' TarifaItem
Public Const csTTarifaItem                             As String = "TarifaItem"
Public Const cscTrfiId                                 As String = "trfi_id"
Public Const cscTrfiMinimo                             As String = "trfi_minimo"
Public Const cscTrfiMenos45                            As String = "trfi_menos45"
Public Const cscTrfiMas45                              As String = "trfi_mas45"
Public Const cscTrfiMas100                             As String = "trfi_mas100"
Public Const cscTrfiMas300                             As String = "trfi_mas300"
Public Const cscTrfiMas500                             As String = "trfi_mas500"
Public Const cscTrfiMas1000                            As String = "trfi_mas1000"
Public Const cscTrfiLunes                              As String = "trfi_lunes"
Public Const cscTrfiMartes                             As String = "trfi_martes"
Public Const cscTrfiMiercoles                          As String = "trfi_miercoles"
Public Const cscTrfiJueves                             As String = "trfi_jueves"
Public Const cscTrfiViernes                            As String = "trfi_viernes"
Public Const cscTrfiSabado                             As String = "trfi_sabado"
Public Const cscTrfiDomingo                            As String = "trfi_domingo"

' Transporte
Public Const cscTransId                               As String = "trans_id"
Public Const cscTransNombre                           As String = "trans_nombre"

'LegajoTipo
Public Const csTLegajoTipo                            As String = "LegajoTipo"
Public Const cscLgjtId                                As String = "lgjt_id"
Public Const cscLgjtNombre                            As String = "lgjt_nombre"
Public Const cscLgjtCodigo                            As String = "lgjt_codigo"
Public Const cscLgjtDescrip                           As String = "lgjt_descrip"

' Monedas
Public Const csTMoneda                           As String = "Moneda"
Public Const cscMonId                            As String = "mon_id"
Public Const cscMonNombre                        As String = "mon_nombre"

'Barco
Public Const csTBarco                                  As String = "Barco"
Public Const cscBarcId                                 As String = "barc_id"
Public Const cscBarcNombre                             As String = "barc_nombre"

'Puerto
Public Const csTPuerto                                As String = "Puerto"
Public Const cscPueId                                 As String = "pue_id"
Public Const cscPueNombre                             As String = "pue_nombre"
Public Const cscPueCodigo                             As String = "pue_codigo"
Public Const cscPueIdDestino                          As String = "pue_id_destino"
Public Const cscPueIdOrigen                           As String = "pue_id_origen"

' Vuelo
Public Const csTVuelo                                 As String = "Vuelo"
Public Const cscVueId                                 As String = "vue_id"
Public Const cscVueNombre                             As String = "vue_nombre"
Public Const cscVueCodigo                             As String = "vue_codigo"
Public Const cscVueDescrip                            As String = "vue_descrip"

' Tarifa Gasto
Public Const csTTarifaGasto                            As String = "TarifaGasto"
Public Const csctrfgId                                 As String = "trfg_id"
Public Const csctrfgFijo                               As String = "trfg_fijo"
Public Const csctrfgMinimo                             As String = "trfg_minimo"
Public Const csctrfgImporte                            As String = "trfg_importe"

' Gasto
Public Const csTGasto                                 As String = "Gasto"
Public Const cscGtoId                                 As String = "gto_id"
Public Const cscGtoNombre                             As String = "gto_nombre"

' Presupuesto TMP
Public Const csTPresupuestoEnvioTMP                   As String = "PresupuestoEnvioTMP"
Public Const cscPreeTMPId                             As String = "preeTMP_id"


' Presupuesto
Public Const csTPresupuestoEnvio                       As String = "PresupuestoEnvio"
Public Const cscPreeId                                 As String = "pree_id"
Public Const cscPreeNumero                             As String = "pree_numero"
Public Const cscPreeNrodoc                             As String = "pree_nrodoc"
Public Const cscPreeDescrip                            As String = "pree_descrip"
Public Const cscPreeFecha                              As String = "pree_fecha"
Public Const cscPreeFechaentrega                       As String = "pree_fechaentrega"
Public Const cscPreeNeto                               As String = "pree_neto"
Public Const cscPreeIvari                              As String = "pree_ivari"
Public Const cscPreeIvarni                             As String = "pree_ivarni"
Public Const cscPreeSubtotal                           As String = "pree_subtotal"
Public Const cscPreeTotal                              As String = "pree_total"
Public Const cscPreePendiente                          As String = "pree_pendiente"
Public Const cscPreeFirmado                            As String = "pree_firmado"
Public Const cscPreeDescuento1                         As String = "pree_descuento1"
Public Const cscPreeDescuento2                         As String = "pree_descuento2"
Public Const cscPreeImportedesc1                       As String = "pree_importedesc1"
Public Const cscPreeImportedesc2                       As String = "pree_importedesc2"

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Vendedor
Public Const csTVendedor                         As String = "Vendedor"
Public Const cscVenId                            As String = "ven_id"
Public Const cscVenNombre                        As String = "ven_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"

' Presupuesto Item Borrado TMP
Public Const csTPresupuestoEnvioItemBorradoTMP          As String = "PresupuestoEnvioItemBorradoTMP"
Public Const cscPreeibTMPId                             As String = "preeibTMP_id"

' Presupuesto Item TMP
Public Const csTPresupuestoEnvioItemTMP                 As String = "PresupuestoEnvioItemTMP"
Public Const cscPreeiTMPId                              As String = "preeiTMP_id"

' Presupuesto Item
Public Const csTPresupuestoEnvioItem                    As String = "PresupuestoEnvioItem"
Public Const cscPreeiId                                 As String = "preei_id"
Public Const cscPreeiOrden                              As String = "preei_orden"
Public Const cscPreeiCantidad                           As String = "preei_cantidad"
Public Const cscPreeiVolumen                            As String = "preei_volumen"
Public Const cscPreeiKilos                              As String = "preei_kilos"
Public Const cscPreeiMinimo                             As String = "preei_minimo"
Public Const cscPreeiPendiente                          As String = "preei_pendiente"
Public Const cscPreeiDescrip                            As String = "preei_descrip"
Public Const cscPreeiPrecio                             As String = "preei_precio"
Public Const cscPreeiPrecioTarifa                       As String = "preei_precioTarifa"
Public Const cscPreeiNeto                               As String = "preei_neto"
Public Const cscPreeiIvari                              As String = "preei_ivari"
Public Const cscPreeiIvarni                             As String = "preei_ivarni"
Public Const cscPreeiIvariporc                          As String = "preei_ivariporc"
Public Const cscPreeiIvarniporc                         As String = "preei_ivarniporc"
Public Const cscPreeiImporte                            As String = "preei_importe"

' Presupuesto Gasto TMP
Public Const csTPresupuestoEnvioGastoTMP                As String = "PresupuestoEnvioGastoTMP"
Public Const cscpreegTMPId                              As String = "preegTMP_id"

' Presupuesto Gasto Borrado TMP
Public Const csTPresupuestoEnvioGastoBorradoTMP         As String = "PresupuestoEnvioGastoBorradoTMP"
Public Const cscpreegbTMPId                             As String = "preegbTMP_id"

' Presupuesto Gasto
Public Const csTPresupuestoEnvioGasto                   As String = "PresupuestoEnvioGasto"
Public Const cscpreegId                                 As String = "preeg_id"
Public Const cscpreegOrden                              As String = "preeg_orden"
Public Const cscpreegCantidad                           As String = "preeg_cantidad"
Public Const cscpreegPendiente                          As String = "preeg_pendiente"
Public Const cscpreegDescrip                            As String = "preeg_descrip"
Public Const cscpreegPrecio                             As String = "preeg_precio"
Public Const cscpreegPrecioTarifa                       As String = "preeg_precioTarifa"
Public Const cscpreegNeto                               As String = "preeg_neto"
Public Const cscpreegIvari                              As String = "preeg_ivari"
Public Const cscpreegIvarni                             As String = "preeg_ivarni"
Public Const cscpreegIvariporc                          As String = "preeg_ivariporc"
Public Const cscpreegIvarniporc                         As String = "preeg_ivarniporc"
Public Const cscpreegImporte                            As String = "preeg_importe"

'Producto
Public Const csTProducto                             As String = "Producto"
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombrecompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreventa                        As String = "pr_Nombreventa"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

' Lista de Precios
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

' Lista de Descuentos
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' Iva
Public Const cscbIvaRi                                As String = "bIvaRi"
Public Const cscbIvaRni                               As String = "bIvaRni"

Public Const csPrioridad = 2003
Public Const csContacto = 2001
Public Const csTareaEstado = 2004

Public Const csBarco = 12004
Public Const csPuerto = 12005

' Alumno
Public Const cscAlumId                          As String = "alum_id"
Public Const cscAlumNombre                      As String = "alum_nombre"
