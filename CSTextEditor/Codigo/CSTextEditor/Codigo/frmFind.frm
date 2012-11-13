VERSION 5.00
Begin VB.Form frmFind 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Find"
   ClientHeight    =   1905
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6495
   Icon            =   "frmFind.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1905
   ScaleWidth      =   6495
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdMarkAll 
      Caption         =   "Mark All"
      Height          =   375
      Left            =   4860
      TabIndex        =   11
      Top             =   540
      Width           =   1455
   End
   Begin VB.Frame Frame1 
      Caption         =   "Direction"
      Height          =   615
      Left            =   2280
      TabIndex        =   10
      Top             =   780
      Width           =   2355
      Begin VB.OptionButton optDown 
         Caption         =   "&Down"
         Height          =   255
         Left            =   1260
         TabIndex        =   8
         Top             =   240
         Value           =   -1  'True
         Width           =   1035
      End
      Begin VB.OptionButton optUp 
         Caption         =   "&Up"
         Height          =   255
         Left            =   60
         TabIndex        =   7
         Top             =   240
         Width           =   975
      End
   End
   Begin VB.CheckBox chkWrap 
      Caption         =   "Wra&p at the end of the document"
      Height          =   315
      Left            =   2280
      TabIndex        =   9
      Top             =   1500
      Width           =   2835
   End
   Begin VB.CheckBox chkRegExp 
      Caption         =   "Regular e&xpression"
      Height          =   255
      Left            =   180
      TabIndex        =   6
      Top             =   1500
      Width           =   2055
   End
   Begin VB.CheckBox chkWhole 
      Caption         =   "&Whole word only"
      Height          =   195
      Left            =   180
      TabIndex        =   5
      Top             =   1140
      Width           =   2055
   End
   Begin VB.CheckBox chkCase 
      Caption         =   "&Case sensitive"
      Height          =   255
      Left            =   180
      TabIndex        =   4
      Top             =   780
      Width           =   1995
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Close"
      Height          =   375
      Left            =   4860
      TabIndex        =   3
      Top             =   960
      Width           =   1455
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "Find Next"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   375
      Left            =   4860
      TabIndex        =   2
      Top             =   120
      Width           =   1455
   End
   Begin VB.ComboBox cboText 
      Height          =   315
      Left            =   1140
      TabIndex        =   1
      Top             =   120
      Width           =   3555
   End
   Begin VB.Label Label1 
      Caption         =   "Find what:"
      Height          =   195
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   915
   End
End
Attribute VB_Name = "frmFind"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'           Copyright Infomation
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

Private m_TextEditor As cTextEditor

Public Function SetTextEditor(ByRef TextEditor As cTextEditor)
  Set m_TextEditor = TextEditor
End Function

Private Sub cboText_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
        Me.Hide
        m_TextEditor.Editawy.SetFocus
    End If
End Sub

Private Sub cmdMarkAll_Click()

    Dim Marked As Long
    
    If cboText.Text = "" Then Exit Sub
    
'Txttofind
'FindReverse
'findinrng
'WrapDocument
'CaseSensative
'WordStart
'WholeWord
'RegExp
    Marked = m_TextEditor.Editawy.MarkAll( _
                        cboText.Text, _
                        optUp.Value, _
                        False, _
                        chkWrap.Value, _
                        chkCase.Value, _
                        False, _
                        chkWhole.Value, _
                        chkRegExp.Value, _
                        2)
    If Marked = -1 Then
        MsgBox "Cannot find string """ & cboText.Text & """", vbOKOnly Or vbInformation, "Replace"
    Else
        
        MsgBox "The specified region has been searched. " & CStr(Marked) & " markers were made.", vbOKOnly Or vbInformation, "Replace"
    End If
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
        Unload Me
    End If
End Sub

'====================================================================
'====================================================================
Private Sub Form_Load()
    
    Me.Left = GetSetting(App.Title, "Settings", "FindLeft", (Screen.Width - Me.Width) \ 2)
    Me.Top = GetSetting(App.Title, "Settings", "FindTop", (Screen.Height - Me.Height) \ 2)
    chkCase.Value = GetSetting(App.Title, "Settings", "FindCase", 0)
    chkRegExp.Value = GetSetting(App.Title, "Settings", "FindRegExp", 0)
    chkWhole.Value = GetSetting(App.Title, "Settings", "FindWhole", 0)
    chkWrap.Value = GetSetting(App.Title, "Settings", "FindWrap", 1)
    optUp.Value = GetSetting(App.Title, "Settings", "FindUp", 0)
    
    cboText.SelStart = 0
    cboText.SelLength = Len(cboText.Text)
    'OnTop Me
    
End Sub

Private Sub cboText_Change()
    If cboText.Text = "" Then
        cmdFind.Enabled = False
    Else
        cmdFind.Enabled = True
    End If
End Sub

Private Sub cmdCancel_Click()
    Me.Hide
End Sub

Private Sub Form_Activate()
    cboText.SetFocus
End Sub

Private Sub cmdFind_Click()
    
    Dim Pos As Long
    
    If cboText.Text = "" Then Exit Sub
    
'Txttofind
'FindReverse
'findinrng
'WrapDocument
'CaseSensative
'WordStart
'WholeWord
'RegExp
    Pos = m_TextEditor.Editawy.Find( _
                        cboText.Text, _
                        optUp.Value, _
                        False, _
                        chkWrap.Value, _
                        chkCase.Value, _
                        False, _
                        chkWhole.Value, _
                        chkRegExp.Value)
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    SaveSetting App.Title, "Settings", "FindLeft", Me.Left
    SaveSetting App.Title, "Settings", "FindTop", Me.Top
    SaveSetting App.Title, "Settings", "FindCase", chkCase.Value
    SaveSetting App.Title, "Settings", "FindRegExp", chkRegExp.Value
    SaveSetting App.Title, "Settings", "FindWhole", chkWhole.Value
    SaveSetting App.Title, "Settings", "FindWrap", chkWrap.Value
    SaveSetting App.Title, "Settings", "FindUp", optUp.Value

End Sub
