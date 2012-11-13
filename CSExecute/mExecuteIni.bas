Attribute VB_Name = "mExecuteIni"
Option Explicit

'--------------------------------------------------------------------------------
' mExecuteIni
' 15-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mExecuteIni"

Public Const c_MainIniFile = "CSExecute.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public Const c_K_Server = "Server"
Public Const c_k_DataBase = "DataBase"
Public Const c_k_User = "User"
Public Const c_k_Password = "Password"
Public Const c_k_TrustedConnection = "TrustedConnection"
Public Const c_k_TarjetonPath = "Tarjeton_Path"
Public Const c_k_TarjetonSP = "Tarjeton_SP"

Public Const c_k_DriverName = "DriverName"
Public Const c_k_PrinterName = "PrinterName"
Public Const c_k_PortName = "PortName"
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next







