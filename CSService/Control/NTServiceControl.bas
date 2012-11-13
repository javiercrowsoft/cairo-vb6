Attribute VB_Name = "NTServiceControl"
Option Explicit

'**************************************************
'* NT Service sample Control Program              *
'* © 2000-2001 Sergey Merzlikin                   *
'* http://smsoft.chat.ru                          *
'* e-mail: smsoft@chat.ru                         *
'**************************************************

Private Const ERROR_SERVICE_DOES_NOT_EXIST = 1060&
Private Const SERVICE_WIN32_OWN_PROCESS = &H10&
'Private Const SERVICE_WIN32_SHARE_PROCESS = &H20&
'Private Const SERVICE_WIN32 = SERVICE_WIN32_OWN_PROCESS + _
                                 SERVICE_WIN32_SHARE_PROCESS
'Private Const SERVICE_ACCEPT_STOP = &H1
'Private Const SERVICE_ACCEPT_PAUSE_CONTINUE = &H2
'Private Const SERVICE_ACCEPT_SHUTDOWN = &H4
Private Const SC_MANAGER_CONNECT = &H1&
Private Const SC_MANAGER_CREATE_SERVICE = &H2&
'Private Const SC_MANAGER_ENUMERATE_SERVICE = &H4
'Private Const SC_MANAGER_LOCK = &H8
'Private Const SC_MANAGER_QUERY_LOCK_STATUS = &H10
'Private Const SC_MANAGER_MODIFY_BOOT_CONFIG = &H20
Private Const STANDARD_RIGHTS_REQUIRED = &HF0000
Private Const SERVICE_QUERY_CONFIG = &H1&
Private Const SERVICE_CHANGE_CONFIG = &H2&
Private Const SERVICE_QUERY_STATUS = &H4&
Private Const SERVICE_ENUMERATE_DEPENDENTS = &H8&
Private Const SERVICE_START = &H10&
Private Const SERVICE_STOP = &H20&
Private Const SERVICE_PAUSE_CONTINUE = &H40&
Private Const SERVICE_INTERROGATE = &H80&
Private Const SERVICE_USER_DEFINED_CONTROL = &H100&
Private Const SERVICE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED Or _
                                       SERVICE_QUERY_CONFIG Or _
                                       SERVICE_CHANGE_CONFIG Or _
                                       SERVICE_QUERY_STATUS Or _
                                       SERVICE_ENUMERATE_DEPENDENTS Or _
                                       SERVICE_START Or _
                                       SERVICE_STOP Or _
                                       SERVICE_PAUSE_CONTINUE Or _
                                       SERVICE_INTERROGATE Or _
                                       SERVICE_USER_DEFINED_CONTROL)
Private Const SERVICE_AUTO_START As Long = 2
'Private Const SERVICE_DEMAND_START As Long = 3
Private Const SERVICE_ERROR_NORMAL As Long = 1
Private Const ERROR_INSUFFICIENT_BUFFER = 122&
Private Enum SERVICE_CONTROL
    SERVICE_CONTROL_STOP = 1&
    SERVICE_CONTROL_PAUSE = 2&
    SERVICE_CONTROL_CONTINUE = 3&
    SERVICE_CONTROL_INTERROGATE = 4&
    SERVICE_CONTROL_SHUTDOWN = 5&
End Enum
Public Enum SERVICE_STATE
    SERVICE_STOPPED = &H1
    SERVICE_START_PENDING = &H2
    SERVICE_STOP_PENDING = &H3
    SERVICE_RUNNING = &H4
    SERVICE_CONTINUE_PENDING = &H5
    SERVICE_PAUSE_PENDING = &H6
    SERVICE_PAUSED = &H7
End Enum
Private Type SERVICE_STATUS
    dwServiceType As Long
    dwCurrentState As Long
    dwControlsAccepted As Long
    dwWin32ExitCode As Long
    dwServiceSpecificExitCode As Long
    dwCheckPoint As Long
    dwWaitHint As Long
End Type
Private Type QUERY_SERVICE_CONFIG
    dwServiceType As Long
    dwStartType As Long
    dwErrorControl As Long
    lpBinaryPathName As Long
    lpLoadOrderGroup As Long
    dwTagId As Long
    lpDependencies As Long
    lpServiceStartName As Long
    lpDisplayName As Long
End Type
Private Declare Function OpenSCManager _
      Lib "advapi32" Alias "OpenSCManagerA" _
      (ByVal lpMachineName As String, ByVal lpDatabaseName As String, _
      ByVal dwDesiredAccess As Long) As Long
Private Declare Function CreateService _
      Lib "advapi32" Alias "CreateServiceA" _
      (ByVal hSCManager As Long, ByVal lpServiceName As String, _
      ByVal lpDisplayName As String, ByVal dwDesiredAccess As Long, _
      ByVal dwServiceType As Long, ByVal dwStartType As Long, _
      ByVal dwErrorControl As Long, ByVal lpBinaryPathName As String, _
      ByVal lpLoadOrderGroup As String, ByVal lpdwTagId As String, _
      ByVal lpDependencies As String, ByVal lp As String, _
      ByVal lpPassword As String) As Long
