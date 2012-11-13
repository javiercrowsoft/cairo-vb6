Attribute VB_Name = "mMain"
Option Explicit

Private Declare Function GetComputerName2 Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long

Public Sub Main()
  On Error Resume Next
  
  Load fLogin
  
  If Not fLogin.DontShow Then
    fLogin.Show
  Else
    StartCairo
    Unload fLogin
  End If
  
End Sub

Public Sub StartCairo()
  Dim cmdLine As String
  
  If fLogin.server <> vbNullString Then

    cmdLine = GetValidPath(App.Path) & _
                 "QBOnix_.exe server=" & fLogin.server & _
                 ";port=" & fLogin.Port

  Else
    cmdLine = GetValidPath(App.Path) & _
                 "QBOnix_.exe"
  
  End If
  
  ShellExecute cmdLine, _
               vbNormalFocus, False
  
  'ShellExecute GetValidPath(App.Path) & "CSCairoSmall.exe", vbNormalFocus, False
  'ShellExecute GetValidPath(App.Path) & "CSCairoSmall2.exe", vbNormalFocus, False
End Sub

Public Sub MngError(ByRef Err As Object, ByVal FunctionName As String, ByVal Module As String, ByVal dummy As String)
  MsgBox Err.Description
End Sub

Public Function GetValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then Path = Path & "\"
  GetValidPath = Path
End Function
