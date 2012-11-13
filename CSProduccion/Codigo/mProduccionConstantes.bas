Attribute VB_Name = "mProduccionConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mProduccionConstantes
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
Private Const C_Module = "mProduccionConstantes"

'Maquina
Public Const csTMaquina                               As String = "Maquina"
Public Const cscMaqId                                 As String = "maq_id"
Public Const cscMaqNombre                             As String = "maq_nombre"
Public Const cscMaqCodigo                             As String = "maq_codigo"
Public Const cscMaqDescrip                            As String = "maq_descrip"

' ProductoBOM
Public Const csTProductoBOM                           As String = "ProductoBOM"
Public Const cscPbmId                                 As String = "pbm_id"
Public Const cscPbmNombre                             As String = "pbm_nombre"
Public Const cscPbmCodigo                             As String = "pbm_codigo"
Public Const cscPbmDescrip                            As String = "pbm_descrip"
Public Const cscPbmFechaAuto                          As String = "pbm_fechaAuto"
Public Const cscPbmMerma                              As String = "pbm_merma"
Public Const cscPbmVarpos                             As String = "pbm_varpos"
Public Const cscPbmVarneg                             As String = "pbm_varneg"
Public Const cscPbmVartipo                            As String = "pbm_vartipo"
Public Const cscPbmDefault                            As String = "pbm_default"

' ProductoBOMElaborado
Public Const csTProductoBOMElaborado                   As String = "ProductoBOMElaborado"
Public Const cscPbmeId                                 As String = "pbme_id"
Public Const cscPbmeCantidad                           As String = "pbme_cantidad"
Public Const cscPbmeCanttipo                           As String = "pbme_canttipo"
Public Const cscPbmeVarpos                             As String = "pbme_varpos"
Public Const cscPbmeVarneg                             As String = "pbme_varneg"
Public Const cscPbmeVartipo                            As String = "pbme_vartipo"

' Producto
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombreCompra                       As String = "pr_Nombrecompra"

' ProductoBOMItem
Public Const csTProductoBOMItem                        As String = "ProductoBOMItem"
Public Const cscPbmiId                                 As String = "pbmi_id"
Public Const cscPbmiCantidad                           As String = "pbmi_cantidad"
Public Const cscPbmiMerma                              As String = "pbmi_merma"
Public Const cscPbmiVarpos                             As String = "pbmi_varpos"
Public Const cscPbmiVarneg                             As String = "pbmi_varneg"
Public Const cscPbmiVartipo                            As String = "pbmi_vartipo"
Public Const cscPbmiEsBase                             As String = "pbmi_esBase"
Public Const cscPbmiTemp                               As String = "pbmi_temp"
' ProductoBOMItem
Public Const csTProductoBOMItemTipo                    As String = "ProductoBOMItemTipo"
Public Const cscPbmitId                                As String = "pbmit_id"
Public Const cscPbmitNombre                            As String = "pbmit_nombre"

' ProductoBOMItemA
Public Const csTProductoBOMItemA                       As String = "ProductoBOMItemA"
Public Const cscPbmiaId                                As String = "pbmia_id"

