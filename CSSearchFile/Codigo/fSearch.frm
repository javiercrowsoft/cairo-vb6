VERSION 5.00
Begin VB.Form fSearch 
   Caption         =   "Find"
   ClientHeight    =   3690
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10125
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   3690
   ScaleWidth      =   10125
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txToSearch 
      Height          =   285
      Left            =   720
      TabIndex        =   2
      Top             =   420
      Width           =   7335
   End
   Begin VB.ListBox lsFiles 
      Height          =   2790
      Left            =   60
      MultiSelect     =   2  'Extended
      TabIndex        =   5
      Top             =   780
      Width           =   9975
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "Find"
      Default         =   -1  'True
      Height          =   315
      Left            =   8640
      TabIndex        =   3
      Top             =   60
      Width           =   1395
   End
   Begin VB.CommandButton cmdPath 
      Caption         =   "..."
      Height          =   315
      Left            =   8160
      TabIndex        =   1
      Top             =   60
      Width           =   375
   End
   Begin VB.TextBox txPath 
      Height          =   285
      Left            =   720
      TabIndex        =   0
      Text            =   "d:\Proyectos\*.*"
      Top             =   60
      Width           =   7335
   End
   Begin VB.Label lbVan 
      Alignment       =   1  'Right Justify
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   8640
      TabIndex        =   4
      Top             =   420
      Width           =   1395
   End
   Begin VB.Label Label1 
      Caption         =   "Search"
      Height          =   255
      Left            =   60
      TabIndex        =   7
      Top             =   420
      Width           =   675
   End
   Begin VB.Label lbpath 
      Caption         =   "Path"
      Height          =   255
      Left            =   60
      TabIndex        =   6
      Top             =   60
      Width           =   675
   End
   Begin VB.Menu popMain 
      Caption         =   "popMain"
      Visible         =   0   'False
      Begin VB.Menu popCopy 
         Caption         =   "Copy"
      End
      Begin VB.Menu popEdit 
         Caption         =   "Edit"
      End
      Begin VB.Menu popSetWritable 
         Caption         =   "Set Writable"
      End
      Begin VB.Menu popToCSV 
         Caption         =   "To Excel"
      End
   End
End
Attribute VB_Name = "fSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_find As Boolean
Private m_cancel As Boolean
Private m_files() As String
Private m_last As Integer
Private m_last2 As Integer

Private Sub cmdFind_Click()
  
  If cmdFind.Caption = "Cancel" Then
    m_cancel = True
  Else
    If m_find Then
      cmdFind.Caption = "Find"
      m_find = False
      m_cancel = True
    Else
      lsFiles.Clear
      cmdFind.Caption = "Stop"
      m_find = True
      m_cancel = False
    
      m_last = 400
      m_last2 = 1
      ReDim m_files(m_last)
      
      LoadFiles txPath
      
      pFind
      cmdFind.Caption = "Find"
      m_find = False
      m_cancel = True
    End If
  End If
End Sub


Private Sub LoadFiles(ByVal path As String)
  On Error Resume Next
  
  Dim s As String
  Dim vDirs() As String
  
  ReDim vDirs(0)
  
  s = Dir(path)
  
  Dim q As Long
  
  For q = Len(path) To 1 Step -1
    If Mid(path, q, 1) = "\" Then Exit For
  Next
  
  Dim path2 As String
  Dim Ext   As String
  
  path2 = Mid(path, 1, q)
  Ext = Mid(path, q + 1)
  
  Do
    If s = "" Then Exit Do
    If m_last2 > m_last Then
      m_last = m_last + 100
      ReDim Preserve m_files(m_last)
    End If
    m_files(m_last2) = path2 & s
    m_last2 = m_last2 + 1
    
    s = Dir
    DoEvents
    If m_cancel Then Exit Sub
  Loop Until s = ""
  
  s = Dir(path2, vbDirectory)
  Do
    If s = "" Then Exit Do
    If (GetAttr(path2 & s) And vbDirectory) = vbDirectory And s <> ".." And s <> "." Then
      ReDim Preserve vDirs(UBound(vDirs) + 1)
      vDirs(UBound(vDirs)) = path2 & s
    End If
    s = Dir
  Loop
  
  Dim i As Integer
  For i = 1 To UBound(vDirs)
    LoadFiles vDirs(i) & "\" & Ext
  Next
End Sub


Private Sub pFind()
  Dim s As String
  Dim n As Long
  Dim s2 As String
  Dim sFile As String
  Dim f As Integer
  Dim l As Long
  Dim n2 As Long
  Dim k   As Long
  Dim bAny As Boolean
  
  n = Len(txToSearch.Text) * 5000
  bAny = txToSearch.Text = "_any_"
  
  f = FreeFile
  For k = 1 To UBound(m_files)
    If m_files(k) = "" Then GoTo NextFile
    sFile = m_files(k)
    
    n2 = FileLen(sFile)
    Me.Caption = sFile
    
    If n2 > 10485760 Then
      If MsgBox("Este archivo mide: " & Round((n2 / 1024) / 1024, 2) & "MB desea buscar en el", vbQuestion + vbYesNo) = vbNo Then
        GoTo NextFile
      End If
    End If
  
    Open sFile For Binary As #f

    l = 0
    Do While Not EOF(f)
      s = String(n, " ")
      Get #f, , s
      If InStr(1, s2 & s, txToSearch.Text, vbTextCompare) Or bAny Then
        lsFiles.AddItem sFile
        Exit Do
      End If
      s2 = s
      
      DoEvents: DoEvents: DoEvents: DoEvents
      If m_cancel Then Exit Sub
      l = l + n
      lbVan.Caption = CLng(DivideByCero(l, n2) * 100)
    Loop
    
    Close #f
    
