VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{9AA2B010-29D7-4BAF-829F-4BF3233B3E66}#32.0#0"; "Editawy.ocx"
Begin VB.Form frmDocument 
   Caption         =   "frmDocument"
   ClientHeight    =   5580
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7935
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5580
   ScaleWidth      =   7935
   Begin VB.PictureBox Picture3 
      Height          =   2355
      Left            =   180
      ScaleHeight     =   2295
      ScaleWidth      =   4995
      TabIndex        =   2
      Top             =   2280
      Width           =   5055
   End
   Begin VB.PictureBox Picture2 
      Height          =   1935
      Left            =   120
      ScaleHeight     =   1875
      ScaleWidth      =   5055
      TabIndex        =   1
      Top             =   120
      Width           =   5115
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   1335
      Left            =   5640
      MousePointer    =   7  'Size N S
      ScaleHeight     =   1335
      ScaleWidth      =   2115
      TabIndex        =   0
      Top             =   3960
      Width           =   2115
      Begin EditawyX.Editawy Editawy2 
         Left            =   1080
         Top             =   360
         _ExtentX        =   847
         _ExtentY        =   847
         SymbolMargin    =   0   'False
         Folding         =   0   'False
         BeginProperty DefaultFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         CaretLineVisible=   0   'False
         TabWidth        =   0
         EdgeColumn      =   120
         EdgeColor       =   0
      End
      Begin EditawyX.Editawy Editawy1 
         Left            =   120
         Top             =   120
         _ExtentX        =   847
         _ExtentY        =   847
         SymbolMargin    =   0   'False
         Folding         =   0   'False
         BeginProperty DefaultFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         CaretLineVisible=   0   'False
         TabWidth        =   0
         EdgeColumn      =   120
         EdgeColor       =   0
      End
   End
   Begin MSComDlg.CommonDialog cd1 
      Left            =   6240
      Top             =   2580
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "frmDocument"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long
Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal _
hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As _
Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Private Const WM_SETREDRAW = &HB&
Private Const WM_SETFONT = &H30
Private Const WM_GETFONT = &H31
Private Const LB_GETITEMRECT = &H198
Private Const LB_ERR = (-1)
Private Const SWP_NOSIZE = &H1
Private Const SWP_NOMOVE = &H2
Private Const SWP_NOZORDER = &H4
Private Const SWP_NOREDRAW = &H8
Private Const SWP_NOACTIVATE = &H10
Private Const SWP_FRAMECHANGED = &H20
Private Const SWP_SHOWWINDOW = &H40
Private Const SWP_HIDEWINDOW = &H80
Private Const SWP_NOCOPYBITS = &H100
Private Const SWP_NOOWNERZORDER = &H200
Private Const SWP_DRAWFRAME = SWP_FRAMECHANGED
Private Const SWP_NOREPOSITION = SWP_NOOWNERZORDER
Private Const HWND_TOP = 0
Private Const HWND_BOTTOM = 1
Private Const HWND_TOPMOST = -1
Private Const HWND_NOTOPMOST = -2
Private Const SM_CXEDGE = 45
Private Const SM_CYEDGE = 46

Public strFilename As String

Private Const SPLITTER_HEIGHT = 40
' The percentage occupied by the first control.
Private Percentage As Single
' True when we are dragging the splitter.
Private Dragging As Boolean
Private LastPercentage As Single

