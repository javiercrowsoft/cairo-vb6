Attribute VB_Name = "mFolder"
Option Explicit

Public Enum csE_CopyFileError
  csEIgnore = 1
  csETryAgain = 2
  csECancel = 3
End Enum

Public Function ExistsFolder(ByVal Folder As String) As Boolean
  On Error Resume Next
  Dim rslt As String
  rslt = Dir(Folder, vbDirectory)
  If rslt <> "" Then
    If Not GetAttr(Folder) And vbDirectory Then
      rslt = ""
    End If
  End If
  ExistsFolder = rslt <> ""
End Function

Public Function ClearFolder(ByVal Folder As String) As Boolean
  On Error GoTo ControlError
  
  Dim strFile     As String
  Dim strError    As String
  
  If ExistsFolder(Folder) Then
    
    strFile = Dir(GetValidPath(Folder) & "*.*")
    While strFile <> vbNullString
      
      If Not DeleteFile(GetValidPath(Folder) & strFile, strError) Then
        MsgError "No se ha podido vaciar la carpeta '" & Folder & "'." & vbCrLf & vbCrLf & "Error: " & strError
        Exit Function
      Else
        strFile = Dir(GetValidPath(Folder) & "*.*")
      End If
    Wend
  End If
  
  ClearFolder = True
  Exit Function
  
ControlError:
  MngError Err, "pClearFolder ", "", ""
End Function

Public Function Continue(ByVal File As String, ByVal strError As String) As csE_CopyFileError
  Dim rslt As VbMsgBoxResult
  Dim msg  As String
  
  msg = "Ha ocurrido un error copiando el archivo '" & File & "'." & vbCrLf & vbCrLf
  msg = msg & "Error: " & strError & vbCrLf & vbCrLf
  rslt = MsgBox(msg, vbAbortRetryIgnore)
  
  Select Case rslt
    Case vbIgnore
      Continue = csEIgnore
    Case vbRetry
      Continue = csETryAgain
    Case vbAbort
      Continue = csECancel
  End Select
End Function

Public Sub SetAttribute(ByVal File As String)
  SetAttr File, vbNormal
End Sub

Public Function CopyFile(ByVal FileSource As String, ByVal FileTo As String) As Boolean
  Dim strError As String
  Dim rslt     As csE_CopyFileError
  
  rslt = csETryAgain
  
  Do While rslt = csETryAgain
    
    DoEvents
    
    If Not CopyFileAux(FileSource, FileTo, strError) Then
      rslt = Continue(FileSource, strError)
      
      If rslt = csECancel Then Exit Function
    Else
      
      SetAttribute FileTo
      Exit Do
    End If
  Loop
  
  CopyFile = True
End Function

Public Function CopyFileAux(ByVal FileSource As String, ByVal FileTo As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not DeleteFile(FileTo, strError) Then Exit Function
  
  FileCopy FileSource, FileTo
  
  strError = Err.Description
  
  CopyFileAux = Err.Number = 0
End Function

Public Function DeleteFile(ByVal File As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If FileExists(File) Then
    SetAttribute File
    Kill File
  End If

  strError = Err.Description

  DeleteFile = Err.Number = 0
End Function

Public Function CreateFolder(ByVal Folder As String) As Boolean
  On Error GoTo ControlError
  
  Dim strError As String
  
  If Not ExistsFolder(Folder) Then
    If Not CreateFolderAux(Folder, strError) Then
      MsgBox "No se ha podido crear la carpeta '" & Folder & "'." & vbCrLf & vbCrLf & "Error: " & strError, vbCritical + vbOKOnly
      Exit Function
    End If
  End If
  
  CreateFolder = True
  Exit Function
  
ControlError:
  MngError Err, "pCreateFolder", "", "", vbCritical
End Function

Public Function CreateFolderAux(ByVal Folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not ExistsFolder(Folder) Then
    If Not CreateFolderAux(GetPath(Folder)) Then Exit Function
    If Not CreateFolderAux2(Folder, strError) Then Exit Function
  End If
  
  strError = Err.Description
  CreateFolderAux = Err.Number = 0
End Function

Public Function CreateFolderAux2(ByVal Folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  MkDir Folder
  
  strError = Err.Description
  
  CreateFolderAux2 = Err.Number = 0
End Function

Public Function GetPath(ByVal Folder As String) As String
  Dim i As Long
  
  For i = Len(Folder) To 1 Step -1
    If Mid(Folder, i, 1) = "\" Then
      If i > 1 Then GetPath = Mid(Folder, 1, i - 1)
      Exit Function
    End If
  Next
End Function

Public Function Ask2(ByVal question As String, _
                     ByVal default As VbMsgBoxResult) As VbMsgBoxResult
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseDefault
  
  Dim fAsk As fAsk
  Set fAsk = New fAsk
  fAsk.cmdIgnore.default = default = vbIgnore
  fAsk.cmdNo.default = default = vbNo
  fAsk.cmdYes.default = default = vbYes
  fAsk.lbQuestion = Replace(question, ";", vbCrLf)
  fAsk.Show vbModal
  Ask2 = fAsk.Answer
  Unload fAsk
End Function

Public Function Ask3(ByVal question As String, _
                     ByVal default As VbMsgBoxResult) As VbMsgBoxResult
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseDefault
  
  Dim Answer As VbMsgBoxResult
  
  Dim fAsk As fAsk
  Set fAsk = New fAsk
  fAsk.cmdIgnore.Caption = "&Cancelar"
  fAsk.cmdIgnore.default = default = vbCancel
  fAsk.cmdNo.default = default = vbNo
  fAsk.cmdYes.default = default = vbYes
  fAsk.lbQuestion = Replace(question, ";", vbCrLf)
  fAsk.Show vbModal
  Answer = fAsk.Answer
  If Answer = vbIgnore Then Answer = vbCancel
  Ask3 = Answer
  Unload fAsk
End Function

Public Function ZipFilesInFolder(ByRef zip As cszip.cZip, _
                                 ByVal Folder As String) As Long
  Dim s       As String
  Dim rtn     As Long
  
  Folder = GetValidPath(Folder)
  
  s = Dir(Folder & "*.*")
  
  While s <> vbNullString
    zip.AddFileSpec Folder & s
    s = Dir()
    rtn = rtn + 1
  Wend
  
  ZipFilesInFolder = rtn
End Function


