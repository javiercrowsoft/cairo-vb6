VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cServiceManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cServiceManager
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIServer

' constantes
Private Const C_Module = "cServiceManager"

Private Const c_ErrorCode    As String = " 0 -  "

Private Const c_BOP = "[BOP]"
Private Const c_EOP = "[EOP]"
Private Const c_EOP2 = "[   ]"

' estructuras
' variables privadas
Private m_Services              As cServices
Private m_Clients               As cClients
Private m_Listen                As cListen
Private m_State                 As CSIService.csSrvState
Private m_PendingMessages       As cPendingMessages
Private m_PendingPackets        As cPendingPackets
' eventos
' propiedadades publicas
Public Property Get Services() As cServices
   Set Services = m_Services
End Property

Public Property Set Services(ByRef rhs As cServices)
   Set m_Services = rhs
End Property

Public Property Get Clients() As cClients
   Set Clients = m_Clients
End Property

Public Property Set Clients(ByRef rhs As cClients)
   Set m_Clients = rhs
End Property

Public Property Get Listen() As cListen
   Set Listen = m_Listen
End Property

Public Property Set Listen(ByRef rhs As cListen)
   Set m_Listen = rhs
End Property

Public Property Get State() As CSIService.csSrvState
   State = m_State
End Property

Public Property Let State(ByVal rhs As CSIService.csSrvState)
   m_State = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub ClientShutDown(ByVal ClientKey As String)
  Dim c As cClient
  Dim s As cIService
  Dim ByteArray() As Byte
  
  Set c = m_Clients.Item(ClientKey)
  
  For Each s In c.Services
    SaveLog "Informando al servicio " & s.ServiceId & " que el cliente " & c.Id & " ha terminado su seción."
    s.ClientShutDown c.Id
  Next
End Sub

Public Sub UnLoadServices()
  Dim Service As cIService

  Const c_ServiceShutDown = -1000

  For Each Service In m_Services
    Service.ClientShutDown c_ServiceShutDown
  Next
End Sub

