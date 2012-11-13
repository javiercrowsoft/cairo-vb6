Attribute VB_Name = "Sample"
Option Explicit

'**************************************************
'* NT Service sample                              *
'* © 2000-2001 Sergey Merzlikin                   *
'* http://smsoft.chat.ru                          *
'* e-mail: smsoft@chat.ru                         *
'**************************************************

Public Const Service_Name = "SampleVB6Service"
Public Const INFINITE = -1&      '  Infinite timeout
Private Const WAIT_TIMEOUT = 258&

Public Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion(1 To 128) As Byte      '  Maintenance string for PSS usage
End Type

Public Const VER_PLATFORM_WIN32_NT = 2&

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Declare Function MessageBox Lib "user32" Alias "MessageBoxA" (ByVal hWnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long

Public hStopEvent As Long, hStartEvent As Long, hStopPendingEvent
Public IsNT As Boolean, IsNTService As Boolean
Public ServiceName() As Byte, ServiceNamePtr As Long

Private Sub Main()
    Dim hnd As Long
    Dim h(0 To 1) As Long
    ' Only one instance
    If App.PrevInstance Then Exit Sub
    ' Check OS type
    IsNT = CheckIsNT()
    ' Creating events
    hStopEvent = CreateEvent(0, 1, 0, vbNullString)
    hStopPendingEvent = CreateEvent(0, 1, 0, vbNullString)
    hStartEvent = CreateEvent(0, 1, 0, vbNullString)
    ServiceName = StrConv(Service_Name, vbFromUnicode)
    ServiceNamePtr = VarPtr(ServiceName(LBound(ServiceName)))
    If IsNT Then
        ' Trying to start service
        hnd = StartAsService
        h(0) = hnd
        h(1) = hStartEvent
        ' Waiting for one of two events: sucsessful service start (1) or
        ' terminaton of service thread (0)
        IsNTService = WaitForMultipleObjects(2&, h(0), 0&, INFINITE) = 1&
        If Not IsNTService Then
            CloseHandle hnd
            'MsgBox "This program must be started as service."
            MessageBox 0&, "This program must be started as a service.", App.Title, vbInformation Or vbOKOnly Or vbMsgBoxSetForeground
        End If
    Else
        MessageBox 0&, "This program is only for Windows NT/2000/XP.", App.Title, vbInformation Or vbOKOnly Or vbMsgBoxSetForeground
    End If
    
    If IsNTService Then
        ' ******************
        ' Here you may initialize and start service's objects
        ' These objects must be event-driven and must return control
        ' immediately after starting.
        ' ******************
        SetServiceState SERVICE_RUNNING
        App.LogEvent "VB6 Service Sample started"
        Do
            ' ******************
            ' It is main service loop. Here you may place statements
            ' which perform useful functionality of this service.
            ' ******************
            pPrint "in do"
            
            ' Loop repeats every second. You may change this interval.
        Loop While WaitForSingleObject(hStopPendingEvent, 1000&) = WAIT_TIMEOUT
        
        pPrint "out do"
        
        ' ******************
        ' Here you may stop and destroy service's objects
        ' ******************
        SetServiceState SERVICE_STOPPED
        App.LogEvent "VB6 Service Sample stopped"
        SetEvent hStopEvent
        ' Waiting for service thread termination
        WaitForSingleObject hnd, INFINITE
        CloseHandle hnd
    End If
    CloseHandle hStopEvent
    CloseHandle hStartEvent
    CloseHandle hStopPendingEvent
End Sub

' CheckIsNT() returns True, if the program runs
' under Windows NT or Windows 2000, and False
' otherwise.
Public Function CheckIsNT() As Boolean
    Dim OSVer As OSVERSIONINFO
    OSVer.dwOSVersionInfoSize = LenB(OSVer)
    GetVersionEx OSVer
    CheckIsNT = OSVer.dwPlatformId = VER_PLATFORM_WIN32_NT
End Function

Private Sub pPrint(ByVal s As String)
  Static i As Integer
  Open "C:\DownLoad\Programacion\service\smsoft\Codigo\log.txt" For Append As #1
  i = i + 1
  Print #1, s & " " & i
  Close #1
End Sub
