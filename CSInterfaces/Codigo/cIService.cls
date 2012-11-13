VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIService"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIService
' 01-11-2002

'--------------------------------------------------------------------------------
' notas: Interfaz basica de servicio

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cIService"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public Property Get ServiceID() As Long
End Property
Public Property Let ServiceID(ByVal rhs As Long)
End Property
Public Property Get Server() As cIServer
End Property
Public Property Set Server(ByRef rhs As cIServer)
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub WndProc(ByVal ClientID As Long, ByRef Message() As Byte, ByRef Response() As Byte)
End Sub
Public Sub ClientShutDown(ByVal ClientID As Long)
End Sub
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


