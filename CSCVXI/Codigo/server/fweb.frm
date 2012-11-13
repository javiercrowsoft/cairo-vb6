VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "SHDOCVW.dll"
Begin VB.Form fWebCtrl 
   Caption         =   "Form1"
   ClientHeight    =   5715
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6045
   LinkTopic       =   "Form1"
   ScaleHeight     =   5715
   ScaleWidth      =   6045
   StartUpPosition =   3  'Windows Default
   Begin SHDocVwCtl.WebBrowser wb 
      Height          =   2235
      Left            =   780
      TabIndex        =   0
      Top             =   1740
      Width           =   4515
      ExtentX         =   7964
      ExtentY         =   3942
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
Attribute VB_Name = "fWebCtrl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' http://www.vbwm.com/articles/builder/viewer.asp?ArticleID=31&CurrentPage=4

Public Event NavigateComplete(ByVal pDisp As Object, url As Variant)
Public Event FormActivate()

Private m_step        As Integer
Private m_bActivate   As Boolean

Private Sub Form_Activate()
  If Not m_bActivate Then
    RaiseEvent FormActivate
    m_bActivate = True
  End If
End Sub

Private Sub Form_Load()
  m_bActivate = False
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  Me.wb.Move 0, 0, ScaleWidth, ScaleHeight
End Sub

Private Sub wb_DocumentComplete(ByVal pDisp As Object, url As Variant)
  RaiseEvent NavigateComplete(pDisp, url)
End Sub

Private Sub wb_Click()

End Sub
