VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fMsg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Mensaje"
   ClientHeight    =   5040
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7710
   Icon            =   "fMsg.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5040
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txDetails 
      BorderStyle     =   0  'None
      Height          =   3120
      Left            =   315
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   5
      Top             =   1755
      Width           =   7110
   End
   Begin VB.TextBox txMessage 
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1125
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   4
      Top             =   270
      Width           =   6330
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   6165
      TabIndex        =   2
      Top             =   1065
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Cancelar"
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
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   3540
      TabIndex        =   0
      Top             =   1065
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Aceptar"
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
   Begin CSButton.cButtonLigth cmdNo 
      Height          =   330
      Left            =   4860
      TabIndex        =   1
      Top             =   1065
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&No"
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
   Begin CSButton.cButtonLigth cmdShowDetails 
      Height          =   330
      Left            =   240
      TabIndex        =   3
      Top             =   1080
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Ver detalles"
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
   Begin VB.Shape shDetails 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FF8080&
      Height          =   3270
      Left            =   240
      Top             =   1680
      Width           =   7260
   End
   Begin VB.Image imgError 
      Height          =   480
      Left            =   2520
      Picture         =   "fMsg.frx":000C
      Top             =   900
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgInfo 
      Height          =   480
      Left            =   1980
      Picture         =   "fMsg.frx":0CD6
      Top             =   900
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgQuestion 
      Height          =   480
      Left            =   300
      Picture         =   "fMsg.frx":19A0
      Top             =   240
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Shape Shape2 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FF8080&
      Height          =   450
      Left            =   1050
      Top             =   195
      Width           =   6480
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8250
      Y1              =   870
      Y2              =   870
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   8235
      Y1              =   885
      Y2              =   885
   End
End
Attribute VB_Name = "fMsg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_rslt        As VbMsgBoxResult
Private m_bAskDialog  As Boolean

Private m_Mouse       As cMouse

Public Sub ShowDialog(ByVal msg As String, _
                      ByVal StyleDialog As VbMsgBoxStyle, _
                      ByVal Title As String, _
                      ByVal Details As String)
  
  msg = pFormatMsg(msg)
  
  Me.Caption = Title
  Me.txMessage.Text = msg
  Me.txDetails.Text = Details
  Me.cmdShowDetails.Visible = LenB(Details)
  
  Me.imgError.Top = Me.imgQuestion.Top
  Me.imgInfo.Top = Me.imgQuestion.Top
  Me.imgError.Left = Me.imgQuestion.Left
  Me.imgInfo.Left = Me.imgQuestion.Left
  
  Dim th As Single
  Dim tw As Single
  Dim fWidth As Single
  fWidth = Me.Width
  Me.Width = Me.txMessage.Width
  th = Me.TextHeight(msg)
  tw = Me.TextWidth(msg)
  If tw > Me.txMessage.Width Then
    th = th * 1.5
  End If
  Me.Width = fWidth
  
  If th < 1000 Then th = 1000
  
  If th > Me.txMessage.Height Then
    If th < Screen.Height - 2000 Then
      Me.txMessage.Height = th + 100
    End If
  End If
  
  If StyleDialog And vbYesNoCancel Then
    m_bAskDialog = True
    cmdOk.Caption = "&Si"
    cmdNo.Visible = True
    Me.imgQuestion.Visible = True
    If StyleDialog And vbDefaultButton1 Then
      cmdOk.TabIndex = 0
    ElseIf StyleDialog And vbDefaultButton2 Then
      cmdNo.TabIndex = 0
    ElseIf StyleDialog And vbDefaultButton2 Then
      cmdCancel.TabIndex = 0
    End If
  
  ElseIf StyleDialog And vbYesNo Then
    cmdOk.Left = cmdNo.Left
    cmdNo.Left = cmdCancel.Left
    m_bAskDialog = True
    cmdOk.Caption = "&Si"
    cmdNo.Visible = True
    cmdNo.Cancel = True
    cmdCancel.Visible = False
    Me.imgQuestion.Visible = True
    If StyleDialog And vbDefaultButton1 Then
      cmdOk.TabIndex = 0
    ElseIf StyleDialog And vbDefaultButton2 Then
      cmdNo.TabIndex = 0
    End If
  Else
    cmdOk.Left = cmdCancel.Left
    cmdNo.Visible = False
    cmdOk.Cancel = True
    cmdCancel.Visible = False
    Me.imgInfo.Visible = True
  End If
  
  If StyleDialog And vbDefaultButton2 Then
    cmdNo.default = True
  Else
    cmdOk.default = True
  End If
  
  On Error Resume Next
  
  Shape2.Height = txMessage.Height + 180
  Line1.Y1 = Shape2.Top + Shape2.Height + 200
  Line1.Y2 = Line1.Y1
  Line2.Y1 = Line1.Y1 + 10
  Line2.Y2 = Line2.Y1
  
  cmdOk.Top = Line1.Y2 + 100
  cmdCancel.Top = cmdOk.Top
  cmdNo.Top = cmdOk.Top
  cmdShowDetails.Top = cmdOk.Top
  shDetails.Top = cmdOk.Top + 460
  txDetails.Top = cmdOk.Top + 500
  
  Me.Height = (Me.Height - Me.ScaleHeight) + cmdNo.Top + 420
  
  CenterForm_ Me
  Me.Show vbModal
End Sub

Public Property Get rslt() As VbMsgBoxResult
  rslt = m_rslt
End Property

Private Sub cmdCancel_Click()
  m_rslt = vbCancel
  Me.Hide
End Sub

Private Sub cmdNo_Click()
  m_rslt = vbNo
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  If m_bAskDialog Then
    m_rslt = vbYes
  Else
    m_rslt = vbOK
  End If
  Me.Hide
End Sub

Private Sub cmdShowDetails_Click()
  On Error Resume Next
  Me.Height = (Me.Height - Me.ScaleHeight) + txDetails.Top + txDetails.Height + 200
End Sub

Private Sub Form_Load()
  m_rslt = vbCancel
  m_bAskDialog = False
  Set m_Mouse = New cMouse
  m_Mouse.MouseDefault
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    cmdCancel_Click
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_Mouse = Nothing
End Sub

Private Function pFormatMsg(ByVal msg As String) As String
  msg = Replace(msg, vbCrLf, "@@vbcrlf@@")
  msg = Replace(msg, vbLf & vbCr, "@@vbcrlf@@")
  msg = Replace(msg, vbLf, "@@vbcrlf@@")
  msg = Replace(msg, vbCr, "@@vbcrlf@@")
  pFormatMsg = Replace(msg, "@@vbcrlf@@", vbCrLf)
End Function
