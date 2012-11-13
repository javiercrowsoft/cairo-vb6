Attribute VB_Name = "mMain"
Option Explicit

Private Declare Function GetComputerName2 Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long

Public Sub Main()
  
  If Not pRegistryActivex() Then Exit Sub

  ShellExecute GetValidPath(App.Path) & "CSCairoSrv.exe " & Command$, vbNormalFocus, False
  'ShellExecute GetValidPath(App.Path) & "CSCairoSmall.exe", vbNormalFocus, False
  'ShellExecute GetValidPath(App.Path) & "CSCairoSmall2.exe", vbNormalFocus, False
End Sub

Public Sub MngError(ByRef Err As Object, ByVal FunctionName As String, ByVal Module As String, ByVal dummy As String)
  MsgBox Err.Description
End Sub

Private Function pRegistryActivex() As Boolean
  Const c_clientesini = "Cliente.ini"
  Const c_clientessection = "CLIENTES"
  Const c_InstalApp = "CSInstall.exe"
  
  Dim ComputerName As String
  Dim iniFile      As String
  
  ComputerName = GetComputerName

  iniFile = GetValidPath(App.Path) & c_clientesini

  If Val(GetIniValue(c_clientessection, ComputerName, 0, iniFile)) = 0 Then
    If Not ShellExecute(GetValidPath(App.Path) & c_InstalApp, vbNormalFocus, True) Then Exit Function
    SaveIniValue c_clientessection, ComputerName, 1, iniFile
  End If
  
  pRegistryActivex = True
End Function

Private Function GetComputerName() As String
  Dim s As String
  s = String(255, " ")
  Dim l As Long
  l = Len(s)

  If GetComputerName2(s, l) <> 0 Then
    GetComputerName = Mid(s, 1, l)
  Else
    GetComputerName = ""
  End If
End Function

Private Function GetValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then Path = Path & "\"
  GetValidPath = Path
End Function

