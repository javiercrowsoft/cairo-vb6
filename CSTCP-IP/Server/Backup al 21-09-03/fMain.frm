VERSION 5.00
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
      Left            =   135
      TabIndex        =   2
      Top             =   675
      Width           =   2355
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Cerrar"
      Height          =   330
      Left            =   2295
      TabIndex        =   0
      Top             =   45
      Width           =   1275
   End
   Begin VB.Label Label1 
      Caption         =   "Log:"
      Height          =   240
      Left            =   45
      TabIndex        =   1
      Top             =   135
      Width           =   1725
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
    cmdClose_Click
  End If
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  cmdClose.Left = Me.ScaleWidth - cmdClose.Width - 200
  lsLog.Top = cmdClose.Height + cmdClose.Top + 80
  lsLog.Width = Me.ScaleWidth - 100
  lsLog.Left = (Me.ScaleWidth - lsLog.Width) * 0.5
  lsLog.Height = (Me.ScaleHeight - lsLog.Top - 50)
  If Me.WindowState <> vbMinimized Then m_oldWinState = Me.WindowState
  If Me.WindowState = vbMinimized Then Me.Hide
End Sub

Private Sub Form_Unload(Cancel As Integer)
  'Ok now this is the time to remove the icon from systray
  Shell_NotifyIcon NIM_DELETE, nid
End Sub

Private Sub cmdClose_Click()
  gClose = True
End Sub

