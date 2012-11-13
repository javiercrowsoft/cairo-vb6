VERSION 5.00
Begin VB.Form frmGoto 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Go To Line"
   ClientHeight    =   1545
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5250
   Icon            =   "frmGoto.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1545
   ScaleWidth      =   5250
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3900
      TabIndex        =   2
      Top             =   600
      Width           =   1155
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3900
      TabIndex        =   1
      Top             =   120
      Width           =   1155
   End
   Begin VB.TextBox txtLine 
      Height          =   345
      Left            =   180
      TabIndex        =   0
      Top             =   480
      Width           =   3495
   End
   Begin VB.Label lblLines 
      Caption         =   "Label2"
      Height          =   315
      Left            =   1260
      TabIndex        =   5
      Top             =   1020
      Width           =   2355
   End
   Begin VB.Label Label1 
      Caption         =   "Total Lines:"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   1020
      Width           =   915
   End
   Begin VB.Label lblData 
      AutoSize        =   -1  'True
      Caption         =   "Enter line number:"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   3
      Top             =   180
      Width           =   1275
   End
End
Attribute VB_Name = "frmGoto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

Private Sub cmdCancel_Click()
  Me.Hide
End Sub

Private Sub cmdOK_Click()
  
    Dim Line As Long
    Dim DocSize As Long
    
    DocSize = fMainForm.ActiveForm.Editawy1.Length
    
    If txtLine.Text = "" Then Exit Sub
    
    Line = CLng(txtLine.Text)
    If Line > 0 And Line <= DocSize Then
        fMainForm.ActiveForm.Editawy1.GoToLine Line - 1
    Else
        txtLine.Text = ""
        txtLine.SelStart = 0
        txtLine.SelLength = Len(txtLine.Text)
        txtLine.SetFocus
        Exit Sub
    End If
    
    Me.Hide
End Sub

Private Sub Form_Activate()
    txtLine.SelStart = 0
    txtLine.SelLength = Len(txtLine.Text)
    txtLine.SetFocus
End Sub

Private Sub Form_Load()
  Me.left = GetSetting(App.Title, "Settings", "GotoLeft", (Screen.width - Me.width) \ 2)
  Me.top = GetSetting(App.Title, "Settings", "GotoTop", (Screen.height - Me.height) \ 2)
  
  Dim DocSize As Long
  DocSize = fMainForm.ActiveForm.Editawy1.Length
  lblLines = DocSize
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  SaveSetting App.Title, "Settings", "GotoLeft", Me.left
  SaveSetting App.Title, "Settings", "GotoTop", Me.top
End Sub

Private Sub txtColumn_KeyPress(KeyAscii As Integer)
  If Not IsNumeric(Chr(KeyAscii)) And (KeyAscii <> 8) Then KeyAscii = 0
End Sub

Private Sub txtLine_KeyPress(KeyAscii As Integer)
  If Not IsNumeric(Chr(KeyAscii)) And KeyAscii <> 8 Then KeyAscii = 0
End Sub
