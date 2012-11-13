Attribute VB_Name = "mContacts"
Option Explicit

Private Const C_Module = "mContacts"

Public Function ListContacts() As Boolean
  On Error GoTo ControlError
  
  Dim Buffer As String
  Dim mouse  As cMouseWait
  
  Set mouse = New cMouseWait
  
  ' Para evitar rebotes entre mensajes
  '
  DoEvents
  Sleep 200
  DoEvents
  
  If Not pGetListContacts(Buffer) Then Exit Function
  
  ' Para evitar rebotes entre mensajes
  '
  Dim n As Integer
  
  Do
    
    ' Para evitar rebotes entre mensajes
    '
    If Left$(Buffer, Len(c_LIST_CHAT_CLIENTS_RESP)) _
      <> c_LIST_CHAT_CLIENTS_RESP Then
      
      Buffer = vbNullString
      
      ' Si fallo me vuelvo a conectar para evitar rebotes
      '
      fMain.Client.ClearResponse
      fMain.Client.Disconnect
      ReConnectChat
      
      If Not pGetListContacts(Buffer) Then Exit Function
    Else
      Exit Do
    End If
    n = n + 1

  Loop Until n > 10
  
  If Left$(Buffer, Len(c_LIST_CHAT_CLIENTS_RESP)) _
    <> c_LIST_CHAT_CLIENTS_RESP Then
    
    MsgInfo "No se pudo abrir la conexión"
    Exit Function
  End If
  
  'MsgBox "Contacts 1 " & Buffer
  
  ShowListContacts Buffer
  
  'MsgBox "Contacts 2 " & Buffer

  ListContacts = True

  GoTo ExitProc
ControlError:
  MngError Err, "ListContacts", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub ShowListContacts(ByVal List As String)
  Dim rs As Recordset
  
  If Not pGetRecordsetFromList(List, rs) Then Exit Sub
  
  LoadFromRecordSet rs, fMain.tvContacts
  
End Sub

Private Function pGetListContacts(ByRef Buffer As String) As Boolean
  
  Buffer = TCPGetMessage(cTCPCommandListChatClients, GetClientProcessId)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "No se pudo obtener la lista de contactos.;;Descripción técnica: " & _
              TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgWarning Buffer
    Exit Function
  End If
  
  pGetListContacts = True
End Function

Private Function pGetRecordsetFromList(ByVal List As String, _
                                       ByRef rs As adodb.Recordset) As Boolean
  On Error GoTo ControlError
  
  Set rs = New Recordset
  
  If Left$(List, Len(c_LIST_CHAT_CLIENTS_RESP)) _
    <> c_LIST_CHAT_CLIENTS_RESP Then
  
    MsgError "No se pudo obtener la lista de contactos" & vbCrLf & _
               "Texto recibido: " & List
    Exit Function
  End If
  
  List = Mid$(List, Len(c_LIST_CHAT_CLIENTS_RESP) + 1)
  
  rs.Fields.Append "ID", adBigInt
  rs.Fields.Append "Computer", adVarChar, 100
  rs.Fields.Append "User", adVarChar, 100
  rs.Fields.Append "TCP Client", adVarChar, 100
  rs.Fields.Append "Connected", adVarChar, 100
  rs.Fields.Append "State", adVarChar, 100
  rs.Fields.Append "Is Monitor", adVarChar, 100
  
  rs.Open
  
  Dim v() As String
  Dim f() As String
  
  v() = Split(List, c_TCPSep2)
  
  Dim i As Integer
  Dim q As Integer
  
  For i = 0 To UBound(v)
    rs.AddNew
    f = Split(v(i), c_TCPSep1)
    rs.Fields.Item(0).Value = f(0)
    rs.Fields.Item(1).Value = f(1)
    rs.Fields.Item(2).Value = f(2)
    rs.Fields.Item(3).Value = f(3)
    rs.Fields.Item(4).Value = TCPGetStringToDate(f(4))
    rs.Fields.Item(5).Value = f(5)
    rs.Fields.Item(6).Value = f(6)
  Next
  
  pGetRecordsetFromList = True

  Exit Function
  GoTo ExitProc
ControlError:
  Dim errNumber  As Long
  Dim errDescrip As String

  errNumber = Err.Number
  errDescrip = "No se pudo obtener la lista de contactos" & vbCrLf & _
               "Texto recibido: " & List & vbCrLf & _
               Err.Description

  On Error GoTo 0
  Err.Raise errNumber, vbNullString, errDescrip
  
ExitProc:
End Function

