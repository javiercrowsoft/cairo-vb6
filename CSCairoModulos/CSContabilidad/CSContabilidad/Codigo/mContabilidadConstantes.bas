Attribute VB_Name = "mContabilidadConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mContabilidadConstantes
' 28-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mContabilidadConstantes"

' Rama
Public Const cscRamNombre                       As String = "ram_nombre"


'Asiento
Public Const csTAsiento                         As String = "Asiento"
Public Const cscAsId                            As String = "as_id"
Public Const cscAsNumero                        As String = "as_numero"
Public Const cscAsNrodoc                        As String = "as_nrodoc"
Public Const cscAsDescrip                       As String = "as_descrip"
Public Const cscAsFecha                         As String = "as_fecha"
Public Const cscAsDocCliente                    As String = "as_doc_cliente"
Public Const cscIdCliente                       As String = "id_cliente"
Public Const cscDoctIdCliente                   As String = "doct_id_cliente"

'AsientoItem
Public Const csTAsientoItem                           As String = "AsientoItem"
Public Const cscAsiId                                 As String = "asi_id"
Public Const cscAsiOrden                              As String = "asi_orden"
Public Const cscAsiDescrip                            As String = "asi_descrip"
Public Const cscAsiDebe                               As String = "asi_debe"
Public Const cscAsiHaber                              As String = "asi_haber"
Public Const cscAsiOrigen                             As String = "asi_origen"

'AsientoItemTMP
Public Const csTAsientoItemTMP                        As String = "AsientoItemTMP"
Public Const cscAsiTMPId                              As String = "asiTMP_id"

' Cliente
Public Const csTCliente                               As String = "Cliente"
Public Const cscCliId                                 As String = "cli_id"
Public Const cscCliNombre                             As String = "cli_nombre"

'AsientoTMP
Public Const csTAsientoTMP                      As String = "AsientoTMP"
Public Const cscAsTMPId                         As String = "asTMP_id"

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Tipos de Documento
Public Const cscDoctId                                 As String = "doct_id"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"

'Producto
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombrecompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreventa                        As String = "pr_Nombreventa"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

'AsientoItemBorradoTMP
Public Const csTAsientoItemBorradoTMP           As String = "AsientoItemBorradoTMP"
Public Const cscAsibTMPId                       As String = "asibTMP_id"

' TasaImpositiva
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"

' Talonario
Public Const cscTaId                            As String = "ta_id"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Cuenta
Public Const csTCuenta                                As String = "Cuenta"
Public Const cscCueNombre                             As String = "cue_nombre"
Public Const cscCueId                                 As String = "cue_id"

' Ejercicio
Public Const csTEjercicioContable                     As String = "EjercicioContable"
Public Const cscEjcId                                 As String = "ejc_id"
Public Const cscEjcNombre                             As String = "ejc_nombre"
Public Const cscEjcCodigo                             As String = "ejc_codigo"
Public Const cscEjcFechaIni                           As String = "ejc_fechaini"
Public Const cscEjcFechaFin                           As String = "ejc_fechafin"
Public Const cscEjcDescrip                            As String = "ejc_descrip"
Public Const cscEjcAbierto                            As String = "ejc_abierto"
Public Const cscAsIdApertura                          As String = "as_id_apertura"
Public Const cscAsIdCierrePatrimonial                 As String = "as_id_cierrepatrimonial"
Public Const cscAsIdCierreResultados                  As String = "as_id_cierreresultados"
Public Const cscCueIdResultado                        As String = "cue_id_resultado"

' Circuitos Contables
Public Const cscCicoId                                As String = "cico_id"
Public Const cscCicoNombre                            As String = "cico_nombre"
