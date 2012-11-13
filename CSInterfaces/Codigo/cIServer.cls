VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIServer
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cIServer"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public Property Get State() As csSrvState
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function SendMessage(ByVal ClientID As Long, ByRef Message() As Byte) As Boolean
End Function
Public Sub StringToByteArray(ByRef ConstMessage As String, ByRef ByteArray() As Byte)
End Sub
Public Sub ByteArrayToString(ByRef Message As String, ByRef ConstByteArray() As Byte)
End Sub
Public Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
End Sub
Public Function RegisterClient(ByVal ClientID As Long, ByRef Service As cIService) As Boolean
End Function
Public Sub UnregisterClient(ByVal ClientID As Long, ByRef Service As cIService)
End Sub
Public Sub SaveLog(ByVal sLog As String)
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