NextFile:
  Next
End Sub

Private Function pGetPath(ByVal path As String) As String
  Dim c As String
  Dim i As Integer
  Dim FileNamePresent As Boolean
  
  For i = Len(path) To 1 Step -1
    c = Mid(path, i, 1)
    If c = "\" Then Exit For
      
    If c = "." Then FileNamePresent = True
  Next
  
  If FileNamePresent Then
    path = Mid(path, 1, i)
  End If
  
  If Right(path, 1) <> "\" Then path = path & "\"
  
  pGetPath = path
End Function

Private Sub Form_Click()
  pSave
End Sub

Private Sub pSave()
  On Error GoTo ControlError
  
  Dim i As Integer
  Dim f As Long
  Dim fileName As String
  
  f = FreeFile
  fileName = InputBox("Indique el nombre del archivo", "File", App.path & "\archivos.txt")
  If fileName = "" Then Exit Sub
  Open fileName For Output As #f
  For i = 0 To Me.lsFiles.ListCount - 1
    Print #f, Me.lsFiles.List(i)
  Next
  Close #f
  
  Exit Sub
ControlError:
  MsgBox Err.Description
End Sub

Private Sub Form_Load()
  On Error Resume Next
  
  txPath.Text = GetSetting(App.EXEName, "config", "txPath", "d:\proyectos\*.*")
  txToSearch.Text = GetSetting(App.EXEName, "config", "txToSearch", "")
  
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  With lsFiles
    .Move .Left, .Top, ScaleWidth - .Left * 2, ScaleHeight - .Top - 80
  End With
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  SaveSetting App.EXEName, "config", "txPath", txPath.Text
  SaveSetting App.EXEName, "config", "txToSearch", txToSearch.Text
  
  End
End Sub

Private Sub lsFiles_DblClick()
  On Error Resume Next
  Dim i As Integer
  
  cmdFind.Caption = "Cancel"
  m_cancel = False

  For i = 0 To lsFiles.ListCount - 1
    If lsFiles.Selected(i) Then
      EditFile lsFiles.List(i), Me.hWnd
    End If
    DoEvents
    If m_cancel Then
      m_cancel = False
      Exit For
    End If
  Next
  
  cmdFind.Caption = "Find"
End Sub

Private Sub lsFiles_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  If Button = vbRightButton Then
    Me.PopupMenu popMain
  End If
End Sub

'Private Sub lsFiles_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
'  On Error Resume Next
'  If Button = vbLeftButton Then
'    lsFiles.OLEDrag
'  End If
'End Sub

Private Sub popCopy_Click()
  On Error Resume Next
  
  Dim vcopy() As String
  Dim scopy   As String
  
  ReDim vcopy(lsFiles.ListCount)
  
  Dim i As Long
  For i = 1 To UBound(vcopy)
    If lsFiles.Selected(i - 1) Then
      vcopy(i) = lsFiles.List(i - 1)
    End If
  Next
  
  Dim j As Long
  For i = 0 To UBound(vcopy) - 1
    If LenB(vcopy(i)) = 0 Then
      For j = i + 1 To UBound(vcopy) - 1
        If LenB(vcopy(j)) Then
          vcopy(i) = vcopy(j)
          Exit For
        End If
      Next
    End If
  Next
  
  For i = 0 To UBound(vcopy) - 1
    If LenB(vcopy(i)) = 0 Then
      Exit For
    End If
  Next
  
  If i > 0 Then
    ReDim Preserve vcopy(i - 1)
  End If
  scopy = Join(vcopy, vbCrLf)
  
  Clipboard.Clear
  Clipboard.SetText scopy
End Sub

Private Sub popEdit_Click()
  lsFiles_DblClick
End Sub

Private Sub popSetWritable_Click()
  If Not Ask("Estas seguro", vbNo) Then Exit Sub
  
  On Error Resume Next
  
  Dim i As Long
  
  For i = 0 To lsFiles.ListCount - 1
    If lsFiles.Selected(i - 1) Then
      SetAttr lsFiles.List(i), vbNormal
    End If
  Next
End Sub

Private Sub popToCSV_Click()
  Dim bOnlyParent As Boolean
  
  bOnlyParent = Not Ask("¿Incluir toda la ruta?.;;;Si contestas que NO, solo se incluira el nombre de la carpeta que contiene el archivo.", vbYes)
  
  On Error Resume Next
  
  Dim i As Long
  
  Dim export As cExporToExcel
  Dim file   As CSKernelFile.cFile
  Dim path   As String
  
  Dim vMatrix() As String
  
  ReDim vMatrix(2, lsFiles.ListCount + 1)
  
  vMatrix(2, 0) = "Carpeta"
  vMatrix(1, 0) = "Archivo"
  
  Set file = New CSKernelFile.cFile
  
  Dim j As Long
  
  For i = 0 To lsFiles.ListCount - 1
    If lsFiles.Selected(i - 1) Then
      j = j + 1
    
      vMatrix(2, j) = file.GetFileName(lsFiles.List(i))
      
      path = file.GetPath(lsFiles.List(i))
      If bOnlyParent Then
        If InStr(4, path, "\") Then
          path = file.GetFileName(path)
        End If
      End If
      vMatrix(1, j) = path
    End If
  Next
  
  Set export = New cExporToExcel
  export.export dblExMatrix, vbNullString, , vMatrix
  
End Sub
