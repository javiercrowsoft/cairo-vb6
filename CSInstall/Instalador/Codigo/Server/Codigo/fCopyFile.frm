VERSION 5.00
Begin VB.Form fCopyFile 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Copiando archivos..."
   ClientHeight    =   2145
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5850
   Icon            =   "fCopyFile.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2145
   ScaleWidth      =   5850
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picStatus 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      FillColor       =   &H0080C0FF&
      Height          =   330
      Left            =   120
      ScaleHeight     =   330
      ScaleWidth      =   5595
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   1260
      Width           =   5592
   End
   Begin VB.Label lbFile 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   5595
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Copiando:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   180
      Width           =   1155
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   435
      Left            =   60
      Top             =   1200
      Width           =   5715
   End
   Begin VB.Image cmdCancel 
      Height          =   330
      Left            =   2040
      Picture         =   "fCopyFile.frx":058A
      Top             =   1740
      Width           =   1635
   End
End
Attribute VB_Name = "fCopyFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_bDone         As Boolean
Private m_Ok            As Boolean
Private m_bCancel       As Boolean
Private m_FolderSource  As String
Private m_FolderTo      As String
Private m_FileCount     As Long
Private m_IdxFile       As Long

Private Enum csE_CopyFileError
  csEIgnore = 1
  csETryAgain = 2
  csECancel = 3
End Enum

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Sub CopyFile(ByVal FolderSource As String, ByVal FolderTo As String)
  m_FolderSource = FolderSource
  m_FolderTo = FolderTo
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  Dim rslt As VbMsgBoxResult
  
  rslt = MsgBox("Si cancela el proceso el sistema no se instalará." & vbCrLf & vbCrLf & "¿Confirma que desea cancelar?", vbQuestion + vbYesNo)
  
  If rslt = vbYes Then
    m_Ok = False
    m_bCancel = True
  End If
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  
  If m_bDone Then Exit Sub
  m_bDone = True
  
  DoEvents
  
  m_FileCount = 0
  m_IdxFile = 0
  
  UpdateStatus picStatus, 0
  
  pCountFiles m_FolderSource, m_FolderTo
  pCopyFiles m_FolderSource, m_FolderTo
  
  Unload Me
End Sub

Private Sub Form_Load()
  On Error Resume Next
  Me.Left = (Screen.Width - Me.Width) * 0.5
  Me.Top = (Screen.Height - Me.Height) * 0.5
  m_Ok = True
  m_bCancel = False
  m_bDone = False
End Sub

Private Function pCountFiles(ByVal FolderSource As String, ByVal FolderTo As String) As Boolean
  Dim vFolders()  As String
  Dim vFiles()    As String
  Dim i           As Long
  
  pGetFolders vFolders, FolderSource
  
  For i = 1 To UBound(vFolders)
    If Not pCountFiles(FolderSource & "\" & vFolders(i), _
                      FolderTo & "\" & vFolders(i)) Then Exit Function
    DoEvents
    If m_bCancel Then Exit Function
  Next
  
  pGetFiles vFiles, FolderSource
  
  For i = 1 To UBound(vFiles)
    DoEvents
    If m_bCancel Then Exit Function

    m_FileCount = m_FileCount + 1
  Next
  
  pCountFiles = True
End Function

Private Function pCopyFiles(ByVal FolderSource As String, ByVal FolderTo As String) As Boolean
  Dim vFolders()  As String
  Dim vFiles()    As String
  Dim i           As Long
  
  pGetFolders vFolders, FolderSource
  
  For i = 1 To UBound(vFolders)
    If Not pCopyFiles(FolderSource & "\" & vFolders(i), _
                      FolderTo & "\" & vFolders(i)) Then Exit Function
    DoEvents
    If m_bCancel Then Exit Function
  Next
  
  pGetFiles vFiles, FolderSource
  
  CreateFolder FolderTo
  
  For i = 1 To UBound(vFiles)
    DoEvents
    If m_bCancel Then Exit Function
    
    If Not pCopyFile(FolderSource & "\" & vFiles(i), FolderTo & "\" & vFiles(i)) Then Exit Function
  Next
  
  pCopyFiles = True
End Function

Private Sub pGetFolders(ByRef vFolders() As String, ByVal Folder As String)
  Dim rslt As String
  
  ReDim vFolders(0)
  rslt = Dir(Folder & "\", vbDirectory)
  
  Do While rslt <> ""
    If rslt <> "." And rslt <> ".." Then
      If GetAttr(Folder & "\" & rslt) And vbDirectory Then
        ReDim Preserve vFolders(UBound(vFolders) + 1)
        vFolders(UBound(vFolders)) = rslt
      End If
    End If
    rslt = Dir()
  Loop
End Sub

Private Sub pGetFiles(ByRef vFiles() As String, ByVal Folder As String)
  Dim rslt As String
  
  ReDim vFiles(0)
  rslt = Dir(Folder & "\")
  
  Do While rslt <> ""
    ReDim Preserve vFiles(UBound(vFiles) + 1)
    vFiles(UBound(vFiles)) = rslt
    rslt = Dir()
  Loop
End Sub

Private Function pCopyFile(ByVal FileSource As String, ByVal FileTo As String) As Boolean
  Dim strError As String
  Dim rslt     As csE_CopyFileError
  
  rslt = csETryAgain
  
  m_IdxFile = m_IdxFile + 1
  lbFile.Caption = FileTo
  UpdateStatus picStatus, m_IdxFile / m_FileCount
  
  Do While rslt = csETryAgain
    
    DoEvents
    
    If Not pCopyFileAux(FileSource, FileTo, strError) Then
      rslt = pContinue(FileSource, strError)
      
      If rslt = csECancel Then Exit Function
    Else
      
      pSetAttribute FileTo
      Exit Do
    End If
  Loop
  
  pCopyFile = True
End Function

Private Function pCopyFileAux(ByVal FileSource As String, ByVal FileTo As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not pDeleteFile(FileTo, strError) Then Exit Function
  
  FileCopy FileSource, FileTo
  
  strError = Err.Description
  
  pCopyFileAux = Err.Number = 0
End Function

Private Function pDeleteFile(ByVal File As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If FileExists(File) Then Kill File

  strError = Err.Description

  pDeleteFile = Err.Number = 0
End Function

Private Function pContinue(ByVal File As String, ByVal strError As String) As csE_CopyFileError
  Dim rslt As VbMsgBoxResult
  Dim msg  As String
  
  msg = "Ha ocurrido un error copiando el archivo '" & File & "'." & vbCrLf & vbCrLf
  msg = msg & "Error: " & strError & vbCrLf & vbCrLf
  rslt = MsgBox(msg, vbAbortRetryIgnore)
  
  Select Case rslt
    Case vbIgnore
      pContinue = csEIgnore
    Case vbRetry
      pContinue = csETryAgain
    Case vbAbort
      pContinue = csECancel
  End Select
End Function

Private Sub pSetAttribute(ByVal File As String)
  SetAttr File, vbNormal
End Sub
