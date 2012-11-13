VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.MDIForm fMainMDI 
   BackColor       =   &H8000000C&
   Caption         =   "MDIForm1"
   ClientHeight    =   6480
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   8820
   Icon            =   "fMainMDI.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   4200
      Top             =   3000
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox Picture1 
      Align           =   1  'Align Top
      BorderStyle     =   0  'None
      Height          =   495
      Left            =   0
      ScaleHeight     =   495
      ScaleWidth      =   8820
      TabIndex        =   1
      Top             =   0
      Width           =   8820
      Begin VB.CommandButton cmdTaskProgress 
         Caption         =   "Tareas en Ejecución"
         Height          =   375
         Left            =   2040
         TabIndex        =   3
         Top             =   60
         Width           =   1935
      End
      Begin VB.CommandButton cmdConfig 
         Caption         =   "Configuración"
         Height          =   375
         Left            =   60
         TabIndex        =   2
         Top             =   60
         Width           =   1935
      End
   End
   Begin MSComctlLib.StatusBar stbMain 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   6225
      Width           =   8820
      _ExtentX        =   15558
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuTask 
      Caption         =   "&Tareas"
      Begin VB.Menu mnuTaskNew 
         Caption         =   "&Nueva ..."
      End
      Begin VB.Menu mnuTaskEdit 
         Caption         =   "&Editar ..."
      End
      Begin VB.Menu mnuTaskDelete 
         Caption         =   "&Borrar"
      End
   End
   Begin VB.Menu mnuSchedule 
      Caption         =   "&Programaciones"
      Begin VB.Menu mnuScheduleNew 
         Caption         =   "&Nueva ..."
      End
      Begin VB.Menu mnuScheduleEdit 
         Caption         =   "&Editar ..."
      End
      Begin VB.Menu mnuScheduleDelete 
         Caption         =   "&Borrar"
      End
   End
   Begin VB.Menu mnuSQLServer 
      Caption         =   "&SQL Server"
      Begin VB.Menu mnuSQLServerNewTask 
         Caption         =   "&Nueva Tarea de Backup ..."
      End
      Begin VB.Menu mnuSQLServerEditTask 
         Caption         =   "&Editar Tarea de Backup ..."
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Herramientas"
      Begin VB.Menu mnuBackup 
         Caption         =   "&Tareas en Ejecución..."
      End
      Begin VB.Menu mnuToolsSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPreferences 
         Caption         =   "&Opciones ..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuHelpIndex 
         Caption         =   "&Indice"
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "&Acerca de CSBackup ..."
      End
   End
   Begin VB.Menu popMenu 
      Caption         =   "popMenu"
      Visible         =   0   'False
      Begin VB.Menu popRestore 
         Caption         =   "Restaurar..."
      End
      Begin VB.Menu popSep 
         Caption         =   "-"
      End
      Begin VB.Menu popExit 
         Caption         =   "Salir"
      End
   End
End
Attribute VB_Name = "fMainMDI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Author:Vishal Kulkarni
'This code can be freely distributed and used by anyone.
'This is a real neat code and easy to understand
'This code puts your project icon in the system tray.
'When you close the application the icon in the systray
'is removed.
'This also gives various events to use.
'In case if you need any help please contact vishal_kulkarni@hotmail.com
Private Type NOTIFYICONDATA
        cbSize As Long
        hWnd As Long
        uId As Long
        uFlags As Long
        uCallBackMessage As Long
        hIcon As Long
        szTip As String * 64
End Type
Private Const NIM_ADD = &H0
Private Const NIM_MODIFY = &H1
Private Const NIM_DELETE = &H2
Private Const WM_MOUSEMOVE = &H200
Private Const NIF_MESSAGE = &H1
Private Const NIF_ICON = &H2
Private Const NIF_TIP = &H4
Private Const WM_LBUTTONDBLCLK = &H203   'Double-click
Private Const WM_LBUTTONDOWN = &H201     'Button down
Private Const WM_LBUTTONUP = &H202       'Button up
Private Const WM_RBUTTONDBLCLK = &H206   'Double-click
Private Const WM_RBUTTONDOWN = &H204     'Button down
Private Const WM_RBUTTONUP = &H205       'Button up
Private Declare Function Shell_NotifyIcon Lib "shell32" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, pnid As NOTIFYICONDATA) As Boolean
Dim nid As NOTIFYICONDATA

Private m_oldWinState As Integer

Private Const C_Module = "fMainMdi"

Public Sub CloseProgram()
  mnuExit_Click
End Sub

Private Sub cmdConfig_Click()
  fMain.ZOrder
End Sub

Private Sub cmdTaskProgress_Click()
  fBackup.ZOrder
End Sub

Private Sub MDIForm_Load()
  On Error GoTo ControlError

  nid.cbSize = Len(nid)
  nid.hWnd = Me.hWnd
  nid.uId = vbNull
  nid.uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
  nid.uCallBackMessage = WM_MOUSEMOVE
  nid.hIcon = Me.Icon
  nid.szTip = "Doble click para restaurar la aplicación..." & vbNullChar
  Shell_NotifyIcon NIM_ADD, nid

  With stbMain
    .Panels.Clear
    .Panels.Add().AutoSize = sbrSpring
    .Panels.Add , , , sbrTime
  End With
  
  FormLoad Me, True

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Load", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error Resume Next
  
  If UnloadMode = vbFormControlMenu Then
    Cancel = True
    Me.WindowState = vbMinimized
    Me.Hide
  End If
