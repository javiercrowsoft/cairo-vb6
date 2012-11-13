VERSION 5.00
Object = "{9B1CFDFA-D542-4503-8D92-C3F239558D55}#5.0#0"; "Editawy.ocx"
Begin VB.Form frmDoc 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   Begin EditawyX.Editawy Editawy1 
      Left            =   1860
      Top             =   1140
      _ExtentX        =   847
      _ExtentY        =   847
      CallTipBackColor=   0
      CallTipForeColor=   0
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
      CaretLineBackColor=   0
      CaretLineVisible=   0   'False
      CaretWidth      =   0
      TabWidth        =   0
      EdgeColumn      =   120
      EdgeColor       =   0
   End
End
Attribute VB_Name = "frmDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private iLngCount As Integer
Public bLoaded As Boolean

Private Sub Form_Activate()
    If Not bLoaded Then Exit Sub
    'UpdateDocBar
    'UpdateToolbar
    'Editawy1.SetFocus
End Sub

Private Sub Form_GotFocus()
    If Not bLoaded Then Exit Sub
    'UpdateDocBar
    UpdateToolbar
    'Editawy1.SetFocus
End Sub

Private Sub Form_Load()
  
    Dim iniFile As String
    
    bLoaded = False
    
    On Error GoTo Errs:
    
    iLngCount = 0
    '----------------------------------------------------------------
    Editawy1.Initialize
'    '----------------------------------------------------------------
    Editawy1.Folding = True
    Editawy1.LineNumbers = True
    iniFile = "C:\\VBmyProjects\\Editor\\LexersConf.ini"
    Editawy1.LanguageINI "Perl", iniFile
    Editawy1.ReadOnly = False
    Editawy1.LoadFile "c:\\apache\\cgi-bin\\auction\\Bidding.pm"
    Editawy1.EmptyUndoBuffer
    
    'Editawy1.SetMouseDwellTime 100
    
    bLoaded = True
    'UpdateDocBar
    'UpdateToolbar
    'fMainForm.tbToolBar.Buttons("Undo").Enabled = False
    Debug.Print "Count: "; fMainForm.tbToolBar.Buttons.Count
    Exit Sub
Errs:
    Debug.Print "Doc Form Error: "; Err.Description
End Sub

Private Sub Form_Resize()
    If Not bLoaded Then Exit Sub
    Editawy1.Resize 0, 0, Me.ScaleWidth, Me.ScaleHeight
End Sub

Private Sub Form_Unload(Cancel As Integer)
  
    Dim X As Long
    
    If Editawy1.Modified = True Then
        X = MsgBox("Save changes to " & Me.Caption & "?", vbYesNoCancel + vbExclamation + vbDefaultButton1, App.ProductName)
        If X = vbYes Then
            'Save the file
        ElseIf X = vbNo Then
            'Do not save the file
        ElseIf X = vbCancel Then
            Cancel = 1
            Exit Sub
        End If
    End If
    
    'fMainForm.tbDocs.Buttons.Remove (Me.Tag)
    'fMainForm.tbDocs.Buttons.Remove ("S" & Me.Tag)
  
End Sub

Private Sub mnuCopy_Click()
  'Editawy1.Copy
End Sub

Private Sub mnuCut_Click()
  'Editawy1.Cut
End Sub

Private Sub mnuExport_Click()
  'Editawy1.ExportToHTML "c:\test1234567.html"
End Sub

Private Sub mnuFileNew_Click()
  'mdiFrmMain.mnuNew_Click
End Sub

Private Sub mnuFind_Click()
  'Editawy1.DoFind
End Sub

Private Sub mnuFindNext_Click()
  'Editawy1.FindNext
End Sub

Private Sub mnuFindPrev_Click()
  'Editawy1.FindPrev
End Sub

Private Sub Editawy1_UpdateUI(ByVal Line As Long, ByVal Column As Long, ByVal Position As Long, ByVal TotalLines As Long)
    
    'Debug.Print "Editawy1_UpdateUI"
    'If Not bLoaded Then Exit Sub
    'fMainForm.sbStatusBar.Panels("Line").Text = "Line: " & Line
    'fMainForm.sbStatusBar.Panels("Column").Text = "Column: " & Column
    'fMainForm.sbStatusBar.Panels("TotalLines").Text = "Total Lines: " & TotalLines
    'fMainForm.sbStatusBar.Panels("Position").Text = "Position: " & Position
    
    UpdateToolbar
End Sub

Private Sub UpdateToolbar()
    
    If Not bLoaded Then Exit Sub
    'On Error Resume Next
    On Error GoTo Errs
    
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
            fMainForm.tbDocs.Buttons(Me.Tag).Image = "LightOn"
        Else
            fMainForm.tbDocs.Buttons(Me.Tag).Image = "LightOff"
        End If
    End If
    
    UpdateDocBar
    UpdateStatusBar
    
    'Editawy1.SetFocus
    'Editawy1.SetFocusFlag True
    Exit Sub
Errs:
    Debug.Print "Error-UpdateToolbar: "; Err.Description

End Sub

Private Sub UpdateStatusBar()
    If Not bLoaded Then Exit Sub
    Debug.Print "UpdateStatusBar"
    fMainForm.sbStatusBar.Panels("Line").Text = "Line: " & Editawy1.GetCurrentLineNumber
    fMainForm.sbStatusBar.Panels("Column").Text = "Column: " & Editawy1.GetCurColumn
    fMainForm.sbStatusBar.Panels("TotalLines").Text = "Total Lines: " & Editawy1.TotalLines
    fMainForm.sbStatusBar.Panels("Position").Text = "Position: " & Editawy1.GetCurrentPos

End Sub

Public Sub UpdateDocBar()
    If Not bLoaded Then Exit Sub
    'On Error Resume Next
    On Error GoTo Errs
    Dim X As Long
    For X = 1 To fMainForm.tbDocs.Buttons.Count
        fMainForm.tbDocs.Buttons(X).Value = tbrUnpressed
        Debug.Print "Key: "; fMainForm.tbDocs.Buttons(X).Key
    Next X
    Debug.Print "Me.Tag = "; Me.Tag
    'fMainForm.tbDocs.Buttons(Me.Tag).Value = tbrPressed
    Exit Sub
Errs:
    Debug.Print "Error: "; Err.Description
End Sub

Private Sub Editawy1_MacroRecord(ByVal Message As Long, wParam As Long, lParam As Long, strParam As String)
    If Not bLoaded Then Exit Sub
    sMacros(lCurentMacro) = sMacros(lCurentMacro) & "|" & Message & ":" & wParam & ":" & strParam
End Sub

Private Sub Editawy1_MarginClick(ByVal modifiers As Long, ByVal Position As Long, ByVal margin As Long)
    If Not bLoaded Then Exit Sub
    'fMainForm.ActiveForm.Editawy1.SetFocus
    'Debug.Print "MarginClick: "; margin, Position
End Sub




