Attribute VB_Name = "mFile"
Option Explicit

#If PREPROC_SETUP_SERVER Then

' 1) Chequeo que exista y si no existe la creo
' 2) Copio a la carpeta y le cambio los atributos a los archivos
Public Function CopyFiles(ByVal Folder As String) As Boolean
  
  ' 1) Chequeo que exista y si no existe la creo
  If Not pCreateFolder(Folder) Then Exit Function

  ' 2) Copio a la carpeta y le cambio los atributos a los archivos
  If Not pCopyFiles(Folder) Then Exit Function

  CopyFiles = True
End Function

Public Function pCopyFiles(Folder) As Boolean
  fCopyFile.CopyFile App.Path & "\Files", Folder
  
  fCopyFile.Show vbModal
  
  pCopyFiles = fCopyFile.Ok
End Function

#End If

Public Function CreateFolder(ByVal Folder As String) As Boolean
  On Error GoTo ControlError
  
  Dim strError As String
  
  If Not pExistsFolder(Folder) Then
    If Not pCreateFolderAux(Folder, strError) Then
      MsgBox "No se ha podido crear la carpeta '" & Folder & "'." & vbCrLf & vbCrLf & "Error: " & strError, vbCritical + vbOKOnly
      Exit Function
    End If
  End If
  
  CreateFolder = True
  Exit Function
  
ControlError:

#If PREPROC_SETUP_SERVER Then
  MngError "CreateFolder", vbCritical
#Else
  MngError Err, "CreateFolder", "", "", vbCritical
#End If
End Function

Private Function pCreateFolder(ByVal Folder As String) As Boolean
  On Error GoTo ControlError
  
  If pExistsFolder(Folder) Then
    Dim rslt As VbMsgBoxResult
    rslt = MsgBox("La carpeta '" & Folder & "' ya existe." & vbCrLf & vbCrLf & "¿Desea continuar?", vbQuestion + vbYesNo)
    If rslt = vbNo Then Exit Function
  Else
    If Not pCreateFolderAux(Folder) Then Exit Function
  End If
  
  pCreateFolder = True
  Exit Function
  
ControlError:
#If PREPROC_SETUP_SERVER Then
  MngError "pCreateFolder", vbCritical
#Else
  MngError Err, "pCreateFolder", "", "", vbCritical
#End If
End Function

Private Function pCreateFolderAux(ByVal Folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not pExistsFolder(Folder) Then
    If Not pCreateFolderAux(pGetPath(Folder)) Then Exit Function
    If Not pCreateFolderAux2(Folder, strError) Then Exit Function
  End If
  
  strError = Err.Description
  pCreateFolderAux = Err.Number = 0
End Function

Private Function pCreateFolderAux2(ByVal Folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  MkDir Folder
  
  strError = Err.Description
  
  pCreateFolderAux2 = Err.Number = 0
End Function

Private Function pGetPath(ByVal Folder As String) As String
  Dim i As Long
  
  For i = Len(Folder) To 1 Step -1
    If Mid(Folder, i, 1) = "\" Then
      If i > 1 Then pGetPath = Mid(Folder, 1, i - 1)
      Exit Function
    End If
  Next
End Function

Private Function pExistsFolder(ByVal Folder As String) As Boolean
  On Error Resume Next
  Dim rslt As String
  rslt = Dir(Folder, vbDirectory)
  If rslt <> "" Then
    If Not GetAttr(Folder) And vbDirectory Then
      rslt = ""
    End If
  End If
  pExistsFolder = rslt <> ""
End Function

