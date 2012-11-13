VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "ieframe.dll"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fMain 
   BackColor       =   &H80000015&
   Caption         =   "QBPoint Browser"
   ClientHeight    =   5100
   ClientLeft      =   120
   ClientTop       =   420
   ClientWidth     =   8745
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5100
   ScaleWidth      =   8745
   Begin VB.Timer tmService 
      Interval        =   3000
      Left            =   4320
      Top             =   3540
   End
   Begin MSComctlLib.ImageList ilIcon 
      Left            =   2580
      Top             =   3780
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   5
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":038A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":0724
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":0ABE
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":0E58
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":11F2
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
      Location        =   ""
   End
   Begin MSComctlLib.ListView lvLog 
      Height          =   1875
      Left            =   6780
      TabIndex        =   5
      Top             =   1140
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3307
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
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
      TabIndex        =   2
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
      Begin VB.PictureBox picAddress 
         BorderStyle     =   0  'None
         Height          =   375
         Left            =   1020
         ScaleHeight     =   375
         ScaleWidth      =   4935
         TabIndex        =   3
         Top             =   60
         Width           =   4935
         Begin VB.TextBox txAddress 
            BorderStyle     =   0  'None
            Height          =   315
            Left            =   0
            TabIndex        =   4
            Text            =   "http://mail.yahoo.com"
            Top             =   0
            Width           =   3795
         End
         Begin VB.Shape shAddress 
            BorderColor     =   &H000080FF&
            Height          =   255
            Left            =   0
            Top             =   0
            Width           =   795
         End
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
            Picture         =   "fMain.frx":158C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2266
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2F40
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvInfo 
      Height          =   1875
      Left            =   5220
      TabIndex        =   6
      Top             =   1140
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3307
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'login=1;us_id=1;emp_id=1;strConnect=Provider=SQLOLEDB.1|Integrated Security=SSPI|Persist Security Info=False|Initial Catalog=cairo|Data Source=DAIMAKU
'login=1;us_id=1;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=192.168.1.1|UID=sa|PWD=CairoOlaen2007Olaen|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairoOlaen"

'TODOENCARTUCHOS
'INGRTIPZ

Private Const c_button_cancel = "cancel"
Private Const c_button_home = "home"
Private Const c_button_reload = "reload"

Private m_bInPreguntas As Boolean
Private m_bInMercadoPago As Boolean
Private m_bInVentas As Boolean
Private m_bInArticulos As Boolean

'Private Const c_home_url = "http://www.mercadolibre.com.ar"
Private Const c_home_url = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES"

Private m_url_calif As String

Private m_mlp As cMercadoLibrePregunta
Private m_mlc As cMercadoLibreCalificacion
Private m_mla As cMercadoLibreArticulo
Private m_mlv As cMercadoLibreVentas
Private m_mmp As cMercadoLibreMercadoPago

Private m_nick As String

Public Property Get bInPreguntas() As Boolean
  bInPreguntas = m_bInPreguntas
End Property

Public Property Get bInMercadoPago() As Boolean
  bInMercadoPago = m_bInMercadoPago
End Property

Public Property Get bInVentas() As Boolean
  bInVentas = m_bInVentas
End Property

Public Property Get bInArticulos() As Boolean
  bInArticulos = m_bInArticulos
End Property

