VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fErrores 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   6180
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   7815
   Icon            =   "fErrores.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6180
   ScaleWidth      =   7815
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth CmdDetail 
      Height          =   330
      Left            =   6075
      TabIndex        =   3
      Top             =   990
      Width           =   1590
      _ExtentX        =   2805
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
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth CmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   6075
      TabIndex        =   2
      Top             =   180
      Width           =   1590
      _ExtentX        =   2805
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
   Begin VB.TextBox TxDetail 
      BorderStyle     =   0  'None
      Height          =   4425
      Left            =   90
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Top             =   1665
      Width           =   7620
   End
   Begin CSButton.cButtonLigth cmdSendMail 
      Height          =   330
      Left            =   6075
      TabIndex        =   4
      Top             =   585
      Width           =   1590
      _ExtentX        =   2805
      _ExtentY        =   582
      Caption         =   "&Enviar E-mail"
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
      Picture         =   "fErrores.frx":038A
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   4460
      Left            =   75
      Top             =   1650
      Width           =   7655
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
      Picture         =   "fErrores.frx":0491
      Top             =   240
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImFatal 
      Height          =   480
      Left            =   240
      Picture         =   "fErrores.frx":115B
      Top             =   240
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImInformation 
      Height          =   480
      Left            =   240
      Picture         =   "fErrores.frx":1E25
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
' Fecha de creacion: 17-06-1999

'////////////////////////////////////////////////////////

' variables privadas
Private m_Mouse             As cMouse
Private m_bDetailsVisible   As Boolean

' Funciones PUBLICAS
Public Sub SetDescrip(s As String)
  Me.lbDescrip = s
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

Private Sub cmdSendMail_Click()
  On Error GoTo ControlError
  
  Dim Subject As String
  Dim Body   As String
  
  Subject = "Error detectado en: " & gEmailErrDescrip
  
  Body = "Dia y Hora: " & Format(Now, "dd/mm/yyyy hh:nn:ss") & vbCrLf & vbCrLf & _
         Me.TxDetail.Text
  
  SendEmailToCrowSoft_ Subject, Body

  Exit Sub
ControlError:
  MsgError_ Err.Description
End Sub

' Funciones PRIVADAS
Private Sub Form_Load()
  Set m_Mouse = New cMouse
  
  m_Mouse.MouseSet vbDefault
  
  m_bDetailsVisible = False
  
  Me.Height = Me.TxDetail.Top + 200
  Me.Left = (Screen.Width - Me.Width) / 2
  Me.Top = (Screen.Height - Me.Height) / 3
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyEscape Then Unload Me
End Sub

Private Sub CmdDetail_Click()
  If m_bDetailsVisible Then
    Me.Height = Me.TxDetail.Top + 200
    CmdDetail.Caption = "Detalles >>"
    m_bDetailsVisible = False
  Else
    Me.Height = Me.TxDetail.Top + Me.TxDetail.Height + 500
    CmdDetail.Caption = "<< Ocultar"
    m_bDetailsVisible = True
  End If
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
  If Not (KeyCode = vbKeyC And (Shift And vbCtrlMask)) Then
    KeyCode = 0
  End If
End Sub

Private Function CreateObject(ByVal Class As String) As Object
  On Error GoTo ControlError
  Set CreateObject = Interaction.CreateObject(Class)
  Exit Function
ControlError:
  Err.Raise Err.Number, Err.Source, "No se pudo crear el objeto " & Class & ".\nError Original: " & Err.Description, Err.HelpFile, Err.HelpContext
End Function

