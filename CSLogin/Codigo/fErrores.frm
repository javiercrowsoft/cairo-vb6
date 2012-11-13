VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Begin VB.Form fErrores 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   3510
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   7275
   Icon            =   "fErrores.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3510
   ScaleWidth      =   7275
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth CmdHide 
      Height          =   330
      Left            =   5760
      TabIndex        =   4
      Top             =   1350
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "<< &Ocultar"
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
      FontSize        =   8,25
   End
   Begin CSButton.cButtonLigth CmdDetail 
      Height          =   330
      Left            =   5760
      TabIndex        =   3
      Top             =   765
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "&Detalles >>"
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
      FontSize        =   8,25
   End
   Begin CSButton.cButtonLigth CmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   5760
      TabIndex        =   2
      Top             =   225
      Width           =   1320
      _ExtentX        =   2328
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
      FontSize        =   8,25
   End
   Begin VB.TextBox TxDetail 
      BorderStyle     =   0  'None
      Height          =   1860
      Left            =   90
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Top             =   1440
      Width           =   5505
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      BorderWidth     =   2
      Height          =   1900
      Left            =   75
      Top             =   1430
      Width           =   5550
   End
   Begin VB.Label LbDescrip 
      BackStyle       =   0  'Transparent
      Height          =   765
      Left            =   1080
      TabIndex        =   0
      Top             =   360
      Width           =   4335
   End
   Begin VB.Image ImWarning 
      Height          =   480
      Left            =   240
      Picture         =   "fErrores.frx":000C
      Top             =   240
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImFatal 
      Height          =   480
      Left            =   240
      Picture         =   "fErrores.frx":044E
      Top             =   240
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImInformation 
      Height          =   480
      Left            =   240
      Picture         =   "fErrores.frx":0890
      Top             =   240
      Visible         =   0   'False
      Width           =   480
   End
End
Attribute VB_Name = "fErrores"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'///////////////////////////////////////
' ERRORES ...
'
'///////////////////////////////////////
' Proposito: Administrar los Errores

'///////////////////////////////////////
' Autor: Javier Alvarez y YO 8-)
' DATE de creacion: 17-06-1999
' DATE de modificacion:

'////////////////////////////////////////////////////////

' variables privadas
Private m_Mouse As cMouse

' Funciones PUBLICAS
Public Sub SetDescrip(s As String)
    Me.LbDescrip = s
End Sub

Public Function GetDetail() As String
    GetDetail = Me.TxDetail
End Function

Public Sub AddDetail(s As String)
    Me.TxDetail = Me.TxDetail + s + vbCrLf
End Sub

Public Sub SetCaption(s As String)
    Me.Caption = s
End Sub

Public Sub SetWarning()
    Me.ImWarning.Visible = True
End Sub

Public Sub SetFatal()
    Me.ImFatal.Visible = True
End Sub

Public Sub SetInformation()
    Me.ImInformation.Visible = True
End Sub

' Funciones PRIVADAS
Private Sub Form_Load()
    Set m_Mouse = New cMouse
    
    m_Mouse.MouseSet vbDefault
    
    Me.Height = Me.TxDetail.Top + 200
    Me.Left = (Screen.Width - Me.Width) / 2
    Me.Top = (Screen.Height - Me.Height) / 3
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = vbKeyEscape Then Unload Me
End Sub

Private Sub CmdDetail_Click()
    Me.Height = Me.TxDetail.Top + Me.TxDetail.Height + 500
End Sub

Private Sub CmdHide_Click()
    Me.Height = Me.TxDetail.Top + 200
End Sub

Private Sub cmdOk_Click()
    Unload Me
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set m_Mouse = Nothing
End Sub

Private Sub TxDetail_KeyDown(KeyCode As Integer, Shift As Integer)
  ' Copy secuence
  If Not (KeyCode = vbKeyC And (Shift And vbShiftMask)) Then
    KeyCode = 0
  End If
End Sub

