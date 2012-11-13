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

Private Const csFirtsError = vbObjectError + 1

' OJO: Esta constante esta declarada dos veces
'      Una vez aqui y otra en mMain de CSImportUsr
'      Si la cambian recuerden cambiar tambien en dicho exe
'      y tambien en mMainService
'
Public Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"

Public Enum csClientErrors
  csCantSubclass = csFirtsError + 2
End Enum
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gfAux As fAux

#If PREPROC_U Then
Public gReceived As Boolean
#End If
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  SaveLog ">>ERROR: " & Err.Number & " - " & Err.Description & ";>>FUNCTION: " & FunctionName & ";>>MODULE: " & Module & ";>>INFOADD: " & InfoAdd & ";"
End Sub

Public Sub InitLog()
  On Error Resume Next
    
  pCreateFolderLog
    
  FileCopy App.Path & "\log\CSTCP-IPClient.log", App.Path & "\log\CSTCP-IPClient-" & Format(Now, "dd-mm-yy hh.nn.ss") & ".log"
  Kill App.Path & "\log\CSTCP-IPClient.log"
End Sub

Public Sub SaveLog(ByVal Message As String)
  On Error Resume Next
  Dim f As Integer
  
  Message = Encript(Message, c_LoginSignature)
  f = FreeFile
  Open App.Path & "\log\CSTCP-IPClient.log" For Append Access Write Shared As #f
  Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & Message
  Close f

  'If Not gfAux Is Nothing Then
  '  gfAux.txLog = gfAux.txLog & vbCrLf & String(4, ">") & Message
  'End If
End Sub

Public Sub ByteArrayToString(Message As String, ConstByteArray() As Byte)
  Dim i As Integer
  
  Message = ""
  
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


