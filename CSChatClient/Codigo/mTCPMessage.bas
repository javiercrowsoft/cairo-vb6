Attribute VB_Name = "mTCPMessage"
Option Explicit

Public Sub ProcessMessage(ByVal Message As String)

  'Debug.Print Message

  Select Case TCPGetTypeMessage(Message)
    Case c_ADD_CLIENT
      ListAddContact TCPGetRealMessage(Message)
    
    Case c_LOGIN_ON
      ' Convierto el mensaje de LOGIN_ON en
      ' LIST_CHAT_CLIENTS_RESP
      '
      ListUpdateContact c_LIST_CHAT_CLIENTS_RESP & _
                        TCPGetRealMessage(Message)
    Case c_CLIENT_SHUT_DOWN
      ListRemoveContact Val(TCPGetRealMessage(Message))
    Case c_REFRESH_LOGINON
      RefresLoginOn
    Case c_CHAT_RECEIVE_TEXT
      ReceiveText TCPGetRealMessage(Message)
    Case Else
      If TCPGetSrvToClientIDMsg(Message) = "OPEN_CHAT_CLIENT___:" Then
        
        AcceptChat Val(TCPGetSrvToClientMsgValue(Message)), _
                   TCPGetSrvToClientMsgValueEx(Message), _
                   fMain.Client.ClientId
      End If
  End Select
End Sub

