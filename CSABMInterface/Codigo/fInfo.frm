VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fInfo 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Info"
   ClientHeight    =   4350
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "fInfo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4350
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkParse 
      Caption         =   "Usar la coma como separador de lineas"
      Height          =   240
      Left            =   90
      TabIndex        =   2
      Top             =   3420
      Width           =   4290
   End
   Begin VB.TextBox txInfo 
      Height          =   3120
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   45
      Width           =   4560
   End
   Begin CSButton.cButton cmdClose 
      Height          =   330
      Left            =   3465
      TabIndex        =   1
      Top             =   3915
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   582
      Caption         =   "&Cerrar"
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
   Begin VB.Line Line4 
      BorderColor     =   &H8000000E&
      X1              =   0
      X2              =   6525
      Y1              =   3300
      Y2              =   3300
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   6525
      Y1              =   3285
      Y2              =   3285
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -135
      X2              =   6390
      Y1              =   3825
      Y2              =   3825
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000E&
      X1              =   -135
      X2              =   6390
      Y1              =   3840
      Y2              =   3840
   End
End
Attribute VB_Name = "fInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_bCtrlKey As Boolean
Private m_info As String

Public Property Let Info(ByVal rhs As String)
  m_info = rhs
  txInfo.Text = m_info
End Property

Private Sub chkParse_Click()
  If chkParse.Value = vbChecked Then
    txInfo.Text = Replace(m_info, ",", vbCrLf)
  Else
    txInfo.Text = m_info
  End If
End Sub

Private Sub cmdClose_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.CenterForm Me
End Sub

Private Sub txInfo_KeyDown(KeyCode As Integer, Shift As Integer)
  m_bCtrlKey = False
  Select Case KeyCode
    Case vbKeyDown, vbKeyUp, vbKeyLeft, vbKeyRight, _
         vbKeyPageDown, vbKeyPageUp, vbKeyHome, vbKeyEnd
      Exit Sub
  End Select
  If (Shift And vbCtrlMask) Or (Shift And vbShiftMask) Then
    m_bCtrlKey = True
    Exit Sub
  Else
    KeyCode = 0
  End If
End Sub

Private Sub txInfo_KeyPress(KeyAscii As Integer)
  If (KeyAscii And vbCtrlMask) Or (KeyAscii And vbShiftMask) Then
    Exit Sub
  End If
  If m_bCtrlKey And UCase$(Chr$(KeyAscii)) = "C" Then Exit Sub
  KeyAscii = 0
End Sub

Private Sub txInfo_KeyUp(KeyCode As Integer, Shift As Integer)
  m_bCtrlKey = False
End Sub
