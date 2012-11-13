VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Encrypt"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text2 
      Height          =   435
      Left            =   360
      TabIndex        =   2
      Top             =   1800
      Width           =   2895
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Encrypt"
      Height          =   375
      Left            =   420
      TabIndex        =   1
      Top             =   1200
      Width           =   1755
   End
   Begin VB.TextBox Text1 
      Height          =   435
      Left            =   360
      TabIndex        =   0
      Top             =   420
      Width           =   2895
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Dim e As cEncrypt
  Set e = New cEncrypt
  
  Text2.Text = e.Encript(Text1.Text, "Virginia Said-Neron-Catalina-la belleza")
End Sub
