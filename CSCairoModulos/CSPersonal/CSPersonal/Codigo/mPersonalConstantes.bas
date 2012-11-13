Attribute VB_Name = "mPersonalConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mPersonalConstantes
' 18-08-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPersonalConstantes"

Public Enum csMenuEnum
  csMenuConfig = 2999
  csMenuPersonalMain = 35999
End Enum

Public Const c_Items = "Items"

Public Const c_ErrorInRtn = vbObjectError + 10001

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' Sindicato
Public Const csTSindicato                              As String = "Sindicato"
Public Const cscSindId                                 As String = "Sind_id"
Public Const cscSindNombre                             As String = "Sind_nombre"
Public Const cscSindCodigo                             As String = "Sind_codigo"
Public Const cscSindDescrip                            As String = "Sind_descrip"

' Sindicato Categoria
Public Const csTSindicatoCategoria                       As String = "SindicatoCategoria"
Public Const cscSindcaId                                 As String = "sindca_id"
Public Const cscSindcaNombre                             As String = "sindca_nombre"
Public Const cscSindcaCodigo                             As String = "sindca_codigo"
Public Const cscSindcaDescrip                            As String = "sindca_descrip"

' Sindicato Convenio
Public Const csTSindicatoConvenio                        As String = "SindicatoConvenio"
Public Const cscSindcoId                                 As String = "sindco_id"
Public Const cscSindcoNombre                             As String = "sindco_nombre"
Public Const cscSindcoCodigo                             As String = "sindco_codigo"
Public Const cscSindcoDescrip                            As String = "sindco_descrip"

' Sindicato Convenio Categoria
Public Const csTSindicatoConvenioCategoria               As String = "SindicatoConvenioCategoria"
Public Const cscSindccId                                 As String = "sindcc_id"
Public Const cscSindccImporte                            As String = "sindcc_importe"
Public Const cscSindccTipo                               As String = "sindcc_tipo"
Public Const cscSindccHoraXmes                           As String = "sindcc_horaXmes"
Public Const cscSindccDiaXmes                            As String = "sindcc_diaXmes"
Public Const cscSindccDesde                              As String = "sindcc_desde"
Public Const cscSindccHasta                              As String = "sindcc_hasta"


' Empleado Especialidad
Public Const csTEmpleadoEspecialidad                  As String = "EmpleadoEspecialidad"
Public Const cscEmeId                                 As String = "eme_id"
Public Const cscEmeNombre                             As String = "eme_nombre"
Public Const cscEmeCodigo                             As String = "eme_codigo"
Public Const cscEmeDescrip                            As String = "eme_descrip"

' Empleado
Public Const csTEmpleado                             As String = "Empleado"
Public Const cscEmId                                 As String = "em_id"
Public Const cscEmApellido                           As String = "em_apellido"
Public Const cscEmNombre                             As String = "em_nombre"
Public Const cscEmCodigo                             As String = "em_codigo"
Public Const cscEmLegajo                             As String = "em_legajo"
Public Const cscEmIngreso                            As String = "em_ingreso"
Public Const cscEmEgreso                             As String = "em_egreso"
Public Const cscEmCuil                               As String = "em_cuil"
Public Const cscEmDni                                As String = "em_dni"
Public Const cscEmFechanacimiento                    As String = "em_fechanacimiento"
Public Const cscEmCodpostal                          As String = "em_codpostal"
Public Const cscEmLocalidad                          As String = "em_localidad"
Public Const cscEmCalle                              As String = "em_calle"
Public Const cscEmCallenumero                        As String = "em_callenumero"
Public Const cscEmPiso                               As String = "em_piso"
Public Const cscEmDepto                              As String = "em_depto"
Public Const cscEmTel                                As String = "em_tel"
Public Const cscEmLibreta                            As String = "em_libreta"
Public Const cscEmTipoLiquidacion                    As String = "em_tipoLiquidacion"
Public Const cscEmCtaBanco                           As String = "em_ctaBanco"
Public Const cscEmFdoDesempleo                       As String = "em_fdoDesempleo"
Public Const cscEmObraSocial                         As String = "em_obraSocial"
Public Const cscEmBanelco                            As String = "em_banelco"
Public Const cscEmPreocupacional                     As String = "em_preocupacional"
Public Const cscEmLugarNacimiento                    As String = "em_lugarNacimiento"
Public Const cscEmDescrip                            As String = "em_descrip"
Public Const cscEmEmail                              As String = "em_email"

