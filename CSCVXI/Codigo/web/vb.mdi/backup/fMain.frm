VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "SHDOCVW.dll"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fMain 
   BackColor       =   &H80000015&
   Caption         =   "QBPoint Browser"
   ClientHeight    =   5100
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   8745
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5100
   ScaleWidth      =   8745
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.StatusBar sbMain 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   3
      Top             =   4845
      Width           =   8745
      _ExtentX        =   15425
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   14896
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbMain 
      Align           =   1  'Align Top
      Height          =   600
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   8745
      _ExtentX        =   15425
      _ExtentY        =   1058
      ButtonWidth     =   609
      ButtonHeight    =   953
      _Version        =   393216
      Begin VB.TextBox txAddress 
         BorderStyle     =   0  'None
         Height          =   315
         Left            =   0
         TabIndex        =   2
         Text            =   "http://mail.yahoo.com"
         Top             =   0
         Width           =   3795
      End
   End
   Begin MSComctlLib.ImageList ilToolbar 
      Left            =   5280
      Top             =   3120
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   32
      ImageHeight     =   32
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":038A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1064
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1D3E
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin SHDocVwCtl.WebBrowser wb 
      Height          =   1815
      Left            =   60
      TabIndex        =   0
      Top             =   660
      Width           =   3675
      ExtentX         =   6482
      ExtentY         =   3201
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
      Location        =   "http:///"
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const c_button_cancel = "cancel"
Private Const c_button_home = "home"
Private Const c_button_reload = "reload"

Private Const c_home_url = "http://www.mercadolibre.com.ar"

Private m_url_calif As String

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  
  If Button.Key = c_button_cancel Then
    wb.Stop
  ElseIf Button.Key = c_button_home Then
    txAddress.Text = c_home_url
    Navigate
  ElseIf Button.Key = c_button_reload Then
    wb.Refresh2
  End If
  
  Err.Clear
End Sub

Private Sub txAddress_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  If KeyAscii = vbKeyReturn Then
    Navigate
  End If
  Err.Clear
End Sub

Private Sub wb_BeforeNavigate2(ByVal pDisp As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
  On Error Resume Next
End Sub

Private Sub Navigate()
  On Error Resume Next
  wb.Navigate txAddress.Text
  Err.Clear
End Sub

Private Sub Form_Load()
  On Error Resume Next
  tbMain.Style = tbrFlat
  tbMain.ImageList = ilToolbar
  tbMain.Buttons.Add , c_button_reload, , , 3
  tbMain.Buttons.Add , c_button_cancel, , , 2
  
  With tbMain.Buttons.Add(, c_button_home, , , 1)
    txAddress.Left = .Left + .Width + 100
    txAddress.Top = 100
  End With
  
  txAddress.Text = c_home_url
  
  wb.Top = tbMain.Height
  wb.Left = -10
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  txAddress.Width = Me.ScaleWidth - txAddress.Left - 50
  wb.Width = Me.ScaleWidth + 20
  wb.Height = Me.ScaleHeight - wb.Top - sbMain.Height
  Err.Clear
End Sub

Private Sub wb_NavigateError(ByVal pDisp As Object, URL As Variant, Frame As Variant, StatusCode As Variant, Cancel As Boolean)
  On Error Resume Next
  Cancel = True
End Sub

Private Sub wb_NewWindow2(ppDisp As Object, Cancel As Boolean)

  Debug.Print wb.LocationURL
  If m_url_calif <> "" Then
    txAddress.Text = m_url_calif
    Navigate
  End If
  Cancel = True
End Sub

Private Sub wb_StatusTextChange(ByVal Text As String)
  If InStr(1, Text, "calif") Then
    m_url_calif = Text
  Else
    m_url_calif = ""
  End If
  sbMain.Panels.Item(1).Text = Text
End Sub
