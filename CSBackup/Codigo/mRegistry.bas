Attribute VB_Name = "mRegistry"
Option Explicit

Public mReg As cRegistry

Public Const cvRun As String = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\"
 
Public Function VerifyReg(ByVal Key As String, ByVal InitWithWindows As Boolean) As Boolean
  Dim s As String

  s = mReg.GetRegString(cvRun, Key)
  If s <> "" Then
    If Not InitWithWindows Then
      RemoveFromRegistry Key
    End If
  Else
    InsertInRegistry Key, """" & App.Path & "\" & App.EXEName & ".exe"" -r"
  End If
End Function


Public Function InsertInRegistry(ByVal Key As String, ByVal Exe As String) As Boolean
  Dim s As String
  
  s = mReg.GetRegString(cvRun, Key)
  If Len(s) = 0 Then
    If mReg.SetReg(cvRun, Key, Exe) = ERROR_NONE Then
      InsertInRegistry = True
    Else
      MsgBox "No se pudo resgistrar la Aplicación", vbCritical
    End If
  End If
End Function

Public Function RemoveFromRegistry(ByVal Key As String) As Boolean
  Dim s As String
  
  s = mReg.GetRegString(cvRun, Key)
  If s <> "" Then
    If mReg.DeleteValue(cvRun, Key) <> ERROR_NONE Then
      MsgBox "ERROR al eliminar la clave."
    End If
  End If
End Function