Private Declare Function DeleteService _
      Lib "advapi32" (ByVal hService As Long) As Long
Private Declare Function CloseServiceHandle _
      Lib "advapi32" (ByVal hSCObject As Long) As Long
Private Declare Function OpenService _
      Lib "advapi32" Alias "OpenServiceA" _
      (ByVal hSCManager As Long, ByVal lpServiceName As String, _
      ByVal dwDesiredAccess As Long) As Long   '** Change SERVICE_NAME as needed
Private Declare Function QueryServiceConfig Lib "advapi32" _
      Alias "QueryServiceConfigA" (ByVal hService As Long, _
      lpServiceConfig As QUERY_SERVICE_CONFIG, _
      ByVal cbBufSize As Long, pcbBytesNeeded As Long) As Long
Private Declare Function QueryServiceStatus Lib "advapi32" _
    (ByVal hService As Long, lpServiceStatus As SERVICE_STATUS) As Long
Private Declare Function ControlService Lib "advapi32" _
        (ByVal hService As Long, ByVal dwControl As SERVICE_CONTROL, _
        lpServiceStatus As SERVICE_STATUS) As Long
Private Declare Function StartService Lib "advapi32" _
        Alias "StartServiceA" (ByVal hService As Long, _
        ByVal dwNumServiceArgs As Long, ByVal lpServiceArgVectors As Long) As Long
Private Declare Function NetWkstaUserGetInfo Lib "Netapi32" (ByVal reserved As Any, ByVal Level As Long, lpBuffer As Any) As Long
Private Declare Function NetApiBufferFree Lib "Netapi32" (ByVal lpBuffer As Long) As Long

Private Declare Function lstrcpy Lib "kernel32" Alias "lstrcpyA" (ByVal lpString1 As Any, ByVal lpString2 As Any) As Long
Private Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As Any) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal length As Long)
Private Declare Function lstrlenW Lib "kernel32" (ByVal lpString As Long) As Long

'Private Const SERVICE_NAME As String = "SampleVB6Service"
'Private Const Service_Display_Name As String = "Sample VB6 Service"
'Private Const Service_File_Name As String = "SvSample.exe"

Public SERVICE_NAME As String
Public Service_Display_Name As String
Public Service_File_Name As String

' This function returns current service status
' or 0 on error
Public Function GetServiceStatus() As SERVICE_STATE
Dim hSCManager As Long, hService As Long, Status As SERVICE_STATUS
hSCManager = OpenSCManager(vbNullString, vbNullString, _
                       SC_MANAGER_CONNECT)
If hSCManager <> 0 Then
    hService = OpenService(hSCManager, SERVICE_NAME, SERVICE_QUERY_STATUS)
    If hService <> 0 Then
        If QueryServiceStatus(hService, Status) Then
            GetServiceStatus = Status.dwCurrentState
        End If
        CloseServiceHandle hService
    End If
    CloseServiceHandle hSCManager
End If
End Function

' This function fills Service Account field in form.
' It returns nonzero value on error

Public Function GetServiceConfig() As Long
Dim hSCManager As Long, hService As Long
Dim r As Long, SCfg() As QUERY_SERVICE_CONFIG, r1 As Long, s As String

hSCManager = OpenSCManager(vbNullString, vbNullString, _
                       SC_MANAGER_CONNECT)
If hSCManager <> 0 Then
    hService = OpenService(hSCManager, SERVICE_NAME, SERVICE_QUERY_CONFIG)
    If hService <> 0 Then
        ReDim SCfg(1 To 1)
        If QueryServiceConfig(hService, SCfg(1), 36, r) = 0 Then
            If Err.LastDllError = ERROR_INSUFFICIENT_BUFFER Then
                r1 = r \ 36 + 1
                ReDim SCfg(1 To r1)
                If QueryServiceConfig(hService, SCfg(1), r1 * 36, r) <> 0 Then
                    s = Space$(255)
                    lstrcpy s, SCfg(1).lpServiceStartName
                    s = Left$(s, lstrlen(s))
                    frmServiceControl.txtAccount = s
                Else
                    GetServiceConfig = Err.LastDllError
                End If
            Else
                GetServiceConfig = Err.LastDllError
            End If
        End If
        CloseServiceHandle hService
    Else
        GetServiceConfig = Err.LastDllError
    End If
    CloseServiceHandle hSCManager
Else
    GetServiceConfig = Err.LastDllError
End If
End Function

