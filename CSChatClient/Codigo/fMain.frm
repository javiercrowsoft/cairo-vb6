VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fMain 
   Caption         =   "CrowSoft Chat Client"
   ClientHeight    =   8175
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   12300
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   8175
   ScaleWidth      =   12300
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog cd 
      Left            =   5940
      Top             =   3840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList ilContacts 
      Left            =   11100
      Top             =   2820
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   4
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":058A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":0924
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":0CBE
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1058
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picTopInfo 
      BorderStyle     =   0  'None
      Height          =   1335
      Left            =   5700
      ScaleHeight     =   1335
      ScaleWidth      =   5295
      TabIndex        =   9
      Top             =   60
      Width           =   5295
      Begin VB.Line Line1 
         BorderColor     =   &H8000000B&
         X1              =   1020
         X2              =   4920
         Y1              =   660
         Y2              =   660
      End
      Begin VB.Image Image3 
         Height          =   480
         Left            =   300
         Picture         =   "fMain.frx":13F2
         Top             =   120
         Width           =   480
      End
      Begin VB.Image Image1 
         Height          =   480
         Left            =   300
         Picture         =   "fMain.frx":19F6
         Top             =   720
         Width           =   480
      End
      Begin VB.Label lbServer 
         Caption         =   "Conectado a Daimaku"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   1020
         TabIndex        =   11
         Top             =   840
         Width           =   4035
      End
      Begin VB.Label lbUser 
         Caption         =   "Administrador"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   1020
         TabIndex        =   10
         Top             =   300
         Width           =   4035
      End
      Begin VB.Shape shTopInfo 
         BorderColor     =   &H80000010&
         Height          =   1215
         Left            =   0
         Top             =   60
         Width           =   5235
      End
   End
   Begin VB.PictureBox picTreeContacts 
      BorderStyle     =   0  'None
      Height          =   6135
      Left            =   5700
      ScaleHeight     =   6135
      ScaleWidth      =   5295
      TabIndex        =   8
      Top             =   1440
      Width           =   5295
      Begin MSComctlLib.TreeView tvContacts 
         Height          =   5835
         Left            =   120
         TabIndex        =   5
         Top             =   120
         Width           =   4995
         _ExtentX        =   8811
         _ExtentY        =   10292
         _Version        =   393217
         HideSelection   =   0   'False
         Indentation     =   353
         LabelEdit       =   1
         LineStyle       =   1
         Style           =   7
         FullRowSelect   =   -1  'True
         Appearance      =   1
      End
      Begin VB.Shape shContacts 
         BorderColor     =   &H80000010&
         Height          =   6075
         Left            =   0
         Top             =   0
         Width           =   5235
      End
   End
   Begin VB.PictureBox picLogin 
      BorderStyle     =   0  'None
      Height          =   4875
      Left            =   60
      ScaleHeight     =   4875
      ScaleWidth      =   5295
      TabIndex        =   7
      Top             =   2640
      Width           =   5295
      Begin VB.CommandButton cmdConnect 
         Caption         =   "Co&nectar"
         Default         =   -1  'True
         Height          =   375
         Left            =   1680
         TabIndex        =   4
         Top             =   3660
         Width           =   1935
      End
      Begin VB.TextBox txUser 
         Height          =   315
         Left            =   1320
         TabIndex        =   1
         Top             =   540
         Width           =   3075
      End
      Begin VB.TextBox txPassword 
         Height          =   315
         IMEMode         =   3  'DISABLE
         Left            =   1320
         PasswordChar    =   "*"
         TabIndex        =   3
         Top             =   1020
         Width           =   3075
      End
      Begin VB.Image Image2 
         Height          =   960
         Left            =   2160
         Picture         =   "fMain.frx":20E1
         Top             =   1800
         Width           =   960
      End
      Begin VB.Shape shLogin 
         BorderColor     =   &H80000010&
         Height          =   4815
         Left            =   0
         Top             =   0
         Width           =   5235
      End
      Begin VB.Label Label1 
         Caption         =   "&Usuario:"
         Height          =   315
         Left            =   540
         TabIndex        =   0
         Top             =   540
         Width           =   735
      End
      Begin VB.Label Label2 
         Caption         =   "&Clave:"
         Height          =   315
         Left            =   540
         TabIndex        =   2
         Top             =   1020
         Width           =   735
      End
   End
   Begin VB.PictureBox picLogo 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   2595
      Left            =   -120
      Picture         =   "fMain.frx":2F5A
      ScaleHeight     =   2595
      ScaleWidth      =   12435
      TabIndex        =   6
      Top             =   0
      Width           =   12435
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuAbout 
         Caption         =   "&Acerca de CSChat Client ..."
      End
   End
End
Attribute VB_Name = "fMain"
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
Private nid As NOTIFYICONDATA

Private Const C_Module = "fMain"

Private WithEvents m_Client As cTCPIPClient
Attribute m_Client.VB_VarHelpID = -1

Private m_oldWinState As Integer

Public Property Get Client() As cTCPIPClient
  Set Client = m_Client
End Property
Public Property Set Client(ByRef rhs As cTCPIPClient)
  Set m_Client = rhs
End Property

Public Function ShowContacts() As Boolean
  If Not ListContacts() Then Exit Function
  pShowContacts
  ShowContacts = True
End Function

