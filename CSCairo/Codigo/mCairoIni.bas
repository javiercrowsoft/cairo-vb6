Attribute VB_Name = "mCairoIni"
Option Explicit

'--------------------------------------------------------------------------------
' mCairoIni
' 25-10-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
    Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mCairoIni"

#If PREPROC_QBPOINT Then
  
  Public Const c_MainIniFile = "Cairo.ini"      ' Por ahora el ini sigue siendo cairo.ini
  Public Const c_K_MainIniConfig = "CONFIG"

#Else
  
  Public Const c_MainIniFile = "Cairo.ini"
  Public Const c_K_MainIniConfig = "CONFIG"

#End If

Public Const c_DESKTOP_KEY = "DESKTOP-CONFIG"
Public Const c_DESKTOP_PathInicio_RPT = "DESKTOP_PATH_INICIO_RPT"

Public Const c_RPT_KEY = "RPT-CONFIG"
Public Const c_RPT_PathReportes = "RPT_PATH_REPORTES"
Public Const c_RPT_CommandTimeOut = "RPT_COMMAND_TIMEOUT"
Public Const c_RPT_ConnectionTimeOut = "RPT_CONNECTION_TIMEOUT"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
'//////////////////////////////////////////////////////////////////////////////
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next





