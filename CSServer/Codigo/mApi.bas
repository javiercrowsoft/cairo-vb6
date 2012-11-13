Attribute VB_Name = "mApi"
Option Explicit

'--------------------------------------------------------------------------------
' mApi
' 03-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mApi"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetWindowsDir() As String
  Dim strFolder As String
  Dim n As Integer
  strFolder = String$(255, " ")
  n = GetWindowsDirectory(strFolder, Len(strFolder))
  GetWindowsDir = Left$(strFolder, n)
End Function

Public Function GetValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then Path = Path & "\"
  GetValidPath = Path
End Function

Public Function FileExists(ByVal File As String) As Boolean
  On Error Resume Next
  Err.Clear
  FileExists = Dir(File) <> ""
  If Err.Number <> 0 Then
    FileExists = False
  End If
End Function
' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


