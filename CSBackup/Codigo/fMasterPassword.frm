VERSION 5.00
Begin VB.Form fMasterPassword 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Clave Maestra"
   ClientHeight    =   2655
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4680
   Icon            =   "fMasterPassword.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2655
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   1320
      TabIndex        =   4
      Top             =   2160
      Width           =   1575
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   3000
      TabIndex        =   5
      Top             =   2160
      Width           =   1575
   End
   Begin VB.TextBox txPassword 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   1200
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   1080
      Width           =   3375
   End
   Begin VB.TextBox txPassword2 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   1200
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   1500
      Width           =   3375
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -2220
      X2              =   4800
      Y1              =   1980
      Y2              =   1980
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -2220
      X2              =   4800
      Y1              =   1995
      Y2              =   1995
   End
   Begin VB.Label lbConfirm 
      Caption         =   "C&onfirmación:"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   1500
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "Cl&ave:"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   1080
      Width           =   1095
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   360
      Picture         =   "fMasterPassword.frx":038A
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Clave Maestra"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1080
      TabIndex        =   6
      Top             =   240
      UseMnemonic     =   0   'False
      Width           =   4935
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   735
      Left            =   0
      Top             =   0
      Width           =   7485
   End
End
Attribute VB_Name = "fMasterPassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_ok As Boolean

Public Property Get Ok() As Boolean
  Ok = m_ok
End Property

Private Sub cmdCancel_Click()
  m_ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  
  If LenB(txPassword.Text) = 0 Then
    MsgWarning "Debe indicar una clave"
    Exit Sub
  End If
  
  If txPassword.Text <> txPassword2.Text And txPassword2.Visible = True Then
    MsgWarning "La clave y su confirmación no coinciden"
    Exit Sub
  End If
  
  If txPassword2.Visible = False Then
    If Not ValidateMasterPassword(txPassword.Text) Then
      If Not Ask("La clave es invalida." & _
              vbCrLf & vbCrLf & _
              "¿Desea ingresar de todas formas?" & _
              vbCrLf & vbCrLf & _
              "(CSBackup no sera capaz de reconocer las claves de ftp y de encriptación de archivos)", vbNo) Then
        Exit Sub
      End If
      txPassword.Text = vbNullString
    End If
  End If
  
  m_ok = True
  
  Me.Hide
  
End Sub

Private Sub Form_Load()
  FormCenter Me
  m_ok = False
End Sub
