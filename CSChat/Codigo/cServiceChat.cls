VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cServiceChat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cServiceChat
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
Implements cIService

' constantes
Private Const C_Module = "cServiceChat"

' estructuras
' variables privadas
Private m_ServiceID           As Long
Private m_Server              As cIServer
Private m_ChatUsers           As cChatUsers
Private m_ChatSessionsCount   As Long
' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal rhs As Long)
  m_ServiceID = rhs
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(rhs As CSIService.cIServer)
  Set m_Server = rhs
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)

End Sub

Private Sub cIService_WndProc(ByVal ClientId As Long, Message() As Byte, Response() As Byte)
  On Error GoTo ControlError

  Dim sMessage          As String
  Dim ErrDescription    As String
  Dim ClientProcess     As Long
  
  m_Server.ByteArrayToString sMessage, Message

  ClientProcess = pGetClientProcess(sMessage)
  
  If Not pIsValidClientProcess(ClientProcess, ErrDescription) Then
    sMessage = c_ErrorCode & ErrDescription
    m_Server.StringToByteArray sMessage, Response
    Exit Sub
  End If
  
  Select Case TCPGetTypeMessage(sMessage)

    Case c_INIT_CHAT
      If pInitChat(TCPGetRealMessage(sMessage), ClientProcess, sMessage) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response

    Case c_INIT_CHAT_SET_REAL_ID
      If pInitChatSetRealId(TCPGetRealMessage(sMessage), ClientProcess, sMessage) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response

    Case c_CHAT_SEND_TEXT
      If pSendText(TCPGetRealMessage(sMessage), ClientProcess, sMessage) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response

    Case c_CLOSE_CHAT
      If pCloseChat(TCPGetRealMessage(sMessage), ClientProcess, sMessage) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response

  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIService_WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
  m_Server.StringToByteArray c_ErrorCode & gErrorInfo, Response
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetClientProcess(ByVal sMessage As String) As Long
  pGetClientProcess = Val(Right$(sMessage, c_Len_ProcessId))
End Function

Private Function pIsValidClientProcess(ByVal ClientProcess As Long, ByRef ErrDescription As String) As Boolean
  If ClientProcess = 0 Then
    ErrDescription = "Invalid Client Process ID: " & ClientProcess
    Exit Function
  End If
  
  pIsValidClientProcess = True
End Function

Private Function pSendText(ByVal Message As String, _
                           ByVal ClientProcess As Long, _
                           ByRef msg As String) As Boolean
  Dim ChatUser      As cChatUser
  Dim ChatSession   As cChatSession
  Dim vParams()     As String
  Dim SessionKey    As String
  Dim Text          As String
  Dim bFound        As Boolean
  
  vParams = Split(Message, c_TCPSep1)
  SessionKey = vParams(1)
  Text = Replace(vParams(2), c_TCPSep1_Aux, c_TCPSep1)
  
  For Each ChatUser In m_ChatUsers
  
    Set ChatSession = ChatUser.ChatSessions.Item(SessionKey)
    
    If Not ChatSession Is Nothing Then
      
      Dim i As Long
      
      For i = 1 To ChatSession.ClientsCount
        If ChatSession.ClientIds(i) <> ClientProcess Then
          pSendTextAux ClientProcess, _
                       ChatSession.ClientIds(i), _
                       SessionKey, _
                       Text
          bFound = True
        End If
      Next
      
      Exit For
      
    End If
  Next
  
  If bFound Then
    msg = c_SucessCode
  Else
    msg = c_FailCode & "La session de Chat (" & SessionKey & ") ya se ha terminado."
  End If
  
  pSendText = True
  
End Function

Private Sub pSendTextAux(ByVal FromClientProcessId As Long, _
                         ByVal ToClientProcessId As Long, _
                         ByVal SessionKey As String, _
                         ByVal Text As String)
                        
  Dim ByteArray()     As Byte
  Dim sMessage        As String
  Dim strFromClient   As String
  
  strFromClient = Format(FromClientProcessId, String(c_Len_ProcessId, "0"))
  
  ' Ojo: strFromClientId se pasa dos veces para cumplir con el protocolo
  '      que indica que el clientid se debe pasar al final del mensaje
  '      y como quiero que el clientid este en el propio mensaje y la funcion
  '      TCPGetRealMessage elimina del mensaje el clientid del final del string
  '      tengo que ponerlo dos veces una en el cuerpo del mensaje separado por
  '      c_TCPSep1 y otra al final del string
  '
  sMessage = c_CHAT_RECEIVE_TEXT & _
             SessionKey _
             & c_TCPSep1 & _
             Replace(Text, c_TCPSep1, c_TCPSep1_Aux) _
             & c_TCPSep1 & _
             strFromClient _
             & c_TCPSep1 & strFromClient

  m_Server.StringToByteArray sMessage, ByteArray
  m_Server.SendMessage ToClientProcessId, ByteArray
