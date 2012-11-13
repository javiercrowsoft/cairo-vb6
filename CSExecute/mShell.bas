Attribute VB_Name = "mShell"
Option Explicit

'--------------------------------------------------------------------------------
' mShell
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const NORMAL_PRIORITY_CLASS = &H20&
    ' estructuras
    ' funciones
    Public Type PROCESS_INFORMATION
      hProcess As Long
      hThread As Long
      dwProcessId As Long
      dwThreadId As Long
    End Type

    Public Type STARTUPINFO
      cb As Long
      lpReserved As String
      lpDesktop As String
      lpTitle As String
      dwX As Long
      dwY As Long
      dwXSize As Long
      dwYSize As Long
      dwXCountChars As Long
      dwYCountChars As Long
      dwFillAttribute As Long
      dwFlags As Long
      wShowWindow As Integer
      cbReserved2 As Integer
      lpReserved2 As Long
      hStdInput As Long
      hStdOutput As Long
      hStdError As Long
    End Type

    Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
    Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
    Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
    Private Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
    Public Const SW_SHOWNORMAL = 1
    Private Const INFINITE = &HFFFF

    Public Declare Function CreateProcess Lib "kernel32" _
       Alias "CreateProcessA" _
       (ByVal lpApplicationName As String, _
       ByVal lpCommandLine As String, _
       lpProcessAttributes As Any, _
       lpThreadAttributes As Any, _
       ByVal bInheritHandles As Long, _
       ByVal dwCreationFlags As Long, _
       lpEnvironment As Any, _
       ByVal lpCurrentDriectory As String, _
       lpStartupInfo As STARTUPINFO, _
       lpProcessInformation As PROCESS_INFORMATION) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mShell"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public Function ShellExecute(ByVal shelstmt As String, _
                             ByVal TypeFocus As VbAppWinStyle, _
                             Optional ByVal bWait As Boolean) As Boolean
                             
  On Error GoTo ControlError

  Dim hProc, Retval As Long

  Dim pInfo As PROCESS_INFORMATION
  Dim sInfo As STARTUPINFO
  Dim sNull As String
  Dim lSuccess As Long
  Dim lRetValue As Long

  Const PROCESS_ALL_ACCESS = 0

  sInfo.cb = Len(sInfo)
  lSuccess = CreateProcess(sNull, _
                          shelstmt, _
                          ByVal 0&, _
                          ByVal 0&, _
                          1&, _
                          NORMAL_PRIORITY_CLASS, _
                          ByVal 0&, _
                          sNull, _
                          sInfo, _
                          pInfo)

  Err.Clear
  
#If PREPROC_INSTALL = 0 And _
    PREPROC_KERNEL_CLIENT = 0 And _
    PREPROC_CAIRO_LAUNCH = 0 And _
    PREPROC_CSSERVER = 0 Then

  If gLogTrafic Then
    SaveLog "Task Id: " & hprog
  
    SaveLog "Error Description: " & Err.Description
  End If
  
#End If

  If bWait Then
  
    'Get process handle
    Do While pIsActive(pInfo.hProcess)
      DoEvents
    Loop
  
    hProc = OpenProcess(PROCESS_ALL_ACCESS, False, pInfo.hProcess)
    
    'wait until the process terminates
    If hProc <> 0 Then
      Retval = WaitForSingleObject(hProc, INFINITE)
      CloseHandle hProc
    End If
  End If
  
  lRetValue = CloseHandle(pInfo.hThread)
  lRetValue = CloseHandle(pInfo.hProcess)
  
  ShellExecute = True
  
  GoTo ExitProc
ControlError:
  
#If PREPROC_INSTALL = 0 And PREPROC_KERNEL_CLIENT = 0 Then
  
  MngError Err, "ShellExecute", C_Module, ""
  
#ElseIf PREPROC_KERNEL_CLIENT Then

  MngError_ Err, "ShellExecute", C_Module, ""
  
#End If

  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function pIsActive(ByVal hprog As Long) As Long
  On Error GoTo ControlError

  Dim hProc, Retval As Long

  Const STILL_ACTIVE = 259

  GetExitCodeProcess hprog, Retval

  pIsActive = (Retval = STILL_ACTIVE)
  CloseHandle hProc
  GoTo ExitProc
ControlError:
  
#If PREPROC_INSTALL = 0 And PREPROC_KERNEL_CLIENT = 0 Then
  
  MngError Err, "pIsActive", C_Module, ""
  
#ElseIf PREPROC_KERNEL_CLIENT Then

  MngError_ Err, "pIsActive", C_Module, ""
  
#End If
  
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function
' propiedadades friend
' propiedades privadas
' funciones publicas
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

