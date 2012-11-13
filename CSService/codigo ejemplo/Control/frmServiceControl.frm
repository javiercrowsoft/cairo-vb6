VERSION 5.00
Begin VB.Form frmServiceControl 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "VB NT Service Sample"
   ClientHeight    =   3075
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6135
   Icon            =   "frmServiceControl.frx":0000
   MaxButton       =   0   'False
   ScaleHeight     =   3075
   ScaleWidth      =   6135
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmrCheck 
      Interval        =   1000
      Left            =   480
      Top             =   2520
   End
   Begin VB.CheckBox chkSystem 
      Caption         =   "System Account"
      Height          =   255
      Left            =   3840
      TabIndex        =   11
      Top             =   1200
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.TextBox txtPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   10
      Top             =   1200
      Width           =   1935
   End
   Begin VB.TextBox txtAccount 
      Height          =   285
      Left            =   1680
      TabIndex        =   8
      Top             =   840
      Width           =   3735
   End
   Begin VB.CommandButton cmdStart 
      Caption         =   "Start Service"
      Height          =   615
      Left            =   3360
      TabIndex        =   6
      Top             =   120
      Width           =   2055
   End
   Begin VB.CommandButton cmdInstall 
      Caption         =   "Install Service"
      Height          =   615
      Left            =   720
      TabIndex        =   5
      Top             =   120
      Width           =   2055
   End
   Begin VB.Label lblPassword 
      Caption         =   "Password:"
      Height          =   255
      Left            =   720
      TabIndex        =   9
      Top             =   1200
      Width           =   855
   End
   Begin VB.Label lblAccount 
      Caption         =   "Account:"
      Height          =   255
      Left            =   720
      TabIndex        =   7
      Top             =   840
      Width           =   855
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   240
      X2              =   5910
      Y1              =   1910
      Y2              =   1910
   End
   Begin VB.Label lblEmail 
      AutoSize        =   -1  'True
      Caption         =   "smsoft@chat.ru"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   204
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   2760
      MouseIcon       =   "frmServiceControl.frx":0442
      MousePointer    =   99  'Custom
      TabIndex        =   4
      ToolTipText     =   "Send e-mail letter to author"
      Top             =   2760
      Width           =   1110
   End
   Begin VB.Label lblEmailHdr 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "e-mail: "
      ForeColor       =   &H00000000&
      Height          =   195
      Left            =   2160
      TabIndex        =   3
      Top             =   2760
      Width           =   495
   End
   Begin VB.Label lblWeb 
      AutoSize        =   -1  'True
      Caption         =   "http://smsoft.chat.ru"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   204
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   2760
      MouseIcon       =   "frmServiceControl.frx":074C
      MousePointer    =   99  'Custom
      TabIndex        =   2
      ToolTipText     =   "Open author's Web Home Page"
      Top             =   2520
      Width           =   1455
   End
   Begin VB.Label lblWebHdr 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "WWW: "
      ForeColor       =   &H00000000&
      Height          =   195
      Left            =   2070
      TabIndex        =   1
      Top             =   2520
      Width           =   585
   End
   Begin VB.Label lblDisclaimer 
      Alignment       =   2  'Center
      Caption         =   "Copyright © 2000-2001 Sergey Merzlikin"
      ForeColor       =   &H00000000&
      Height          =   225
      Left            =   240
      TabIndex        =   0
      Top             =   2160
      Width           =   5655
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FFFFFF&
      BorderWidth     =   2
      Index           =   0
      X1              =   240
      X2              =   5910
      Y1              =   1920
      Y2              =   1920
   End
End
Attribute VB_Name = "frmServiceControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

'**************************************************
'* NT Service sample Control Program              *
'* © 2000-2001 Sergey Merzlikin                   *
'* http://smsoft.chat.ru                          *
'* e-mail: smsoft@chat.ru                         *
'**************************************************

Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion(1 To 128) As Byte
End Type
Private Const VER_PLATFORM_WIN32_NT = 2&

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long

