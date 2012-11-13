VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fMain 
   Caption         =   "CSTCPIPServer"
   ClientHeight    =   4590
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6375
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4590
   ScaleWidth      =   6375
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lsLog 
      Height          =   2010
      Left            =   60
      TabIndex        =   0
      Top             =   1680
      Width           =   2355
   End
   Begin VB.ListBox lsConnections 
      Height          =   2010
      Left            =   360
      TabIndex        =   5
      Top             =   1740
      Width           =   2355
   End
   Begin CSButton.cButtonLigth cmdLog 
      Height          =   315
      Left            =   60
      TabIndex        =   2
      Top             =   600
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   556
      Caption         =   "Log"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdConnections 
      Height          =   315
      Left            =   1320
      TabIndex        =   3
      Top             =   600
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   556
      Caption         =   "Conexiones"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdClose 
      Height          =   315
      Left            =   4860
      TabIndex        =   4
      Top             =   600
      Width           =   1515
      _ExtentX        =   2672
      _ExtentY        =   556
      Caption         =   "Terminar Sesión"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdHide 
      Height          =   315
      Left            =   2580
      TabIndex        =   6
      Top             =   600
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   556
      Caption         =   "Cerrar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   180
      Picture         =   "fMain.frx":014A
      Top             =   60
      Width           =   480
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Crowsoft TCP-IP Server"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   495
      Left            =   840
      TabIndex        =   1
      Top             =   120
      Width           =   6075
   End
   Begin VB.Shape shTop 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   555
      Left            =   0
      Shape           =   4  'Rounded Rectangle
      Top             =   0
      Width           =   4755
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
        hwnd As Long
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

Private Sub cmdConnections_Click()
  On Error Resume Next
  lsConnections.ZOrder
End Sub

Private Sub cmdHide_Click()
  On Error Resume Next
  Me.WindowState = vbMinimized
End Sub

Private Sub cmdLog_Click()
  On Error Resume Next
  lsLog.ZOrder
End Sub

Private Sub Form_Load()
  gClose = False

  'If the application dosen't have a previous instance then load the form
  If App.PrevInstance = False Then
       nid.cbSize = Len(nid)
       nid.hwnd = Me.hwnd
       nid.uId = vbNull
       nid.uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
       nid.uCallBackMessage = WM_MOUSEMOVE
       nid.hIcon = Me.Icon
       nid.szTip = "Double Click To Restore Your application.." & vbNullChar
       Shell_NotifyIcon NIM_ADD, nid
  End If
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  
   Dim lMsg As Long
   Dim sFilter As String
   lMsg = X / Screen.TwipsPerPixelX
   Select Case lMsg
   'you can play with other events as I did as per your use
      Case WM_LBUTTONDOWN
      Case WM_LBUTTONUP
      Case WM_LBUTTONDBLCLK
        Me.WindowState = m_oldWinState
        Me.Show
        Me.ZOrder
      Case WM_RBUTTONDOWN
      Case WM_RBUTTONUP
      Case WM_RBUTTONDBLCLK
   End Select
 End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error Resume Next
  
  If UnloadMode = vbFormControlMenu Then
    Me.WindowState = vbMinimized
    Cancel = True
  Else
    gClose = True
  End If
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  cmdClose.Left = Me.ScaleWidth - cmdClose.Width - 200
  shTop.Width = Me.ScaleWidth - shTop.Left * 2
  lsLog.Top = cmdClose.Height + cmdClose.Top + 80
  lsLog.Width = Me.ScaleWidth - lsLog.Left * 2
  lsLog.Height = (Me.ScaleHeight - lsLog.Top - 20)
  lsConnections.Move lsLog.Left, lsLog.Top, lsLog.Width, lsLog.Height
  If Me.WindowState <> vbMinimized Then m_oldWinState = Me.WindowState
  If Me.WindowState = vbMinimized Then Me.Hide
End Sub

Private Sub Form_Unload(Cancel As Integer)
  'Ok now this is the time to remove the icon from systray
  Shell_NotifyIcon NIM_DELETE, nid
End Sub

Private Sub cmdClose_Click()
  If gClose Then Exit Sub
  If Ask("¿Confirma que desea terminar la sesión?.;;Hasta que no inicie una nueva sesión los usuarios de Cairo no podran conectarce.") Then
    MSShutDownTCPServer
    gClose = True
  End If
End Sub

