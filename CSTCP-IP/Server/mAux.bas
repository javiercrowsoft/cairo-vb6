Attribute VB_Name = "mAux"
Option Explicit

'--------------------------------------------------------------------------------
' mAux
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
Private Const C_Module = "mAux"

#If PREPROC_SERVER3 Then
  Private Const c_log_file = "CSTCP-IPServer3"
#ElseIf PREPROC_SERVER2 Then
  Private Const c_log_file = "CSTCP-IPServer2"
#Else
  Private Const c_log_file = "CSTCP-IPServer"
#End If

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gClose As Boolean
' propiedadades friend
' propiedades privadas
' funciones publicas

Public Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  SaveLog ">>ERROR: " & Err.Number & " - " & Err.Description & ";>>FUNCTION: " & FunctionName & ";>>MODULE: " & Module & ";>>INFOADD: " & InfoAdd & ";Linea " & Erl
End Sub

Public Sub InitLog()
  On Error Resume Next
  
  pCreateFolderLog
  
  FileCopy App.Path & "\Log\" & c_log_file & ".log", _
           App.Path & "\Log\" & c_log_file & "-" & _
           Format(Now, "dd-mm-yy hh.nn.ss") & ".log"
  Kill App.Path & "\Log\" & c_log_file & ".log"
End Sub

Public Sub SaveLog(ByVal Message As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open App.Path & "\Log\" & c_log_file & ".log" For Append Access Write Shared As #f
  Message = Format(Now, "dd/mm/yy hh:nn:ss   ") & Message
  Print #f, Message
  AddToLog Message
  Close f
End Sub

Public Sub ByteArrayToString(Message As String, ConstByteArray() As Byte)
  Dim i As Integer
  
  For i = LBound(ConstByteArray) To UBound(ConstByteArray)
    Message = Message & Chr(ConstByteArray(i))
  Next i
End Sub

Public Sub StringToByteArray(ConstMessage As String, ByteArray() As Byte)
  Dim i As Integer
  Dim lenArray As Long
  
  ReDim ByteArray(0)
  
  If Len(ConstMessage) = 0 Then
    Exit Sub
  End If
  
  lenArray = Len(ConstMessage) - 1
  If lenArray < 0 Then lenArray = 0
  ReDim ByteArray(lenArray)
  For i = 1 To lenArray + 1
    ByteArray(i - 1) = Asc(Mid(ConstMessage, i, 1))
  Next i
End Sub

Public Sub AddToLog(ByVal Message As String)
  On Error Resume Next
  
#If PREPROC_EXE Then
  With fMain.lsLog
    If .ListCount > 1000 Then
      .RemoveItem 0
    End If
    .AddItem Message
    .ListIndex = .ListCount - 1
  End With
#End If
End Sub

Public Sub AddClient(ByVal Address As String, ByVal Id As Long)
#If PREPROC_EXE Then
  With fMain.lsConnections
    .AddItem "Client " & Format(Id, "000") & " - " & Address
    .ItemData(.NewIndex) = Id
  End With
#End If
End Sub

Public Sub RemoveClient(ByVal Id As Long)
#If PREPROC_EXE Then
  Dim i As Integer
  With fMain.lsConnections
    For i = 0 To .ListCount - 1
      If .ItemData(i) = Id Then
        .RemoveItem i
      End If
    Next
  End With
#End If
End Sub

Public Function GetAddressAsString(Socket As cSocket) As String
  GetAddressAsString = Socket.RemoteHost & " - " & Socket.RemoteHostIP & " : " & Socket.RemotePort
End Function

Public Function Ask(ByVal msg As String) As Boolean
  If InStr(1, msg, "?") = 0 Then msg = "¿" & msg & "?"
  msg = Replace(msg, ";", vbCrLf)
  Ask = MsgBox(msg, vbQuestion + vbYesNo) = vbYes
End Function
' funciones friend
' funciones privadas
Private Sub pCreateFolderLog()
  On Error Resume Next
  If Dir(App.Path & "\Log", vbDirectory) = "" Then
    MkDir App.Path & "\Log"
  End If
End Sub
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