Private Declare Function ShellExecute Lib "shell32" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Const SW_SHOWNORMAL = 1&
Dim ServState As SERVICE_STATE, Installed As Boolean

Private Sub chkSystem_Click()
    If chkSystem Then
        txtAccount = "LocalSystem"
        txtAccount.Enabled = False
        txtPassword.Enabled = False
        lblAccount.Enabled = False
        lblPassword.Enabled = False
    Else
        txtAccount = vbNullString
        txtAccount.Enabled = True
        txtPassword.Enabled = True
        lblAccount.Enabled = True
        lblPassword.Enabled = True
    End If
End Sub

Private Sub cmdInstall_Click()
    CheckService
    If Not cmdInstall.Enabled Then Exit Sub
    cmdInstall.Enabled = False
    If Installed Then
        DeleteNTService
    Else
        SetNTService
        txtPassword = vbNullString
    End If
    CheckService
End Sub

' This sub checks service status
Private Sub CheckService()
    If GetServiceConfig() = 0 Then
        Installed = True
        cmdInstall.Caption = "Uninstall Service"
        txtAccount.Enabled = False
        txtPassword.Enabled = False
        lblAccount.Enabled = False
        lblPassword.Enabled = False
        chkSystem.Enabled = False
        ServState = GetServiceStatus()
        Select Case ServState
            Case SERVICE_RUNNING
                cmdInstall.Enabled = False
                cmdStart.Caption = "Stop Service"
                cmdStart.Enabled = True
            Case SERVICE_STOPPED
                cmdInstall.Enabled = True
                cmdStart.Caption = "Start Service"
                cmdStart.Enabled = True
            Case Else
                cmdInstall.Enabled = False
                cmdStart.Enabled = False
        End Select
    Else
        Installed = False
        cmdInstall.Caption = "Install Service"
        txtAccount.Enabled = chkSystem = 0
        txtPassword.Enabled = chkSystem = 0
        lblAccount.Enabled = chkSystem = 0
        lblPassword.Enabled = chkSystem = 0
        chkSystem.Enabled = True
        cmdStart.Enabled = False
        cmdInstall.Enabled = True
    End If
End Sub

Private Sub cmdStart_Click()
    CheckService
    If Not cmdStart.Enabled Then Exit Sub
    cmdStart.Enabled = False
    If ServState = SERVICE_RUNNING Then
        StopNTService
    ElseIf ServState = SERVICE_STOPPED Then
        StartNTService
    End If
    CheckService
End Sub

Private Sub Form_Load()
    If Not CheckIsNT() Then
        MsgBox "This program requires Windows NT/2000/XP"
        Unload Me
        Exit Sub
    End If
    AppPath = App.Path
    If Right$(AppPath, 1) <> "\" Then AppPath = AppPath & "\"
    chkSystem_Click
    CheckService
End Sub

' This sub opens blank letter with filled address field
' in default e-mail client

Private Sub lblEmail_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        ShellExecute Me.hwnd, "open", "mailto:" & lblEmail.Caption, vbNullString, App.Path, SW_SHOWNORMAL
    End If
End Sub

' This sub opens Web page in default browser

Private Sub lblWeb_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        ShellExecute Me.hwnd, "open", lblWeb.Caption, vbNullString, App.Path, SW_SHOWNORMAL
    End If
End Sub


' CheckIsNT() returns True, if the program runs
' under Windows NT or Windows 2000, and False
' otherwise.

Private Function CheckIsNT() As Boolean
    Dim OSVer As OSVERSIONINFO
    OSVer.dwOSVersionInfoSize = LenB(OSVer)
    GetVersionEx OSVer
    CheckIsNT = (OSVer.dwPlatformId = VER_PLATFORM_WIN32_NT)
End Function

Private Sub tmrCheck_Timer()
    CheckService
End Sub
