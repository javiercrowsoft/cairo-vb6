VERSION 5.00
Begin VB.Form FrmLogin 
   Appearance      =   0  'Flat
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Login"
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3630
   Icon            =   "FrmLogin.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2400
   ScaleWidth      =   3630
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TxPassword 
      Height          =   285
      Left            =   1080
      TabIndex        =   7
      Top             =   1485
      Width           =   2265
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Aceptar"
      Height          =   330
      Left            =   2160
      TabIndex        =   6
      Top             =   1890
      Width           =   1185
   End
   Begin VB.TextBox TxUser 
      Height          =   285
      Left            =   1080
      TabIndex        =   4
      Text            =   "sa"
      Top             =   1080
      Width           =   2265
   End
   Begin VB.TextBox TxBase 
      Height          =   285
      Left            =   1080
      TabIndex        =   2
      Text            =   "cairoinit"
      Top             =   675
      Width           =   2265
   End
   Begin VB.TextBox TxServer 
      Height          =   285
      Left            =   1080
      TabIndex        =   0
      Text            =   "Mesalina"
      Top             =   270
      Width           =   2265
   End
   Begin VB.Label Label4 
      Caption         =   "PWD:"
      Height          =   240
      Left            =   225
      TabIndex        =   8
      Top             =   1530
      Width           =   780
   End
   Begin VB.Label Label3 
      Caption         =   "UID:"
      Height          =   240
      Left            =   225
      TabIndex        =   5
      Top             =   1125
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "Base:"
      Height          =   240
      Left            =   225
      TabIndex        =   3
      Top             =   720
      Width           =   780
   End
   Begin VB.Label Label1 
      Caption         =   "Servidor:"
      Height          =   240
      Left            =   225
      TabIndex        =   1
      Top             =   315
      Width           =   780
   End
End
Attribute VB_Name = "FrmLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public ok As Boolean

Private Sub Command1_Click()
  ok = True
  Me.Hide
End Sub

Private Sub Form_Load()
  ok = False
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Cancel = UnloadMode <> vbFormCode
End Sub