'
'  El codigo del formulario debe tener solo funciones comunes a todas la paginas
'  y codigo de reconocimiento de tipo de pagina. El codigo especifico de preguntas y
'  respuestas debe estar en una clase y ser invocado por el codigo del form
'  al detectar eventos que deben ser manejados por alguna de las dos clases (preguntas
'  calificaciones). Esto es extensible a todas las comunidades. Por lo tanto debera
'  haber un codigo preguntas y uno calificaciones para cada comunidad en una clase.
'  Ejemplo cMercadoLibrePregunta, cMercadoLibreCalificacion, cMasOportunidadesPregunta,
'  cMasOportunidadesCalificacion.
'
'  Toda la funcionalidad referente a detectar el tipo de pagina en el que se esta navegando
'  debe estar en una unica funcion:
'
'  pCallManager
'
'  Esta se encarga de analizar la pagina y la direccion URL para detectar a
'  que navegador se debe invocar si es que hay que invocar alguno.
'
Public Sub CallManager(ByVal inBeforeNavigate As Boolean, ByVal inDeactivate As Boolean)
  
  tmService.Enabled = False
  m_bInPreguntas = False
  m_bInMercadoPago = False
  m_bInPreguntas = False
  m_bInVentas = False

  ' Before navigate
  '
  If inBeforeNavigate Then
  
    ' Si es una pagina de preguntas de MercadoLibre
    '
    If txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES" Then
      m_bInPreguntas = True
      m_mlp.BeforeNavigate
    Else
      
      If Not inDeactivate Then
        
        ' Si es una pagina de calificaciones
        '
        If Left$(txAddress.Text, 75) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow&subAct=calif&as_choose" Then
          m_mlc.BeforeNavigate
        ElseIf Left$(txAddress.Text, 52) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow" Then
          m_mlc.BeforeNavigate
        ElseIf txAddress.Text = "http://www.mercadolibre.com.ar/jm/calif" Then
          m_mlc.BeforeNavigate
        End If
      
      End If
      
    End If
  
  ' Navigate
  '
  Else
  
    ' Si es una pagina de preguntas de MercadoLibre
    '
    If txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES" Then
      m_bInPreguntas = True
      m_mlp.ReadPage
    Else
      If Not inDeactivate Then
        
        ' Si es una pagina de calificaciones
        '
        If Left$(txAddress.Text, 75) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow&subAct=calif&as_choose" Then
          m_mlc.ReadPage
        ElseIf Left$(txAddress.Text, 52) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow" Then
          m_mlc.ReadPage
        ElseIf txAddress.Text = "http://www.mercadolibre.com.ar/jm/calif" Then
          m_mlc.BeforeNavigate
        
        ' Si es una pagina de articulos activos
        '
        ElseIf txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS" Then
          m_mla.ReadPage
          m_bInArticulos = True
        ElseIf Left$(txAddress.Text, 58) = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS" Then
          m_mla.ReadPage
          m_bInArticulos = True

        ' Si es una pagina de articulos vendidos
        '
        ElseIf txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS" Then
          m_mlv.ReadPage
          m_bInVentas = True
        ElseIf Left$(txAddress.Text, 58) = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS" Then
          m_mlv.ReadPage
          m_bInVentas = True
        
        ' Si es una pagina de mercado pago
        '
        ElseIf txAddress.Text = "https://www.mercadopago.com/mla/collections" Then
          m_mmp.ReadPage
          m_bInMercadoPago = True
        ElseIf txAddress.Text = "https://www.mercadopago.com/mla/collections?opGp=C_DFLT" Then
          m_mmp.ReadPage
          m_bInMercadoPago = True
          
        End If
      End If
    End If
  End If
  
  If Not inBeforeNavigate Then
    pPutPassword
  Else
    pGetUser
  End If
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  tmRefresh.Enabled = False
  Err.Clear
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, "fMain"
End Sub

Private Sub lvInfo_DblClick()
  On Error Resume Next
  
  'ShowInfoPregunta "", "", "74520017", 1
  
  ShowInfoPregunta lvInfo.SelectedItem.Text, _
                   lvInfo.SelectedItem.SubItems(2), _
                   lvInfo.SelectedItem.SubItems(3), _
                   Val(lvInfo.SelectedItem.SubItems(4))
  
  Err.Clear
End Sub

Private Sub tmReadPage_Timer()
  On Error Resume Next
  tmReadPage.Enabled = False
  CallManager False, False
  Err.Clear
End Sub

Private Sub tmRefresh_Timer()
  On Error Resume Next
  tmRefresh.interval = 60000
  Navigate
  Err.Clear
End Sub

Private Sub tmService_Timer()
  On Error Resume Next
  tmService.Enabled = False
  Navigate
  tmService.Enabled = True
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
  
  ShowHtmlInfo "Esperando a que se cargue la pagina ..."
  
  CallManager True, False
        
  ShowLog "Abriendo", txAddress.Text '--lng
  Err.Clear
End Sub

Private Sub Navigate()
  On Error Resume Next
  wb.Navigate txAddress.Text
  Err.Clear
End Sub

Private Sub wb_NavigateComplete2(ByVal pDisp As Object, URL As Variant)
  On Error Resume Next
  
  ShowHtmlInfo "Pagina cargada"
  
  ' Siempre apago el timer de refresh
  '
  tmRefresh.Enabled = False
  txAddress.Text = URL
  
  ShowLog "Pagina Ok", URL '--lng
  
  ' Prendo el timer de lectura
  '
  tmReadPage.interval = 5000
  tmReadPage.Enabled = True
  
  ' La funcion pCheckPreguntas invocada por el timer de lectura
  ' se encarga de prender el timer de refresh
  '
  
  Err.Clear
End Sub

Private Sub wb_NavigateError(ByVal pDisp As Object, URL As Variant, Frame As Variant, StatusCode As Variant, Cancel As Boolean)
  On Error Resume Next
  
  ShowHtmlInfo "Error al leer la pagina"
  
  Cancel = True
End Sub

Private Sub wb_NewWindow2(ppDisp As Object, Cancel As Boolean)
  '
  ' Codigo especial para navegar pagina de calificaciones
  ' en MercadoLibre
  '
  If m_url_calif <> "" Then
    txAddress.Text = m_url_calif
    Navigate
    Cancel = True
  End If
  
End Sub

Private Sub wb_StatusTextChange(ByVal Text As String)
  '
  ' Codigo especial para detectar pagina de calificaciones
  ' en MercadoLibre
  '
  If InStr(1, Text, "calif") Then
    m_url_calif = Text
  Else
    m_url_calif = ""
  End If
  
  '
  ' Codigo generico
  '
  sbMain.Panels.Item(1).Text = Text
