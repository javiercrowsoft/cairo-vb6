VERSION 5.00
Begin VB.Form frmNewLang 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "New Language"
   ClientHeight    =   4590
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3150
   Icon            =   "frmNewLang.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4590
   ScaleWidth      =   3150
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   2040
      TabIndex        =   7
      Top             =   4080
      Width           =   975
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   960
      TabIndex        =   6
      Top             =   4080
      Width           =   975
   End
   Begin VB.PictureBox picSplit 
      Height          =   60
      Left            =   120
      ScaleHeight     =   0
      ScaleWidth      =   2835
      TabIndex        =   16
      TabStop         =   0   'False
      Top             =   3840
      Width           =   2895
   End
   Begin VB.TextBox txtName 
      Height          =   315
      Left            =   120
      TabIndex        =   5
      Top             =   3360
      Width           =   2895
   End
   Begin VB.PictureBox picBack 
      BackColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   2280
      ScaleHeight     =   315
      ScaleWidth      =   675
      TabIndex        =   14
      TabStop         =   0   'False
      Top             =   2520
      Width           =   735
   End
   Begin VB.PictureBox picFore 
      BackColor       =   &H00000000&
      Height          =   375
      Left            =   600
      ScaleHeight     =   315
      ScaleWidth      =   675
      TabIndex        =   13
      TabStop         =   0   'False
      Top             =   2520
      Width           =   735
   End
   Begin VB.CommandButton cmdBack 
      Caption         =   ".."
      Height          =   375
      Left            =   1800
      TabIndex        =   4
      Top             =   2520
      Width           =   375
   End
   Begin VB.CommandButton cmdFore 
      Caption         =   ".."
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   2520
      Width           =   375
   End
   Begin VB.TextBox txtSize 
      Height          =   315
      Left            =   120
      TabIndex        =   2
      Text            =   "10"
      Top             =   1800
      Width           =   2895
   End
   Begin VB.ComboBox cmbFont 
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   1080
      Width           =   2895
   End
   Begin VB.ComboBox cmbLexer 
      Height          =   315
      ItemData        =   "frmNewLang.frx":000C
      Left            =   120
      List            =   "frmNewLang.frx":00EE
      TabIndex        =   0
      Top             =   360
      Width           =   2895
   End
   Begin VB.Label Label5 
      Caption         =   "Language Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   3120
      Width           =   2775
   End
   Begin VB.Label Label4 
      Caption         =   "Def Backcolor:"
      Height          =   375
      Left            =   1800
      TabIndex        =   12
      Top             =   2280
      Width           =   1335
   End
   Begin VB.Label Label3 
      Caption         =   "Def Forecolor:"
      Height          =   375
      Left            =   120
      TabIndex        =   11
      Top             =   2280
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "Default Font Size:"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1560
      Width           =   2655
   End
   Begin VB.Label Label1 
      Caption         =   "Default Font:"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   840
      Width           =   2535
   End
   Begin VB.Label lblLexer 
      Caption         =   "Use Lexer:"
      Height          =   375
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   2775
   End
End
Attribute VB_Name = "frmNewLang"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public strDir As String

Private Sub cmbLexer_Click()
  If txtName.Text = "" Then txtName.Text = cmbLexer.Text
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOK_Click()
  Dim strFile As String
  Dim strHold As String
  Dim lLang As Integer
  Dim strLang As String
  If txtName.Text = "" Then
    MsgBox "Please enter a valid name for this language"
    Exit Sub
  End If
  lLang = cmbLexer.ListIndex
  If lLang > 28 Then lLang = lLang + 2
  strLang = lLang
  strFile = strDir & "\" & txtName.Text & ".CHL"
  writeini "data", "LangName", txtName.Text, strFile
  writeini "data", "Language", strLang, strFile
  strHold = ":::V:C:::" & cmbFont.Text & ":" & txtSize.Text & ":" & picFore.BackColor & ":" & picBack.BackColor & "::"
  writeini "data", "Style[32]", strHold, strFile
  LoadHighlighter strFile
  frmOptions.ListLangs strDir
  Unload Me
End Sub

Private Sub Form_Load()
  Flatten Me
  Dim i As Long
  For i = 0 To Screen.FontCount - 1
    cmbFont.AddItem Screen.Fonts(i)
  Next i
  cmbFont.Text = "Courier New"
  cmbLexer.ListIndex = 3
End Sub

Private Sub txtSize_KeyPress(KeyAscii As Integer)
  If Not IsNumeric(Chr(KeyAscii)) And (KeyAscii <> 8) Then KeyAscii = 0
End Sub
