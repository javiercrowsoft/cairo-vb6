Attribute VB_Name = "mSchedule"
Option Explicit

Public Function LoadSchedule(ByRef lvSchedule As ListView) As Boolean
  Dim dbPath   As String
  Dim FileName As String
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))
  
  With lvSchedule.ColumnHeaders
    .Clear
    .Add , , "Nombre", 3500
    .Add , , "Path", 4500
  End With
  
  lvSchedule.ListItems.Clear
  
  If Not pValidateFolder(dbPath) Then Exit Function
  
  FileName = Dir(dbPath & "\*_sch.xml", vbArchive)
  While FileName <> vbNullString
    
    With lvSchedule.ListItems.Add(, , FileName, , 1)
      .SubItems(1) = dbPath & "\" & FileName
    End With
    FileName = Dir()
  Wend
End Function

Private Function pValidateFolder(ByVal dbPath As String) As Boolean
  On Error Resume Next
  
  If GetAttr(dbPath) <> vbDirectory Then
    MsgBox "No se pudo acceder a la carpeta " & dbPath
    Exit Function
  End If

  pValidateFolder = True
End Function


