VERSION 5.00
Begin VB.Form fLogin 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Login"
   ClientHeight    =   2415
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4425
   Icon            =   "fLogin.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2415
   ScaleWidth      =   4425
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "Aceptar"
      Height          =   375
      Left            =   2400
      TabIndex        =   2
      Top             =   1920
      Width           =   1815
   End
   Begin VB.ListBox lsLogin 
      Appearance      =   0  'Flat
      Height          =   1200
      Left            =   180
      TabIndex        =   1
      Top             =   480
      Width           =   4095
   End
   Begin VB.Label Label1 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Login"
      Height          =   315
      Left            =   180
      TabIndex        =   0
      Top             =   120
      Width           =   2655
   End
End
Attribute VB_Name = "fLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
  Me.Hide
End Sub

Private Sub Form_Load()
  lsLogin.AddItem "TODOENCARTUCHOS"
  lsLogin.AddItem "BAIRESTONER"
  lsLogin.AddItem "OFFICEBAIRES"
  Me.Left = 1000
  Me.Top = 1000
End Sub

Private Sub lsLogin_Click()
  cmdOk_Click
End Sub