End Sub

Private Function pInitChatSetRealId(ByVal Message As String, _
                                    ByVal ClientProcess As Long, _
                                    ByRef msg As String) As Boolean
  Dim ChatUser      As cChatUser
  Dim ChatSession   As cChatSession
  Dim vParams()     As String
  Dim RealId        As Long
  Dim TempId        As Long
  Dim SessionKey    As String
  Dim bFound        As Boolean
  
  RealId = ClientProcess
  vParams = Split(Message, c_TCPSep1)
  TempId = Val(vParams(0))
  SessionKey = vParams(1)
  
  For Each ChatUser In m_ChatUsers
  
    Set ChatSession = ChatUser.ChatSessions.Item(SessionKey)
    
    If Not ChatSession Is Nothing Then
      ChatSession.RemoveTempId TempId
      ChatSession.AddRealId RealId
      bFound = True
      Exit For
    End If
  Next
  
  If bFound Then
    msg = c_SucessCode
  Else
    msg = c_FailCode & "La session de Chat (" & SessionKey & ") ya se ha terminado."
  End If
  
  pInitChatSetRealId = True
  
End Function

Private Function pCloseChat(ByVal Message As String, _
                            ByVal ClientProcess As Long, _
                            ByRef msg As String) As Boolean

  Dim ChatUser    As cChatUser
  Dim ChatSession As cChatSession
  Dim i           As Long
    
  For Each ChatUser In m_ChatUsers
    
    For i = ChatUser.ChatSessions.Count To 1 Step -1
      
      Set ChatSession = ChatUser.ChatSessions.Item(i)
      
      ChatSession.RemoveRealId ClientProcess
      
      If ChatSession.ClientsCount <= 1 Then
        ChatUser.ChatSessions.Remove i
      End If
      
    Next
  Next
    
  msg = c_SucessCode
  
  pCloseChat = True

End Function

Private Function pInitChat(ByVal Message As String, _
                           ByVal ClientProcess As Long, _
                           ByRef msg As String) As Boolean

  Dim ChatUser As cChatUser
  
  Set ChatUser = m_ChatUsers.Item(GetKey(ClientProcess))
  
  If ChatUser Is Nothing Then
  
    Set ChatUser = m_ChatUsers.Add(Nothing, GetKey(ClientProcess))
  
  End If
  
  If Not ChatUser Is Nothing Then
    
    Dim SessionKey  As String
    Dim ChatSession As cChatSession
    
    m_ChatSessionsCount = m_ChatSessionsCount + 1
    SessionKey = GetKey(m_ChatSessionsCount)
    Set ChatSession = ChatUser.ChatSessions.Add(Nothing, SessionKey)
    
    If Not ChatSession Is Nothing Then
      
      Dim vParams()  As String
      Dim TempId     As Long
      
      vParams = Split(Message, c_TCPSep1)
      TempId = Val(vParams(1))
      
      ChatSession.ClientIds(1) = ClientProcess  ' Este es el que inicia el Chat
      '
      ChatSession.AddTempId TempId              ' Aqui tengo el ClientProcess del otro
                                                ' usuario del chat
      
      pNotifyUser TempId, ClientProcess, SessionKey
      
      msg = c_SucessCode & SessionKey
    Else
      msg = c_FailCode & "No se pudo crear una nueva sesion de chat"
    End If
    
  Else
    msg = c_FailCode & "No se pudo agregar el usuario a la lista de chats"
  End If
  
  pInitChat = True
  
End Function

Private Sub pNotifyUser(ByVal TCP_ID As Long, _
                        ByVal ClientProcessId As Long, _
                        ByVal ChatSession As String)
                        
  Dim ByteArray() As Byte
  Dim sMessage    As String
  
  
  ' Ojo con como se construye el mensaje
  ' no alteren la secuencia de estas cuatro lineas
  ' porque deja de andar
  sMessage = TCPSetDllID(c_AnyComponentTCP, "")
  sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
  sMessage = TCPSetDllProgID(csSecChat, sMessage)
  sMessage = sMessage & TCPSecurityGetMessage(cTCPSecCommandOpenChatClient, ClientProcessId, "")
  sMessage = sMessage & ChatSession
  sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
                                      ' Esta repetido aproposito para que no falle
                                      ' la primitiva TCPSetDllProgID
  
  m_Server.StringToByteArray sMessage, ByteArray
  m_Server.SendMessage TCP_ID, ByteArray
End Sub


' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_ServiceID = SRV_ID_CHAT

  Set m_Server = gServer
  gServiceCreated = True
  
  Set m_ChatUsers = New cChatUsers

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Server = Nothing
  gServiceCreated = False
  
  CollClear m_ChatUsers
  Set m_ChatUsers = Nothing
  
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


