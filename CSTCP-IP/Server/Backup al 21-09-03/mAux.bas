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
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gClose As Boolean
' propiedadades friend
' propiedades privadas
' funciones publicas

Public Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  SaveLog ">>ERROR: " & Err.Number & " - " & Err.Description & ";>>FUNCTION: " & FunctionName & ";>>MODULE: " & Module & ";>>INFOADD: " & InfoAdd & ";"
End Sub

Public Sub InitLog()
  On Error Resume Next
  FileCopy App.Path & "\CSTCP-IPServer.log", App.Path & "\CSTCP-IPServer-" & Format(Now, "dd-mm-yy hh.nn.ss") & ".log"
  Kill App.Path & "\CSTCP-IPServer.log"
End Sub

Public Sub SaveLog(ByVal Message As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open App.Path & "\CSTCP-IPServer.log" For Append Access Write Shared As #f
  Message = Format(Now, "dd/mm/yy hh:nn:ss   ") & Message
  Print #f, Message
  pAddToLog Message
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

Private Sub pAddToLog(ByVal Message As String)
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

' funciones friend
' funciones privadas
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