Private Sub Form_Load()
  
    Dim iniFile As String
    Dim PerlStyler As Styler
    Dim pDoc As Long
    
    On Error GoTo Errs:
    
    'Dim frm As frmTest

    Set Editor1 = New frmEditor
    SetParent Editor1.hwnd, Picture2.hwnd
    Editor1.Show
    Editor1.Editawy1.Folding = True
    Editor1.Editawy1.LineNumbers = True
    Editor1.Editawy1.SymbolMargin = True
    Editor1.Editawy1.ReadOnly = False
    iniFile = "C:\VBmyProjects\Editawy\LexersConf.ini"
    'Editawy1.LanguageINI "Perl", iniFile
    
    Editor1.Editawy1.LoadFile App.Path & "\ForumLib.pm"
    Editor1.Editawy1.ShowCallTips = True
    Editor1.Editawy1.LoadCallTipFile "C:\VBmyProjects\Editawy\cpp.txt"
    Editor1.Editawy1.HScrollBar = True
    Editor1.Editawy1.CaretLineVisible = True
    Editor1.Editawy1.SerialNumber = "#a9l0oil%w93d2k08740_^&*hw$w)%fv@fg!h`ak-L=s*|s..)k\"
    
    'Dim Tips() As String
    'Editawy1.GetCallTips Tips()
    'Debug.Print Tips(134), LBound(Tips), UBound(Tips)
    
    PerlStyler = Editor1.Editawy1.ReadLanguageStyler("Perl", iniFile)
    Editor1.Editawy1.SetLanguageStyler PerlStyler
    
    'Set Editor1 = frm
    
    '============================================
    'Set frm = New frmTest
    Set Editor2 = New frmEditor
    SetParent Editor2.hwnd, Picture3.hwnd
    Editor2.Show
    Editor2.Editawy1.Folding = True
    Editor2.Editawy1.LineNumbers = True
    Editor2.Editawy1.SymbolMargin = True
    Editor2.Editawy1.ReadOnly = False
    iniFile = "C:\VBmyProjects\Editawy\LexersConf.ini"
    'Editawy1.LanguageINI "Perl", iniFile
    
    Editor2.Editawy1.LoadFile App.Path & "\ForumLib.pm"
    Editor2.Editawy1.ShowCallTips = True
    Editor2.Editawy1.LoadCallTipFile "C:\VBmyProjects\Editawy\cpp.txt"
    Editor2.Editawy1.HScrollBar = True
    Editor2.Editawy1.CaretLineVisible = True
    Editor2.Editawy1.SerialNumber = "#a9l0oil%w93d2k08740_^&*hw$w)%fv@fg!h`ak-L=s*|s..)k\"
    
    'Dim Tips() As String
    'Editawy1.GetCallTips Tips()
    'Debug.Print Tips(134), LBound(Tips), UBound(Tips)
    
    PerlStyler = Editor2.Editawy1.ReadLanguageStyler("Perl", iniFile)
    Editor2.Editawy1.SetLanguageStyler PerlStyler
    
    pDoc = Editor1.Editawy1.GetDocPointer
    Editor2.Editawy1.SetDocPointer pDoc
        
    Exit Sub
    
'    top = -200
'    Left = -200
'    width = 31000
'    height = 31000
    
    ' Start with the split in the middle.
    Percentage = 0.5
    LastPercentage = 0.5
    '----------------------------------------------------------------
    Editawy1.Initialize
    '----------------------------------------------------------------
    Editawy1.Folding = True
    Editawy1.LineNumbers = True
    Editawy1.SymbolMargin = True
    Editawy1.ReadOnly = False
    iniFile = "C:\VBmyProjects\Editawy\LexersConf.ini"
    'Editawy1.LanguageINI "Perl", iniFile
    
    Editawy1.LoadFile App.Path & "\ForumLib.pm"
    
    'Editawy1.SetBufferedDraw True
    'Editawy1.SetTwoPhaseDraw False
    'Editawy1.SetWrapVisualFlags 1
    'Editawy1.SetLayoutCache 0
    'Editawy1.EmptyUndoBuffer
    'Editawy1.CaretWidth = 1
    Editawy1.ShowCallTips = True
    Editawy1.LoadCallTipFile "C:\VBmyProjects\Editawy\cpp.txt"
    Editawy1.HScrollBar = True
    Editawy1.CaretLineVisible = True
    Editawy1.SerialNumber = "#a9l0oil%w93d2k08740_^&*hw$w)%fv@fg!h`ak-L=s*|s..)k\"
    
    'Dim Tips() As String
    'Editawy1.GetCallTips Tips()
    'Debug.Print Tips(134), LBound(Tips), UBound(Tips)
    
    PerlStyler = Editawy1.ReadLanguageStyler("Perl", iniFile)
    Editawy1.SetLanguageStyler PerlStyler
    
    With Editawy1
        '.EOLVisible =False
        '.MatchBraces
        '.WhiteSpaceVisible
        '.CaretLineVisible
        '.IndGuides
        '.AutoIndent
        '.Remove
        '.SelectAll
    End With
    'PerlStyler.File = iniFile
    'PerlStyler.Name = "PerlEx"
    'Editawy1.WriteLanguageStyler PerlStyler
    
    'Editawy1.SetMouseDwellTime 100
    '----------------------------------------------------------------
    Editawy2.Initialize
    
    Editawy2.Folding = True
    Editawy2.LineNumbers = True
    Editawy2.SymbolMargin = True
    Editawy2.ReadOnly = False
    Editawy2.CaretLineVisible = True
    Editawy2.SetLanguageStyler PerlStyler
