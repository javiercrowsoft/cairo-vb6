VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "*\ACSTextBox.vbp"
Begin VB.Form frmMain 
   Caption         =   "Code Highlight Test"
   ClientHeight    =   5460
   ClientLeft      =   1575
   ClientTop       =   1875
   ClientWidth     =   10215
   Icon            =   "codeHighlightTest.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5460
   ScaleWidth      =   10215
   Begin CSTextBox.cTextBox CodeHighlight1 
      Height          =   2895
      Left            =   0
      TabIndex        =   5
      Top             =   720
      Width           =   3975
      _extentx        =   7011
      _extenty        =   5106
      language        =   1
      operatorcolor   =   33023
      delimitercolor  =   49152
      forecolor       =   0
      highlightcode   =   0
      font            =   "codeHighlightTest.frx":000C
   End
   Begin MSComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   2
      Top             =   5205
      Width           =   10215
      _ExtentX        =   18018
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   7056
            MinWidth        =   7056
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog CD1 
      Left            =   6600
      Top             =   960
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   5520
      Top             =   720
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   20
      ImageHeight     =   20
      MaskColor       =   16776960
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   7
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":0030
            Key             =   "copy"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":0532
            Key             =   "cut"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":0A34
            Key             =   "paste"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":0F36
            Key             =   "find"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":1438
            Key             =   "open"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":193A
            Key             =   "save"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "codeHighlightTest.frx":1E3C
            Key             =   "new"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbMain 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   10215
      _ExtentX        =   18018
      _ExtentY        =   1111
      ButtonWidth     =   1455
      ButtonHeight    =   1058
      Appearance      =   1
      Style           =   1
      ImageList       =   "ImageList1"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   10
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "new"
            Object.ToolTipText     =   "New"
            ImageKey        =   "new"
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "open"
            Object.ToolTipText     =   "Open"
            ImageKey        =   "open"
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "save"
            Object.ToolTipText     =   "Save"
            ImageKey        =   "save"
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "cut"
            Object.ToolTipText     =   "Cut"
            ImageKey        =   "cut"
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "copy"
            Object.ToolTipText     =   "Copy"
            ImageKey        =   "copy"
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "paste"
            Object.ToolTipText     =   "Paste"
            ImageKey        =   "paste"
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Goto Line"
            Key             =   "goto"
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Language"
            Style           =   4
         EndProperty
      EndProperty
      Begin VB.ComboBox cboHighlightOn 
         Height          =   315
         ItemData        =   "codeHighlightTest.frx":233E
         Left            =   7680
         List            =   "codeHighlightTest.frx":2348
         Style           =   2  'Dropdown List
         TabIndex        =   4
         TabStop         =   0   'False
         Top             =   240
         Width           =   2415
      End
      Begin VB.ComboBox cboLanguage 
         Height          =   315
         Left            =   6120
         Style           =   2  'Dropdown List
         TabIndex        =   1
         TabStop         =   0   'False
         Top             =   240
         Width           =   1455
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "&Language"
         Height          =   195
         Left            =   8760
         TabIndex        =   3
         Top             =   240
         Width           =   480
      End
   End
   Begin VB.Menu menuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFile 
         Caption         =   "&New"
         Index           =   0
      End
      Begin VB.Menu mnuFile 
         Caption         =   "&Open"
         Index           =   1
      End
      Begin VB.Menu mnuFile 
         Caption         =   "&Save"
         Index           =   2
      End
      Begin VB.Menu mnuSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu menuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuEdit 
         Caption         =   "Cut"
         Index           =   0
      End
      Begin VB.Menu mnuEdit 
         Caption         =   "Copy"
         Index           =   1
      End
      Begin VB.Menu mnuEdit 
         Caption         =   "&Paste"
         Index           =   2
      End
      Begin VB.Menu mnuEdit 
         Caption         =   "-"
         Index           =   3
      End
      Begin VB.Menu mnuEdit 
         Caption         =   "Select All"
         Index           =   4
      End
   End
   Begin VB.Menu menuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About Developer's Domain Code Highlight Control Test"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim FileName As String




Private Sub cboHighlightOn_Click()
    If cboHighlightOn.ListIndex = 0 Then
        CodeHighlight1.HighlightCode = hlAsType
    Else
       CodeHighlight1.HighlightCode = hlOnNewLine
    End If
End Sub


Private Sub cboLanguage_Click()
    Select Case cboLanguage.ListIndex
        Case 0
            CodeHighlight1.Language = hlNOHighLight
        Case 1
            CodeHighlight1.Language = hlVisualBasic
        Case 2
            CodeHighlight1.Language = hlJava
        Case 3
            CodeHighlight1.Language = hlhtml
        Case 4
            CodeHighlight1.Language = hlSql
    End Select
End Sub

Private Sub CodeHighlight1_SelChange()
     StatusBar1.Panels(1).Text = CodeHighlight1.Line(CodeHighlight1.LineIndex)
End Sub


Private Sub Form_Load()
    With cboLanguage
        .AddItem "No Highlighting"
        .AddItem "Visual Basic"
        .AddItem "Java"
        .AddItem "HTML"
        .AddItem "SQL"
    End With
    cboLanguage.ListIndex = CodeHighlight1.Language
    cboHighlightOn.ListIndex = 0
End Sub

Private Sub Form_Resize()
    CodeHighlight1.Move 0, tbMain.Height, ScaleWidth, ScaleHeight - (tbMain.Height + StatusBar1.Height)
End Sub


Private Sub mnuAbout_Click()
    MsgBox "Get more code at http://www.developersdomain.com", , "About"
End Sub

Private Sub mnuEdit_Click(Index As Integer)
    Select Case Index
        Case 0 ' Cut
            Clipboard.SetText CodeHighlight1.SelText
            CodeHighlight1.SelText = ""
        Case 1 'Copy
            Clipboard.SetText CodeHighlight1.SelText
        Case 2 'Paste
            CodeHighlight1.SelText = Clipboard.GetText
        Case 4 'Select All
            CodeHighlight1.SelStart = 0
            CodeHighlight1.SelLength = Len(CodeHighlight1.Text)
    End Select
End Sub

Private Sub mnuExit_Click()
    Unload Me
End Sub

Private Sub mnuFile_Click(Index As Integer)
    Select Case Index
        Case 0 'New
            CodeHighlight1.Text = ""
        Case 1 ' Open
            CD1.ShowOpen
            If Len(CD1.FileName) > 0 Then
                CodeHighlight1.LoadFile CD1.FileName
            End If
        Case 2 'Save
            CD1.ShowSave
            If Len(CD1.FileName) > 0 Then
                CodeHighlight1.SaveFile CD1.FileName
            End If
    End Select
    CD1.FileName = ""
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
    Select Case Button.Key
        Case "new"
            CodeHighlight1.Text = ""
        Case "open"
            mnuFile_Click 1
        Case "save"
            mnuFile_Click 2
        Case "cut"
            mnuEdit_Click 0
        Case "copy"
            mnuEdit_Click 1
        Case "paste"
            mnuEdit_Click 2
        Case "goto"
            Dim lineNumber As Long
            lineNumber = InputBox("Which Line", "Goto Line", 1)
            CodeHighlight1.LineIndex = lineNumber - 1
            CodeHighlight1.SetFocus
    End Select
End Sub


