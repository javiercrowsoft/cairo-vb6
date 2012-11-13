VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "ieframe.dll"
Begin VB.Form fInfo 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Info"
   ClientHeight    =   5775
   ClientLeft      =   150
   ClientTop       =   285
   ClientWidth     =   8400
   Icon            =   "fInfo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5775
   ScaleWidth      =   8400
   ShowInTaskbar   =   0   'False
   Begin SHDocVwCtl.WebBrowser wb 
      Height          =   5715
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   8355
      ExtentX         =   14737
      ExtentY         =   10081
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
End
Attribute VB_Name = "fInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_lastUrl As String
Private m_bNavigateComplete As Boolean

Public Property Get NavigateComplete() As Boolean
  NavigateComplete = m_bNavigateComplete
End Property

Public Property Let NavigateComplete(ByVal rhs As Boolean)
  m_bNavigateComplete = rhs
End Property

Private Sub Form_Load()
  On Error Resume Next
  
  wb.Top = 0
  wb.Left = 0
  
  CSKernelClient2.LoadForm Me, "fInfo"

  Err.Clear
  
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  wb.Height = Me.ScaleHeight
  wb.Width = Me.ScaleWidth
  
  Err.Clear
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  CSKernelClient2.UnloadForm Me, "fInfo"
  
  Err.Clear
  
End Sub

Private Sub wb_BeforeNavigate2(ByVal pDisp As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
  
  If m_lastUrl = URL Then
  
    Cancel = True
    
  End If
  
  m_lastUrl = URL
  
  If InStr(1, URL, "#respuesta:") Then
    Dim respuesta As String
    
    respuesta = Replace(Mid$(URL, InStr(1, URL, "#respuesta:") + 11), "%20", " ")
    Clipboard.Clear
    Clipboard.SetText respuesta
  
    Cancel = True
  End If
End Sub

Private Sub wb_NavigateComplete2(ByVal pDisp As Object, URL As Variant)
  On Error Resume Next
  
  m_bNavigateComplete = True
  
  Err.Clear
End Sub
