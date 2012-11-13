VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cClient
' 02-11-2002

' Contiene la info de los clientes conectados

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cClient"
' estructuras
' variables privadas
Private m_ID                            As Long
Private WithEvents m_Socket             As cSocket
Attribute m_Socket.VB_VarHelpID = -1
' Coleccion de servicios que han registrado a este cliente
Private m_Services                      As cServices
Private m_ServiceMng                    As cServiceManager
' eventos
' propiedadades publicas

Public Property Set ServiceMng(ByRef rhs As cServiceManager)
  Set m_ServiceMng = rhs
End Property

Public Property Get Id() As Long
   Id = m_ID
End Property

Public Property Let Id(ByVal rhs As Long)
   m_ID = rhs
End Property

Public Property Get Socket() As cSocket
   Set Socket = m_Socket
End Property

Public Property Set Socket(ByRef rhs As cSocket)
   Set m_Socket = rhs
End Property

Public Property Get Services() As cServices
   Set Services = m_Services
End Property

Public Property Set Services(ByRef rhs As cServices)
   Set m_Services = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Services = New cServices

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  m_Socket.CloseSocket
  Set m_Services = Nothing
  Set m_Socket = Nothing
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
Private Sub m_Socket_OnClose()
  On Error GoTo ControlError
  
  Dim Counter As cCounter
  Set Counter = Socket.UserData
  
  SaveLog "OnConnectionClosed : " & GetAddressAsString(Socket)
  SaveLog "Received packages= " & Counter.GetCount()
  
  m_ServiceMng.ClientShutDown GetKey(Counter.Id)
  m_ServiceMng.Clients.Remove GetKey(Counter.Id)
  RemoveClient Val(Mid(Counter.Id, 2))
  
  Socket.UserData = 0

  GoTo ExitProc
ControlError:
  MngError Err, "m_server_OnConnectionClosed", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Socket_OnDataArrival(ByVal bytesTotal As Long)
  On Error GoTo ControlError
  
  Dim Counter As cCounter
  Set Counter = Socket.UserData
  
  If gLogTrafic Then
    SaveLog "OnDataArrival"
  End If
  
  Counter.IncrementCount
  
  OnReceived Socket, Counter.GetCount
  
  ' Ojo con esto que no se para que esta
  'Socket.RequestRead

  GoTo ExitProc
ControlError:
  MngError Err, "m_Socket_OnDataArrival", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub OnReceived(ByVal Socket As cSocket, Counter As Integer)
  Dim Message As String
  Dim Bytes() As Byte
  Dim i As Integer
  
  Socket.GetData Message
  StringToByteArray Message, Bytes
  m_ServiceMng.WndProc Bytes, Socket
End Sub

Private Sub m_Socket_OnError(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
  ' Software cause abort connection
  If Number = 10053 Then
    m_Socket_OnClose
  End If
End Sub