'    iniFile = "C:\VBmyProjects\Editawy\LexersConf.ini"
'    Editawy2.LanguageINI "Perl", iniFile
'    Editawy2.LoadFile "c:\\apache\\cgi-bin\\auction\\Bidding.pm"
'    Editawy2.EmptyUndoBuffer
    Editawy2.CaretWidth = 1
'    Editawy2.ShowCallTips = True
'    Editawy2.LoadCallTipFile "C:\VBmyProjects\Editawy\cpp.txt"
    Editawy2.HScrollBar = True
    Editawy2.SerialNumber = "#a9l0oil%w93d2k08740_^&*hw$w)%fv@fg!h`ak-L=s*|s..)k\"
'
    '----------------------------------------------------------------
'    Dim pDoc As Long
'    pDoc = Editawy1.GetDocPointer
'    Editawy2.SetDocPointer pDoc
    '----------------------------------------------------------------
    Exit Sub
Errs:
    Debug.Print "Doc Form Error: "; Err.Description
End Sub

Private Sub Editawy1_KeyDown(ByVal KeyCode As Long, ByVal Shift As Long)
    'Debug.Print "KeyDown: "; KeyCode, Chr(KeyCode), Shift
End Sub

Private Sub Editawy1_KeyPress(ByVal KeyAscii As Long)
    'Debug.Print "KeyPress: "; KeyAscii, Chr(KeyAscii)
End Sub

Private Sub Editawy1_PagePreview(ByVal StartCharPos As Long, ByVal NextCharPos As Long, ByVal PageNum As Long, ByVal Measuring As Boolean, ByRef Cancel As Boolean)
    
    'Debug.Print "PagePreview: "; StartCharPos, NextCharPos, Count, Measuring
    'If Count = 3 Then Cancel = True
    If Measuring = True Then
    
    End If
    
End Sub

Private Sub Editawy1_PagePrint(ByVal StartCharPos As Long, ByVal NextCharPos As Long, ByVal PageNum As Long, Cancel As Boolean)
    'Debug.Print "PagePrint: "; StartCharPos, NextCharPos, PageNum, Cancel
End Sub

Private Sub Editawy2_EnterTheFocus()
    'Editawy1.SetFocusFlag False
    'Editawy2.SetFocusFlag True
    'Debug.Print "EnterTheFocus 2"
End Sub

Private Sub Editawy1_EnterTheFocus()
    'Editawy2.SetFocusFlag False
    'Editawy1.SetFocusFlag True
    'Debug.Print "EnterTheFocus 1"
End Sub

Private Sub Editawy1_GotTheFocus()
    'Debug.Print "Editawy1_GotTheFocus: "; ActiveSpliterEditor
End Sub

Private Sub Editawy2_GotTheFocus()
    'Debug.Print "Editawy2_GotTheFocus: "; ActiveSpliterEditor
End Sub

Private Sub Editawy2_LostTheFocus()
    'Debug.Print "Editawy2_LostTheFocus"
End Sub

Private Sub Editawy1_LostTheFocus()
    'Debug.Print "Editawy1_LostTheFocus"
End Sub

Private Sub Editawy2_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    'Editawy2.SetFocus
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
'
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
'
End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dragging = True
End Sub

Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Dragging Then
        Percentage = y / ScaleHeight
        If Percentage < 0 Then Percentage = 0
        If Percentage > 1 Then Percentage = 1
        If Percentage <> LastPercentage Then
            Form_Resize
        End If
        LastPercentage = Percentage
    End If
End Sub

Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Dragging = True Then
        Form_Resize
    End If
    Dragging = False
End Sub

