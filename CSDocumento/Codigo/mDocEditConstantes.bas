Attribute VB_Name = "mDocEditConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mDocEditConstantes
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

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscDocCodigo                             As String = "doc_codigo"
Public Const cscDocDescrip                            As String = "doc_descrip"
Public Const cscDocLlevaFirma                         As String = "doc_llevaFirma"
Public Const cscDocLlevaFirmaCredito                  As String = "doc_llevaFirmaCredito"
Public Const cscDocIdAsiento                          As String = "doc_id_asiento"
Public Const cscDocRvDesdePv                          As String = "doc_rv_desde_pv"
Public Const cscDocRvDesdeOs                          As String = "doc_rv_desde_os"
Public Const cscDocPvDesdePrv                         As String = "doc_pv_desde_prv"
Public Const cscDocTipoFactura                        As String = "doc_tipofactura"
Public Const cscDocTipoPackingList                    As String = "doc_tipopackinglist"
Public Const cscDocTipoOrdenCompra                    As String = "doc_tipoordencompra"
Public Const cscDocIdRemito                           As String = "doc_id_remito"
Public Const cscDocIdStock                            As String = "doc_id_stock"
Public Const cscDocGeneraRemito                       As String = "doc_generaremito"
Public Const cscDocMueveStock                         As String = "doc_muevestock"
Public Const cscDocRcDesdeOc                          As String = "doc_rc_desde_oc"
Public Const cscDocRvBom                              As String = "doc_rv_bom"
Public Const cscDocRcDespachoImpo                     As String = "doc_rc_despachoimpo"
Public Const cscDocFvSinPercepcion                    As String = "doc_fv_sinpercepcion"
Public Const cscDocStConsumo                          As String = "doc_st_consumo"
Public Const cscDocEditarImpresos                     As String = "doc_editarimpresos"
Public Const cscDocLlevaFirmaPrint0                   As String = "doc_llevaFirmaPrint0"
Public Const cscDocesFacturaElectronica               As String = "doc_esFacturaElectronica"

Public Const cscDocEsResumenBco                       As String = "doc_esresumenbco"
Public Const cscDocEsCreditobanco                     As String = "doc_escreditobanco"
Public Const cscDocEsVentaAccion                      As String = "doc_esventaaccion"
Public Const cscDocEsVentaCheque                      As String = "doc_esventacheque"
Public Const cscDocEsCobChequeSgr                     As String = "doc_escobchequesgr"
Public Const cscDocEsCobCaidaSgr                      As String = "doc_escobcaidasgr"

Public Const cscDocObjectEdit                         As String = "doc_object_edit"

' CicuitoContable
Public Const csTCircuitoContable                      As String = "CircuitoContable"
Public Const cscCicoId                                As String = "cico_id"
Public Const cscCicoNombre                            As String = "cico_nombre"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"
Public Const cscDoctCodigo                             As String = "doct_codigo"
Public Const cscDoctGrupo                              As String = "doct_grupo"

' fecha Control de Acceso
Public Const csTfechaControlAcceso                  As String = "FechaControlAcceso"
Public Const cscFcaId                               As String = "fca_id"
Public Const cscFcaNombre                           As String = "fca_nombre"
Public Const cscFcaCodigo                           As String = "fca_codigo"
Public Const cscFcaFechaHasta                       As String = "fca_Fechahasta"
Public Const cscFcaFechaDesde                       As String = "fca_Fechadesde"

' DocumentoFirma
Public Const csTDocumentoFirma                        As String = "DocumentoFirma"
Public Const cscdocfrId                               As String = "docfr_id"

' Moneda
Public Const cscMonId                                 As String = "mon_id"
Public Const cscMonNombre                             As String = "mon_nombre"

' Talonario
Public Const csTTalonario                            As String = "Talonario"
Public Const cscTaId                                 As String = "ta_id"
Public Const cscTaNombre                             As String = "ta_nombre"
Public Const cscTaCodigo                             As String = "ta_codigo"
Public Const cscTaDescrip                            As String = "ta_descrip"
Public Const cscTaUltimoNro                          As String = "ta_ultimonro"
Public Const cscTaTipo                               As String = "ta_tipo"
Public Const cscTaMascara                            As String = "ta_mascara"
Public Const cscTaCai                                As String = "ta_cai"
Public Const cscTaPtoVta                             As String = "ta_puntovta"
Public Const cscTaTipoAFIP                           As String = "ta_tipoafip"
Public Const cscTaIdFinal                            As String = "ta_id_final"
Public Const cscTaIdInscripto                        As String = "ta_id_inscripto"
Public Const cscTaIdExterno                          As String = "ta_id_externo"
Public Const cscTaIdInscriptoM                       As String = "ta_id_inscriptom"

Public Const cscTaIdHaberes                          As String = "ta_id_haberes"

' Cuenta Grupo
Public Const csTCuentaGrupo                            As String = "CuentaGrupo"
Public Const cscCuegId                                 As String = "cueg_id"
Public Const cscCuegNombre                             As String = "cueg_nombre"

' Documento Impresora
Public Const csTDocumentoImpresora                    As String = "DocumentoImpresora"
Public Const cscDociId                                As String = "doci_id"
Public Const cscDociPC                                As String = "doci_pc"
Public Const cscDociImpresora                         As String = "doci_impresora"
Public Const cscDociBandeja                           As String = "doci_bandeja"
Public Const cscDociPrintByService                    As String = "doci_printbyservice"

' DocumentoGrupo
Public Const csTDocumentoGrupo                    As String = "DocumentoGrupo"
Public Const cscDocgId                            As String = "docg_id"
Public Const cscDocgNombre                        As String = "docg_nombre"
Public Const cscDocgCodigo                        As String = "docg_codigo"
Public Const cscDocgDescrip                       As String = "docg_descrip"

