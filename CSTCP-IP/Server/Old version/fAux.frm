VERSION 5.00
Object = "{E7BC34A0-BA86-11CF-84B1-CBC2DA68BF6C}#1.0#0"; "NTSVC.OCX"
Begin VB.Form fAux 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin NTService.NTService NTService 
      Left            =   45
      Top             =   90
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      DisplayName     =   "VBService"
      ServiceName     =   "VBService"
      StartMode       =   3
   End
End
Attribute VB_Name = "fAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
  On Error GoTo Err_Load

  Dim strDisplayName As String
  
  InitLog
  
  strDisplayName = NTService.DisplayName
  
  If Command = "-install" Then
      
    NTService.Interactive = True
    If NTService.Install Then
      'You could enhance this by setting extra parameters for the
      'service, for example the timer-interval:
      'Call NTService.SaveSetting("Parameters", "TimerInterval", "1000")
      SaveLog strDisplayName & " installed successfully"
    Else
      SaveLog strDisplayName & " failed to install"
    End If
    End
  
  ElseIf Command = "-uninstall" Then
    If NTService.Uninstall Then
      SaveLog strDisplayName & " uninstalled successfully"
    Else
      SaveLog strDisplayName & " failed to uninstall"
    End If
    End
  
  ElseIf Command = "-debug" Then
    NTService.Debug = True
  
  ElseIf Command <> "" Then
    SaveLog "Invalid command option"
    End
  End If
    
  ' enable Pause/Continue. Must be set before StartService
  ' is called or in design mode
  NTService.ControlsAccepted = svcCtrlPauseContinue
  
  ' connect service to Windows NT services controller
  SaveLog "Connection to Windows NT services controller"
  NTService.StartService
  
  Me.Hide
  
  Exit Sub
    
Err_Load:
    ServiceLog ("[" & Err.number & "] " & Err.Description)
End Sub

Private Sub NTService_Start(Success As Boolean)

  On Error GoTo Err_start
    
  SaveLog "Starting service"
  
  Success = Start(Me)
  
  If Success Then
      ServiceLog ("Crowsoft CSTCP-IPServer start succesfully")
  Else
      ServiceLog ("Crowsoft CSTCP-IPServer start failed")
  End If
    
  Exit Sub

Err_start:
  ServiceLog ("[" & Err.number & "] " & Err.Description)
End Sub

Private Sub NTService_Stop()

  On Error GoTo Err_stop

  CloseApp
        
  Unload Me
    
  Exit Sub
    
Err_stop:
    ServiceLog ("[" & Err.number & "] " & Err.Description)
End Sub

Private Sub NTService_Continue(Success As Boolean)

  On Error GoTo Err_Continue
    
  ServerContinue
  Success = True
    
  Call NTService.LogEvent(svcEventInformation, svcMessageInfo, "Service continued")
   
  Exit Sub
    
Err_Continue:
    ServiceLog ("[" & Err.number & "] " & Err.Description)
End Sub

Private Sub NTService_Control(ByVal lngEvent As Long)
'Dummy function
'you can add code here

  On Error GoTo Err_Control
  Exit Sub

Err_Control:
    ServiceLog ("[" & Err.number & "] " & Err.Description)
End Sub

Private Sub NTService_Pause(Success As Boolean)
On Error GoTo Err_Pause

  ServerPause
  Call NTService.LogEvent(svcEventError, svcMessageError, "Service paused")
  Success = True
    
  Exit Sub
    
Err_Pause:
  ServiceLog ("[" & Err.number & "] " & Err.Description)
End Sub

Public Sub ServiceLog(strMessage As String)
  Call NTService.LogEvent(svcMessageError, svcEventError, strMessage)
End Sub

