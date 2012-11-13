Attribute VB_Name = "mInstall"
Option Explicit

Private Const C_Module = "mInstall"

Public Sub Register()
  On Error GoTo ControlError
  
  Dim strFile As String
  Dim strPath As String
  Dim strRegsvr32 As String
  
  strRegsvr32 = Environ$("WINDIR") & "\SYSTEM32\REGSVR32.EXE"
  If Not pFileExists(strRegsvr32) Then
    
    strRegsvr32 = Environ$("WINDIR") & "\SYSTEM\REGSVR32.EXE"
    
    If Not pFileExists(strRegsvr32) Then
      
      strRegsvr32 = App.Path & "\REGSVR32.EXE"
      
      If Not pFileExists(strRegsvr32) Then
#If PREPROC_CSSERVER = 0 Then
        MsgBox "No se puede ubicar Regsvr32.exe en " & strRegsvr32, vbCritical, "Error"
#Else
        SaveLog "ERROR: No se puede ubicar Regsvr32.exe en " & strRegsvr32
#End If
        Exit Sub
      End If
    End If
  End If
  
  
#If PREPROC_INSTALL_CLIENT Then

  If Right$(m_Path, 1) <> "\" Then
    strPath = m_Path & "\"
  End If

#Else

  If Right$(App.Path, 1) <> "\" Then
    strPath = App.Path & "\"
  End If
  
#End If
  
  strFile = Dir(strPath & "*.dll")
  pRegister strFile, strPath, strRegsvr32
  
  strFile = Dir(strPath & "*.ocx")
  pRegister strFile, strPath, strRegsvr32
  
#If PREPROC_INSTALL_CLIENT Then

  Unload Me

#Else

#If PREPROC_CSSERVER = 0 Then
  SaveLog "Los componentes se han registrados con exito"
#End If

#End If

  GoTo ExitProc
ControlError:
  MngError Err, "Register", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pRegister(ByVal strFile As String, ByVal strPath As String, ByVal strRegsvr32 As String)
  Dim result      As Long
  
  While strFile <> ""
  
    result = ShellExecute(strRegsvr32 & " /s " & """" & strPath & strFile & """", vbHide, True)
  
#If PREPROC_CSSERVER = 0 Then
    If result = 0 Then
      lsRegister.AddItem "!!!! ERROR: " & strFile
    Else
      lsRegister.AddItem strFile
    End If
#Else
    If result = 0 Then
      SaveLog "ERROR: No se pudo registrar: " & strFile
    Else
      SaveLog "Registro exitoso: " & strFile
    End If
#End If
    
    DoEvents
    
#If PREPROC_CSSERVER = 0 Then
    lsRegister.ListIndex = lsRegister.ListCount - 1
#End If

    strFile = Dir
  Wend
End Sub

Private Function pFileExists(ByVal strFile As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Dir(strFile) <> "" Then
    pFileExists = True
  End If
  
  If Err.Number Then pFileExists = False
End Function

