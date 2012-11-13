Attribute VB_Name = "mCataloglIni"
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
    Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
    Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mCatalogIni"

Public Const c_MainIniFile = "CSCatalog.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public Const c_k_Server = "Server"
Public Const c_k_DataBase = "DataBase"
Public Const c_k_User = "User"
Public Const c_k_Password = "Password"
Public Const c_k_TrustedConnection = "TrustedConnection"
Public Const c_k_LogTrafic = "LogTrafic"
Public Const c_k_Log = "LogFile"
Public Const c_k_interval = "Interval"
Public Const c_k_update_page = "UpdatePage"
Public Const c_k_logFull = "LogFull"
Public Const c_k_logLevel = "LogLevel"
Public Const c_k_WindowVisible = "WindowVisible"

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





