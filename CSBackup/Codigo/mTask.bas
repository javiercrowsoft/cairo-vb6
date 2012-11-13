Attribute VB_Name = "mTask"
Option Explicit

Public Function LoadTask(ByRef lvTask As ListView) As Boolean
  Dim dbPath   As String
  Dim FileName As String
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))
  
  With lvTask.ColumnHeaders
    .Clear
    .Add , , "Nombre", 3500
    .Add , , "Path", 4500
  End With
  
  lvTask.ListItems.Clear
  
  If Not pValidateFolder(dbPath) Then Exit Function
  
  FileName = Dir(dbPath & "\*_def.xml", vbArchive)
  While FileName <> vbNullString
    
    With lvTask.ListItems.Add(, , FileName, , 2)
      .SubItems(1) = dbPath & "\" & FileName
    End With
    FileName = Dir()
  Wend
  
  Dim i As Integer
  With lvTask.ListItems
    For i = 1 To .Count
      With .Item(i)
        .Tag = pGetDescrip(.SubItems(1))
      End With
    Next
  End With
End Function

Private Function pValidateFolder(ByVal dbPath As String) As Boolean
  On Error Resume Next
  
  If GetAttr(dbPath) <> vbDirectory Then
    MsgBox "No se pudo acceder a la carpeta " & dbPath
    Exit Function
  End If

  pValidateFolder = True
End Function

Private Function pGetDescrip(ByVal TaskFile As String) As String
  Dim Task As cTask
  Set Task = New cTask
  
  If Task.Load(TaskFile, False) Then
    pGetDescrip = Task.Descrip
  End If
End Function
