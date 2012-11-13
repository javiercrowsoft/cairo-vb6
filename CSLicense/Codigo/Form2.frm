VERSION 5.00
Begin VB.Form Form2 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Login"
   ClientHeight    =   435
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3855
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   435
   ScaleWidth      =   3855
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Acpetar"
      Default         =   -1  'True
      Height          =   315
      Left            =   2580
      TabIndex        =   1
      Top             =   60
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   180
      PasswordChar    =   "*"
      TabIndex        =   0
      Top             =   60
      Width           =   2295
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  If Text1.Text = "cata1998" Then
    Form1.Show
    Unload Form2
  End If
End Sub

Private Sub Form_Load()
  Left = (Screen.Width - Width) / 2
  Top = (Screen.Height - Height) / 2
End Sub
