Attribute VB_Name = "mServiceLocal"
Option Explicit

'--------------------------------------------------------------------------------
' mServiceLocal
' 09-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mServiceLocal"

Public Const LOG_NAME = "\Log\CSSecurity.log"
Public Const LOG_NAME2 = "\Log\CSSecurity"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gLogTrafic As Boolean
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
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



