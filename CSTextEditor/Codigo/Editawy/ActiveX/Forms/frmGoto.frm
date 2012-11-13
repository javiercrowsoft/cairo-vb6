VERSION 5.00
Begin VB.Form frmGoto 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Goto"
   ClientHeight    =   1425
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5175
   Icon            =   "frmGoto.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1425
   ScaleWidth      =   5175
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtLine 
      Height          =   345
      Left            =   180
      TabIndex        =   2
      Top             =   480
      Width           =   3495
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
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3900
      TabIndex        =   0
      Top             =   600
      Width           =   1155
   End
   Begin VB.Label lblData 
      AutoSize        =   -1  'True
      Caption         =   "Enter line number:"
      Height          =   255
      Index           =   0
      Left            =   180
      TabIndex        =   5
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label Label1 
      Caption         =   "Total Lines:"
      Height          =   255
      Left            =   180
      TabIndex        =   4
      Top             =   1020
      Width           =   975
   End
   Begin VB.Label lblLines 
      Caption         =   "Label2"
      Height          =   315
      Left            =   1260
      TabIndex        =   3
      Top             =   1020
      Width           =   2355
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

Public Editawy1 As Editawy

Private Sub cmdCancel_Click()
    Editawy1.SetFocus
    Unload Me
End Sub

Private Sub cmdOK_Click()
  
    Dim Line As Long
    Dim DocSize As Long
    
    DocSize = Editawy1.length
    
    If txtLine.Text = "" Then Exit Sub
    
    Line = CLng(txtLine.Text)
    If Line > 0 And Line <= DocSize Then
        Editawy1.GoToLine Line - 1
        Editawy1.SetFocus
    Else
        txtLine.Text = ""
        txtLine.SelStart = 0
        txtLine.SelLength = Len(txtLine.Text)
        txtLine.SetFocus
        Exit Sub
    End If
    
    Editawy1.SetFocus
    Unload Me
End Sub

Private Sub Form_Activate()
    txtLine.SelStart = 0
    txtLine.SelLength = Len(txtLine.Text)
    txtLine.SetFocus
End Sub

Private Sub Form_Load()
  Me.Left = GetSetting(App.Title, "Settings", "XGotoLeft", (Screen.Width - Me.Width) \ 2)
  Me.Top = GetSetting(App.Title, "Settings", "XGotoTop", (Screen.Height - Me.Height) \ 2)
  
  Dim DocSize As Long
  DocSize = Editawy1.length
  lblLines = DocSize
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  SaveSetting App.Title, "Settings", "XGotoLeft", Me.Left
  SaveSetting App.Title, "Settings", "XGotoTop", Me.Top
  
  Editawy1.SetFocus
End Sub

Private Sub txtLine_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
      cmdCancel_Click
    End If
    If Not IsNumeric(Chr(KeyAscii)) And KeyAscii <> 8 Then KeyAscii = 0
End Sub

