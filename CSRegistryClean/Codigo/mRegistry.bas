Attribute VB_Name = "mRegistry"
Option Explicit

Public mReg As cRegistry

Public Const cvRun As String = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\"
 
Public Const cvTypeRun As String = "HKEY_CLASSES_ROOT\TypeLib"

Public Function SearchInRegistryTypeLib(ByVal toSearch As String, ByRef lsKeys As ListView, ByRef f As Form)
  Dim Keys As Collection
  
  lsKeys.ListItems.Clear
  
  Dim i As Long
  
  Set Keys = mReg.SearchInTypeLib("TypeLib", toSearch, f)

  For i = 1 To Keys.Count
    With lsKeys.ListItems.Add(, , Keys(i).Key)
      .SubItems(1) = Keys(i).Description
      .SubItems(2) = Keys(i).Path
      .SubItems(3) = Keys(i).Extra
      .SubItems(4) = "TypeLib"
    End With
  Next

  Set Keys = mReg.SearchInTypeLib("CLSID", toSearch, f)
  
  For i = 1 To Keys.Count
    With lsKeys.ListItems.Add(, , Keys(i).Key)
      .SubItems(1) = Keys(i).Description
      .SubItems(2) = Keys(i).Path
      .SubItems(3) = Keys(i).Extra
      .SubItems(4) = "CLSID"
    End With
  Next

End Function

Public Function DeleteKeys(ByRef lsKeys As ListView, ByRef f As Form)
  Dim i As Long
  
  For i = 1 To lsKeys.ListItems.Count
    
    mReg.DeleteRegistryKey lsKeys.ListItems.Item(i).SubItems(4), lsKeys.ListItems.Item(i)
  
  Next
  
End Function

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
