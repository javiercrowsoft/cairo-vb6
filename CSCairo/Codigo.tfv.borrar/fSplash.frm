VERSION 5.00
Begin VB.Form fSplash 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   ClientHeight    =   5190
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7785
   ControlBox      =   0   'False
   FillColor       =   &H00808080&
   ForeColor       =   &H8000000C&
   Icon            =   "fSplash.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5190
   ScaleWidth      =   7785
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picHand 
      Height          =   495
      Left            =   7140
      Picture         =   "fSplash.frx":08CA
      ScaleHeight     =   435
      ScaleWidth      =   435
      TabIndex        =   2
      Top             =   120
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.Timer Timer1 
      Left            =   6660
      Top             =   120
   End
   Begin VB.Label lbLink 
      BackStyle       =   0  'Transparent
      Caption         =   "http://www.crowsoft.com.ar"
      BeginProperty Font 
         Name            =   "Microsoft Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   315
      Left            =   240
      TabIndex        =   1
      Top             =   4380
      Width           =   2835
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Portions Copyright © 1998 Kirk Stowell."
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   1500
      TabIndex        =   7
      Top             =   4920
      Width           =   4575
   End
   Begin VB.Shape shMain 
      BackColor       =   &H00FFFFFF&
      BorderColor     =   &H00808080&
      Height          =   5195
      Left            =   0
      Top             =   0
      Width           =   7785
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000F&
      X1              =   0
      X2              =   7800
      Y1              =   4620
      Y2              =   4620
   End
   Begin VB.Image imgLink 
      Height          =   960
      Left            =   0
      Picture         =   "fSplash.frx":0BD4
      Top             =   3420
      Width           =   2640
   End
   Begin VB.Label lbLinkAccelerator 
      BackStyle       =   0  'Transparent
      Caption         =   "This product includes software developed by vbAccelerator (http://vbaccelerator.com/)."
      BeginProperty Font 
         Name            =   "Microsoft Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   1500
      TabIndex        =   6
      Top             =   4680
      Width           =   6795
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Queda prohibida toda copia NO autorizada."
      BeginProperty Font 
         Name            =   "Microsoft Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   3480
      TabIndex        =   5
      Top             =   4200
      Width           =   4215
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Programa protegido por las leyes de derecho de autor."
      BeginProperty Font 
         Name            =   "Microsoft Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   2640
      TabIndex        =   4
      Top             =   3960
      Width           =   5055
   End
   Begin VB.Label lbCopyRight01 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Copyright © 2003-2008 Crowsoft."
      BeginProperty Font 
         Name            =   "Microsoft Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   3480
      TabIndex        =   3
      Top             =   3720
      Width           =   4215
   End
   Begin VB.Label LbVersion 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "exe: 10.0.10 - db: 10.0.1"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   240
      Left            =   5505
      TabIndex        =   0
      Top             =   2820
      Width           =   2130
   End
   Begin VB.Image Image3 
      Height          =   3120
      Left            =   0
      Picture         =   "fSplash.frx":2C10
      Top             =   0
      Width           =   7770
   End
End
Attribute VB_Name = "fSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim m_inicio        As Boolean
'Dim m_leftVersion   As Integer
Dim m_IsSplash      As Boolean

Private Const C_Module = "fSplash"

Public Property Let IsSplash(ByVal rhs As Boolean)
  m_IsSplash = rhs
End Property

Private Sub Image1_Click()
  Form_Click
End Sub

Private Sub Image3_Click()
  Form_Click
End Sub

Private Sub Timer1_Timer()
  Timer1.Enabled = False
  If m_IsSplash Then AlwaysOnTop Me, True
End Sub

Private Sub Form_Activate()
  If Not m_IsSplash Then
    ActiveBar Me
  End If
End Sub

Private Sub Form_Deactivate()
  If Not m_IsSplash Then
    DeactiveBar Me
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  If Not m_IsSplash Then
    DeactiveBar Me
  End If
  Screen.MousePointer = vbDefault
End Sub

Private Sub Form_Click()
  If Not m_IsSplash Then
    Unload Me
  End If
End Sub

Private Sub lbLink_Click()
  On Error Resume Next
  SwhowPage lbLink.Caption, Me.hWnd
End Sub

Private Sub lbLink_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  Screen.MousePointer = vbCustom
  Screen.MouseIcon = picHand.Picture
End Sub

Private Sub SwhowPage(ByVal strFile As String, ByVal hWnd As Long)
  CSKernelClient2.EditFile strFile, Me.hWnd
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  Screen.MousePointer = vbDefault
End Sub

Private Sub imgLink_Click()
  lbLink_Click
End Sub

Private Sub imgLink_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  lbLink_MouseMove Button, Shift, x, y
End Sub

Private Sub lbLinkAccelerator_Click()
  On Error Resume Next
  SwhowPage "http://www.vbaccelerator.com", Me.hWnd
End Sub

Private Sub lbLinkAccelerator_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  Screen.MousePointer = vbCustom
  Screen.MouseIcon = picHand.Picture
End Sub

Private Sub Form_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  m_IsSplash = True
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

Private Sub Form_Load()
  If m_IsSplash Then
    Top = (Screen.Height - Height) * 0.25
    Left = (Screen.Width - Width) * 0.5
    m_inicio = True
    LbVersion.Caption = App.Major & "." & App.Minor & "." & App.Revision
    'm_leftVersion = LbVersion.Left
    'LbVersion.Left = -LbVersion.Width
    Timer1.Enabled = True
    Timer1.Interval = 20
  Else
    CSKernelClient2.CenterForm Me, fMain
    LbVersion.Caption = "exe: " & GetExeVersion & " - db: " & CSOAPI2.BdVersion
  End If
  shMain.Top = 0
  shMain.Left = 0
End Sub