' Empleado Familia
Public Const csTEmpleadoFamilia                       As String = "EmpleadoFamilia"
Public Const cscEmfId                                 As String = "emf_id"
Public Const cscEmfNombre                             As String = "emf_nombre"
Public Const cscEmfApellido                           As String = "emf_apellido"
Public Const cscEmfDni                                As String = "emf_dni"
Public Const cscEmfFechanacimiento                    As String = "emf_fechanacimiento"
Public Const cscEmfDescrip                            As String = "emf_descrip"

' Empleado ART
Public Const csTEmpleadoART                           As String = "EmpleadoART"
Public Const cscEmaId                                 As String = "ema_id"
Public Const cscEmaNombre                             As String = "ema_nombre"
Public Const cscEmaCodigo                             As String = "ema_codigo"
Public Const cscEmaDescrip                            As String = "ema_descrip"

' Estado Civil
Public Const cscEstcId                                As String = "estc_id"
Public Const cscEstcNombre                            As String = "estc_nombre"

' Provincia
Public Const cscProId                           As String = "pro_id"
Public Const cscProNombre                       As String = "pro_nombre"

' Pais
Public Const cscPaId                            As String = "pa_id"
Public Const cscPaNombre                        As String = "pa_nombre"

' Liquidacion Plantilla
Public Const csTLiquidacionPlantilla                   As String = "LiquidacionPlantilla"
Public Const cscLiqpId                                 As String = "liqp_id"
Public Const cscLiqpNombre                             As String = "liqp_nombre"
Public Const cscLiqpCodigo                             As String = "liqp_codigo"
Public Const cscLiqpDescrip                            As String = "liqp_descrip"

' Liquidacion Plantilla Item
Public Const csTLiquidacionPlantillaItem                As String = "LiquidacionPlantillaItem"
Public Const cscLiqpiId                                 As String = "liqpi_id"

' Liquidacion Formula
Public Const csTLiquidacionFormula                     As String = "LiquidacionFormula"
Public Const cscLiqf                                   As String = "liqf_id"
Public Const cscLiqfId                                 As String = "liqf_id"
Public Const cscLiqfNombre                             As String = "liqf_nombre"
Public Const cscLiqfCodigo                             As String = "liqf_codigo"
Public Const cscLiqfDescrip                            As String = "liqf_descrip"
Public Const cscLiqfFormula                            As String = "liqf_formula"

' Liquidacion Formula Item
Public Const csTLiquidacionFormulaItem                  As String = "LiquidacionFormulaItem"
Public Const cscLiqfiId                                 As String = "liqfi_id"
Public Const cscLiqfiNombre                             As String = "liqfi_nombre"
Public Const cscLiqfiCodigo                             As String = "liqfi_codigo"
Public Const cscLiqfiDescrip                            As String = "liqfi_descrip"
Public Const cscLiqfiNombrerecibo                       As String = "liqfi_nombrerecibo"
Public Const cscLiqfiFormula                            As String = "liqfi_formula"

' Periodo de Presentismo y Asistencia
Public Const csTEmpleadoPeriodo                        As String = "EmpleadoPeriodo"
Public Const cscEmpeId                                 As String = "empe_id"
Public Const cscEmpeNumero                             As String = "empe_numero"
Public Const cscEmpeFecha                              As String = "empe_fecha"
Public Const cscEmpeDesde                              As String = "empe_desde"
Public Const cscEmpeHasta                              As String = "empe_hasta"
Public Const cscEmpeTipo                               As String = "empe_tipo"
Public Const cscEmpeDescrip                            As String = "empe_descrip"

