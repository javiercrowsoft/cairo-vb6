Attribute VB_Name = "mLog"
Option Explicit

Private m_logFile As String

Public Sub InitLog()
  m_logFile = pGetPath(App.Path) & "Log\CSWBPreguntas.log"
  On Error Resume Next
  Kill m_logFile
  Err.Clear
End Sub

Public Sub ClearLog()
  fMain.lvLog.ListItems.Clear
End Sub

Public Sub ShowLog( _
  ByVal title As String, _
  ByVal info As String, _
  Optional ByVal toFile As Boolean)
  
  With fMain.lvLog.ListItems.Add(1, , title)
    .SubItems(1) = info
  End With
  
  If toFile Then
    SaveLog title & ": " & info
  End If
  
End Sub

Public Sub SaveLog(ByVal msg As String)
  On Error Resume Next
  
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & msg
  Close f
    
  Err.Clear
    
End Sub

Private Function pGetPath(ByVal Path As String) As String
  If Right(Path, 1) <> "\" Then Path = Path & "\"
  pGetPath = Path
End Function

