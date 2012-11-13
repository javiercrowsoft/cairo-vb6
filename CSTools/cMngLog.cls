VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngLog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cMngLog
' 15-06-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMngLog"
' estructuras
' variables privadas
Private m_LogFile               As String
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub Show()
  On Error GoTo ControlError

  Shell "Notepad.exe """ & m_LogFile & """", vbNormalFocus

  GoTo ExitProc
ControlError:
  MngError Err, "Show", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
Public Function Init(ByVal File As String) As Boolean
  On Error GoTo ControlError

  If File = "" Then Exit Function
  
  m_LogFile = File
  
  Log "Iniciando Log"

  GoTo ExitProc
ControlError:
  MngError Err, "Init", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub Log(ByVal Msg As String, Optional ByVal InfoAdd As String)
  On Error GoTo ControlError

  Dim File As Integer
  File = FreeFile

  If m_LogFile = "" Then Exit Sub

  Open m_LogFile For Append Access Write As File
  
  Msg = Format(Now, "dd-mm-yy hh:nn") & ": " & Msg & " ||InfoAdd: " & InfoAdd
  
  Print #File, "-------------------------------------"
  Print #File, Msg

  GoTo ExitProc
ControlError:
  MngError Err, "Log", C_Module, m_LogFile
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close File
End Sub
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
