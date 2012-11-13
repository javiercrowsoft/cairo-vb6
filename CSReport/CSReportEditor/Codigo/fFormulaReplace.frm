VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fFormulaReplace 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Remplazo en Formulas"
   ClientHeight    =   5655
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   6885
   Icon            =   "fFormulaReplace.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5655
   ScaleWidth      =   6885
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox PicSplitter 
      BorderStyle     =   0  'None
      Height          =   105
      Left            =   315
      MousePointer    =   7  'Size N S
      ScaleHeight     =   105
      ScaleWidth      =   1530
      TabIndex        =   6
      TabStop         =   0   'False
      Top             =   2610
      Width           =   1530
   End
   Begin VB.PictureBox PicSplitterBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   105
      Left            =   2205
      ScaleHeight     =   105
      ScaleWidth      =   1590
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   2610
      Width           =   1590
   End
   Begin VB.TextBox ctxNewFormula 
      Height          =   2115
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   2
      Top             =   2970
      Width           =   6855
   End
   Begin VB.TextBox ctxCurrFormula 
      BackColor       =   &H8000000F&
      Height          =   2115
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   765
      Width           =   6855
   End
   Begin CSButton.cButton cmdCancelar 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   5535
      TabIndex        =   3
      Top             =   5265
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin CSButton.cButton cmdAceptar 
      Height          =   315
      Left            =   4140
      TabIndex        =   4
      Top             =   5265
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Remplazo en Formulas"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   960
      TabIndex        =   1
      Top             =   270
      Width           =   2235
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fFormulaReplace.frx":000C
      Top             =   45
      Width           =   675
   End
   Begin VB.Shape shTop 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fFormulaReplace"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fFormulaReplace
' 21-09-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fFormulaReplace"

Private Const sglSplitLimit = 1500

' estructuras
' variables privadas
Private m_moving                        As Boolean
Private m_Ok                            As Boolean

' eventos
' propiedades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
Private Sub cmdAceptar_Click()
  On Error GoTo ControlError
  
  m_Ok = True
  Hide
  
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Hide
End Sub

Private Sub ctxCurrFormula_KeyPress(KeyAscii As Integer)
  KeyAscii = 0
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    m_Ok = False
    Hide
  End If
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

'-------------------------------------------------------------
' Splitter
Private Sub PicSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    With PicSplitter
      PicSplitterBar.Move .Left, .Top, .Width, .Height - 20
    End With
    PicSplitterBar.Visible = True
    m_moving = True
End Sub

Private Sub PicSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim sglPos As Single

    If m_moving Then
        sglPos = y + PicSplitter.Top
        If sglPos < sglSplitLimit Then
            PicSplitterBar.Top = sglSplitLimit
        ElseIf sglPos > ScaleHeight - sglSplitLimit Then
            PicSplitterBar.Top = ScaleHeight - sglSplitLimit
        Else
            PicSplitterBar.Top = sglPos
        End If
    End If
End Sub
Private Sub PicSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    SizeControls
    PicSplitterBar.Visible = False
    m_moving = False
End Sub

Private Sub SizeControls()
  On Error GoTo ControlError
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  If WindowState = vbMinimized Then Exit Sub
  
  PicSplitterBar.Visible = False
  
  If PicSplitterBar.Top > ScaleHeight Then
    PicSplitterBar.Top = ScaleHeight - sglSplitLimit
  ElseIf PicSplitterBar.Top < sglSplitLimit Then
    PicSplitterBar.Top = sglSplitLimit
  End If
  
  shTop.Width = ScaleWidth
  
  cmdAceptar.Top = ScaleHeight - cmdAceptar.Height - 50
  cmdCancelar.Top = cmdAceptar.Top
  
  PicSplitter.Top = PicSplitterBar.Top
  PicSplitter.Width = ScaleWidth
  PicSplitterBar.Width = ScaleWidth
  
  ctxCurrFormula.Height = PicSplitterBar.Top - ctxCurrFormula.Top - 60
  ctxNewFormula.Top = PicSplitterBar.Top + 60
  ctxNewFormula.Height = cmdAceptar.Top - PicSplitterBar.Top - 120
  ctxCurrFormula.Width = ScaleWidth
  ctxNewFormula.Width = ScaleWidth
  
  cmdCancelar.Left = ScaleWidth - cmdCancelar.Width - 50
  cmdAceptar.Left = cmdCancelar.Left - cmdAceptar.Width - 100
ControlError:
End Sub

Private Sub Form_Load()
  m_Ok = False
  CenterForm Me
  PicSplitter.Left = 0
  PicSplitterBar.Left = 0
  PicSplitter.Height = 50
  PicSplitter.Top = Me.ScaleHeight / 2
  PicSplitterBar.Top = PicSplitter.Top
  SizeControls
  PicSplitterBar.ZOrder
End Sub