Public Function LoadFromRecordSet(ByRef rs As adodb.Recordset, _
                                  ByRef tv As TreeView, _
                                  Optional ByVal Add As Boolean) As Boolean
  On Error GoTo ControlError
  
  Dim Root      As Node
  Dim Node      As Node
  Dim info      As String
  Dim Key       As String
  
  With tv
  
    .Visible = False
    
    If Not Add Then
      .Nodes.Clear
    End If
    
    If tv.Nodes.Count = 0 Then
      Set Root = tv.Nodes.Add(, , c_key_root, pGetFolderName(), pGetFolderIcon())
      Root.Bold = True
    Else
      Set Root = tv.Nodes.Item(c_key_root)
    End If
    
    Root.Expanded = True
    
    If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
      
    While Not rs.EOF
      If LenB(rs.Fields.Item("User").Value) Then
        If rs.Fields.Item("Is Monitor").Value = 0 Then
        
          If pUserIsNotMe(rs) Then
          
              Key = pGetKeyContact(rs)
              
              If pNotExists(tv, Key) Then
              
              Set Node = .Nodes.Add(Root, tvwChild, Key, pGetContactName(rs), 1)
              
              info = SetInfoString(info, _
                                   c_key_contact_id, _
                                   rs.Fields.Item("ID").Value)
      
              info = SetInfoString(info, _
                                   c_key_contact_computer, _
                                   rs.Fields.Item("Computer").Value)
      
              info = SetInfoString(info, _
                                   c_key_contact_user, _
                                   rs.Fields.Item("User").Value)
              Node.Tag = info
            
            End If
          End If
        End If
      End If
      rs.MoveNext
    Wend
    
    .Visible = True
  
  End With
  
  LoadFromRecordSet = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadFromRecordSet", "cGridManager", "", "Error al cargar la grilla", csErrorWarning, csErrorVba
ExitProc:
End Function

Public Sub ListAddContact(ByVal Client As String)
  Dim rs As Recordset
  
  If Not pGetRecordsetFromList(Client, rs) Then Exit Sub
  
  LoadFromRecordSet rs, fMain.tvContacts, True
  
End Sub

Public Sub ListUpdateContact(ByVal Client As String)
  Dim rs As Recordset
 
  If Not pGetRecordsetFromList(Client, rs) Then Exit Sub

  UpdateRowFromRecordset rs, fMain.tvContacts
  
End Sub

Public Function UpdateRowFromRecordset(ByRef rs As Recordset, _
                                       ByRef tv As TreeView)
  Dim Key As String
  Key = pGetKeyContact(rs)
  With fMain.tvContacts.Nodes
    If pNotExists(tv, Key) Then
      LoadFromRecordSet rs, fMain.tvContacts, True
    Else
      With .Item(Key)
        .Text = pGetContactName(rs)
        .Tag = SetInfoString(.Tag, c_key_contact_id, rs.Fields.Item("ID").Value)
        .Image = 1
      End With
    End If
  End With
  
  UpdateRowFromRecordset = True
End Function

Private Function pNotExists(ByRef tv As TreeView, _
                            ByVal Key As String) As Boolean
  On Error Resume Next
  Dim aux As Node
  Set aux = tv.Nodes.Item(Key)
  pNotExists = aux Is Nothing
End Function

Public Sub ListRemoveContact(ByVal ClientId As Long)
  pRemoveContact ClientId
End Sub

Private Sub pRemoveContact(ByVal ClientId As Long)
  Dim i As Integer
  Dim User As String
  Dim Computer As String
  
  With fMain.tvContacts.Nodes
    For i = 1 To .Count
      If Val(GetInfoString(.Item(i).Tag, c_key_contact_id, 0)) = ClientId Then
        User = GetInfoString(.Item(i).Tag, c_key_contact_user)
        Computer = GetInfoString(.Item(i).Tag, c_key_contact_computer)
        If Not pUserIsConnectedInOtherSession(User, Computer, .Item(i)) Then
          .Item(i).Image = 2
        End If
        Exit For
      End If
    Next
  End With
End Sub

Private Function pUserIsConnectedInOtherSession(ByVal User As String, ByVal Computer As String, ByRef Node As Node) As Boolean
  Dim Buffer As String
  
  If Not pGetListContacts(Buffer) Then Exit Function

  Dim rs As Recordset
  
  If Not pGetRecordsetFromList(Buffer, rs) Then Exit Function
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst

    User = UCase$(User)
    Computer = UCase$(Computer)
    
    Do While Not rs.EOF
    
      If UCase$(rs.Fields.Item("Computer").Value) = Computer Then
        If UCase$(rs.Fields.Item("User").Value) = User Then
          Node.Tag = SetInfoString(Node.Tag, c_key_contact_id, rs.Fields.Item("ID").Value)
          pUserIsConnectedInOtherSession = True
          Exit Do
        End If
      End If
      rs.MoveNext
    Loop
  End If
End Function

Private Function pGetKeyContact(ByRef rs As adodb.Recordset) As String
  pGetKeyContact = UCase(rs.Fields.Item("User").Value _
                         & "-" & _
                         rs.Fields.Item("Computer").Value)
End Function

Private Function pGetContactName(ByRef rs As adodb.Recordset) As String
  pGetContactName = rs.Fields.Item("User").Value _
                    & " (" & _
                    rs.Fields.Item("Computer").Value & ")"
End Function

Private Function pUserIsNotMe(ByRef rs As adodb.Recordset) As Boolean
  pUserIsNotMe = UCase$(rs.Fields.Item("User")) <> UCase$(fMain.txUser) Or _
                 UCase$(rs.Fields.Item("Computer")) <> UCase$(GetComputerName())
End Function

Private Function pGetFolderIcon() As Long
  If gIsSoporte Then
    pGetFolderIcon = 4
  Else
    pGetFolderIcon = 3
  End If
End Function

Private Function pGetFolderName() As String
  If gIsSoporte Then
    pGetFolderName = "Soporte CrowSoft"
  Else
    pGetFolderName = "Contactos"
  End If
End Function
