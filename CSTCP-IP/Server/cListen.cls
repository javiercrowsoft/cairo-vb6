VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cListen
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
Private Const C_Module = "cListen"
' estructuras
' variables privadas
Private WithEvents m_Server     As cSocket
Attribute m_Server.VB_VarHelpID = -1
Private m_ServiceMng            As cServiceManager
Private m_NextId                As Integer
' eventos
' propiedadades publicas
Public Property Get Server() As cSocket
  Set Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub SetServer(Server As cSocket)
   Set m_Server = Server
   m_ServiceMng.State = csSrvStateRunning
   SaveLog "Socket server listening on: " & Server.LocalPort
End Sub

Public Sub UnLoadServices()
  On Error GoTo ControlError
  
  m_ServiceMng.UnLoadServices
  
  GoTo ExitProc
ControlError:
  MngError Err, "UnloadServices", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function SendBytes(ByRef Bytes() As Byte, ByRef Socket As cSocket) As Boolean
  On Error GoTo ControlError
  
  Dim Message As String
  
  ByteArrayToString Message, Bytes
  Socket.SendData Message
  
  GoTo ExitProc
ControlError:
  MngError Err, "SendBytes", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas
Private Sub m_Server_OnClose()
'
End Sub

Private Sub m_Server_OnConnect()
'
End Sub

Private Sub m_Server_OnConnectionRequest(ByVal requestID As Long)
  On Error GoTo ControlError
  
  Dim Message As String
  Dim Counter As cCounter
  Dim Socket  As cSocket
  Set Counter = New cCounter
  
  Counter.Id = pGetNextID
  Set Socket = New cSocket
  Socket.UserData = Counter
  
  Socket.Accept requestID
  
  SaveLog "Nueva conexión a: " & GetAddressAsString(Socket)
  
  Dim ClientId  As Long
  ClientId = m_ServiceMng.Clients.Add(Socket, GetKey(Counter.Id)).Id
  Set m_ServiceMng.Clients(GetKey(Counter.Id)).ServiceMng = m_ServiceMng
  AddClient GetAddressAsString(Socket), ClientId
  
  Socket.SendData Trim(ClientId) & vbCrLf
  
  If gLogTrafic Then SaveLog Message
  
  ' Ojo con esto que no se para que esta
  'Socket.RequestRead

  GoTo ExitProc
ControlError:
  MngError Err, "m_server_OnConnectionEstablished", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Server_OnDataArrival(ByVal bytesTotal As Long)
'
End Sub

Private Sub m_Server_OnError(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
'
End Sub

Private Sub m_Server_OnSendComplete()
'
End Sub

Private Sub m_Server_OnSendProgress(ByVal bytesSent As Long, ByVal bytesRemaining As Long)
'
End Sub

Private Function pGetNextID() As String
  m_NextId = m_NextId + 1
  pGetNextID = GetKey(m_NextId)
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_ServiceMng = New cServiceManager
  Set m_ServiceMng.Listen = Me
  m_ServiceMng.State = csSrvStatePaused
  m_ServiceMng.LoadServices
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ServiceMng = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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