Private Sub Form_Resize()
    
    ' Don't bother if we're iconized.
    If WindowState = vbMinimized Then Exit Sub
    Dim H As Long, W As Long
        
    H = Me.height
    W = Me.width
    
    'Picture1.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
    
    Picture2.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
    Picture3.Move 0, Me.ScaleTop + Me.ScaleHeight \ 2, Me.ScaleWidth, Me.ScaleHeight \ 2
    
    Picture2.Container.Editawy1.Resize 0, 0, Me.width \ Screen.TwipsPerPixelX, Me.ScaleHeight
    Picture3.Container.Editawy2.Resize 0, 0, Me.width \ Screen.TwipsPerPixelX, Me.ScaleHeight
     
    'Resize the windows
    SetWindowPos Editor1.hwnd, HWND_TOP, 0, 0, W \ Screen.TwipsPerPixelX - 15, H \ Screen.TwipsPerPixelY \ 2 - 20, 0
    SetWindowPos Editor2.hwnd, HWND_TOP, 0, 0, W \ Screen.TwipsPerPixelX - 15, H \ Screen.TwipsPerPixelY \ 2 - 20, 0
    
    'If Not bLoaded Then Exit Sub
    'Editawy1.Resize 0, 0, W \ Screen.TwipsPerPixelX - 10, (H \ Screen.TwipsPerPixelY) - 25
    '--------------------------------------------
    Dim hgt1 As Single, hgt2 As Single

    hgt1 = (Picture1.height - SPLITTER_HEIGHT) * Percentage
    Editawy1.Resize 0, 0, W \ Screen.TwipsPerPixelX - 5, (hgt1 \ Screen.TwipsPerPixelY) - 3
    

    hgt2 = (Picture1.height - SPLITTER_HEIGHT) - hgt1
    'Picture2.Move 0, hgt1 + SPLITTER_HEIGHT, ScaleWidth, hgt2
    Editawy2.Resize 0, (hgt1 + SPLITTER_HEIGHT) \ Screen.TwipsPerPixelX, W \ Screen.TwipsPerPixelX - 5, (hgt2 \ Screen.TwipsPerPixelY) - 0
    
    'Editawy1.Resize 0, 0, W \ Screen.TwipsPerPixelX - 10, (H \ Screen.TwipsPerPixelY) \ 2 - 10
    'Editawy2.Resize 0, (H \ Screen.TwipsPerPixelY) \ 2 + 10, W \ Screen.TwipsPerPixelX - 10, (H \ Screen.TwipsPerPixelY) \ 2 - 40
   
End Sub

Private Sub Form_Activate()
    UpdateToolbar
    'Editawy1.SetFocus
End Sub

Private Sub Form_GotFocus()
    'Debug.Print "Form_GotFocus: "; Me.Tag
    UpdateToolbar
    'Editawy1.SetFocus
End Sub

Private Sub Form_LostFocus()
    'Debug.Print "Form_LostFocus: "; Me.Tag
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    'Debug.Print "Form_KeyPress: "; Chr(KeyAscii)
End Sub

Private Sub Form_Unload(Cancel As Integer)
  
    Dim x As Long
    
    If Editawy1.Modified = True Then
        'X = MsgBox("Save changes to " & Me.Caption & "?", vbYesNoCancel + vbExclamation + vbDefaultButton1, App.ProductName)
        If x = vbYes Then
            'Save the file
            
        ElseIf x = vbNo Then
            'Do not save the file
            
        ElseIf x = vbCancel Then
            Cancel = 1
            Exit Sub
        End If
    End If
    
    fMainForm.TabStrip1.Tabs.Remove fMainForm.TabStrip1.Tabs(Me.Tag).index
    
End Sub

Private Sub Editawy2_UpdateUI(ByVal Line As Long, ByVal Column As Long, ByVal Position As Long, ByVal TotalLines As Long)
    'Debug.Print "Editawy2_UpdateUI "
End Sub


Private Sub Editawy1_UpdateUI(ByVal Line As Long, ByVal Column As Long, ByVal Position As Long, ByVal TotalLines As Long)
    'Debug.Print "Editawy1_UpdateUI"
    
    UpdateToolbar
End Sub

