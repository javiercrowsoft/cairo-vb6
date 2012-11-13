VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   675
      TabIndex        =   0
      Top             =   675
      Width           =   1770
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Dim oMail As cMailSimpleMapi
  Set oMail = New cMailSimpleMapi
  
  oMail.AttachFiles.Add "C:\Documents and Settings\javier\Local Settings\Temp\DC_CSC_COM_0020.pdf"
  oMail.AttachFiles.Add "C:\Documents and Settings\javier\Local Settings\Temp\Microsoft_Visual_Basic.pdf"
  
  oMail.SendMail "Javier Alvarez", _
                 "jaresax@yahoo.com", _
                 "Prueba de PDF", _
                 "Aca va un pdf"
End Sub
