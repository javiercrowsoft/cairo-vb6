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
Private WithEvents m_Server     As JBSOCKETSERVERLib.Server
Attribute m_Server.VB_VarHelpID = -1
Private m_ServiceMng            As cServiceManager
Private m_NextId                As Integer
' eventos
' propiedadades publicas
Public Property Get Server() As JBSOCKETSERVERLib.Server
  Set Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub SetServer(Server As JBSOCKETSERVERLib.Server)
   Set m_Server = Server
   m_ServiceMng.State = csSrvStateRunning
   SaveLog "Socket server listening on: " & Server.LocalAddress.Port
End Sub

Public Function SendBytes(ByRef Bytes() As Byte, ByRef Socket As Socket) As Boolean
  On Error GoTo ControlError
  
  Socket.Write Bytes, False
  
  GoTo ExitProc
ControlError:
  MngError Err, "SendBytes", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
Private Sub m_server_OnConnectionClosed(ByVal Socket As JBSOCKETSERVERLib.ISocket)
  On Error GoTo ControlError
  
  Dim counter As cCounter
  Set counter = Socket.UserData
  
  SaveLog "OnConnectionClosed : " & GetAddressAsString(Socket)
  SaveLog "Received packages= " & counter.GetCount()
  
  m_ServiceMng.ClientShutDown GetKey(counter.ID)
  m_ServiceMng.Clients.Remove GetKey(counter.ID)
  
  Socket.UserData = 0

  GoTo ExitProc
ControlError:
  MngError Err, "m_server_OnConnectionClosed", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_server_OnConnectionEstablished(ByVal Socket As JBSOCKETSERVERLib.ISocket)
  On Error GoTo ControlError
  
  Dim Message As String
  Dim counter As cCounter
  Set counter = New cCounter
  
  counter.ID = pGetNextID
  Socket.UserData = counter
  
  SaveLog "OnConnectionEstablished : " & GetAddressAsString(Socket)
  
  Dim ClientId  As Long
  ClientId = m_ServiceMng.Clients.Add(Socket, GetKey(counter.ID)).ID
  
  Socket.WriteString Trim(ClientId) & vbCrLf, gSignOnAsUnicode
  
  If gLogTrafic Then SaveLog Message
  
  Socket.RequestRead

  GoTo ExitProc
ControlError:
  MngError Err, "m_server_OnConnectionEstablished", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_server_OnDataReceived(ByVal Socket As JBSOCKETSERVERLib.ISocket, ByVal Data As JBSOCKETSERVERLib.IData)
  On Error GoTo ControlError
  
  Dim counter As cCounter
  Set counter = Socket.UserData
  
  SaveLog "onDataReceived"
  
  counter.IncrementCount
  
  OnReceived Socket, Data, counter.GetCount
  
  Socket.RequestRead

  GoTo ExitProc
ControlError:
  MngError Err, "m_server_OnDataReceived", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub OnReceived(ByVal Socket As JBSOCKETSERVERLib.ISocket, ByVal Data As JBSOCKETSERVERLib.IData, counter As Integer)
  Dim Message As String
  Dim Bytes() As Byte
  Dim i As Integer
  
  Bytes = Data.Read()

  m_ServiceMng.WndProc Bytes, Socket

'  If gLogTrafic Then
'    ByteArrayToString Message, Bytes()
'    Message = "OnReceived : " & GetAddressAsString(Socket) & " - " & Message
'    SaveLog Message
'  End If
End Sub

Private Function GetAddressAsString(Socket As JBSOCKETSERVERLib.ISocket) As String
  GetAddressAsString = Socket.RemoteAddress.Address & " : " & Socket.RemoteAddress.Port
End Function

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


