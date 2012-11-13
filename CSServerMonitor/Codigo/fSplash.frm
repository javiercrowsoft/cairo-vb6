VERSION 5.00
Begin VB.Form fSplash 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   ClientHeight    =   5190
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7800
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5190
   ScaleWidth      =   7800
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Left            =   6600
      Top             =   120
   End
   Begin VB.PictureBox picHand 
      Height          =   495
      Left            =   7080
      Picture         =   "fSplash.frx":0000
      ScaleHeight     =   435
      ScaleWidth      =   435
      TabIndex        =   0
      Top             =   120
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.Shape shMain 
      BackColor       =   &H00FFFFFF&
      BorderColor     =   &H00808080&
      Height          =   5190
      Left            =   0
      Top             =   0
      Width           =   7795
   End
   Begin VB.Shape Shape4 
      BackColor       =   &H00FF8080&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   135
      Left            =   -240
      Top             =   3180
      Width           =   7695
   End
   Begin VB.Label lbCopyRight01 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Copyright © 2003-2005 Crowsoft."
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
      Left            =   3420
      TabIndex        =   5
      Top             =   3720
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
      Left            =   2580
      TabIndex        =   4
      Top             =   3960
      Width           =   5055
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
      Left            =   3420
      TabIndex        =   3
      Top             =   4200
      Width           =   4215
   End
   Begin VB.Shape Shape5 
      BackColor       =   &H000080FF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   4215
      Left            =   7260
      Top             =   420
      Width           =   675
   End
   Begin VB.Image Image1 
      Height          =   1605
      Left            =   480
      Picture         =   "fSplash.frx":030A
      Top             =   1200
      Width           =   6915
   End
   Begin VB.Shape Shape6 
      BackColor       =   &H00FF8080&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   375
      Left            =   3720
      Top             =   240
      Width           =   6315
   End
   Begin VB.Label lbVersion 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "1.01.01"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   270
      Left            =   6435
      TabIndex        =   7
      Top             =   2820
      Width           =   720
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
      Left            =   120
      TabIndex        =   6
      Top             =   4200
      Width           =   2835
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
      Left            =   1440
      TabIndex        =   2
      Top             =   4680
      Width           =   6795
   End
   Begin VB.Image imgLink 
      Height          =   720
      Left            =   780
      Picture         =   "fSplash.frx":4667
      Top             =   3420
      Width           =   1200
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000F&
      X1              =   -60
      X2              =   9000
      Y1              =   4620
      Y2              =   4620
   End
   Begin VB.Image Image3 
      Height          =   750
      Left            =   240
      Picture         =   "fSplash.frx":4AEB
      Top             =   360
      Width           =   3120
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Portions Copyright © 1998 Kirk Stowell."
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   1440
      TabIndex        =   1
      Top             =   4920
      Width           =   4575
   End
End
Attribute VB_Name = "fSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim m_inicio        As Boolean
Dim m_leftVersion   As Integer
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

Private Sub Form_Unload(Cancel As Integer)
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
  m_IsSplash = True
End Sub

Private Sub Form_Load()
  If m_IsSplash Then
    Top = (Screen.Height - Height) * 0.25
    Left = (Screen.Width - Width) * 0.5
    m_inicio = True
    lbVersion.Caption = GetExeVersion
    m_leftVersion = lbVersion.Left
    Timer1.Enabled = True
    Timer1.Interval = 20
  Else
    Top = (Screen.Height - Height) * 0.25
    Left = (Screen.Width - Width) * 0.5
    lbVersion.Caption = GetExeVersion
  End If
  shMain.Top = 0
  shMain.Left = 0
End Sub

Private Function GetExeVersion() As String
  GetExeVersion = App.Major & "." & Format(App.Minor, "00") & "." & Format(App.Revision, "00")
End Function

