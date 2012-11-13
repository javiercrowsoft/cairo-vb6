Attribute VB_Name = "mChat"
Option Explicit

Private Const C_Module = "mChat"

Private m_Text As String

Public Sub CloseChat()
  Dim Buffer    As String
  Dim Message   As String
  
  Message = TCPGetMessageCloseChat(fMain.Client.ClientId)
  
  Buffer = TCPGetMessage(cTCPCommandCloseChat, GetClientProcessId(), Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_CHAT) Then Exit Sub
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "No se pudo informar el cierre de la sesion al servidor de chat.;;Descripción técnica: " & _
              TCPGetResponse(fMain.Client.DataReceived)
    Exit Sub
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError "No se pudo informar el cierre de la sesion al servidor de chat.;;Descripción técnica: " & Buffer
    Exit Sub
  End If
  
End Sub

Public Function ReceiveText(ByVal Message As String) As Boolean

  Dim Text        As String
  Dim SessionKey  As String
  Dim FromId      As Long
  Dim vParams()   As String

  vParams = Split(Message, c_TCPSep1)
  SessionKey = vParams(0)
  Text = Replace(vParams(1), c_TCPSep1_Aux, c_TCPSep1)
  
  'Debug.Print Message
  
  If UBound(vParams) < 2 Then
    m_Text = m_Text & Text
  Else
  
    FromId = Val(vParams(2))
    
    If Len(m_Text) Then
      Text = m_Text & Text
      m_Text = vbNullString
    End If
    
    If LenB(Text) + LenB(SessionKey) Then
  
      Dim f       As Form
      Dim fChat   As fChat
      Dim bFound  As Boolean
      
      For Each f In Forms
        
        If TypeOf f Is fChat Then
        
          Set fChat = f
          If fChat.SessionKey = SessionKey Then
            bFound = True
            Exit For
          End If
        End If
      Next
      
      If Not bFound Then
      
        Set fChat = New fChat
        
        CSKernelClient2.GetConfigForm fChat, fChat.Name
        
        Dim User      As String
        Dim Computer  As String
        
        fChat.Caption = pGetInfoFromCallerId(FromId, User, Computer) & " - " & SessionKey
        fChat.User = User
        fChat.Computer = Computer
        fChat.SessionKey = SessionKey
        
        fChat.Show
  
      End If
      
      If Not fChat Is Nothing Then
        fChat.AddText pGetInfoFromCallerId(FromId, _
                                           vbNullString, _
                                           vbNullString), _
                      Text, _
                      vbWindowText, _
                      True
      End If
      
    End If
  
  End If
  
  ReceiveText = True
End Function

Public Function Send(ByVal SessionKey As String, _
                     ByVal Text As String, _
                     ByRef f As fChat) As Boolean
  Send = pSend(SessionKey, _
               Text, _
               f)
End Function

Public Function AcceptChat(ByVal CallerId As Long, _
                           ByVal SessionKey As String, _
                           ByVal TempId As Long) As Boolean
                           
  On Error GoTo ControlError
  
  Dim f         As fChat
  Dim User      As String
  Dim Computer  As String
  
  Set f = New fChat
  
  CSKernelClient2.GetConfigForm f, f.Name
  
  f.Caption = pGetInfoFromCallerId(CallerId, User, Computer) & " - " & SessionKey
  f.User = User
  f.Computer = Computer
  f.SessionKey = SessionKey
  
  f.Show
  
  pInitChatSetRealId f, TempId
  
  AcceptChat = True
  GoTo ExitProc
ControlError:
  MngError Err, "AcceptChat", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function InitChat(ByVal InfoContact As String)
  On Error GoTo ControlError
  
  If Not pExistsChatAlreadyOpenForContact(InfoContact, True) Then
  
    Dim f As fChat
    Set f = New fChat
    
    f.User = GetInfoString(InfoContact, c_key_contact_user)
    f.Computer = GetInfoString(InfoContact, c_key_contact_computer)
    
    f.Caption = f.User & " (" & _
                f.Computer & ")"
    
    CSKernelClient2.LoadForm f, f.Name
    f.Show
    
    pInitChat f, Val(GetInfoString(InfoContact, c_key_contact_id))
  
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "InitChat", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pExistsChatAlreadyOpenForContact(ByVal InfoContact As String, _
                                                  ByVal bShow As Boolean) As Boolean

  Dim f         As Form
  Dim fChat     As fChat
  Dim User      As String
  Dim Computer  As String
  
  User = UCase$(GetInfoString(InfoContact, c_key_contact_user))
  Computer = UCase$(GetInfoString(InfoContact, c_key_contact_computer))
  
  For Each f In Forms
    If TypeOf f Is fChat Then
      Set fChat = f
      If UCase$(fChat.User) = User And _
         UCase$(fChat.Computer) = Computer Then
        If bShow Then
          f.Show
          f.ZOrder
        End If
        pExistsChatAlreadyOpenForContact = True
        Exit Function
      End If
    End If
  Next