Private Sub UpdateToolbar()
    
    'Debug.Print "Editawy1_UpdateUI"
    'If Not bLoaded Then Exit Sub
    'On Error Resume Next
    'On Error GoTo Errs
    
    If Editawy1.CanCut Then
        fMainForm.tbToolBar.Buttons("Cut").Enabled = True
    Else
        fMainForm.tbToolBar.Buttons("Cut").Enabled = False
    End If
    
    If Editawy1.CanCopy Then
        fMainForm.tbToolBar.Buttons("Copy").Enabled = True
        fMainForm.tbToolBar1.Buttons("ToUpper").Enabled = True
        fMainForm.tbToolBar1.Buttons("ToLower").Enabled = True
    Else
        fMainForm.tbToolBar.Buttons("Copy").Enabled = False
        fMainForm.tbToolBar1.Buttons("ToUpper").Enabled = False
        fMainForm.tbToolBar1.Buttons("ToLower").Enabled = False
    End If
    
    If Editawy1.CanPaste Then
        fMainForm.tbToolBar.Buttons("Paste").Enabled = True
    Else
        fMainForm.tbToolBar.Buttons("Paste").Enabled = False
    End If
    
    If Editawy1.CanUndo Then
        fMainForm.tbToolBar.Buttons("Undo").Enabled = True
    Else
        fMainForm.tbToolBar.Buttons("Undo").Enabled = False
    End If
    
    If Editawy1.CanRedo Then
        fMainForm.tbToolBar.Buttons("Redo").Enabled = True
    Else
        fMainForm.tbToolBar.Buttons("Redo").Enabled = False
    End If
     
    If Me.Tag <> "" Then
        If Editawy1.Modified = True Then
            fMainForm.TabStrip1.Tabs(Me.Tag).Image = "LightOn"
        Else
            fMainForm.TabStrip1.Tabs(Me.Tag).Image = "LightOff"
        End If
    End If
    
    If Editawy1.GetZoom = 0 Then
        fMainForm.tbToolBar1.Buttons("NoZoom").Enabled = False
    Else
        fMainForm.tbToolBar1.Buttons("NoZoom").Enabled = True
    End If
    
    UpdateDocBar
    UpdateStatusBar
    
    'Editawy1.SetFocus
    Exit Sub
Errs:
    Debug.Print "Error, UpdateToolbar: "; Err.Description

End Sub

Private Sub UpdateStatusBar()
    fMainForm.sbStatusBar.Panels("Line").Text = "Line: " & Editawy1.GetCurrentLineNumber
    fMainForm.sbStatusBar.Panels("Column").Text = "Column: " & Editawy1.GetCurColumn
    fMainForm.sbStatusBar.Panels("TotalLines").Text = "Lines: " & Editawy1.TotalLines
    fMainForm.sbStatusBar.Panels("Position").Text = "Position: " & Editawy1.GetCurrentPos
    fMainForm.sbStatusBar.Panels("DocSize").Text = "Size: " & Editawy1.GetTextLength
End Sub

Private Sub UpdateDocBar()

    Dim x As Long
    For x = 1 To fMainForm.TabStrip1.Tabs.count
        fMainForm.TabStrip1.Tabs(Me.Tag).Selected = False
    Next x
    fMainForm.TabStrip1.Tabs(Me.Tag).Selected = True
End Sub

Private Sub Editawy1_MacroRecord(ByVal Message As Long, wParam As Long, lParam As Long, strParam As String)
    'sMacros(lCurentMacro) = sMacros(lCurentMacro) & "|" & Message & ":" & wParam & ":" & strParam
End Sub

Private Sub Editawy1_MarginClick(ByVal modifiers As Long, ByVal Position As Long, ByVal margin As Long)
    'Debug.Print "MarginClick: "; margin, Position
End Sub

Private Sub Editawy1_DblClick(ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    'Debug.Print "DblClick: "; Shift, X, Y
End Sub

Private Sub Editawy1_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    'Debug.Print "MouseDown: "; Button, Shift, X, Y
End Sub

Private Sub Editawy1_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    'Debug.Print Button, Shift, X, Y
End Sub

Private Sub Editawy1_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    'Debug.Print "MouseUp: "; Button, Shift, X, Y
End Sub

Private Sub Editawy1_MouseWheel(ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    'Debug.Print "MouseWheel: "; Shift, X, Y
    
End Sub

Private Sub Editawy1_FoundText(ByVal count As Long)
    'Debug.Print "FoundText: "; Count
End Sub

Private Sub Editawy1_ReplacedText(ByVal count As Long)
    'Debug.Print "ReplacedText: "; Count
End Sub


