VERSION 5.00
Object = "{781EA44F-AC84-420A-A5ED-7C4BD447C313}#1.0#0"; "CSCalendar.ocx"
Begin VB.Form fCalendar 
   BackColor       =   &H00808080&
   BorderStyle     =   0  'None
   ClientHeight    =   6270
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3600
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   6270
   ScaleWidth      =   3600
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSCalendar.cCalendar clCalendar 
      Height          =   4105
      Left            =   15
      TabIndex        =   1
      Top             =   435
      Width           =   3565
      _ExtentX        =   6297
      _ExtentY        =   7250
   End
   Begin VB.PictureBox picButton 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   135
      ScaleHeight     =   315
      ScaleWidth      =   3315
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   80
      Width           =   3315
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "(+2) Pasado mañana, etc..."
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   5940
      Width           =   3195
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "(+1) Mañana"
      Height          =   255
      Left            =   240
      TabIndex        =   6
      Top             =   5700
      Width           =   3195
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "(-2) Antes de ayer, etc..."
      Height          =   255
      Left            =   240
      TabIndex        =   5
      Top             =   5460
      Width           =   3195
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "(h) Hoy"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   4980
      Width           =   3195
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "(-1) Ayer"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   5220
      Width           =   3195
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Dias por Nombres"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   4680
      Width           =   3315
   End
   Begin VB.Shape Shape2 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FFFFFF&
      Height          =   1695
      Left            =   15
      Top             =   4560
      Width           =   3570
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H8000000F&
      BorderWidth     =   3
      Height          =   435
      Left            =   30
      Top             =   30
      Width           =   3535
   End
End
Attribute VB_Name = "fCalendar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Ok As Boolean
Public Event ShowPopMenuDates()

Private m_FlagInside        As Boolean
Private m_FocusInMe         As Boolean
Private m_Editing           As Boolean
Private m_NoLostFocus       As Boolean
Private m_Status            As STATUS_BUTTON

Private m_BorderColor   As Long

Public Property Let BorderColor(ByVal rhs As OLE_COLOR)
  m_BorderColor = rhs
End Property

Private Sub clCalendar_DblClick()
  On Error Resume Next
  Ok = True
  Hide
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  If KeyAscii = vbKeyEscape Then Hide
End Sub

Private Sub Form_Load()
  On Error Resume Next
  Ok = False
  m_BorderColor = vbButtonShadow
  pDrawBorder
  pDrawSelectionBox UNPRESSED
End Sub

Private Sub picButton_Click()
  On Error Resume Next
  
  Dim Cancel As Boolean
  ' Para que se ejecute el lostfocus de los demas controles
  DoEvents
  pDrawSelectionBox PRESSED
  DoEvents
  
  RaiseEvent ShowPopMenuDates
  
  ' Como el foco esta en el control, el control se levanta
  Sleep 200
  pDrawSelectionBox MOUSE_MOVE
  m_FlagInside = False
End Sub

Private Sub picButton_GotFocus()
  On Error Resume Next
  
  m_Editing = True
  m_FocusInMe = True
  pDrawSelectionBox MOUSE_MOVE
  
  m_NoLostFocus = True
End Sub

Private Sub picButton_LostFocus()
  On Error Resume Next
  
  m_FocusInMe = False
  pDrawSelectionBox UNPRESSED
  
  m_NoLostFocus = False
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  If m_NoLostFocus Then
      m_NoLostFocus = False
      Exit Sub
  End If
End Sub

Private Sub picButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  
  Dim ret As Long
  
  If m_FocusInMe Then Exit Sub
      
  If X < 0 Or X > picButton.Width Or Y < 0 Or Y > picButton.Height Then
      
      ' el punto esta fuera del control
      m_FlagInside = False
      ret = ReleaseCapture()
      pDrawSelectionBox UNPRESSED
  Else
      ' el punto esta dentro del control
      If m_FlagInside = False Then
          m_FlagInside = True
          ret = SetCapture(picButton.hWnd)
          pDrawSelectionBox MOUSE_MOVE
      End If
  End If
End Sub

Private Sub pDrawSelectionBox(ByVal bStatus As STATUS_BUTTON)
  Dim clrTopLeft      As Long
  Dim clrBottomRight  As Long

  picButton.Cls
  m_Status = bStatus

  'Set highlight and shadow colors
  Select Case bStatus
  
      Case PRESSED
          clrTopLeft = vbButtonShadow
          clrBottomRight = vb3DHighlight
      Case UNPRESSED
          clrTopLeft = m_BorderColor
          clrBottomRight = m_BorderColor
      Case MOUSE_MOVE
          clrTopLeft = vb3DHighlight
          clrBottomRight = vbButtonShadow
  End Select
  
  'Draw box around date
  picButton.Line (0, picButton.ScaleHeight - 15)-Step(0, -picButton.ScaleHeight + 15), clrTopLeft
  picButton.Line -Step(picButton.ScaleWidth - 15, 0), clrTopLeft
  picButton.Line -Step(0, picButton.ScaleHeight - 15), clrBottomRight
  picButton.Line -Step(-picButton.ScaleWidth, 0), clrBottomRight
  pSetCaptionButton
End Sub

Private Sub pDrawBorder()
  Dim clrTopLeft      As Long
  Dim clrBottomRight  As Long

  clrTopLeft = m_BorderColor
  clrBottomRight = m_BorderColor

  Me.Line (0, ScaleHeight - 15)-Step(0, -ScaleHeight + 15), clrTopLeft
  Me.Line -Step(ScaleWidth - 15, 0 + 0), clrTopLeft
  Me.Line -Step(0 + 0, ScaleHeight - 15), clrBottomRight
  Me.Line -Step(-ScaleWidth + 15, 0), clrBottomRight
End Sub

Private Sub pSetCaptionButton()
  Const Caption = "Fechas por nombre ..."
  picButton.CurrentX = (picButton.ScaleWidth - picButton.TextWidth(Caption)) / 2 + 5
  picButton.CurrentY = (picButton.ScaleHeight - picButton.TextHeight(Caption)) / 2 - 5
  picButton.Print Caption
End Sub