Public Sub LoadServices()
  On Error GoTo ControlError
  
  Dim serviceList As String
  Dim vService()  As String
  Dim ServiceInit As cIServiceInit
  Dim Service     As cIService
  Dim i           As Integer
  
  serviceList = IniServiceGet(c_k_ServiceList, "")
  vService = Split(serviceList, ",")
  
  For i = 0 To UBound(vService)
    SaveLog "Creating service: " & vService(i)
    Set ServiceInit = Nothing
    Set ServiceInit = pCreateObjectAux(vService(i))
    If Not ServiceInit Is Nothing Then
      Set Service = ServiceInit.GetServiceObject(Me)
      If Not Service Is Nothing Then
        m_Services.Add Service
        SaveLog "Service: " & vService(i) & " created sucessfully"
      Else
        SaveLog "Creation of Service: " & vService(i) & " failed"
      End If
    Else
      SaveLog "Creation of Service: " & vService(i) & " failed"
    End If
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "LoadServices", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub WndProc(ByRef ByteArray() As Byte, ByVal Socket As cSocket)
  On Error GoTo ControlError
  
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP][id de servicio]mensaje[   ]
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP]mensaje[   ]
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP]mensaje[EOP]
' 1    2           3           4                        5
'     1           2           3                     4               5
  
  Dim buff     As String
  Dim v()      As String
  Dim i        As Integer
  Dim endstr   As String
  Dim beginstr As String
  Dim c        As cPendingPacket
  Dim ByteArrayAux() As Byte
  
  Const c_splitchar = "||@@"
  
  ByteArrayToString buff, ByteArray
  
  buff = Replace(buff, c_BOP, c_splitchar & c_BOP, , , vbTextCompare)
  v = Split(buff, c_splitchar)
    
  For i = 0 To UBound(v)
  
    If v(i) <> "" Then
  
      beginstr = Left(v(i), Len(c_BOP))
      endstr = Right$(v(i), Len(c_EOP))
      
      ' Si no contiene el principio es por
      ' que se trata de la cola de un bloque
      ' que esta en m_PendingPackets
      
      If beginstr <> c_BOP Then
        Set c = m_PendingPackets(Socket.UserData.Id)
        If c Is Nothing Then
          SaveLog "Se recibio un mensaje sin principio para el cliente " & Socket.UserData.Id
          SaveLog "y no se encuentra el principio en m_PendingPackets"
          SaveLog "Mensaje recibido:" & Encrypt(v(i))
          Exit For
        Else
          v(i) = c.strBuff & v(i)
        End If
      End If
      
      If endstr = c_EOP Or endstr = c_EOP2 Then
        If Not c Is Nothing Then m_PendingPackets.Remove c.ClientId
        StringToByteArray v(i), ByteArrayAux
        pWndProcAux ByteArrayAux
      Else
        Set c = m_PendingPackets.Item(Socket.UserData.Id)
        If c Is Nothing Then Set c = m_PendingPackets.Add(Nothing, Socket.UserData.Id)
        c.strBuff = v(i)
      End If
    End If
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pWndProcAux(ByRef ByteArray() As Byte)
  On Error GoTo ControlError
  
  Dim IsEOP As Boolean
  Dim c As CSTCPIPManager.cTCPIPManager
  Set c = New CSTCPIPManager.cTCPIPManager
  
  If c.IsValid(ByteArray) Then
    
    Dim ss As String
    ByteArrayToString ss, ByteArray
    
    If gLogTrafic Then
      SaveLog "Mensaje Valido:" & Encrypt(ss)
    End If
    
    IsEOP = c.IsEOP(ByteArray)
  
    ' Si es el primer paquete
    If c.TCPIPId = 1 Then
    
      ' Si es el unico paquete lo envio al servicio
      If IsEOP Then
        c.GetMessage ByteArray
        ss = ""
        ByteArrayToString ss, ByteArray
        
        If gLogTrafic Then
          SaveLog "Mensaje Procesado:" & Encrypt(ss)
        End If
        
        pSendMessageToService ByteArray, c.ServiceId, c.ClientId
      
      ' Sino lo agrego a la coleccion de paquetes pendientes
      Else
        pAddToPendingMessage ByteArray, c
      End If
      
    ' Sino lo busco en la lista de paquetes pendientes
    Else
      
      ' Si es el ultimo le envio el mensaje al servidor
      If IsEOP Then
        c.GetMessage ByteArray
        Dim msg As cMessage
        Set msg = pGetFullMessage(ByteArray, c)
        pSendMessageToService ByteArray, msg.ServiceId, msg.ClientId
      Else
        pAddToPendingMessage ByteArray, c
      End If
    End If
  Else
    Dim s As String
    ByteArrayToString s, ByteArray
    SaveLog "Mensaje invalido:" & Encrypt(s)
    
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pWndProcAux", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Interfaz
Private Sub cIServer_MngError(ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  MngError ErrObj, FunctionName, Module, InfoAdd
End Sub

Private Function cIServer_RegisterClient(ByVal ClientId As Long, ByRef Service As cIService) As Boolean
  On Error GoTo ControlError
  
  Dim c As cClient
  Dim s As cIService
  
  For Each c In m_Clients
    If c.Id = ClientId Then
      Set s = c.Services.Item(GetKey(Service.ServiceId))
      If s Is Nothing Then
        c.Services.Add Service, GetKey(Service.ServiceId)
      End If
      cIServer_RegisterClient = True
      Exit For
    End If
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "cIServer_RegisterClient", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub cIServer_SaveLog(ByVal sLog As String)
  If Left$(sLog, 5) = "show:" Then
    AddToLog Mid$(sLog, 6)
  Else
    SaveLog sLog
  End If
End Sub

Private Sub cIServer_UnregisterClient(ByVal ClientId As Long, ByRef Service As cIService)
  On Error GoTo ControlError
  
  Dim c As cClient
  
  For Each c In m_Clients
    If c.Id = ClientId Then
      c.Services.Remove GetKey(Service.ServiceId)
      Exit For
    End If
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "cIServer_UnregisterClient", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function cIServer_SendMessage(ByVal ClientId As Long, Message() As Byte) As Boolean
  On Error GoTo ControlError
  
  pSenMessageToClient Message(), ClientId
  cIServer_SendMessage = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIServer_SendMessage", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Property Get cIServer_State() As CSIService.csSrvState
  cIServer_State = m_State
End Property

Private Sub cIServer_ByteArrayToString(Message As String, ConstByteArray() As Byte)
  ByteArrayToString Message, ConstByteArray
End Sub

Private Sub cIServer_StringToByteArray(ConstMessage As String, ByteArray() As Byte)
  StringToByteArray ConstMessage, ByteArray
End Sub

' funciones friend
' funciones privadas
Private Function pCreateObjectAux(ByVal ObjectName As String) As Object
  On Error Resume Next
  Set pCreateObjectAux = CreateObject(ObjectName)
End Function

Private Function pGetPendingMessage(ByVal KeyMessage As String) As cMessage
  On Error Resume Next
  Set pGetPendingMessage = m_PendingMessages(KeyMessage)
End Function

Private Function pGetKeyMessage(ByRef c As CSTCPIPManager.cTCPIPManager) As String
  pGetKeyMessage = "K" & c.ClientId & "*" & c.MessageId
End Function

Private Sub pSendMessageToService(ByRef ByteArray() As Byte, ByVal ServiceId As Long, ByVal ClientId As Long)
  Dim srv As cIService
  Dim Response() As Byte
  
  ReDim Response(0)
  
  For Each srv In m_Services
    If srv.ServiceId = ServiceId Then
      srv.WndProc ClientId, ByteArray, Response
      Exit For
    End If
  Next
  
  If UBound(Response) >= 0 Then
    
    ' Mandamos un mensaje de error
    If Response(0) = 0 Then
      StringToByteArray c_ErrorCode & "ERROR-EN-SERVICIO - " & ServiceId, Response
    End If
    
    pSenMessageToClient Response, ClientId
  End If
End Sub

Private Sub pSenMessageToClient(ByRef ByteArray() As Byte, ByVal ClientId As Long)
  Dim Client As cClient
  
  For Each Client In m_Clients
    If Client.Id = ClientId Then
    
      pSendMessage Client.Socket, ByteArray
      Exit For
    End If
  Next

  Dim s As String
  ByteArrayToString s, ByteArray
  
  If gLogTrafic Then
    SaveLog "Mensaje a cliente: " & Encrypt(s)
  End If
End Sub

Private Sub pSendMessage(ByRef Socket As cSocket, ByRef ByteArray() As Byte)
  Dim From As Long
  Dim TCPIPId As Long
  Dim msg As String
  Dim Message As String
  
  Dim c As CSTCPIPManager.cTCPIPManager
  
  ByteArrayToString Message, ByteArray
  
  Set c = New CSTCPIPManager.cTCPIPManager
  
  Do
    msg = c.CreateMessageToSend(Message, From, 1, 1, 1, TCPIPId)
    StringToByteArray msg, ByteArray
    
    Socket.SendData ByteArray
    
    If gLogTrafic Then
      SaveLog "Enviando mensaje: " & Encrypt(msg)
    End If
  Loop Until From = 0
End Sub

Private Function pGetFullMessage(ByRef ByteArray() As Byte, ByRef c As CSTCPIPManager.cTCPIPManager) As cMessage
  Dim msg As cMessage
  Set msg = pGetPendingMessage(pGetKeyMessage(c))
  If Not msg Is Nothing Then
    msg.GetFullMessage ByteArray
  End If
  Set pGetFullMessage = msg
End Function

Private Sub pAddToPendingMessage(ByRef ByteArray() As Byte, ByRef c As CSTCPIPManager.cTCPIPManager)
  Dim msg As cMessage
  Set msg = pGetPendingMessage(pGetKeyMessage(c))
  If msg Is Nothing Then
    Set msg = m_PendingMessages.Add(Nothing, pGetKeyMessage(c))
    msg.ClientId = c.ClientId
    msg.ServiceId = c.ServiceId
    msg.MessageId = c.MessageId
  End If

  c.GetMessage ByteArray
  msg.AddMessage ByteArray, c.TCPIPId
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Services = New cServices
  Set m_Clients = New cClients
  Set m_PendingMessages = New cPendingMessages
  Set m_PendingPackets = New cPendingPackets

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Services = Nothing
  Set m_Clients = Nothing
  Set m_PendingMessages = Nothing
  Set m_PendingPackets = Nothing
  
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


'  cValid = "["
'  For i = 1 To UBound(ByteArray)
'    c = Asc(ByteArray)
'    If c <> cValid Then
'      cValid = "["
'    Else
'      Select Case c
'        Case "["
'          cValid = "B"
'        Case "B"
'          cValid = "O"
'        Case "O"
'          cValid = "P"
'        Case "P"
'          cValid = "]"
'        Case "]"
'
'      End Select
'    End If
'  Loop

