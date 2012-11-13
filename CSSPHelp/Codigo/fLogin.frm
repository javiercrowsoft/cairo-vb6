VERSION 5.00
Begin VB.Form fLogin 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Login"
   ClientHeight    =   3105
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3045
   ControlBox      =   0   'False
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3105
   ScaleWidth      =   3045
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancelar"
      Height          =   315
      Left            =   1575
      TabIndex        =   9
      Top             =   2700
      Width           =   1290
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   150
      TabIndex        =   8
      Top             =   2700
      Width           =   1290
   End
   Begin VB.OptionButton opSQL 
      Caption         =   "SQL Security"
      Height          =   315
      Left            =   525
      TabIndex        =   7
      Top             =   1125
      Width           =   1740
   End
   Begin VB.OptionButton opWindows 
      Caption         =   "Windows Security"
      Height          =   315
      Left            =   525
      TabIndex        =   6
      Top             =   675
      Value           =   -1  'True
      Width           =   1740
   End
   Begin VB.TextBox txPassword 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   825
      PasswordChar    =   "*"
      TabIndex        =   5
      Top             =   2175
      Width           =   2115
   End
   Begin VB.TextBox txUser 
      Height          =   315
      Left            =   825
      TabIndex        =   3
      Top             =   1725
      Width           =   2115
   End
   Begin VB.TextBox txServer 
      Height          =   315
      Left            =   825
      TabIndex        =   1
      Text            =   "daimaku"
      Top             =   225
      Width           =   2115
   End
   Begin VB.Label Label3 
      Caption         =   "Password"
      Height          =   315
      Left            =   75
      TabIndex        =   4
      Top             =   2175
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "User"
      Height          =   315
      Left            =   75
      TabIndex        =   2
      Top             =   1725
      Width           =   615
   End
   Begin VB.Label Label1 
      Caption         =   "Server"
      Height          =   315
      Left            =   75
      TabIndex        =   0
      Top             =   225
      Width           =   615
   End
End
Attribute VB_Name = "fLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_ok As Boolean

Public Event Connect(ByRef Cancel As Boolean)

Public Property Get Ok() As Boolean
    Ok = m_ok
End Property

Private Sub cmdCancel_Click()
    m_ok = False
    Me.Hide
End Sub

Private Sub cmdOk_Click()
    Dim Cancel As Boolean
    RaiseEvent Connect(Cancel)
    If Cancel Then Exit Sub
    m_ok = True
    Me.Hide
End Sub

Private Sub Form_Load()
    Center Me
    pSetEnabled
End Sub

Private Sub opSQL_Click()
    pSetEnabled
End Sub

Private Sub opWindows_Click()
    pSetEnabled
End Sub

Private Sub pSetEnabled()
    If opWindows.Value Then
        txPassword.Enabled = False
        txUser.Enabled = False
        txPassword.BackColor = vbButtonFace
        txUser.BackColor = vbButtonFace
    Else
        txPassword.Enabled = True
        txUser.Enabled = True
        txPassword.BackColor = vbWindowBackground
        txUser.BackColor = vbWindowBackground
    End If
End Sub
