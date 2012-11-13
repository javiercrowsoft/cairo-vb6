VERSION 5.00
Begin VB.Form frmReplace 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Replace"
   ClientHeight    =   2520
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7470
   Icon            =   "frmReplace.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2520
   ScaleWidth      =   7470
   ShowInTaskbar   =   0   'False
   Begin VB.ComboBox cboReplace 
      Height          =   315
      Left            =   1440
      TabIndex        =   1
      Top             =   780
      Width           =   4095
   End
   Begin VB.CommandButton cmdReplaceAll 
      Caption         =   "Replace &All"
      Height          =   375
      Left            =   5760
      TabIndex        =   4
      Top             =   1200
      Width           =   1455
   End
   Begin VB.CommandButton cmdReplace 
      Caption         =   "&Replace"
      Height          =   375
      Left            =   5760
      TabIndex        =   3
      Top             =   720
      Width           =   1455
   End
   Begin VB.ComboBox cboText 
      Height          =   315
      Left            =   1440
      TabIndex        =   0
      Top             =   240
      Width           =   4095
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "&Find"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   375
      Left            =   5760
      TabIndex        =   2
      Top             =   240
      Width           =   1455
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Close"
      Height          =   375
      Left            =   5760
      TabIndex        =   5
      Top             =   1680
      Width           =   1455
   End
   Begin VB.CheckBox chkCase 
      Caption         =   "&Case sensitive"
      Height          =   255
      Left            =   300
      TabIndex        =   6
      Top             =   1380
      Width           =   1995
   End
   Begin VB.CheckBox chkWhole 
      Caption         =   "&Whole word only"
      Height          =   195
      Left            =   300
      TabIndex        =   7
      Top             =   1740
      Width           =   2055
   End
   Begin VB.CheckBox chkRegExp 
      Caption         =   "Regular e&xpression"
      Height          =   255
      Left            =   300
      TabIndex        =   8
      Top             =   2100
      Width           =   2055
   End
   Begin VB.CheckBox chkWrap 
      Caption         =   "Wra&p at the end of the document"
      Height          =   315
      Left            =   2400
      TabIndex        =   11
      Top             =   2100
      Width           =   2835
   End
   Begin VB.Frame Frame1 
      Caption         =   "Direction"
      Height          =   615
      Left            =   2400
      TabIndex        =   12
      Top             =   1380
      Width           =   2355
      Begin VB.OptionButton optUp 
         Caption         =   "&Up"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   240
         Width           =   975
      End
      Begin VB.OptionButton optDown 
         Caption         =   "&Down"
         Height          =   255
         Left            =   1260
         TabIndex        =   10
         Top             =   240
         Value           =   -1  'True
         Width           =   1035
      End
   End
   Begin VB.Label Label2 
      Caption         =   "Replace with:"
      Height          =   255
      Left            =   300
      TabIndex        =   14
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Find what:"
      Height          =   195
      Left            =   300
      TabIndex        =   13
      Top             =   300
      Width           =   915
   End
End
Attribute VB_Name = "frmReplace"
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

'====================================================================
Private Sub cboReplace_KeyPress(KeyAscii As Integer)

    If KeyAscii = 27 Then 'vbKeyEscape
        Me.Hide
        fMainForm.ActiveForm.Editawy1.SetFocus
    End If
End Sub

Private Sub cboText_Change()
    If cboText.Text = "" Then
        cmdFind.Enabled = False
    Else
        cmdFind.Enabled = True
    End If
End Sub

Private Sub cboText_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
        Me.Hide
        fMainForm.ActiveForm.Editawy1.SetFocus
    End If
End Sub

