Attribute VB_Name = "mClientIni"
Option Explicit

'--------------------------------------------------------------------------------
' cMngIni
' 25-10-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Public Declare Function GetpublicProfileString Lib "kernel32" Alias "GetpublicProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
    Public Declare Function WritepublicProfileString Lib "kernel32" Alias "WritepublicProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'--------------------------------------------------------------------------------

' constantes
Public Const C_Module = "mAfipIni"

Public Const c_MainIniFile = "CSAfipWebClient.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public Const c_K_Log = "Log"
Public Const c_K_connstr = "Connect"
' estructuras
' variables privadas
Public m_logFile             As String

' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Now & " " & msg
  Close f
End Sub

Public Function pGetPath(ByVal path As String) As String
  If Right(path, 1) <> "\" Then path = path & "\"
  pGetPath = path
End Function

Public Sub MngError(ByRef errObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  pSaveLog errObj.Description
End Sub
' funciones friend
' funciones privadas
'//////////////////////////////////////////////////////////////////////////////
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

