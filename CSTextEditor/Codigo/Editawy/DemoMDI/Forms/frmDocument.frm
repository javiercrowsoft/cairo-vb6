VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{895A3E6C-C27E-4388-95FB-595E3D758B6E}#1.0#0"; "Editawy.ocx"
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
   Begin EditawyX.Editawy Editawy1 
      Left            =   960
      Top             =   1740
      _ExtentX        =   847
      _ExtentY        =   847
      SymbolMargin    =   0   'False
      Folding         =   0   'False
      BeginProperty DefaultFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
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

Public strFilename As String

'====================================================================
Private Sub Form_Load()
  
    Dim iniFile As String
    Dim PerlStyler As Styler
    Dim pDoc As Long
    
    On Error GoTo Errs:
    
    '----------------------------------------------------------------
    Editawy1.Initialize
    '----------------------------------------------------------------
    Editawy1.Folding = True
    Editawy1.LineNumbers = True
    Editawy1.SymbolMargin = True
    Editawy1.ReadOnly = False
    Editawy1.HScrollBar = True
    Editawy1.CaretLineVisible = True
    iniFile = App.Path & "\LexersConf.ini"
    
    'Editawy1.LoadFile App.Path & "\ForumLib.pm"
    
    'Editawy1.CaretWidth = 1
    Editawy1.ShowCallTips = True
    Editawy1.LoadCallTipFile App.Path & "\cpp.txt"
    
    'Dim Tips() As String
    'Editawy1.GetCallTips Tips()
    'Debug.Print Tips(134), LBound(Tips), UBound(Tips)
    
    PerlStyler = Editawy1.ReadLanguageStyler("Perl", iniFile)
    Editawy1.SetLanguageStyler PerlStyler
    
    With Editawy1
        '.EOLVisible =False
        '.MatchBraces = True
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
'    Dim pDoc As Long
'    pDoc = Editawy1.GetDocPointer
'    Editawy2.SetDocPointer pDoc
    '----------------------------------------------------------------
    Exit Sub
Errs:
    Debug.Print "Doc Form Error: "; Err.Description
End Sub

Private Sub Form_Resize()
    
    ' Don't bother if we're iconized.
    If WindowState = vbMinimized Then Exit Sub
    Dim H As Long, W As Long
        
    H = Me.height
    W = Me.width
   
    Editawy1.Resize 0, 0, W \ Screen.TwipsPerPixelX - 8, (H \ Screen.TwipsPerPixelY) \ 1 - 25
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

Private Sub Editawy1_GotTheFocus()
    'Debug.Print "Editawy1_GotTheFocus: "
End Sub

Private Sub Editawy1_LostTheFocus()
    'Debug.Print "Editawy1_LostTheFocus"
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
'
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
'
End Sub

Private Sub Form_Activate()
    UpdateToolbar
    'Editawy1.SetFocus
End Sub

Private Sub Form_GotFocus()
    UpdateToolbar
    Editawy1.SetFocus
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

Private Sub Editawy1_UpdateUI(ByVal Line As Long, ByVal Column As Long, ByVal Position As Long, ByVal TotalLines As Long)
    'Debug.Print "Editawy1_UpdateUI"
    UpdateToolbar
End Sub

Private Sub UpdateToolbar()
    
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
'    Dim x As Long
'    For x = 1 To fMainForm.TabStrip1.Tabs.count
'        fMainForm.TabStrip1.Tabs(Me.Tag).Selected = False
'    Next x
'    fMainForm.TabStrip1.Tabs(Me.Tag).Selected = True
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