' This function installs service on local computer
' It returns nonzero value on error
Public Function SetNTService() As Long
  Dim hSCManager As Long
  Dim hService As Long, DomainName As String
  
  If frmServiceControl.txtAccount <> "LocalSystem" Then
  ' Add domain name to account string
      If InStr(1, frmServiceControl.txtAccount, "\") = 0 Then
          DomainName = GetDomainName()
          If DomainName = "" Then DomainName = "."
          frmServiceControl.txtAccount.Text = DomainName & "\" & frmServiceControl.txtAccount.Text
      End If
  End If
  hSCManager = OpenSCManager(vbNullString, vbNullString, _
                         SC_MANAGER_CREATE_SERVICE)
  If hSCManager <> 0 Then
  ' Install service to manual start. To set service to autostart
  ' replace SERVICE_DEMAND_START to SERVICE_AUTO_START
      hService = CreateService(hSCManager, SERVICE_NAME, _
                         Service_Display_Name, SERVICE_ALL_ACCESS, _
                         SERVICE_WIN32_OWN_PROCESS, _
                         SERVICE_AUTO_START, SERVICE_ERROR_NORMAL, _
                         Service_File_Name, vbNullString, _
                         vbNullString, vbNullString, frmServiceControl.txtAccount, _
                         frmServiceControl.txtPassword)
      If hService <> 0 Then
          CloseServiceHandle hService
      Else
          SetNTService = Err.LastDllError
      End If
      CloseServiceHandle hSCManager
  Else
      SetNTService = Err.LastDllError
  End If
End Function

' This function uninstalls service
' It returns nonzero value on error
Public Function DeleteNTService() As Long
Dim hSCManager As Long
Dim hService As Long, Status As SERVICE_STATUS

hSCManager = OpenSCManager(vbNullString, vbNullString, _
                       SC_MANAGER_CONNECT)
If hSCManager <> 0 Then
    hService = OpenService(hSCManager, SERVICE_NAME, _
                       SERVICE_ALL_ACCESS)
    If hService <> 0 Then
' Stop service if it is running
        ControlService hService, SERVICE_CONTROL_STOP, Status
        If DeleteService(hService) = 0 Then
            DeleteNTService = Err.LastDllError
        End If
        CloseServiceHandle hService
    Else
        DeleteNTService = Err.LastDllError
    End If
    CloseServiceHandle hSCManager
Else
    DeleteNTService = Err.LastDllError
End If

End Function

' This function returns local network domain name
' or zero-length string on error
Public Function GetDomainName() As String
Dim lpBuffer As Long, l As Long, p As Long
If NetWkstaUserGetInfo(0&, 1&, lpBuffer) = 0 Then
    CopyMemory p, ByVal lpBuffer + 4, 4
    l = lstrlenW(p)
    If l > 0 Then
        GetDomainName = Space$(l)
        CopyMemory ByVal StrPtr(GetDomainName), ByVal p, l * 2
    End If
    NetApiBufferFree lpBuffer
End If
End Function

' This function starts service
' It returns nonzero value on error
Public Function StartNTService() As Long
  Dim hSCManager As Long, hService As Long
  hSCManager = OpenSCManager(vbNullString, vbNullString, _
                         SC_MANAGER_CONNECT)
  If hSCManager <> 0 Then
      hService = OpenService(hSCManager, SERVICE_NAME, SERVICE_START)
      If hService <> 0 Then
          If StartService(hService, 0, 0) = 0 Then
              StartNTService = Err.LastDllError
          End If
      CloseServiceHandle hService
      Else
          StartNTService = Err.LastDllError
      End If
  CloseServiceHandle hSCManager
  Else
      StartNTService = Err.LastDllError
  End If
End Function

' This function stops service
' It returns nonzero value on error
Public Function StopNTService() As Long
Dim hSCManager As Long, hService As Long, Status As SERVICE_STATUS
hSCManager = OpenSCManager(vbNullString, vbNullString, _
                       SC_MANAGER_CONNECT)
If hSCManager <> 0 Then
    hService = OpenService(hSCManager, SERVICE_NAME, SERVICE_STOP)
    If hService <> 0 Then
        If ControlService(hService, SERVICE_CONTROL_STOP, Status) = 0 Then
            StopNTService = Err.LastDllError
        End If
    CloseServiceHandle hService
    Else
        StopNTService = Err.LastDllError
    End If
CloseServiceHandle hSCManager
Else
    StopNTService = Err.LastDllError
End If
End Function

#If PREPROC_INSTALL = 0 Then

  Private Sub Main()
    SERVICE_NAME = IniGet(c_k_SERVICE_NAME, "")
    Service_Display_Name = IniGet(c_k_Service_Display_Name, "")
    Service_File_Name = IniGet(c_k_Service_File_Name, "")
    frmServiceControl.Show
  End Sub

#Else

  Public Function InstallService(ByVal ServiceName As String, _
                                 ByVal ServiceDisplay As String, _
                                 ByVal ServiceFile As String) As Boolean
    SERVICE_NAME = ServiceName
    Service_Display_Name = ServiceDisplay
    Service_File_Name = ServiceFile
    frmServiceControl.Show vbModal
    InstallService = frmServiceControl.Ok
  End Function

#End If

#If PREPROC_INSTALL = 0 Then

  Public Function MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
    MsgBox ">>ERROR: " & Err.Number & " - " & Err.Description & ";>>FUNCTION: " & FunctionName & ";>>MODULE: " & Module & ";>>INFOADD: " & InfoAdd & ";"
  End Function
  
#End If
