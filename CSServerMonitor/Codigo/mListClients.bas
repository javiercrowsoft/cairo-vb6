Attribute VB_Name = "mListClients"
Option Explicit

'--------------------------------------------------------------------------------
' mListClients
' 27-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mListClients"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub ListAddClient(ByVal Client As String)
  Dim rs As Recordset
  
  If Not fListClients.IsPresent Then Exit Sub

  Set rs = pGetRecordsetFromList(Client)
  
  LoadFromRecordSet rs, fListClients.cgrClients, True
  
  pSetIcons
End Sub

Public Sub ListUpdateClient(ByVal Client As String)
  Dim rs      As Recordset
  Dim iRow    As Integer
  
  If Not fListClients.IsPresent Then Exit Sub
  
  Set rs = pGetRecordsetFromList(Client)

  iRow = pGetRowFromId(Val(rs.Fields(0)))
  
  UpdateRowFromRecordset rs, fListClients.cgrClients, iRow
  
  pSetIcons
End Sub

Public Sub ListRemoveClient(ByVal ClientId As Long)
  pRemoveClient ClientId
End Sub

Public Sub ListClients()
  On Error GoTo ControlError
  
  Dim Buffer    As String
  
  If Not pGetListClients(Buffer) Then Exit Sub
  
  ' Para evitar rebotes entre mensajes
  '
  Dim n As Integer
  
  Do
    
    ' Para evitar rebotes entre mensajes
    '
    If Left$(Buffer, Len(c_LIST_CLIENTS_RESP)) _
      <> c_LIST_CLIENTS_RESP Then
      
      If Not pGetListClients(Buffer) Then Exit Sub
    Else
      Exit Do
    End If
    n = n + 1
  Loop Until n > 10
  
  ' Para evitar rebotes entre mensajes
  '
  If Left$(Buffer, Len(c_LIST_CLIENTS_RESP)) _
    <> c_LIST_CLIENTS_RESP Then
  
    Exit Sub
  End If
  
  pShowListClients Mid$(Buffer, Len(c_LIST_CLIENTS_RESP) + 1)

  GoTo ExitProc
ControlError:
  MngError Err, "ListClients", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' funciones friend
' funciones privadas
Private Sub pRemoveClient(ByVal ClientId As Long)
  Dim iRow As Integer
  iRow = pGetRowFromId(ClientId)
  If iRow = 0 Then Exit Sub
  fListClients.cgrClients.RemoveRow iRow
End Sub

Private Function pGetRowFromId(ByVal ClientId As Long) As Integer
  Dim iRow As Integer
  
  With fListClients.cgrClients
    For iRow = 1 To .Rows
      If Val(.CellText(iRow, 1)) = ClientId Then
        pGetRowFromId = iRow
        Exit Function
      End If
    Next
  End With
End Function

Private Function pGetRecordsetFromList(ByVal List As String) As Recordset
  Dim rs As Recordset
  
  Set rs = New Recordset
  
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
    rs.Fields(0).Value = f(0)
    rs.Fields(1).Value = f(1)
    rs.Fields(2).Value = f(2)
    rs.Fields(3).Value = f(3)
    rs.Fields(4).Value = TCPGetStringToDate(f(4))
    rs.Fields(5).Value = f(5)
    rs.Fields(6).Value = f(6)
  Next
  
  Set pGetRecordsetFromList = rs
End Function

Private Sub pShowListClients(ByVal List As String)
  Dim rs As Recordset
  
  Set rs = pGetRecordsetFromList(List)
  
  fListClients.Show
  LoadFromRecordSet rs, fListClients.cgrClients
  
  pSetIcons
End Sub

Private Sub pSetIcons()
  Dim i As Integer
  
  With fListClients.cgrClients
  
    If .Columns < 7 Then Exit Sub
  
    .Redraw = False
  
    .ColumnWidth(1) = 60
    .ColumnWidth(2) = 100
    .ColumnWidth(3) = 100
    .ColumnWidth(4) = 70
    .ColumnWidth(5) = 120
    .ColumnWidth(6) = 100
    .ColumnWidth(7) = 70
  
    For i = 1 To .Rows
      If Val(.CellText(i, 7)) <> 0 Then
        .CellIcon(i, 1) = 1
      Else
        .CellIcon(i, 1) = 0
      End If
    Next
    
    .Redraw = True
    
    .SetHeaders
  End With
End Sub

Private Function pGetListClients(ByRef Buffer As String) As Boolean
  
  Buffer = TCPGetMessage(cTCPCommandRefreshLoginOn, ClientProcessId)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError ".;;Descripción técnica: " & TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Buffer = TCPGetMessage(cTCPCommandListClients, ClientProcessId)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError ".;;Descripción técnica: " & TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgWarning Buffer
    Exit Function
  End If
  
  pGetListClients = True
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


