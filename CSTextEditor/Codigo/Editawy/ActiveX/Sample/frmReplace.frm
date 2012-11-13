VERSION 5.00
Begin VB.Form frmReplace 
   Caption         =   "replace"
   ClientHeight    =   2520
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7470
   Icon            =   "frmReplace.frx":0000
   LinkTopic       =   "Form2"
   ScaleHeight     =   2520
   ScaleWidth      =   7470
   StartUpPosition =   1  'CenterOwner
   Begin VB.ComboBox cboReplace 
      Height          =   315
      Left            =   1440
      TabIndex        =   14
      Top             =   780
      Width           =   4095
   End
   Begin VB.CommandButton cmdReplaceAll 
      Caption         =   "Replace &All"
      Height          =   375
      Left            =   5760
      TabIndex        =   12
      Top             =   1200
      Width           =   1455
   End
   Begin VB.CommandButton cmdReplace 
      Caption         =   "&Replace"
      Height          =   375
      Left            =   5760
      TabIndex        =   11
      Top             =   720
      Width           =   1455
   End
   Begin VB.ComboBox cboText 
      Height          =   315
      Left            =   1440
      TabIndex        =   9
      Top             =   240
      Width           =   4095
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "&Find"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   375
      Left            =   5760
      TabIndex        =   8
      Top             =   240
      Width           =   1455
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Close"
      Height          =   375
      Left            =   5760
      TabIndex        =   7
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
   Begin VB.CheckBox chkWord 
      Caption         =   "&Whole word only"
      Height          =   195
      Left            =   300
      TabIndex        =   5
      Top             =   1740
      Width           =   2055
   End
   Begin VB.CheckBox chkRegEx 
      Caption         =   "Regular e&xpression"
      Height          =   255
      Left            =   300
      TabIndex        =   4
      Top             =   2100
      Width           =   2055
   End
   Begin VB.CheckBox chkWrap 
      Caption         =   "Wra&p at the end of the document"
      Height          =   315
      Left            =   2400
      TabIndex        =   3
      Top             =   2100
      Width           =   2835
   End
   Begin VB.Frame Frame1 
      Caption         =   "Direction"
      Height          =   615
      Left            =   2400
      TabIndex        =   0
      Top             =   1380
      Width           =   2355
      Begin VB.OptionButton OptionUp 
         Caption         =   "&Up"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   975
      End
      Begin VB.OptionButton OptionDown 
         Caption         =   "&Down"
         Height          =   255
         Left            =   1260
         TabIndex        =   1
         Top             =   240
         Value           =   -1  'True
         Width           =   1035
      End
   End
   Begin VB.Label Label2 
      Caption         =   "Replace with:"
      Height          =   255
      Left            =   300
      TabIndex        =   13
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Find what:"
      Height          =   195
      Left            =   300
      TabIndex        =   10
      Top             =   300
      Width           =   915
   End
End
Attribute VB_Name = "frmReplace"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private targetStart As Long
Private targetEnd As Long
Private LastSearchTerm As String
Private FirstSearch As Boolean
Private LastSearchPos As Long
Private LastSearchEndPos As Long
Private LastCaretPos As Long

'====================================================================
'====================================================================
Private Sub cboReplace_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
        Me.Hide
        fMainForm.ActiveForm.SourceEditor1.SetFocus
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
        fMainForm.ActiveForm.SourceEditor1.SetFocus
    End If
End Sub

Private Sub cmdCancel_Click()
    Me.Hide
End Sub

Private Sub cmdReplace_Click()
    fMainForm.ActiveForm.SourceEditor1.ReplaceSel cboReplace.Text
End Sub

Private Sub cmdReplaceAll_Click()
    
    Dim lReplaced As Long
    
    lReplaced = 0
    Do
        cmdFind_Click
        If LastSearchPos <> -1 Then
            lReplaced = lReplaced + 1
            fMainForm.ActiveForm.SourceEditor1.ReplaceSel cboReplace.Text
        End If
    Loop While LastSearchPos <> -1
    
    MsgBox "Replaced " & CStr(lReplaced), vbOKOnly, "Replace"
    
End Sub

Private Sub Form_Activate()
    cboText.SetFocus
    'FirstSearch = True
    'cboText.SetFocus
End Sub

Private Sub Form_Load()
    
    LastSearchTerm = ""
    FirstSearch = True
    
    OnTop Me
    
End Sub

Private Sub cmdFind_Click()
    
    Dim endPos As Long
    Dim SearchTerm As String
    Dim Pos As Long
    Dim Backward As Boolean
    Dim Flags As Long
    
    SearchTerm = cboText.Text
    If SearchTerm = "" Then Exit Sub
    
    If OptionDown.Value = True Then Backward = False Else Backward = True
    '----------------------------------------------------------------
    If FirstSearch = True Then
        targetStart = fMainForm.ActiveForm.SourceEditor1.GetCurrentPos
    Else
        If Backward = True Then
            targetStart = LastSearchPos
        Else
            targetStart = LastSearchEndPos
        End If
    End If
    '----------------------------------------------------------------
    If OptionDown.Value = True Then Backward = False Else Backward = True
    
    If Backward = True Then
        targetEnd = 0
    Else
        targetEnd = fMainForm.ActiveForm.SourceEditor1.GetTextLength
    End If
        
    '----------------------------------------------------------------
    ' Set search flags
    Flags = 0
    
    ' A match only occurs with text that matches the case of the search string.
    If chkCase.Value = 1 Then Flags = Flags Or &H4
    
    'A match only occurs if the characters before and after are not word characters.
    If chkWord.Value = 1 Then Flags = Flags Or &H2
    
    'The search string should be interpreted as a regular expression.
    If chkRegEx.Value = 1 Then Flags = Flags Or &H200000
    
    'FindWholeWord = 2        'A match only occurs if the characters before and after are not word characters.
    'FindMatchCase = 4        ' A match only occurs with text that matches the case of the search string.
    'FindWordStart = &H100000 'A match only occurs if the character before is not a word character.
    'FindRegExp = &H200000    'The search string should be interpreted as a regular expression.
    'FindPosIX = &H400000     'Treat regular expression in a more POSIX compatible manner by interpreting bare ( and ) for tagged sections rather than \( and \).
    '----------------------------------------------------------------
    
    Pos = fMainForm.ActiveForm.SourceEditor1.FindText(Flags, targetStart, targetEnd, SearchTerm, endPos, Backward)
    
    If Pos = -1 And chkWrap.Value = 1 Then
        If Backward = True Then
            targetStart = fMainForm.ActiveForm.SourceEditor1.GetCurrentPos
            targetEnd = fMainForm.ActiveForm.SourceEditor1.GetTextLength
        Else
            targetStart = 0
            targetEnd = fMainForm.ActiveForm.SourceEditor1.GetCurrentPos
        End If
        Pos = fMainForm.ActiveForm.SourceEditor1.FindText(Flags, targetStart, targetEnd, SearchTerm, endPos, Backward)
    End If
    
    If Pos <> -1 Then
        LastSearchPos = Pos
        LastSearchEndPos = endPos
        FirstSearch = False
    Else
        LastSearchPos = -1
        LastSearchEndPos = -1
    End If
    
    LastCaretPos = fMainForm.ActiveForm.SourceEditor1.GetCurrentPos
    
    'Me.SetFocus
    FirstSearch = False
    'Debug.Print "Find Text: "; Pos
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = 27 Then
        Unload Me
    End If
End Sub

