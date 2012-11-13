Attribute VB_Name = "mConstantesAfip"
Option Explicit
'--------------------------------------------------------------------------------
' mConstantesAfip
' 29-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mConstantesAfip"

Public Const C_Macro_FechaDesde     As String = "@@@FechaDesde"
Public Const C_Macro_FechaHasta     As String = "@@@FechaHasta"
Public Const C_Macro_Path           As String = "@@@Path"

Public Const C_Param_FechaDesde    As String = "fecha desde"
Public Const C_Param_FechaHasta    As String = "fecha hasta"
Public Const C_Param_StrConnect    As String = "string de conexión"
Public Const C_Param_Path          As String = "PathDBFStrad"
Public Const C_Param_FolderOut     As String = "Carpeta"

Public Const c_ErrorClientOpenDB = vbObjectError + 1500
Public Const c_ErrorCodigoDocStrad = vbObjectError + 1501
Public Const c_ErrorCondicionIvaStrad = vbObjectError + 1502

Public Const C_ID = "COL___ID"

Public Const c_img_task = 1

' Proveedor
Public Const cscProvImprimeTicket                      As String = "prov_imprimeticket"

' Proveedores CAI
Public Const csTProveedorCAI                            As String = "ProveedorCAI"
Public Const cscProvcId                                 As String = "provc_id"
Public Const cscProvcNumero                             As String = "provc_numero"
Public Const cscProvcDescrip                            As String = "provc_descrip"
Public Const cscProvcFechavto                           As String = "provc_fechavto"
Public Const cscProvcSucursal                           As String = "provc_sucursal"

