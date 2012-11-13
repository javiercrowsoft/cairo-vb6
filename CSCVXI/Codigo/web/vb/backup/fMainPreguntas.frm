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
   Icon            =   "fMainPreguntas.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5100
   ScaleWidth      =   8745
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmReadPage 
      Left            =   4680
      Top             =   1740
   End
   Begin VB.Timer tmRefresh 
      Left            =   3780
      Top             =   2340
   End
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
            Picture         =   "fMainPreguntas.frx":038A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMainPreguntas.frx":1064
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMainPreguntas.frx":1D3E
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

' SysTray
Private WithEvents m_fSysTray As fSysTray
Attribute m_fSysTray.VB_VarHelpID = -1

Private m_logFile As String

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

Private Sub tmReadPage_Timer()
  On Error Resume Next
  tmReadPage.Enabled = False
  pCheckPreguntas
  Err.Clear
End Sub

Private Sub tmRefresh_Timer()
  On Error Resume Next
  tmRefresh.Interval = 60000 ' 1 minuto
  Navigate
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
  
  m_logFile = pGetPath(App.Path) & "Log\CSWBPreguntas.log"
  
  LoadSysTray

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

Private Sub wb_NavigateComplete2(ByVal pDisp As Object, URL As Variant)
  On Error Resume Next
  
  ' Siempre apago el timer de refresh
  '
  tmRefresh.Enabled = False
  txAddress.Text = URL
  
  If txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES" Then
    
    ' Prendo el timer de lectura
    '
    tmReadPage.Interval = 5000
    tmReadPage.Enabled = True
    
    ' La funcion pCheckPreguntas invocada por el timer de lectura
    ' se encarga de prender el timer de refresh
    '
    
  End If
  
  Err.Clear
End Sub

Private Sub pCheckPreguntas()
  On Error Resume Next
  
  Dim formObj As Object
  Dim body As String
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = wb.Document.Forms("pend_ques")
   
  body = formObj.innerHTML
  
  pSaveLog body
   
  m_fSysTray.ShowBalloonTip _
     "Tiene preguntas por contestar.", _
     "Pregunta de XXX", _
     NIIF_INFO

  tmRefresh.Interval = 30000 ' 30 segundos
  tmRefresh.Enabled = True

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

'/////////////////////////////////////////////////////////////
' SysTray

Private Sub LoadSysTray()
    Set m_fSysTray = New fSysTray
    With m_fSysTray
        .AddMenuItem "&Open SysTray Sample", "open", True
        .AddMenuItem "-"
        .AddMenuItem "&Close", "close"
        .ToolTip = "SysTray Sample!"
        .IconHandle = Me.Icon.Handle
    End With
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Me.Hide
    Cancel = True
  Else
    Unload m_fSysTray
    Set m_fSysTray = Nothing
  End If
End Sub

Private Sub m_fSysTray_MenuClick(ByVal lIndex As Long, ByVal sKey As String)
    Select Case sKey
    Case "open"
        Me.Show
        Me.ZOrder
    Case "close"
        Unload Me
    End Select
    
End Sub

Private Sub m_fSysTray_SysTrayDoubleClick(ByVal eButton As MouseButtonConstants)
    Me.Show
    Me.ZOrder
End Sub

Private Sub m_fSysTray_SysTrayMouseDown(ByVal eButton As MouseButtonConstants)
    If (eButton = vbRightButton) Then
        m_fSysTray.ShowMenu
    End If
End Sub

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & msg
  Close f
    
End Sub

Private Function pGetPath(ByVal Path As String) As String
  If Right(Path, 1) <> "\" Then Path = Path & "\"
  pGetPath = Path
End Function

