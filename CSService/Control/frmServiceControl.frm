VERSION 5.00
Begin VB.Form frmServiceControl 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "VB NT Service"
   ClientHeight    =   4875
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7035
   Icon            =   "frmServiceControl.frx":0000
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4875
   ScaleWidth      =   7035
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancelar"
      Height          =   315
      Left            =   3660
      TabIndex        =   13
      Top             =   4320
      Width           =   1635
   End
   Begin VB.CommandButton cmdInstall 
      Caption         =   "Aceptar"
      Height          =   315
      Left            =   1980
      TabIndex        =   12
      Top             =   4320
      Width           =   1635
   End
   Begin VB.CommandButton cmdStart 
      Caption         =   "Start"
      Height          =   315
      Left            =   4920
      TabIndex        =   11
      Top             =   3720
      Visible         =   0   'False
      Width           =   1875
   End
   Begin VB.Timer tmrCheck 
      Interval        =   1000
      Left            =   480
      Top             =   3360
   End
   Begin VB.CheckBox chkSystem 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      Caption         =   "System Account"
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   3840
      TabIndex        =   9
      Top             =   1980
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.TextBox txtPassword 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      Height          =   300
      IMEMode         =   3  'DISABLE
      Left            =   1635
      PasswordChar    =   "*"
      TabIndex        =   8
      Top             =   1970
      Width           =   2025
   End
   Begin VB.TextBox txtAccount 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1635
      TabIndex        =   6
      Top             =   1545
      Width           =   3825
   End
   Begin VB.Line Line1 
      BorderColor     =   &H0080C0FF&
      BorderStyle     =   6  'Inside Solid
      Index           =   0
      X1              =   240
      X2              =   6840
      Y1              =   4140
      Y2              =   4140
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   $"frmServiceControl.frx":1042
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   915
      Left            =   180
      TabIndex        =   10
      Top             =   300
      Width           =   6615
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   1620
      Top             =   1950
      Width           =   2055
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   1620
      Top             =   1530
      Width           =   3855
   End
   Begin VB.Label lblPassword 
      BackStyle       =   0  'Transparent
      Caption         =   "Password:"
      Height          =   255
      Left            =   720
      TabIndex        =   7
      Top             =   1980
      Width           =   855
   End
   Begin VB.Label lblAccount 
      BackStyle       =   0  'Transparent
      Caption         =   "Account:"
      Height          =   255
      Left            =   720
      TabIndex        =   5
      Top             =   1560
      Width           =   855
   End
   Begin VB.Line Line1 
      BorderColor     =   &H0080C0FF&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   240
      X2              =   6840
      Y1              =   2625
      Y2              =   2625
   End
   Begin VB.Label lblEmail 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "smsoft@chat.ru"
      BeginProperty Font 
         Name            =   "Lucida Sans Unicode"
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
      MouseIcon       =   "frmServiceControl.frx":10CD
      MousePointer    =   99  'Custom
      TabIndex        =   4
      ToolTipText     =   "Send e-mail letter to author"
      Top             =   3600
      Width           =   2250
   End
   Begin VB.Label lblEmailHdr 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      Caption         =   "e-mail: "
      ForeColor       =   &H00000000&
      Height          =   195
      Left            =   2160
      TabIndex        =   3
      Top             =   3600
      Width           =   495
   End
   Begin VB.Label lblWeb 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "http://smsoft.chat.ru"
      BeginProperty Font 
         Name            =   "Lucida Sans Unicode"
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
      MouseIcon       =   "frmServiceControl.frx":13D7
      MousePointer    =   99  'Custom
      TabIndex        =   2
      ToolTipText     =   "Open author's Web Home Page"
      Top             =   3360
      Width           =   2235
   End
   Begin VB.Label lblWebHdr 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      Caption         =   "WWW: "
      ForeColor       =   &H00000000&
      Height          =   195
      Left            =   2070
      TabIndex        =   1
      Top             =   3360
      Width           =   585
   End
   Begin VB.Label lblDisclaimer 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Caption         =   "Copyright © 2000-2001 Sergey Merzlikin"
      ForeColor       =   &H00000000&
      Height          =   225
      Left            =   240
      TabIndex        =   0
      Top             =   3000
      Width           =   5655
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

Private ServState       As SERVICE_STATE
Private Installed       As Boolean
Private m_Ok            As Boolean

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

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

