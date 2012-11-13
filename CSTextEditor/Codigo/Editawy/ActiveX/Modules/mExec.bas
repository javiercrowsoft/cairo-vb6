Attribute VB_Name = "mExec"
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

'=================================================================
'=================================================================
'''''''''''''''''''''
'''   Constants   '''
'''''''''''''''''''''
' STARTUPINFO flags
Public Const STARTF_USESHOWWINDOW = &H1
Public Const STARTF_USESTDHANDLES = &H100
' ShowWindow flags
Public Const SW_HIDE = 0
' DuplicateHandle flags
Public Const DUPLICATE_CLOSE_SOURCE = &H1
Public Const DUPLICATE_SAME_ACCESS = &H2
' Error codes
Public Const ERROR_BROKEN_PIPE = 109

'''''''''''''''''
'''   Types   '''
'''''''''''''''''
Public Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
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

Public Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessId As Long
    dwThreadId As Long
End Type

Public Const PROCESS_ALL_ACCESS = &H1F0FFF

''''''''''''''''''''
'''   Declares   '''
''''''''''''''''''''
Public Declare Function CreatePipe Lib "KERNEL32" (phReadPipe As Long, phWritePipe As Long, lpPipeAttributes As Any, ByVal nSize As Long) As Long
Public Declare Function ReadFile Lib "KERNEL32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToRead As Long, lpNumberOfBytesRead As Long, lpOverlapped As Any) As Long
Public Declare Function CreateProcess Lib "KERNEL32" Alias "CreateProcessA" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, lpProcessAttributes As Any, lpThreadAttributes As Any, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, lpEnvironment As Any, ByVal lpCurrentDriectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
Public Declare Function GetCurrentProcess Lib "KERNEL32" () As Long
Public Declare Function DuplicateHandle Lib "KERNEL32" (ByVal hSourceProcessHandle As Long, ByVal hSourceHandle As Long, ByVal hTargetProcessHandle As Long, lpTargetHandle As Long, ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwOptions As Long) As Long
Public Declare Function CloseHandle Lib "KERNEL32" (ByVal hObject As Long) As Long
Public Declare Function OemToCharBuff Lib "user32" Alias "OemToCharBuffA" (lpszSrc As Any, ByVal lpszDst As String, ByVal cchDstLength As Long) As Long
Public Declare Function GetExitCodeProcess Lib "KERNEL32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Public Declare Function TerminateProcess Lib "KERNEL32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long
'===========================================================
'==========================================================
' Module to find out what version operating system this DLL
' is installed on. Since Windows 9x uses command.com as the
' command interpreter and Windows NT uses cmd.exe, we have
' to know what we're working with here to be able to shell
' DOS programs.

Public Const VER_PLATFORM_WIN32s = 0
Public Const VER_PLATFORM_WIN32_WINDOWS = 1
Public Const VER_PLATFORM_WIN32_NT = 2

Public Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion      As Long
    dwMinorVersion      As Long
    dwBuildNumber       As Long
    dwPlatformId        As Long
    szCSDVersion        As String * 128
End Type

Public Declare Function GetVersionEx Lib "KERNEL32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Public Const STATUS_PENDING = &H103&
'=================================================================
'=================================================================

'================================================================
' Check what our OS is and send it to the caller
' either 3.x, 9x, or NT
Public Function CheckOS() As Long
  Dim OSInfo As OSVERSIONINFO
  OSInfo.dwOSVersionInfoSize = Len(OSInfo)
  GetVersionEx OSInfo
  CheckOS = OSInfo.dwPlatformId
End Function
'==================================================================

