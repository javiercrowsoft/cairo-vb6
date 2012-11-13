VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmOptions 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Syntax Options"
   ClientHeight    =   5850
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6315
   Icon            =   "frmOptions.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5850
   ScaleWidth      =   6315
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picKeywords 
      Height          =   4185
      Left            =   2400
      ScaleHeight     =   4125
      ScaleWidth      =   3555
      TabIndex        =   32
      TabStop         =   0   'False
      Top             =   600
      Visible         =   0   'False
      Width           =   3615
      Begin VB.TextBox txtKeyword 
         Height          =   2895
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   16
         Top             =   1080
         Width           =   3255
      End
      Begin VB.ComboBox cmbKeyword 
         Height          =   315
         ItemData        =   "frmOptions.frx":000C
         Left            =   120
         List            =   "frmOptions.frx":0028
         Style           =   2  'Dropdown List
         TabIndex        =   15
         Top             =   360
         Width           =   3255
      End
      Begin VB.Label Label8 
         Caption         =   "Keywords:"
         Height          =   255
         Left            =   120
         TabIndex        =   34
         Top             =   840
         Width           =   2415
      End
      Begin VB.Label Label7 
         Caption         =   "Keyword Sets:"
         Height          =   375
         Left            =   120
         TabIndex        =   33
         Top             =   120
         Width           =   2535
      End
   End
   Begin VB.PictureBox picStyles 
      Height          =   4185
      Left            =   2400
      ScaleHeight     =   4125
      ScaleWidth      =   3555
      TabIndex        =   22
      TabStop         =   0   'False
      Top             =   600
      Width           =   3615
      Begin VB.CheckBox chkVisible 
         Caption         =   "&Visible"
         Height          =   195
         Left            =   1440
         TabIndex        =   12
         Top             =   3840
         Width           =   1095
      End
      Begin VB.CheckBox chkUnderline 
         Caption         =   "&Underline"
         Height          =   195
         Left            =   120
         TabIndex        =   11
         Top             =   3840
         Width           =   1215
      End
      Begin VB.CheckBox chkEOL 
         Caption         =   "&EOL"
         Height          =   255
         Left            =   2640
         TabIndex        =   10
         Top             =   3480
         Width           =   735
      End
      Begin VB.CheckBox chkItalic 
         Caption         =   "&Italic"
         Height          =   255
         Left            =   1440
         TabIndex        =   9
         Top             =   3480
         Width           =   975
      End
      Begin VB.CheckBox chkBold 
         Caption         =   "&Bold"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   3480
         Width           =   1455
      End
      Begin VB.VScrollBar styleScroll 
         Height          =   255
         Left            =   1410
         Max             =   0
         Min             =   127
         TabIndex        =   25
         TabStop         =   0   'False
         Top             =   1110
         Width           =   255
      End
      Begin VB.PictureBox picBack 
         Height          =   375
         Left            =   3000
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   24
         TabStop         =   0   'False
         Top             =   3000
         Width           =   375
      End
      Begin VB.PictureBox picFore 
         Height          =   375
         Left            =   1200
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   23
         TabStop         =   0   'False
         Top             =   3000
         Width           =   375
      End
      Begin VB.CommandButton cmdBack 
         Caption         =   "&Backcolor"
         Height          =   375
         Left            =   1920
         TabIndex        =   7
         Top             =   3000
         Width           =   975
      End
      Begin VB.CommandButton cmdFore 
         Caption         =   "&Forecolor"
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   3000
         Width           =   975
      End
      Begin VB.TextBox txtStyleDesc 
         Height          =   315
         Left            =   120
         TabIndex        =   5
         Top             =   2520
         Width           =   3255
      End
      Begin VB.TextBox txtSize 
         Height          =   315
         Left            =   1800
         TabIndex        =   4
         Text            =   "0"
         Top             =   1800
         Width           =   1575
      End
      Begin VB.ComboBox cmbFont 
         Height          =   315
         ItemData        =   "frmOptions.frx":0044
         Left            =   120
         List            =   "frmOptions.frx":0046
         TabIndex        =   3
         Text            =   "cmbFont"
         Top             =   1800
         Width           =   1575
      End
      Begin VB.TextBox txtStyle 
         Height          =   315
         Left            =   120
         TabIndex        =   2
         Text            =   "0"
         Top             =   1080
         Width           =   1575
      End
      Begin VB.TextBox txtComment 
         Height          =   315
         Left            =   1800
         TabIndex        =   1
         Top             =   360
         Width           =   1575
      End
      Begin VB.TextBox txtFilter 
         Height          =   315
         Left            =   120
         TabIndex        =   0
         Top             =   360
         Width           =   1575
      End
      Begin VB.Label Label6 
         Caption         =   "Style Description:"
         Height          =   255
         Left            =   120
         TabIndex        =   31
         Top             =   2280
         Width           =   2535
      End
      Begin VB.Label Label5 
         Caption         =   "Size (0=Default):"
         Height          =   255
         Left            =   1800
         TabIndex        =   30
         Top             =   1560
         Width           =   1455
      End
      Begin VB.Label Label4 
         Caption         =   "Font:"
         Height          =   255
         Left            =   120
         TabIndex        =   29
         Top             =   1560
         Width           =   1575
      End
      Begin VB.Label Label3 
         Caption         =   "Style Num:"
         Height          =   255
         Left            =   120
         TabIndex        =   28
         Top             =   840
         Width           =   1455
      End
      Begin VB.Label Label2 
         Caption         =   "Single Line Comment:"
         Height          =   255
         Left            =   1800
         TabIndex        =   27
         Top             =   120
         Width           =   1575
      End
      Begin VB.Label Label1 
         Caption         =   "Filter:"
         Height          =   255
         Left            =   120
         TabIndex        =   26
         Top             =   120
         Width           =   1095
      End
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add Language"
      Height          =   375
      Left            =   120
      TabIndex        =   17
      Top             =   4515
      Width           =   2055
   End
   Begin VB.ListBox lstLang 
      Appearance      =   0  'Flat
      ForeColor       =   &H00000000&
      Height          =   3930
      ItemData        =   "frmOptions.frx":0048
      Left            =   120
      List            =   "frmOptions.frx":004A
      TabIndex        =   18
      TabStop         =   0   'False
      Top             =   375
      Width           =   2055
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   1200
      Top             =   1200
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox picSplit 
      Height          =   60
      Left            =   120
      ScaleHeight     =   0
      ScaleWidth      =   5955
      TabIndex        =   20
      TabStop         =   0   'False
      Top             =   5040
      Width           =   6015
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3720
      TabIndex        =   13
      Top             =   5280
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   5040
      TabIndex        =   14
      Top             =   5280
      Width           =   1095
   End
   Begin MSComctlLib.TabStrip tbsOptions 
      Height          =   4695
      Left            =   2280
      TabIndex        =   21
      Top             =   195
      Width           =   3855
      _ExtentX        =   6800
      _ExtentY        =   8281
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   2
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Syntax Settings"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Keyword Settings"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin VB.Label lblLang 
      Caption         =   "Language:"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   120
      Width           =   1935
   End