Public Sub Connect()
  
  Dim CallerId    As Long
  Dim SessionKey  As String
  Dim TempId      As Long
  
  If Not mLogin.ConnectChat(CallerId, SessionKey, TempId) Then Exit Sub
  
  pSaveLastLogin
  ShowContacts

  ' Cuando ingreso por linea de comandos
  ' es posible que me pasen un callerid
  ' para que acepte un chat
  '
  If CallerId Then
    AcceptChat CallerId, SessionKey, TempId
  End If
End Sub

Private Sub cmdConnect_Click()
  On Error Resume Next
  cmdConnect.Enabled = False
  cmdConnect.Caption = "Conectando ..."
  Connect
  cmdConnect.Caption = "Conectar ..."
  cmdConnect.Enabled = True
End Sub

Private Sub pShowContacts()
  picLogin.Visible = False
  picLogo.Visible = False
  picTopInfo.Left = 20
  picTreeContacts.Left = 20
  picTreeContacts.ZOrder
  picTopInfo.ZOrder
  picTreeContacts.Visible = True
  picTopInfo.Visible = True
End Sub

Private Sub pShowLogin()
  picTopInfo.Visible = False
  picTreeContacts.Visible = False
  picLogo.Left = -100
  picLogin.Left = 20
  picLogo.ZOrder
  picLogin.ZOrder
  picLogo.Visible = True
  picLogin.Visible = True
End Sub

Private Sub Form_Load()

  pLoadRegistry
  pSetTvTreeImage
  pShowLogin

  If Me.Width < 5350 Then Me.Width = 5350
  If Me.Height < 8000 Then Me.Height = 8000

  Me.Width = picLogin.Width + picLogin.Left * 5
  Me.Height = Me.Height - Me.ScaleHeight _
              + picLogin.Height + picLogin.Top + 10
  

  nid.cbSize = Len(nid)
  nid.hWnd = Me.hWnd
  nid.uId = vbNull
  nid.uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
  nid.uCallBackMessage = WM_MOUSEMOVE
  nid.hIcon = Me.Icon
  nid.szTip = "Double Click To Restore Your application.." & vbNullChar
  Shell_NotifyIcon NIM_ADD, nid

End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
   Dim lMsg As Long
   Dim sFilter As String
   lMsg = x / Screen.TwipsPerPixelX
   Select Case lMsg
   'you can play with other events as I did as per your use
      Case WM_LBUTTONDOWN
      Case WM_LBUTTONUP
      Case WM_LBUTTONDBLCLK
        Me.mnuFile.Visible = True
        Me.mnuHelp.Visible = True
        Me.WindowState = m_oldWinState
        Me.Show
        Me.ZOrder
      Case WM_RBUTTONDOWN
      Case WM_RBUTTONUP
      Case WM_RBUTTONDBLCLK
   End Select
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode = vbFormControlMenu Then
    Me.Hide
    Me.WindowState = vbMinimized
    Me.mnuFile.Visible = False
    Me.mnuHelp.Visible = False
    Cancel = True
  End If
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  If Me.WindowState = vbMinimized Then Exit Sub
  picLogo.Width = Me.Width
  picLogin.Width = Me.Width
  picLogin.Height = Me.ScaleHeight - picLogin.Top
  shLogin.Width = picLogin.ScaleWidth - 160
  shLogin.Height = picLogin.ScaleHeight - 40

  picTopInfo.Width = Me.Width
  shTopInfo.Width = picTopInfo.ScaleWidth - 160
  picTreeContacts.Width = Me.Width
  picTreeContacts.Height = Me.ScaleHeight - picTreeContacts.Top
  tvContacts.Width = picTreeContacts.ScaleWidth - 400
  tvContacts.Height = picTreeContacts.ScaleHeight - 280

  shContacts.Width = picTreeContacts.ScaleWidth - 160
  shContacts.Height = picTreeContacts.ScaleHeight - 40
  
  If Me.WindowState <> vbMinimized Then
    m_oldWinState = Me.WindowState
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  Shell_NotifyIcon NIM_DELETE, nid
  CSKernelClient2.UnloadForm Me, Me.Name
  CloseApp
End Sub

' Recibe todos los mensajes enviados por el server TCP-IP
'
Private Sub m_Client_ReciveText(ByVal Buffer As String)
  On Error GoTo ControlError
   
  ProcessMessage Buffer

  GoTo ExitProc
ControlError:
  MngError Err, "m_Client_ReciveText", C_Module, Erl
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetTvTreeImage()
  Set tvContacts.ImageList = ilContacts
End Sub

Private Sub mnuAbout_Click()
  fSpalsh.Show vbModal
End Sub

Private Sub mnuExit_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub tvContacts_DblClick()
  If tvContacts.SelectedItem Is Nothing Then Exit Sub
  With tvContacts.SelectedItem
    If .Key = c_key_root Then Exit Sub
    InitChat .Tag
  End With
End Sub

Private Sub pLoadRegistry()
  Dim LastCompany As String
  LastCompany = CSKernelClient2.GetRegistry(csSeccionSetting.csLogin, c_Key_LastCompany, "")
  txUser.Text = CSKernelClient2.GetRegistry(csSeccionSetting.csLogin, c_Key_LastUser & LastCompany, "")
End Sub

Private Sub pSaveLastLogin()
  Dim LastCompany As String
  LastCompany = CSKernelClient2.GetRegistry(csSeccionSetting.csLogin, c_Key_LastCompany, "")
  CSKernelClient2.SetRegistry csSeccionSetting.csLogin, c_Key_LastUser & LastCompany, txUser.Text
End Sub

