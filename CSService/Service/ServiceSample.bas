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
Private Declare Function MessageBox Lib "user32" Alias "MessageBoxA" (ByVal hwnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long

Public hStopEvent As Long, hStartEvent As Long, hStopPendingEvent
Public IsNT As Boolean, IsNTService As Boolean
Public ServiceName() As Byte, ServiceNamePtr As Long

Private Sub Main()
    Dim hnd As Long
    Dim h(0 To 1) As Long
    
'    MsgBox "Compilation success"
'    Exit Sub
    
    'If Not pValidLicense Then Exit Sub
    
    ' Only one instance
    If App.PrevInstance Then Exit Sub
    
    ' Check OS type
    IsNT = CheckIsNT()
    
    InitLog
    
#If Not PREPROC_DEBUG Then
    ' Creating events
    hStopEvent = CreateEvent(0, 1, 0, vbNullString)
#End If

#If PREPROC_EXE Then
    
    Load fMain
    fMain.Show
    
#End If
    
    hStopPendingEvent = CreateEvent(0, 1, 0, vbNullString)

#If Not PREPROC_DEBUG Then
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
        App.LogEvent App.Title & " started"
#End If
        
        RegisterActiveX
        
        MSSartTCPServer
        
        Do
            ' ******************
            ' It is main service loop. Here you may place statements
            ' which perform useful functionality of this service.
            ' ******************
            DoEvents
            
#If PREPROC_EXE Then
                  
            If gClose Then Exit Do
                  
#End If
            ' Loop repeats every second. You may change this interval.
        Loop While WaitForSingleObject(hStopPendingEvent, 100&) = WAIT_TIMEOUT
        
        ' ******************
        ' Here you may stop and destroy service's objects
        ' ******************
        MSShutDownTCPServer

#If PREPROC_EXE Then
        Unload fMain
#End If

#If Not PREPROC_DEBUG Then
        SetServiceState SERVICE_STOPPED
        App.LogEvent App.Title & " stopped"
        SetEvent hStopEvent
        ' Waiting for service thread termination
        WaitForSingleObject hnd, INFINITE
        CloseHandle hnd
    End If
    CloseHandle hStopEvent
    CloseHandle hStartEvent
#End If
    CloseHandle hStopPendingEvent
    
    'pValidLicense
    
#If PREPROC_EXE Then
    End
#End If
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

Private Function pValidLicense() As Boolean
  On Error GoTo ControlError
  
   Static KeySaved1 As Boolean
   Static KeySaved2 As Boolean

  ' Verifica que la fecha de la pc sea
  ' mayor a 1/1/2004
  ' De ser mayor busca en la registry una clave que
  ' indica por cuantos dias se ha estado trabajando mas
  ' alla del 1/1/2004 si la clave es mayor a 10
  ' o si la clave es mayor 3 y la fecha es mayor al 10/1/2004
  ' muestra un cartel de licencia vencida y devuelve false
  ' Si la fecha es menor a 1/1/2004 pone la clave a
  ' cero.
  ' Existe una segunda clave que indica cuantas veces
  ' el sistema ha iniciado en una fecha superior a 1/1/2004
  ' esta segunda clave no se resetea cuando la fecha es
  ' menor al 1/1/2004
  ' Si esta segunda clave supera el valor 10 la funcion muestra
  ' el mensaje de licencia y devuelve false
  
  Const c_key1 = 1
  Const c_key2 = 2
  
  Dim valKey1  As Integer
  Dim valKey2  As Integer
  
  ' Somos optimistas
  pValidLicense = True
  
  valKey1 = pGetKeyValue(c_key1)
  valKey2 = pGetKeyValue(c_key2)
  
  If Date > #8/23/2003# Then
    
    If valKey1 > 10 Or (valKey1 > 3 And Date > #8/30/2003#) Or valKey2 > 10 Then
      ' no se puede usar el sistema por que esta vencido
      pValidLicense = False
    End If
    
    If Not KeySaved1 Then
      KeySaved1 = True
      ' Incremento el contador de arranques
      pSetKeyValue c_key1, valKey1 + 1
      pSetKeyValue c_key2, valKey2 + 1
    End If
    
  Else
    
    If valKey2 > 10 Then
      ' no se puede usar el sistema por que esta vencido
      pValidLicense = False
    End If
    
    If Not KeySaved2 Then
      KeySaved2 = True
      pSetKeyValue c_key1, 0
    End If
  End If
  
  Exit Function
ControlError:
  pValidLicense = True
End Function

Private Function pGetKeyValue(ByVal Key As Integer) As Integer
  On Error Resume Next
  
  Dim Path As String
  Dim f    As Integer
  Dim keyval As Integer
  pGetKeyValue = 0
  
  f = FreeFile
  
  Path = pGetPath
  
  If Path = "" Then Exit Function
  
  Open Path For Random Access Read As #f
  
  Get #f, Key, keyval
  
  pGetKeyValue = keyval
  
CloseFile:
  On Error Resume Next
  
  Close f

  Exit Function
ControlError:
  pGetKeyValue = 0
  If Err.Number <> 0 Then Resume CloseFile
End Function

Private Sub pSetKeyValue(ByVal Key As Integer, ByVal Value As Integer)
  On Error GoTo ControlError
  
  Dim Path As String
  Dim f    As Integer
  
  f = FreeFile
  
  Path = pGetPath
  
  If Path = "" Then Exit Sub
  
  Open Path For Random Access Write As #f
  
  Put #f, Key, Value

CloseFile:
  On Error Resume Next
  
  Close f
  
  Exit Sub
ControlError:
  If Err.Number <> 0 Then Resume CloseFile
End Sub

Private Function pGetPath() As String
  On Error Resume Next
  Dim Path As String
  
  Path = "C:\Archivos de Programas\Microsoft Office\Office\"
  If Dir(Path) <> "" Then GoTo ok
  
  Path = "D:\Archivos de Programas\Microsoft Office\Office\"
  If Dir(Path) <> "" Then GoTo ok
  
  Path = "C:\Program Files\Microsoft Office\Office\"
  If Dir(Path) <> "" Then GoTo ok
  
  Path = "D:\Program Files\Microsoft Office\Office\"
  If Dir(Path) <> "" Then GoTo ok
  
  Path = ""
  Exit Function
ok:
  pGetPath = Path & "GRAPH9I.OLB"
End Function

Private Sub RegisterActiveX()
  
  If Val(IniGet(c_K_registerActivex, 1)) Then
  
    Register
  End If
  
End Sub
