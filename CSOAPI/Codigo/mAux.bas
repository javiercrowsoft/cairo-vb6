Attribute VB_Name = "mAux"
Option Explicit

'--------------------------------------------------------------------------------
' mAux
' 01-11-2002

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

Public Const C_PSqlFechaHora                    As String = "\'yyyymmdd HH:nn:ss\'"   'MS SQLServer
Public Const C_PSqlFecha                        As String = "\'yyyymmdd\'"

#If PREPROC_CSCVXI = 0 Then
Public Const csSqlDateString   As String = "\'yyyy-mm-dd HH:nn:ss\'"   'Access
#End If

Public Const csNoDate          As Date = #1/1/1900#
Public Const csNo_Id           As Long = 0

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gServer            As cIServer
Public gServiceCreated    As Boolean

Public gErrorInfo         As String
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  gErrorInfo = ErrObj.Description
  If gServer Is Nothing Then Exit Sub
  gServer.MngError ErrObj, FunctionName, Module, InfoAdd
End Sub

Public Function RemoveLastColon(ByVal Lista As String) As String
  If Right(Lista, 1) = "," Then
    RemoveLastColon = Mid(Lista, 1, Len(Lista) - 1)
  Else
    RemoveLastColon = Lista
  End If
End Function

Public Sub InitLog()
  On Error Resume Next
  
  pCreateFolderLog
  
  FileCopy App.Path & LOG_NAME, App.Path & LOG_NAME2 & Format(Now, "dd-mm-yy hh.nn.ss") & ".log"
  Kill App.Path & LOG_NAME
End Sub

Public Sub SaveLog(ByVal Message As String, Optional ByVal bNoLog As Boolean = False)
  On Error Resume Next
  
  'gServer.SaveLog LOG_NAME2 & "-" & Message
  
  If Not bNoLog Then
  
    Dim f As Integer
    f = FreeFile
    Open App.Path & LOG_NAME For Append Access Write Shared As #f
    Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & Message
    Close f
    
  End If
End Sub

Public Function GetToken(ByVal Token As String, ByVal Source As String) As String
  Dim i As Integer
  Dim s As String
  Dim c As String
  Dim l As Integer
  l = Len(Source)
  i = InStr(1, Source, Token, vbTextCompare)
  
  If i = 0 Then Exit Function
  
  Do
    i = i + 1
    If i > l Then Exit Do
    c = Mid(Source, i, 1)
    If c = "=" Then
      Exit Do
    End If
  Loop
  
  Do
    i = i + 1
    If i > l Then Exit Do
    c = Mid(Source, i, 1)
    If c <> ";" Then
      s = s & c
    Else
      Exit Do
    End If
  Loop
  
  GetToken = s
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