End Sub

Private Sub MDIForm_Resize()
  On Error Resume Next
  
  If Me.Height < 9200 Then
    Me.Height = 9200
  End If
  If Me.Width < 9400 Then
    Me.Width = 9400
  End If
End Sub

Private Sub MDIForm_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
 
  Dim lMsg As Long
  Dim sFilter As String
  lMsg = x / Screen.TwipsPerPixelX
  Select Case lMsg
  'you can play with other events as I did as per your use
     Case WM_LBUTTONDOWN
     Case WM_LBUTTONUP
       Me.PopupMenu popMenu
     Case WM_LBUTTONDBLCLK
     Case WM_RBUTTONDOWN
     Case WM_RBUTTONUP
     Case WM_RBUTTONDBLCLK
  End Select
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
  On Error GoTo ControlError

  'Ok now this is the time to remove the icon from systray
  Shell_NotifyIcon NIM_DELETE, nid

  FormUnload Me, True

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Unload", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuAbout_Click()
  ShowAbout
End Sub

Private Sub mnuBackup_Click()
  fBackup.Show
  fBackup.ZOrder
End Sub

Private Sub mnuExit_Click()
  On Error GoTo ControlError
  
  Unload Me
  End

  GoTo ExitProc
ControlError:
  MngError Err, "mnuExit_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuHelpIndex_Click()
  ShowHelp
End Sub

Private Sub mnuPreferences_Click()
  On Error GoTo ControlError
  
  EditPreferences vbModeless

  GoTo ExitProc
ControlError:
  MngError Err, "mnuPreferences_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuScheduleDelete_Click()
  On Error GoTo ControlError
  
  If fMain.lvSchedule.SelectedItem Is Nothing Then Exit Sub
  If Ask("¿Confirma que desea borrar?" & vbCrLf & vbCrLf _
           & fMain.lvSchedule.SelectedItem.Text & vbCrLf _
           & fMain.lvSchedule.SelectedItem.SubItems(1), vbNo) Then
    Kill fMain.lvSchedule.SelectedItem.SubItems(1)
    LoadSchedule fMain.lvSchedule
    fBackup.ReLoad
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "mnuScheduleDelete_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuScheduleEdit_Click()
  On Error GoTo ControlError
  
  If fMain.lvSchedule.SelectedItem Is Nothing Then Exit Sub
  fSchedule.Edit fMain.lvSchedule.SelectedItem.SubItems(1)
  LoadSchedule fMain.lvSchedule
  fBackup.ReLoad
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuScheduleEdit_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuScheduleNew_Click()
  On Error GoTo ControlError
  
  fSchedule.Edit vbNullString
  LoadSchedule fMain.lvSchedule
  fBackup.ReLoad
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuScheduleNew_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuSQLServerEditTask_Click()
  mnuTaskEdit_Click
End Sub

Private Sub mnuSQLServerNewTask_Click()
  On Error GoTo ControlError
  
  fTaskCommandBackup.Edit vbNullString
  LoadTask fMain.lvTask
  fBackup.ReLoad
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuSQLServerNewTask_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuTaskDelete_Click()
  On Error GoTo ControlError
  
  If fMain.lvTask.SelectedItem Is Nothing Then Exit Sub
  If Ask("¿Confirma que desea borrar?" & vbCrLf & vbCrLf _
           & fMain.lvTask.SelectedItem.Text & vbCrLf _
           & fMain.lvTask.SelectedItem.SubItems(1), vbNo) Then
    Kill fMain.lvTask.SelectedItem.SubItems(1)
    LoadTask fMain.lvTask
    fBackup.ReLoad
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "mnuTaskDelete_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuTaskEdit_Click()
  On Error GoTo ControlError
  
  If fMain.lvTask.SelectedItem Is Nothing Then Exit Sub
  
  Dim TaskFile As String
  TaskFile = fMain.lvTask.SelectedItem.SubItems(1)
  
  If TaskType(TaskFile, False) = c_TaskTypeBackupDB Then
    fTaskCommandBackup.Edit TaskFile
  Else
    fTask.Edit TaskFile
  End If
  LoadTask fMain.lvTask
  fBackup.ReLoad
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuTaskEdit_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuTaskNew_Click()
  On Error GoTo ControlError
  
  fTask.Edit vbNullString
  LoadTask fMain.lvTask
  fBackup.ReLoad
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuTaskNew_Click", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popExit_Click()
  mnuExit_Click
End Sub

Private Sub popRestore_Click()
  pRestore
End Sub

Private Sub pRestore()
  On Error Resume Next
  
  Me.WindowState = m_oldWinState
  Me.Show
  Me.ZOrder
End Sub

Public Sub ShowHelp()

End Sub

Public Sub ShowAbout()
  fAbout.Show vbModal
End Sub