' Centro de Costo
Public Const csTCentroCosto                            As String = "CentroCosto"
Public Const cscCcosId                                 As String = "ccos_id"
Public Const cscCcosNombre                             As String = "ccos_nombre"
Public Const cscCcosCodigo                             As String = "ccos_codigo"
Public Const cscCcosIdPadre                            As String = "ccos_id_padre"
Public Const cscCcosNombrePadre                        As String = "ccos_nombre_padre"
Public Const cscCcosCodigoPadre                        As String = "ccos_codigo_padre"

' Empleado Horas
Public Const csTEmpleadoHoras                         As String = "EmpleadoHoras"
Public Const cscEmhId                                 As String = "emh_id"
Public Const cscEmhFecha                              As String = "emh_fecha"
Public Const cscEmhHoras                              As String = "emh_horas"
Public Const cscEmhDesde                              As String = "emh_desde"
Public Const cscEmhHasta                              As String = "emh_hasta"

' Empleado Semana
Public Const csTEmpleadoSemana                        As String = "EmpleadoSemana"
Public Const cscEmsId                                 As String = "ems_id"
Public Const cscEmsFecha                              As String = "ems_fecha"
Public Const cscEmsHoras                              As String = "ems_horas"
Public Const cscEmsDesde                              As String = "ems_desde"
Public Const cscEmsHasta                              As String = "ems_hasta"

' EmpleadoAsistenciaTipo
Public Const csTEmpleadoAsistenciaTipo                 As String = "EmpleadoAsistenciaTipo"
Public Const cscEastId                                 As String = "east_id"
Public Const cscEastNombre                             As String = "east_nombre"
Public Const cscEastCodigo                             As String = "east_codigo"
Public Const cscEastDescrip                            As String = "east_descrip"

' Empleado CentroCosto
Public Const csTEmpleadoCentroCosto                   As String = "EmpleadoCentroCosto"
Public Const cscEmCcosId                              As String = "emccos_id"
Public Const cscEmCcosDesde                           As String = "emccos_desde"
Public Const cscEmCcosHasta                           As String = "emccos_hasta"

' Liquidacion
Public Const csTLiquidacion                           As String = "Liquidacion"
Public Const cscLiq                                   As String = "liq_id"
Public Const cscLiqId                                 As String = "liq_id"
Public Const cscLiqNumero                             As String = "liq_numero"
Public Const cscLiqNrodoc                             As String = "liq_nrodoc"
Public Const cscLiqDescrip                            As String = "liq_descrip"
Public Const cscLiqFecha                              As String = "liq_fecha"
Public Const cscLiqFechaDesde                         As String = "liq_fechaDesde"
Public Const cscLiqFechaHasta                         As String = "liq_fechaHasta"
Public Const cscLiqPeriodo                            As String = "liq_periodo"
Public Const cscLiqNeto                               As String = "liq_neto"
Public Const cscLiqImpuesto                           As String = "liq_impuesto"
Public Const cscLiqTotal                              As String = "liq_total"
Public Const cscLiqTotalorigen                        As String = "liq_totalorigen"
Public Const cscLiqFirmado                            As String = "liq_firmado"
Public Const cscLiqGrabarasiento                      As String = "liq_grabarasiento"
Public Const cscLiqCotizacion                         As String = "liq_cotizacion"

' Liquidacion Item
Public Const csTLiquidacionItem                        As String = "LiquidacionItem"
Public Const cscLiqiId                                 As String = "liqi_id"
Public Const cscLiqiImporte                            As String = "liqi_importe"
Public Const cscLiqiOrden                              As String = "liqi_orden"
Public Const cscLiqiImporteOrigen                      As String = "liqi_importeorigen"
Public Const cscLiqiImpuesto                           As String = "liqi_impuesto"
Public Const cscLiqiDescrip                            As String = "liqi_descrip"
Public Const cscLiqiNroDoc                             As String = "liqi_nrodoc"