End Function

Private Sub pInitChat(ByRef f As fChat, _
                      ByVal ClientIdToChat As Long)
                           
  Dim Buffer    As String
  Dim Message   As String
  
  Message = TCPGetMessageInitChat(fMain.Client.ClientId, ClientIdToChat)
  
  Buffer = TCPGetMessage(cTCPCommandInitChat, GetClientProcessId(), Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_CHAT) Then Exit Sub
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "No se ha podido iniciar la sesión de chat.;;Descripción técnica: " & _
              TCPGetResponse(fMain.Client.DataReceived)
    Exit Sub
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError "No se ha podido iniciar la sesión de chat.;;Descripción técnica: " & Buffer
    Exit Sub
  End If
  
  f.SessionKey = TCPGetResponse(fMain.Client.DataReceived)
  f.Caption = f.Caption & " - " & f.SessionKey
  
End Sub

Private Sub pInitChatSetRealId(ByRef f As fChat, _
                               ByVal TempId As Long)
                           
  Dim Buffer    As String
  Dim Message   As String
  
  Message = TCPGetMessageInitChatSetRealId( _
              fMain.Client.ClientId, _
              TempId, _
              f.SessionKey)
  
  Buffer = TCPGetMessage(cTCPCommandInitChatSetRealId, _
                         GetClientProcessId(), _
                         Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_CHAT) Then Exit Sub
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "No se ha podido actualizar la sesión de chat.;;Descripción técnica: " & _
              TCPGetResponse(fMain.Client.DataReceived)
    Exit Sub
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError "No se ha podido actualizar la sesión de chat.;;Descripción técnica: " & Buffer
    Exit Sub
  End If
  
End Sub

Private Function pGetInfoFromCallerId(ByVal CallerId As Long, _
                                      ByRef User As String, _
                                      ByRef Computer As String) As String
  Dim rtn As String
  
  rtn = pGetInfoFromCallerIdAux(CallerId, User, Computer)
  If LenB(rtn) = 0 Then
    If pGetInfoFromServer(CallerId) Then
      rtn = pGetInfoFromCallerIdAux(CallerId, User, Computer)
    End If
  End If
  pGetInfoFromCallerId = rtn
End Function

Private Function pGetInfoFromCallerIdAux(ByVal CallerId As Long, _
                                         ByRef User As String, _
                                         ByRef Computer As String) As String
  Dim Node As Node
  
  For Each Node In fMain.tvContacts.Nodes

    If Val(GetInfoString(Node.Tag, c_key_contact_id)) = CallerId Then
      pGetInfoFromCallerIdAux = Node.Text
      User = GetInfoString(Node.Tag, c_key_contact_user)
      Computer = GetInfoString(Node.Tag, c_key_contact_computer)
      Exit Function
    End If
  Next
  
End Function

Private Function pGetInfoFromServer(ByVal CallerId As Long) As Boolean
  Dim Buffer    As String
  Dim Message   As String
  
  Message = TCPGetMessageGetInfoClient(CallerId)
  
  Buffer = TCPGetMessage(cTCPCommandGetInfoClient, GetClientProcessId(), Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "No se pudo obtener la información asociada al proceso " & CallerId & _
             ".;;Descripción técnica: " & _
             TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError "No se pudo obtener la información asociada al proceso " & CallerId & _
             ".;;Descripción técnica: " & Buffer
    Exit Function
  End If

  If Left$(Buffer, Len(c_LIST_CLIENTS_RESP)) _
    <> c_LIST_CLIENTS_RESP Then

    Exit Function
  Else
    Buffer = c_LIST_CHAT_CLIENTS_RESP & _
             Mid$(Buffer, Len(c_LIST_CLIENTS_RESP) + 1)
  End If
  
  ShowListContacts Buffer

  pGetInfoFromServer = True
End Function

Private Function pSend(ByVal SessionKey As String, _
                       ByVal Text As String, _
                       ByRef f As fChat) As Boolean
                           
  Dim Buffer    As String
  Dim Message   As String
  
  Message = TCPGetMessageChatSendText( _
                     fMain.Client.ClientId, _
                     SessionKey, _
                     Text)
  
  Buffer = TCPGetMessage(cTCPCommandChatSendText, _
                         GetClientProcessId(), _
                         Message)
                         
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_CHAT) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "No se ha podido enviar el mensaje.;;Descripción técnica: " & _
              TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError "No se ha podido enviar el mensaje.;;Descripción técnica: " & Buffer
    Exit Function
  End If
  
  pSend = True
  
End Function