End
Attribute VB_Name = "frmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Dim lSelLang As Long
Dim hLighter() As Highlighter
Dim lStyle As Long
Dim strHoldDir As String

Private Sub chkBold_Click()
  On Error Resume Next
  hLighter(lSelLang).StyleBold(lStyle) = chkBold.value
End Sub

Private Sub chkEOL_Click()
  On Error Resume Next
  hLighter(lSelLang).StyleEOLFilled(lStyle) = chkEOL.value
End Sub

Private Sub chkItalic_Click()
  On Error Resume Next
  hLighter(lSelLang).StyleItalic(lStyle) = chkItalic.value
End Sub

Private Sub chkUnderline_Click()
  On Error Resume Next
  hLighter(lSelLang).StyleUnderline(lStyle) = chkUnderline.value
End Sub

Private Sub chkVisible_Click()
  On Error Resume Next
  hLighter(lSelLang).StyleVisible(lStyle) = chkVisible.value
End Sub

Private Sub cmbFont_Change()
  On Error Resume Next
  hLighter(lSelLang).StyleFont(lStyle) = cmbFont.Text
End Sub

Private Sub cmbKeyword_Click()
  On Error Resume Next
  txtKeyword.Text = hLighter(lSelLang).Keywords(cmbKeyword.ListIndex)
End Sub

Private Sub cmdAdd_Click()
  Load frmNewLang
  frmNewLang.strDir = strHoldDir
  frmNewLang.Show vbModal, Me
End Sub

Private Sub cmdBack_Click()
  On Error GoTo errhandler
  With cd
    .CancelError = True
    .ShowColor
    picBack.BackColor = cd.Color
    hLighter(lSelLang).StyleBack(lStyle) = .Color
  End With
  Exit Sub
errhandler:
  ' Cancel button was pressed.
  ' Just let it exit.

End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdFore_Click()
  On Error GoTo errhandler
  With cd
    .CancelError = True
    .ShowColor
    picFore.BackColor = cd.Color
    hLighter(lSelLang).StyleFore(lStyle) = .Color
  End With
  Exit Sub
errhandler:
  ' Cancel button was pressed.
  ' Just let it exit.