#If PREPROC_INSTALL <> 0 Then
  
  Private Sub cmdCancel_Click()
    UnloadForm
  End Sub
  
  Private Function UnloadForm() As Boolean
    If vbYes = MsgBox("Si cancela no se registrara el servicio CrowSoft." & vbCrLf & vbCrLf & "¿Desea cancelar de todas formas?", vbYesNo + vbQuestion, "Instalación") Then
      Unload Me
    Else
      UnloadForm = True
    End If
  End Function

  Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode <> vbFormCode Then Cancel = UnloadForm
  End Sub

#Else
  
  Private Sub cmdCancel_Click()
    Unload Me
  End Sub

#End If

Private Sub cmdInstall_Click()
  
  If LenB(SERVICE_NAME) = 0 Then
    MsgBox "Debe indicar el nombre del servicio en el archivo " & App.Path & "\" & c_MainIniFile
    Exit Sub
  End If
    
  If LenB(Service_Display_Name) = 0 Then
    MsgBox "Debe indicar la descripcion del servicio en el archivo " & App.Path & "\" & c_MainIniFile
    Exit Sub
  End If
    
  If LenB(Service_File_Name) = 0 Then
    MsgBox "Debe indicar el nombre del archivo ejecutable del servicio en el archivo " & App.Path & "\" & c_MainIniFile
    Exit Sub
  End If
  
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
  
#If PREPROC_INSTALL <> 0 Then
  
  ' Cuando estoy instalando si esta registrado
  ' cierro esta ventana
  If Installed Then
    
    ' Antes lo arranco
    If ServState <> SERVICE_RUNNING Then
        StartNTService
    End If
    
    m_Ok = True
    Unload Me
  End If
#End If

End Sub

' This sub checks service status
Private Sub CheckService(Optional ByVal bUnInstall As Boolean)
    If GetServiceConfig() = 0 Then
        Installed = True
        
        'cmdInstall.Caption = "Uninstall Service"
        
        txtAccount.Enabled = False
        txtPassword.Enabled = False
        lblAccount.Enabled = False
        lblPassword.Enabled = False
        chkSystem.Enabled = False
        ServState = GetServiceStatus()
        Select Case ServState
            Case SERVICE_RUNNING
                cmdInstall.Enabled = False

#If PREPROC_INSTALL = 0 Then
                cmdStart.Caption = "Stop Service"
                cmdStart.Enabled = True
#End If

            Case SERVICE_STOPPED
                cmdInstall.Enabled = True

#If PREPROC_INSTALL = 0 Then
                cmdStart.Caption = "Start Service"
                cmdStart.Enabled = True
#End If

            Case Else
                cmdInstall.Enabled = False

#If PREPROC_INSTALL = 0 Then
                cmdStart.Enabled = False
#End If

        End Select
    
#If PREPROC_INSTALL <> 0 Then

  ' Cuando estoy instalando si ya esta registrado
  ' lo desinstalo para que el usuario lo instale
  If bUnInstall Then
  
    ServState = GetServiceStatus()
    If ServState = SERVICE_RUNNING Then
        StopNTService
    End If
    
    DeleteNTService
    
    ' Me llamo recursivamente para que
    ' se configure nuevamente ahora que esta
    ' desinstalado
    CheckService
  End If

#End If
    
    Else
        Installed = False

#If PREPROC_INSTALL = 0 Then
        'cmdInstall.Caption = "Install Service"
#End If

        txtAccount.Enabled = chkSystem = 0
        txtPassword.Enabled = chkSystem = 0
        lblAccount.Enabled = chkSystem = 0
        lblPassword.Enabled = chkSystem = 0
        chkSystem.Enabled = True

#If PREPROC_INSTALL = 0 Then
        cmdStart.Enabled = False
#End If

        cmdInstall.Enabled = True
    End If
End Sub

#If PREPROC_INSTALL = 0 Then

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

#End If

Private Sub Form_Load()
  On Error Resume Next
  
  m_Ok = False

  Me.Left = (Screen.Width - Me.Width) * 0.5
  Me.Top = (Screen.Height - Me.Height) * 0.5
  
  If Not CheckIsNT() Then
    MsgBox "This program requires Windows NT/2000/XP"
    Unload Me
    Exit Sub
  End If
  chkSystem_Click
  
  Me.Caption = Me.Caption & " - " & Service_File_Name
  
#If PREPROC_INSTALL = 0 Then
  cmdStart.Visible = True
  CheckService
#Else
  CheckService True
#End If
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