' Liquidacion TMP
Public Const csTLiquidacionTMP                        As String = "LiquidacionTMP"
Public Const cscLiqTMPId                              As String = "liqTMP_id"

' Liquidacion Item TMP
Public Const csTLiquidacionItemTMP                    As String = "LiquidacionItemTMP"
Public Const cscLiqiTMPId                             As String = "liqiTMP_id"

' Liquidacion Item Borrado TMP
Public Const csTLiquidacionItemBorradoTMP             As String = "LiquidacionItemBorradoTMP"
Public Const cscLiqibTMPId                            As String = "liqibTMP_id"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_Id"
Public Const cscLgjTitulo                             As String = "lgj_Titulo"
Public Const cscLgjCodigo                             As String = "lgj_Codigo"

' Monedas
Public Const csTMoneda                           As String = "Moneda"
Public Const cscMonId                            As String = "mon_id"
Public Const cscMonNombre                        As String = "mon_nombre"

' Asiento
Public Const cscAsId                                  As String = "as_id"

' Liquidacion Excepcion
Public Const csTLiquidacionExcepcion                  As String = "LiquidacionExcepcion"
Public Const cscLiqeId                                As String = "liqe_id"
Public Const cscLiqeDescrip                           As String = "liqe_descrip"
Public Const cscLiqeOrden                             As String = "liqe_orden"

' Liquidacion ConceptoAdm
Public Const csTLiquidacionConceptoAdm                As String = "LiquidacionConceptoAdm"
Public Const cscLiqcaId                               As String = "liqca_id"
Public Const cscLiqcaImporte                          As String = "liqca_importe"
Public Const cscLiqcaDescrip                          As String = "liqca_descrip"
Public Const cscLiqcaOrden                            As String = "liqca_orden"

' Liquidacion Excepcion Borrado TMP
Public Const csTLiquidacionExcepcionBorradoTMP        As String = "LiquidacionExcepcionBorradoTMP"
Public Const cscLiqebTMPId                            As String = "liqebTMP_id"

' Liquidacion Excepcion TMP
Public Const csTLiquidacionExcepcionTMP               As String = "LiquidacionExcepcionTMP"
Public Const cscLiqeTMPId                             As String = "liqeTMP_id"

' Liquidacion ConceptoAdm Borrado TMP
Public Const csTLiquidacionConceptoAdmBorradoTMP      As String = "LiquidacionConceptoAdmBorradoTMP"
Public Const cscLiqcabTMPId                           As String = "liqcabTMP_id"

' Liquidacion ConceptoAdm TMP
Public Const csTLiquidacionConceptoAdmTMP             As String = "LiquidacionConceptoAdmTMP"
Public Const cscLiqcaTMPId                            As String = "liqcaTMP_id"

' Liquidacion Item Codigo TMP
Public Const csTLiquidacionItemCodigoTMP              As String = "LiquidacionItemCodigoTMP"
Public Const cscLiqcTMPId                             As String = "liqcTMP_id"

' EmpleadoFamiliaTipo
Public Const csTEmpleadoFamiliaTipo                   As String = "EmpleadoFamiliaTipo"
Public Const cscEmftId                                As String = "emft_id"
Public Const cscEmftCodigo                            As String = "emft_codigo"
Public Const cscEmftNombre                            As String = "emft_nombre"

' Circuito Contable
Public Const cscCicoId                                As String = "cico_id"
Public Const cscCicoNombre                            As String = "cico_nombre"

'LiquidacionCodigoTipo
Public Const csTLiquidacionCodigoTipo                 As String = "LiquidacionCodigoTipo"
Public Const cscLiqctId                               As String = "Liqct_id"
Public Const cscLiqctNombre                           As String = "Liqct_nombre"
Public Const cscLiqctCodigo                           As String = "Liqct_codigo"
Public Const cscLiqctDescrip                          As String = "Liqct_descrip"
