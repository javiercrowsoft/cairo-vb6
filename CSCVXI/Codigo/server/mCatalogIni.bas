Attribute VB_Name = "mCatalogIni"
Option Explicit

'--------------------------------------------------------------------------------
' cMngIni
' 25-10-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mCatalogIni"

Public Const c_MainIniFile = "CSCVXI.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public Const c_k_Server = "Server"
Public Const c_k_DataBase = "DataBase"
Public Const c_k_User = "User"
Public Const c_k_password = "Password"
Public Const c_k_TrustedConnection = "TrustedConnection"
Public Const c_k_LogTrafic = "LogTrafic"
Public Const c_k_Log = "LogFile"
Public Const c_k_interval = "Interval"
Public Const c_k_update_page = "UpdatePage"
Public Const c_k_logFull = "LogFull"
Public Const c_k_logLevel = "LogLevel"
Public Const c_k_EmailTest = "EmailTest"
Public Const c_k_EmailBcc = "EmailBcc"

Public Const c_k_intervalMp = "Interval_mp"
Public Const c_k_intervalVtas = "Interval_vtas"
Public Const c_k_intervalArticulos = "Interval_articulos"
Public Const c_k_ml_password = "ml_password"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gLogFull As Boolean
Public giLevel  As Long

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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
