Attribute VB_Name = "mChatIni"
Option Explicit

'--------------------------------------------------------------------------------
' mAdoAuxIni
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
Private Const C_Module = "mAdoAuxIni"

Public Const c_MainIniFile = "CSADOAux.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public Const c_K_Server = "Server"
Public Const c_k_DataBase = "DataBase"
Public Const c_k_User = "User"
Public Const c_k_Password = "Password"
Public Const c_k_TrustedConnection = "TrustedConnection"
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





