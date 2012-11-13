Attribute VB_Name = "mConstantes2"
Option Explicit
'--------------------------------------------------------------------------------
' mConstantes
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
Private Const C_Module = "mConstantes"

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

' Proveedor
Public Const cscProvImprimeTicket                      As String = "prov_imprimeticket"