Private Sub cmdCancel_Click()
    Me.Hide
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
    Pos = fMainForm.ActiveForm.Editawy1.Find( _
                        cboText.Text, _
                        optUp.Value, _
                        False, _
                        chkWrap.Value, _
                        chkCase.Value, _
                        False, _
                        chkWhole.Value, _
                        chkRegExp.Value)
    If Pos = -1 Then
        MsgBox "Cannot find string """ & cboText.Text & """", vbOKOnly Or vbInformation, "Replace"
    End If

End Sub

Private Sub cmdReplace_Click()
    If cboText.Text = "" Then Exit Sub
    
    If fMainForm.ActiveForm.Editawy1.GetSelectionLength <= 0 Then
        Dim Pos As Long
        'Txttofind
        'FindReverse
        'findinrng
        'WrapDocument
        'CaseSensative
        'WordStart
        'WholeWord
        'RegExp
        Pos = fMainForm.ActiveForm.Editawy1.Find( _
                            cboText.Text, _
                            optUp.Value, _
                            False, _
                            chkWrap.Value, _
                            chkCase.Value, _
                            False, _
                            chkWhole.Value, _
                            chkRegExp.Value)
        If Pos = -1 Then
            MsgBox "Cannot find string """ & cboText.Text & """", vbOKOnly Or vbInformation, "Replace"
        End If
        Exit Sub
    End If
        
    fMainForm.ActiveForm.Editawy1.ReplaceSel cboReplace.Text
    
    Pos = fMainForm.ActiveForm.Editawy1.Find( _
                        cboText.Text, _
                        optUp.Value, _
                        False, _
                        chkWrap.Value, _
                        chkCase.Value, _
                        False, _
                        chkWhole.Value, _
                        chkRegExp.Value)
    If Pos = -1 Then
        MsgBox "Cannot find string """ & cboText.Text & """", vbOKOnly Or vbInformation, "Replace"
    End If
End Sub

Private Sub cmdReplaceAll_Click()

    Dim Replaced As Long
    
    If cboText.Text = "" Then Exit Sub
    
'strSearchFor
'strReplaceWith
'ReplaceAll

'FindReverse
'findinrng
'WrapDocument
'CaseSensative
'WordStart
'WholeWord
'RegExp

    Replaced = fMainForm.ActiveForm.Editawy1.ReplaceText( _
                        cboText.Text, _
                        cboReplace.Text, _
                        True, _
                        optUp.Value, _
                        False, _
                        chkWrap.Value, _
                        chkCase.Value, _
                        False, _
                        chkWhole.Value, _
                        chkRegExp.Value)
    
    MsgBox "Replaced " & CStr(Replaced), vbOKOnly, "Replace"

End Sub

Private Sub Form_Activate()
    cboText.SetFocus
End Sub

Private Sub Form_Load()
    
    Me.left = GetSetting(App.Title, "Settings", "ReplaceLeft", (Screen.width - Me.width) \ 2)
    Me.top = GetSetting(App.Title, "Settings", "ReplaceTop", (Screen.height - Me.height) \ 2)
    chkCase.Value = GetSetting(App.Title, "Settings", "ReplaceCase", 0)
    chkRegExp.Value = GetSetting(App.Title, "Settings", "ReplaceRegExp", 0)
    chkWhole.Value = GetSetting(App.Title, "Settings", "ReplaceWhole", 0)
    chkWrap.Value = GetSetting(App.Title, "Settings", "ReplaceWrap", 1)
    optUp.Value = GetSetting(App.Title, "Settings", "ReplaceUp", 0)
    
    cboText.SelStart = 0
    cboText.SelLength = Len(cboText.Text)
    'OnTop Me
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
        Unload Me
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SaveSetting App.Title, "Settings", "ReplaceLeft", Me.left
    SaveSetting App.Title, "Settings", "ReplaceTop", Me.top
    SaveSetting App.Title, "Settings", "ReplaceCase", chkCase.Value
    SaveSetting App.Title, "Settings", "ReplaceRegExp", chkRegExp.Value
    SaveSetting App.Title, "Settings", "ReplaceWhole", chkWhole.Value
    SaveSetting App.Title, "Settings", "ReplaceWrap", chkWrap.Value
    SaveSetting App.Title, "Settings", "ReplaceUp", optUp.Value
End Sub

