VERSION 5.00
Begin VB.Form fSearch 
   Caption         =   "CrowSoft Count Lines"
   ClientHeight    =   7725
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   12960
   LinkTopic       =   "Form1"
   ScaleHeight     =   7725
   ScaleWidth      =   12960
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txNoSearch 
      Height          =   285
      Left            =   600
      TabIndex        =   7
      Text            =   "D:\Proyectos\z|D:\Proyectos\dll.compatibylity|D:\Proyectos\dll - ocx - exe"
      ToolTipText     =   "Permite listas ejemplo: D:\Proyectos\z|D:\Proyectos\dll.compatibylity|D:\Proyectos\dll - ocx - exe"
      Top             =   420
      Width           =   8535
   End
   Begin VB.ListBox lsFiles 
      Height          =   6885
      Left            =   600
      TabIndex        =   4
      Top             =   780
      Width           =   12315
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "Count"
      Height          =   315
      Left            =   9600
      TabIndex        =   3
      Top             =   60
      Width           =   1395
   End
   Begin VB.CommandButton cmdPath 
      Caption         =   "..."
      Height          =   315
      Left            =   9120
      TabIndex        =   2
      Top             =   60
      Width           =   375
   End
   Begin VB.TextBox txPath 
      Height          =   285
      Left            =   600
      TabIndex        =   0
      Text            =   "d:\Proyectos\*.cls"
      Top             =   60
      Width           =   8535
   End
   Begin VB.Label Label2 
      Caption         =   "Excluir"
      Height          =   255
      Left            =   60
      TabIndex        =   8
      Top             =   420
      Width           =   615
   End
   Begin VB.Label lbVan 
      Alignment       =   1  'Right Justify
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   11100
      TabIndex        =   6
      Top             =   60
      Width           =   1815
   End
   Begin VB.Label Label1 
      Caption         =   "Detalle"
      Height          =   255
      Left            =   60
      TabIndex        =   5
      Top             =   780
      Width           =   615
   End
   Begin VB.Label lbpath 
      Caption         =   "Path"
      Height          =   255
      Left            =   60
      TabIndex        =   1
      Top             =   60
      Width           =   615
   End
End
Attribute VB_Name = "fSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function ShellExecute2 Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Const SW_SHOWNORMAL = 1
Private Const ERROR_PATH_NOT_FOUND = 3&
Private Const ERROR_BAD_FORMAT = 11&
Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
Private Const SE_ERR_ASSOCINCOMPLETE = 27
Private Const SE_ERR_DDEBUSY = 30
Private Const SE_ERR_DDEFAIL = 29
Private Const SE_ERR_DDETIMEOUT = 28
Private Const SE_ERR_DLLNOTFOUND = 32
Private Const SE_ERR_FNF = 2                     '  file not found
Private Const SE_ERR_NOASSOC = 31
Private Const SE_ERR_OOM = 8                     '  out of memory
Private Const SE_ERR_PNF = 3                     '  path not found
Private Const SE_ERR_SHARE = 26

Private m_find As Boolean
Private m_cancel As Boolean
Private m_files() As String
Private m_last As Integer
Private m_last2 As Integer
Private m_Lines As Long

Private Sub cmdFind_Click()
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
    
    m_Lines = 0
    pFind
    Me.lsFiles.AddItem m_Lines
    cmdFind.Caption = "Find"
    m_find = False
    m_cancel = True
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
    If GetAttr(path2 & s) = vbDirectory And s <> ".." And s <> "." Then
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
  Dim sFile As String
  Dim f As Integer
  Dim l As Long
  Dim n2 As Long
  Dim k   As Long
  Dim bCount As Boolean
  
  Dim n         As Long
  Dim vNoSearch As Variant
  
  vNoSearch = Split(LCase(txNoSearch.Text), "|")
  
  f = FreeFile
  
  For k = 1 To UBound(m_files)
    If m_files(k) = "" Then GoTo NextFile
    
    For n = 0 To UBound(vNoSearch)
      If InStr(1, LCase(m_files(k)), vNoSearch(n), vbBinaryCompare) Then GoTo NextFile
    Next
    
    sFile = m_files(k)
    
    n2 = FileLen(sFile)
    Me.Caption = sFile
    
    If n2 > 10485760 Then
      If MsgBox("Este archivo mide: " & Round((n2 / 1024) / 1024, 2) & "MB desea buscar en el", vbQuestion + vbYesNo) = vbNo Then
        GoTo NextFile
      End If
    End If
  
    Open sFile For Input As #f

    Dim nlines As Long

    nlines = 0
    bCount = False

    Do While Not EOF(f)

      Line Input #f, s
      
      If s <> "" And Left$(s, 1) <> "'" Then
      
        If bCount Then
          nlines = nlines + 1
        Else
          If LCase(s) = "option explicit" Or Right(sFile, 4) = ".sql" Then
            bCount = True
          End If
        End If
      End If
      
      DoEvents: DoEvents: DoEvents: DoEvents
      If m_cancel Then Exit Sub
      l = l + Len(s)
      lbVan.Caption = Format(m_Lines, "#,###,###,###0")
    Loop
    
    m_Lines = m_Lines + nlines
    
    lsFiles.AddItem sFile & " - " & nlines
    
    Close #f
    
NextFile:
  Next

  lsFiles.AddItem "Characters - " & l

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

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  End
End Sub

Private Sub lsFiles_DblClick()
  On Error Resume Next
  EditFile lsFiles.Text, Me.hwnd
End Sub

Public Sub EditFile(ByVal strFile As String, ByVal hwnd As Long)
  Dim Hresult As Long
  
  
  Hresult = ShellExecute2(hwnd, "open", strFile + Chr(0), 0, strFile + Chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Sub

