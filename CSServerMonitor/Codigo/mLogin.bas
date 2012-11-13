Attribute VB_Name = "mLogin"
Option Explicit
'--------------------------------------------------------------------------------
' mLogin
' 29-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mLogin"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Login(ByVal Password As String, ByRef ErrorMsg As String) As Boolean
  Dim Buffer        As String
  Dim Message       As String
  Dim DataReceived  As String
  
  Message = TCPGetMessageLoginOnDomain(fMain.Client.ClientId, Password)
  
  Buffer = TCPGetMessage(cTCPCommandLoginOnDomain, ClientProcessId, Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  DataReceived = pProcessData(fMain.Client.DataReceived)
  
  If TCPError(DataReceived) Then
    MsgError GetErrorMessage(DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(DataReceived)
  If TCPGetFail(DataReceived) Then
    ErrorMsg = Buffer
    Exit Function
  End If
  
  Login = DataReceived = c_SucessCode
End Function

' funciones friend
' funciones privadas
Private Function pProcessData(ByVal Data As String) As String
  ' Si se mesclaron dos mensajes
  ' descarto el primero y listo
  If Mid(Data, 1, 8) = "LOGIN_ON" Then
    Data = Mid(Data, InStr(1, Data, "[EOP]") + 22)
  End If
  pProcessData = Data
End Function
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