End Sub

Private Sub cmdOK_Click()
  Dim i As Long
  WriteSettings
  'Set the editor highlighters to the modified highlighters
  For i = 0 To UBound(Highlighters) - 1
    Highlighters(i) = hLighter(i)
  Next i
  'LoadDirectory strHoldDir
  Unload Me
End Sub

Private Sub Form_Load()
  Flatten Me
  LoadFonts
  Me.Left = GetSetting("ScintillaClass", "Settings", "OptLeft", (Screen.Width - Me.Width) \ 2)
  Me.Top = GetSetting("ScintillaClass", "Settings", "OptTop", (Screen.Height - Me.Height) \ 2)
  
End Sub

Private Sub TabStrip1_Click()

End Sub


Public Sub ListLangs(strDir As String)
  On Error Resume Next
  Dim strFile As String, i As Long, strName As String
  lstLang.Clear
  strHoldDir = strDir
  strFile = Dir(strDir & "\*.CHL", vbNormal)
  ReDim hLighter(0 To UBound(Highlighters))
  i = 0
  Do Until strFile = ""
    strName = ReadINI("data", "LangName", strDir & "\" & strFile)
    lstLang.AddItem strName
    hLighter(i) = FindHighlighter(strName)
    hLighter(i).strFile = strDir & "\" & strFile
    strFile = Dir
    i = i + 1
  Loop
  lstLang.ListIndex = 0
End Sub

Private Sub Form_Unload(Cancel As Integer)
  ' save location
  SaveSetting "ScintillaClass", "Settings", "OptLeft", Me.Left
  SaveSetting "ScintillaClass", "Settings", "OptTop", Me.Top
  ' Clean up memory
  Erase hLighter
End Sub

Private Sub lstLang_Click()
  'hLighter(lstLang.ListIndex) = FindHighlighter(lstLang.Text)
  lSelLang = lstLang.ListIndex
  txtStyle.Text = 0
  cmbKeyword.ListIndex = 0
  DispOpt
End Sub

Private Sub DispOpt()
  On Error Resume Next
  lStyle = txtStyle.Text
  cmbFont.Text = hLighter(lSelLang).StyleFont(lStyle)
  picBack.BackColor = hLighter(lSelLang).StyleBack(lStyle)
  picFore.BackColor = hLighter(lSelLang).StyleFore(lStyle)
  txtStyleDesc.Text = hLighter(lSelLang).StyleName(lStyle)
  txtComment.Text = hLighter(lSelLang).strComment
  txtFilter.Text = hLighter(lSelLang).strFilter
  txtSize.Text = hLighter(lSelLang).StyleSize(lStyle)
  chkBold.value = hLighter(lSelLang).StyleBold(lStyle)
  chkEOL.value = hLighter(lSelLang).StyleEOLFilled(lStyle)
  chkItalic.value = hLighter(lSelLang).StyleItalic(lStyle)
  chkUnderline.value = hLighter(lSelLang).StyleUnderline(lStyle)
  chkVisible.value = hLighter(lSelLang).StyleVisible(lStyle)
  cmbKeyword.ListIndex = 0
  txtKeyword.Text = hLighter(lSelLang).Keywords(0)
  
End Sub

Private Sub styleScroll_Change()
  txtStyle.Text = styleScroll.value
  DispOpt
End Sub

Private Sub tbsOptions_Click()
  picStyles.Visible = False
  picKeywords.Visible = False
  Select Case tbsOptions.SelectedItem.index
    Case 1
      picStyles.Visible = True
    Case 2
      picKeywords.Visible = True
  End Select
End Sub

Private Sub txtComment_Change()
  On Error Resume Next
  hLighter(lSelLang).strComment = txtComment.Text
End Sub

Private Sub txtFilter_Change()
  On Error Resume Next
  hLighter(lSelLang).strFilter = txtFilter.Text
End Sub

Private Sub txtKeyword_Change()
  On Error Resume Next
  hLighter(lSelLang).Keywords(cmbKeyword.ListIndex) = txtKeyword.Text
End Sub

Private Sub txtSize_Change()
  On Error Resume Next
  hLighter(lSelLang).StyleSize(lStyle) = txtSize.Text
End Sub

Private Sub txtSize_KeyPress(KeyAscii As Integer)
  If Not IsNumeric(Chr(KeyAscii)) And (KeyAscii <> 8) Then KeyAscii = 0
End Sub

Private Sub txtStyle_Change()
  On Error Resume Next
  If txtStyle.Text > 127 Then txtStyle.Text = 127
  If txtStyle.Text = "" Then
    styleScroll.value = 0
    txtStyle.Text = 0
  End If
  styleScroll.value = txtStyle.Text
End Sub

Private Sub txtStyle_KeyPress(KeyAscii As Integer)
  If Not IsNumeric(Chr(KeyAscii)) And (KeyAscii <> 8) Then KeyAscii = 0
End Sub

Private Sub LoadFonts()
  Dim i As Long
  For i = 0 To Screen.FontCount - 1
    cmbFont.AddItem Screen.Fonts(i)
  Next i
End Sub

Private Function FindHighlighter(strLangName As String) As Highlighter
  Dim i As Integer
   For i = 0 To UBound(Highlighters) - 1
    If UCase(Highlighters(i).strName) = UCase(strLangName) Then
      FindHighlighter = Highlighters(i)
      
      Exit Function
    End If
  Next i
End Function

Private Sub txtStyleDesc_Change()
  On Error Resume Next
  hLighter(lSelLang).StyleName(lStyle) = txtStyleDesc.Text
End Sub

Private Function StyleSet(lHigh As Long, lStyle As Long) As Boolean
  StyleSet = False
  If lStyle = 32 Then StyleSet = True
  If hLighter(lHigh).StyleBack(lStyle) <> hLighter(lHigh).StyleBack(32) Then StyleSet = True
  If hLighter(lHigh).StyleFore(lStyle) <> hLighter(lHigh).StyleFore(32) Then StyleSet = True
  If hLighter(lHigh).StyleEOLFilled(lStyle) <> hLighter(lHigh).StyleEOLFilled(32) Then StyleSet = True
  If hLighter(lHigh).StyleBold(lStyle) <> hLighter(lHigh).StyleBold(32) Then StyleSet = True
  If hLighter(lHigh).StyleItalic(lStyle) <> hLighter(lHigh).StyleItalic(32) Then StyleSet = True
  If hLighter(lHigh).StyleUnderline(lStyle) <> hLighter(lHigh).StyleUnderline(32) Then StyleSet = True
  If hLighter(lHigh).StyleVisible(lStyle) <> hLighter(lHigh).StyleVisible(32) Then StyleSet = True
  If hLighter(lHigh).StyleFont(lStyle) <> hLighter(lHigh).StyleFont(32) Then StyleSet = True
  If hLighter(lHigh).StyleSize(lStyle) <> hLighter(lHigh).StyleSize(32) Then StyleSet = True
End Function

Private Sub WriteSettings()
  Dim i As Long, x As Long
  Dim strFile As String
  Dim strOutput As String
  For i = 0 To UBound(hLighter) - 1
    strFile = hLighter(i).strFile
    writeini "data", "filter", hLighter(i).strFilter, strFile
    writeini "data", "LangName", hLighter(i).strName, strFile
    For x = 0 To 127
      strOutput = ""
      If StyleSet(i, x) Then
        If hLighter(i).StyleBold(x) = 1 Then
          strOutput = "B"
        End If
        strOutput = strOutput & ":"
        If hLighter(i).StyleItalic(x) = 1 Then
          strOutput = strOutput & "I"
        End If
        strOutput = strOutput & ":"
        If hLighter(i).StyleUnderline(x) = 1 Then
          strOutput = strOutput & "U"
        End If
        strOutput = strOutput & ":"
        If hLighter(i).StyleVisible(x) = 1 Then
          strOutput = strOutput & "V"
        End If
        strOutput = strOutput & ":C:"
        If hLighter(i).StyleEOLFilled(x) = 1 Then
          strOutput = strOutput & "E"
        End If
        strOutput = strOutput & "::"
        If hLighter(i).StyleFont(x) <> "" Then
          strOutput = strOutput & hLighter(i).StyleFont(x)
        End If
        strOutput = strOutput & ":"
        strOutput = strOutput & hLighter(i).StyleSize(x)
        strOutput = strOutput & ":"
        If hLighter(i).StyleFore(x) <> 0 Then
          strOutput = strOutput & hLighter(i).StyleFore(x)
        End If
        strOutput = strOutput & ":"
        If hLighter(i).StyleBack(x) <> 0 Then
          strOutput = strOutput & hLighter(i).StyleBack(x)
        End If
        strOutput = strOutput & ":"
        If hLighter(i).StyleName(x) <> "" Then
          strOutput = strOutput & hLighter(i).StyleName(x)
        End If
        strOutput = strOutput & ":"
        Call writeini("data", "Style[" & x & "]", strOutput, strFile)
      End If
    Next x
    For x = 0 To 7
      If hLighter(x).Keywords(x) <> "" Then
        Call writeini("data", "Keywords[" & x & "]", hLighter(x).Keywords(x), strFile)
      End If
    Next x
  Next i
End Sub