End Sub

Private Sub Form_Load()
  On Error Resume Next
    
  Set m_mlp = New cMercadoLibrePregunta
  Set m_mlc = New cMercadoLibreCalificacion
  Set m_mla = New cMercadoLibreArticulo
  Set m_mlv = New cMercadoLibreVentas
  Set m_mmp = New cMercadoLibreMercadoPago

  tbMain.Style = tbrFlat
  tbMain.ImageList = ilToolbar
  tbMain.Buttons.Add , c_button_reload, , , 3
  tbMain.Buttons.Add , c_button_cancel, , , 2
  
  With tbMain.Buttons.Add(, c_button_home, , , 1)
    picAddress.Left = .Left + .Width + 100
    picAddress.Top = 100
  End With
  
  shAddress.Move 0, 0, picAddress.Width - 40, picAddress.Height - 20
  txAddress.Move 10, 10, picAddress.Width - 80, picAddress.Height - 50
  
  txAddress.Text = c_home_url
  
  lvInfo.Top = tbMain.Height
  lvLog.Height = 1500
  
  lvLog.ColumnHeaders.Add , , "Title", 1500 '--lng
  lvLog.ColumnHeaders.Add , , "Info", 2300 '--lng
  lvLog.View = lvwReport
  LV_FlatHeaders Me.hWnd, lvLog.hWnd
  
  lvInfo.ColumnHeaders.Add , , "Nick", 1500 '--lng
  lvInfo.ColumnHeaders.Add , , "Pregunta", 6300 '--lng
  lvInfo.ColumnHeaders.Add , , "PreguntaId", 0 '--lng
  lvInfo.ColumnHeaders.Add , , "ArticuloId", 0 '--lng
  lvInfo.ColumnHeaders.Add , , "ComunidadId", 0 '--lng
  
  lvInfo.View = lvwReport
  LV_FlatHeaders Me.hWnd, lvInfo.hWnd
  
  wb.Width = 12000
  wb.Top = tbMain.Height
  wb.Left = -10
  wb.Silent = True
  
  txAddress.Text = c_home_url
  Navigate
    
  'CSKernelClient2.LoadForm Me, "fMain"
  Me.WindowState = vbMaximized
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  picAddress.Width = Me.ScaleWidth - picAddress.Left - 50
  shAddress.Width = picAddress.Width - 40
  txAddress.Width = picAddress.Width - 80
  lvLog.Width = Me.ScaleWidth - wb.Width
  lvLog.Left = Me.ScaleWidth - lvLog.Width - 10
  lvInfo.Height = Me.ScaleHeight - lvInfo.Top - lvLog.Height - sbMain.Height
  lvLog.Top = lvInfo.Height + lvInfo.Top
  lvInfo.Left = lvLog.Left
  lvInfo.Width = lvLog.Width
  wb.Height = Me.ScaleHeight - wb.Top - sbMain.Height
  Err.Clear
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  
  If Button.Key = c_button_cancel Then
    wb.Stop
  ElseIf Button.Key = c_button_home Then
    txAddress.Text = c_home_url
    Navigate
  ElseIf Button.Key = c_button_reload Then
    Navigate
  End If
  
  Err.Clear
End Sub

Private Sub pPutPassword()
   
  On Error Resume Next
  
  ' Para que no se llame dos veces en el deactivate
  '
  If fLogin.Visible Then Exit Sub
  
  Err.Clear
  
  Dim dummy As String
  
  ' Con esto detecto si estoy en la pagina de login
  '
  dummy = wb.Document.Forms(1).All("password").Value
      
  If Err.Number = 0 Then
    
    fLogin.Show vbModal, fMainMdi
    
    If fLogin.lsLogin.ListIndex >= 0 Then
      m_nick = fLogin.lsLogin.Text
    End If
    
    Unload fLogin
    
    If m_nick <> "" Then
      wb.Document.Forms(1).All("user").Value = m_nick
    End If
      
    wb.Document.Forms(1).All("password").Value = "INGRTIPZ"
    
    pGetUser
    
  End If
    
  Err.Clear
End Sub

Private Sub pGetUser()
   
  On Error Resume Next
  
  Err.Clear
      
  Dim dummy As String
  
  ' Con esto detecto si estoy en la pagina de login
  '
  dummy = wb.Document.Forms(1).All("password").Value
      
  If Err.Number = 0 Then
  
    Dim comunidad As String
    
    If InStr(txAddress.Text, "mercadolibre") Then
      comunidad = "ML"
    End If
    
    If InStr(txAddress.Text, "masoportunidades") Then
      comunidad = "MP"
    End If
    
    dummy = UCase$(wb.Document.Forms(1).All("user").Value)
     
    If Len(dummy) Then
      m_nick = dummy
      gCMIUser = dummy
    End If
    
    Me.Caption = comunidad & "-" & dummy & "-" & gMainCaption
  
  End If
  
  Err.Clear
End Sub
