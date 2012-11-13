VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00000000&
   Caption         =   "Form1"
   ClientHeight    =   4230
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   13530
   LinkTopic       =   "Form1"
   ScaleHeight     =   4230
   ScaleWidth      =   13530
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TxNext 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   10035
      TabIndex        =   7
      Top             =   45
      Width           =   690
   End
   Begin VB.CommandButton cmdAuto 
      Caption         =   "Auto"
      Height          =   330
      Left            =   12375
      TabIndex        =   6
      Top             =   45
      Width           =   1095
   End
   Begin VB.Timer Timer1 
      Left            =   5310
      Top             =   1890
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   330
      Left            =   10755
      TabIndex        =   5
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton cmdBack 
      Caption         =   "Back"
      Default         =   -1  'True
      Height          =   330
      Left            =   7740
      TabIndex        =   4
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   "Next"
      Height          =   330
      Left            =   8865
      TabIndex        =   3
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton cmdShow 
      Caption         =   "Show"
      Height          =   330
      Left            =   6615
      TabIndex        =   2
      Top             =   0
      Width           =   1095
   End
   Begin VB.TextBox txPath 
      Height          =   330
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   6495
   End
   Begin VB.PictureBox picPic 
      AutoSize        =   -1  'True
      Height          =   1680
      Left            =   0
      ScaleHeight     =   1620
      ScaleWidth      =   2025
      TabIndex        =   0
      Top             =   360
      Width           =   2085
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_next As Boolean
Private m_files() As String
Private m_cancel As Boolean

Private m_last As Integer
Private m_last2 As Integer

Private Sub cmdAuto_Click()
  If cmdAuto.Caption = "Auto" Then
    cmdAuto.Caption = "Stop"
    Timer1.Interval = 2000
  Else
    cmdAuto.Caption = "Auto"
    Timer1.Interval = 0
  End If
End Sub

Private Sub cmdBack_Click()
  If Val(TxNext.Text) = 0 Then TxNext.Text = UBound(m_files)
  TxNext.Text = Val(TxNext.Text) - 1
  pShow
End Sub

Private Sub cmdCancel_Click()
  m_cancel = True
End Sub

Private Sub cmdNext_Click()
  TxNext.Text = Val(TxNext.Text) + 1
  pShow
End Sub

Private Sub pShow()
  If Val(TxNext.Text) >= LBound(m_files) And Val(TxNext.Text) <= UBound(m_files) Then
    Set picPic.Picture = LoadPicture(m_files(Val(TxNext.Text)))
  Else
    TxNext.Text = 0
  End If
  Form_Resize
End Sub

Private Sub cmdShow_Click()
  On Error Resume Next
  m_last = 400
  m_last2 = 1
  ReDim m_files(m_last)
  m_cancel = False
  picPic.Visible = False
  LoadFiles txPath & "\"
  ReDim Preserve m_files(m_last2 - 1)
  picPic.Visible = True
End Sub

Private Sub LoadFiles(ByVal path As String)
  On Error Resume Next
  
  Dim s As String
  Dim vDirs() As String
  
  ReDim vDirs(0)
  
  s = Dir(path & "*.*")
  Do
    If s = "" Then Exit Do
    Err.Clear
    Set picPic.Picture = LoadPicture(path & s)
    If Err.Number = 0 Then
      If m_last2 > m_last Then
        m_last = m_last + 100
        ReDim Preserve m_files(m_last)
      End If
      m_files(m_last2) = path & s
      TxNext.Text = m_last2
      m_last2 = m_last2 + 1
    End If
    s = Dir
    DoEvents
    If m_cancel Then Exit Sub
  Loop Until s = ""

  s = Dir(path, vbDirectory)
  Do
    If s = "" Then Exit Do
    If GetAttr(path & s) = vbDirectory And s <> ".." And s <> "." Then
      ReDim Preserve vDirs(UBound(vDirs) + 1)
      vDirs(UBound(vDirs)) = path & s
    End If
    s = Dir
  Loop
  
  Dim i As Integer
  For i = 1 To UBound(vDirs)
    LoadFiles vDirs(i) & "\"
  Next
End Sub

Private Sub Form_Load()
  ReDim m_files(0)
End Sub

Private Sub Form_Resize()
  picPic.Move (ScaleWidth - picPic.Width) / 2, (ScaleHeight - picPic.Height) / 2
End Sub

Private Sub Timer1_Timer()
  cmdNext_Click
End Sub
