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
   ScaleHeight     =   5100
   ScaleWidth      =   8745
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmService 
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
      Height          =   390
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   8745
      _ExtentX        =   15425
      _ExtentY        =   688
      ButtonWidth     =   609
      ButtonHeight    =   582
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
         NumListImages   =   4
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
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":3C1A
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

'login=1;us_id=1;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=192.168.1.1|UID=sa|PWD=CairoOlaen2007Olaen|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairoOlaen"
'login=1;us_id=84;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=servercairo|UID=sa|PWD=CairoOlaen2007Olaen|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairoO"
'login=1;us_id=84;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=servercairo|UID=sa|PWD=CairoOlaen2007Olaen|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairoO";autoStart=1;cmiLogin=OFFICEBAIRES;cmiModo=1;nextPage=4
'login=1;us_id=1;emp_id=1;strConnect=Provider=SQLOLEDB.1|Integrated Security=SSPI|Persist Security Info=False|Initial Catalog=cairoOlaen|Data Source=OTOMO\SQLEXPRESS;autoStart=1;cmiLogin=OFFICEBAIRES;cmiModo=1
'login=1;us_id=1;emp_id=1;strConnect=Provider=SQLOLEDB.1|Integrated Security=SSPI|Persist Security Info=False|Initial Catalog=cairo|Data Source=OTOMO\SQLEXPRESS;cmiLogin=OFFICEBAIRES
'login=1;us_id=84;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=servercairo|UID=sa|PWD=CairoOlaen2007Olaen|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairoO";cmiLogin=OFFICEBAIRES
'login=1;us_id=1;emp_id=1;strConnect=Provider=SQLOLEDB.1|Integrated Security=SSPI|Persist Security Info=False|Initial Catalog=cairo|Data Source=OTOMO\SQLEXPRESS;autoStart=1;cmiLogin=OFFICEBAIRES;cmiModo=1;nextPage=4

'TODOENCARTUCHOS
'INGRTIPZ

Private Const c_button_cancel = "cancel"
Private Const c_button_home = "home"
Private Const c_button_reload = "reload"
Private Const c_button_type = "type"

Private Const c_button_ventas = "ventas"
Private Const c_button_mp = "mp"
Private Const c_button_articulos = "articulos"
Private Const c_button_op = "op"

' SysTray
Private WithEvents m_fSysTray As fSysTray
Attribute m_fSysTray.VB_VarHelpID = -1

Private m_bInPreguntas As Boolean
Private m_bInMercadoPago As Boolean
Private m_bInVentas As Boolean
Private m_bInArticulos As Boolean

'Private Const c_home_url = "http://www.mercadolibre.com.ar"
Private Const c_home_url = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES"
Private Const c_logout_url = "http://www.mercadolibre.com.ar/jm/logout"
Private Const c_login_url = "https://www.mercadolibre.com/jms/mla/ml.hercules.log_user_data"

Private m_url_calif As String

Private m_mlp As cMercadoLibrePregunta
Private m_mlc As cMercadoLibreCalificacion
Private m_mla As cMercadoLibreArticulo
Private m_mlv As cMercadoLibreVentas
Private m_mmp As cMercadoLibreMercadoPago

Private m_lastLogin As Date

Private m_nick As String

Private m_modo As E_MODO

Private WithEvents m_body As MSHTML.HTMLBody
Attribute m_body.VB_VarHelpID = -1

Private m_inStarting As Boolean
Private m_inAutoLoginMode As Boolean
Private m_autoLoginWait As Long
Private m_inFirstCallAfterAutoLogin As Boolean

Private m_bNavigateComplete     As Boolean
Private m_bSendingLoginPage     As Boolean
Private m_startedByAutoLogin    As Boolean

Private Const C_MAX_READ_PAGE_BY_LAP = 4

Private m_firstCallToSetPageAfterRelogin As Boolean
Private m_lastReadPage As Long
Private m_readPages As Long
Private m_nextPage As Long
Private m_bFirstReadMP As Boolean

Public Property Let nextPage(ByVal rhs As Long)
  m_nextPage = rhs
End Property

Public Property Let inStarting(ByVal rhs As Boolean)
  m_inStarting = rhs
End Property

Public Property Let inAutoLogiMode(ByVal rhs As Boolean)
  m_inAutoLoginMode = rhs
End Property

Public Property Let startedByAutoLogin(ByVal rhs As Boolean)
  m_startedByAutoLogin = rhs
End Property

Public Property Let nick(ByVal rhs As String)
  m_nick = rhs
End Property

Public Property Get fSysTray() As fSysTray
  Set fSysTray = m_fSysTray
End Property

Public Sub RefreshIcon(ByVal iconIndex, ByVal msg As String)
  Me.Icon = fMain.ilIcon.ListImages(iconIndex).Picture
  m_fSysTray.ToolTip = "CVXI Browser! " & msg
  m_fSysTray.IconHandle = Me.Icon.Handle
End Sub
Public Sub LoginAutomatico(ByVal modo As E_MODO)
  On Error Resume Next
  
  m_modo = modo
  
  Dim ButtonMenu As MSComctlLib.ButtonMenu
  
  If modo = VTA Then
    Set ButtonMenu = tbMain.buttons.Item(c_button_type).ButtonMenus.Item(c_button_ventas)
  ElseIf modo = MP Then
    Set ButtonMenu = tbMain.buttons.Item(c_button_type).ButtonMenus.Item(c_button_mp)
    m_inFirstCallAfterAutoLogin = True
    m_bFirstReadMP = True
  ElseIf modo = ART Then
    Set ButtonMenu = tbMain.buttons.Item(c_button_type).ButtonMenus.Item(c_button_articulos)
  ElseIf modo = OP Then
    Set ButtonMenu = tbMain.buttons.Item(c_button_type).ButtonMenus.Item(c_button_op)
  End If
  
  If Not ButtonMenu Is Nothing Then
  
    If ButtonMenu.Text = "Ventas" Then
      ButtonMenu.Text = "Ventas [x]"
      tbMain.buttons.Item(4).ButtonMenus.Item(2).Text = "MercadoPago"
      tbMain.buttons.Item(4).ButtonMenus.Item(3).Text = "Articulos"
      tbMain.buttons.Item(4).ButtonMenus.Item(4).Text = "Otras Paginas"
      tbMain.buttons.Item(4).Caption = "Modo: VTA"
    ElseIf ButtonMenu.Text = "MercadoPago" Then
      ButtonMenu.Text = "MercadoPago [x]"
      tbMain.buttons.Item(4).ButtonMenus.Item(1).Text = "Ventas"
      tbMain.buttons.Item(4).ButtonMenus.Item(3).Text = "Articulos"
      tbMain.buttons.Item(4).ButtonMenus.Item(4).Text = "Otras Paginas"
      tbMain.buttons.Item(4).Caption = "Modo: MP"
    ElseIf ButtonMenu.Text = "Articulos" Then
      ButtonMenu.Text = "Articulos [x]"
      tbMain.buttons.Item(4).ButtonMenus.Item(2).Text = "MercadoPago"
      tbMain.buttons.Item(4).ButtonMenus.Item(1).Text = "Ventas"
      tbMain.buttons.Item(4).ButtonMenus.Item(4).Text = "Otras Paginas"
      tbMain.buttons.Item(4).Caption = "Modo: ART"
    ElseIf ButtonMenu.Text = "Otras Paginas" Then
      ButtonMenu.Text = "Otras Paginas [x]"
      tbMain.buttons.Item(4).ButtonMenus.Item(3).Text = "Articulos"
      tbMain.buttons.Item(4).ButtonMenus.Item(2).Text = "MercadoPago"
      tbMain.buttons.Item(4).ButtonMenus.Item(1).Text = "Ventas"
      tbMain.buttons.Item(4).Caption = "Modo: OP"
    End If
  
  End If
  
  tmService_Timer
End Sub

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
Private Sub pCallManager(ByVal inBeforeNavigate As Boolean, ByVal inDeactivate As Boolean)
  On Error Resume Next
  
  tmService.Enabled = False
  m_bInPreguntas = False
  m_bInArticulos = False
  m_bInMercadoPago = False
  m_bInVentas = False

  pCallManagerAux inBeforeNavigate, inDeactivate

  ' Si estoy en modo Ventas, MP o Articulos, es decir
  ' no estoy en OP, prendo el timer del servicio
  '
  If m_modo <> OP Then
    tmService.Enabled = True
  End If

End Sub

Private Sub pCallManagerAux(ByVal inBeforeNavigate As Boolean, ByVal inDeactivate As Boolean)
  

  ' Before navigate
  '
  If inBeforeNavigate Then
  
    ' Si es una pagina de preguntas de MercadoLibre
    '
    If Left$(txAddress.Text, 58) = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES" Then
      m_bInPreguntas = True
      m_mlp.BeforeNavigate
    ElseIf Left$(txAddress.Text, 44) = "https://questions.mercadolibre.com.ar/seller" Then
      m_bInPreguntas = True
      m_mlp.BeforeNavigate2
    Else
      
      If Not inDeactivate Then
        
        ' Si es una pagina de calificaciones
        '
        If Left$(txAddress.Text, 75) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow&subAct=calif&as_choose" Then
          m_mlc.BeforeNavigate
        ElseIf Left$(txAddress.Text, 52) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow" Then
          m_mlc.BeforeNavigate
        ElseIf Left$(txAddress.Text, 39) = "http://www.mercadolibre.com.ar/jm/calif" Then
          m_mlc.BeforeNavigate
        
        Else
          ' Esto sirve para mercado pago y ventas cuando estan automaticas
          '
          pCheckLoginPage
        End If
      
      End If
      
    End If
  
  ' Navigate
  '
  Else
    
    ' Si es una pagina de preguntas de MercadoLibre
    '
    If Left$(txAddress.Text, 58) = "http://www.mercadolibre.com.ar/jm/myML?as_section=PEN_QUES" Then
      m_bInPreguntas = True
      m_mlp.ReadPage
    ElseIf Left$(txAddress.Text, 44) = "https://questions.mercadolibre.com.ar/seller" Then
      m_bInPreguntas = True
      m_mlp.ReadPageV2
      pSetBodyObject
    Else
      If Not inDeactivate Then
        
        ' Si es una pagina de calificaciones
        '
        If Left$(txAddress.Text, 75) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow&subAct=calif&as_choose" Then
          m_mlc.ReadPage
        ElseIf Left$(txAddress.Text, 52) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow" Then
          m_mlc.ReadPage
        ElseIf Left$(txAddress.Text, 39) = "http://www.mercadolibre.com.ar/jm/calif" Then
          m_mlc.BeforeNavigate
        
        ' Si es una pagina de articulos activos
        '
        ElseIf Left$(txAddress.Text, 58) = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS" Then
          m_mla.ReadPage
          m_bInArticulos = True

        ElseIf Left$(txAddress.Text, 59) = "http://myaccount.mercadolibre.com.ar/listings/#label=active" Then
          m_mla.ReadPage
          m_bInArticulos = True

        ' Si es una pagina de articulos vendidos
        '
        ElseIf Left$(txAddress.Text, 58) = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS" Then
                
          m_mlv.ReadPage
          m_bInVentas = True
        
        ' Si es una pagina de mercado pago
        '
        ElseIf Left$(txAddress.Text, 43) = "https://www.mercadopago.com/mla/collections" Then
          m_mmp.ReadPage
          m_bInMercadoPago = True
        ElseIf Left$(txAddress.Text, 55) = "https://www.mercadopago.com/mla/collections?opGp=C_DFLT" Then
          m_mmp.ReadPage
          m_bInMercadoPago = True
          
        Else
          ' Esto sirve para mercado pago y ventas cuando estan automaticas
          '
          pCheckLoginPage
        End If
      End If
    End If
  End If
  
  If Not inBeforeNavigate Then
    pPutPassword
  Else
    pGetUser True
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

Private Sub m_body_onmousedown()
  If Left$(txAddress.Text, 44) = "https://questions.mercadolibre.com.ar/seller" Then
    m_mlp.BeforeNavigate2
  End If
End Sub

Private Sub tbMain_ButtonMenuClick(ByVal ButtonMenu As MSComctlLib.ButtonMenu)
  On Error Resume Next
  
  ' Contadores para ventas y mercadopago
  '
  m_readPages = 0
  m_lastReadPage = 0
  m_bFirstReadMP = False
  
  If ButtonMenu.Text = "Ventas" Then
    ButtonMenu.Text = "Ventas [x]"
    tbMain.buttons.Item(4).ButtonMenus.Item(2).Text = "MercadoPago"
    tbMain.buttons.Item(4).ButtonMenus.Item(3).Text = "Articulos"
    tbMain.buttons.Item(4).ButtonMenus.Item(4).Text = "Otras Paginas"
    tbMain.buttons.Item(4).Caption = "Modo: VTA"
    m_modo = VTA
    txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS"
    Navigate
  ElseIf ButtonMenu.Text = "MercadoPago" Then
    ButtonMenu.Text = "MercadoPago [x]"
    tbMain.buttons.Item(4).ButtonMenus.Item(1).Text = "Ventas"
    tbMain.buttons.Item(4).ButtonMenus.Item(3).Text = "Articulos"
    tbMain.buttons.Item(4).ButtonMenus.Item(4).Text = "Otras Paginas"
    tbMain.buttons.Item(4).Caption = "Modo: MP"
    m_modo = MP
    m_bFirstReadMP = True
    txAddress.Text = "https://www.mercadopago.com/mla/collections?opGp=C_DFLT"
    Navigate
  ElseIf ButtonMenu.Text = "Articulos" Then
    ButtonMenu.Text = "Articulos [x]"
    tbMain.buttons.Item(4).ButtonMenus.Item(2).Text = "MercadoPago"
    tbMain.buttons.Item(4).ButtonMenus.Item(1).Text = "Ventas"
    tbMain.buttons.Item(4).ButtonMenus.Item(4).Text = "Otras Paginas"
    tbMain.buttons.Item(4).Caption = "Modo: ART"
    m_modo = ART
    txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS"
    Navigate
  ElseIf ButtonMenu.Text = "Otras Paginas" Then
    ButtonMenu.Text = "Otras Paginas [x]"
    tbMain.buttons.Item(4).ButtonMenus.Item(3).Text = "Articulos"
    tbMain.buttons.Item(4).ButtonMenus.Item(2).Text = "MercadoPago"
    tbMain.buttons.Item(4).ButtonMenus.Item(1).Text = "Ventas"
    tbMain.buttons.Item(4).Caption = "Modo: OP"
    m_modo = OP
  End If
End Sub

Private Sub tmReadPage_Timer()
  On Error Resume Next
  
  If m_inStarting Then Exit Sub
  
  ' Para evitar el primer login
  '
  If m_inAutoLoginMode Then
    m_inAutoLoginMode = False
    '
    ' Me obligo a esperar 5 eventos de timer antes de leer la pagina
    ' para darle tiempo al explorer a leer la pagina que me pasaron
    ' en el login, por que sino le damos tiempo, queda la pagina
    ' de login de mercadolibre activa y se hace el show de flogin
    ' y como no hay usuario para contestar esta ventana, el programa
    ' queda pausado
    '
    m_autoLoginWait = 5
    Exit Sub
  End If
  
  ' Si entre por autologin tengo
  ' que entrar 5 veces al timer para que
  ' se lea la pagina
  '
  If m_autoLoginWait > 0 Then
    m_autoLoginWait = m_autoLoginWait - 1
    Exit Sub
  End If
  
  tmReadPage.Enabled = False
  pCallManager False, False
  Err.Clear
End Sub

' OJO: solo se usa en preguntas
'      el timer que refrezca las paginas de ventas y mercadopago es tmService
'      lo hace en el else del if que hay en el evento Timer
'
Private Sub tmRefresh_Timer()
  On Error Resume Next
  tmRefresh.interval = 60000
  Navigate
  Err.Clear
End Sub

Private Sub tmService_Timer()
  On Error Resume Next
  
  If DateDiff("n", m_lastLogin, Now) > 5 Then
  
    ' Si estoy arrancando tengo que llamarme a mi mismo
    '
    If Not m_inStarting Then
  
      Dim strCommandLine As String
      Dim strLogin As String
      Dim strEmpId As String
      Dim strUsId As String
      Dim strAutoStart As String
      Dim strCmiLogin As String
      Dim strCmiModo As String
      Dim strNextPage As String
      
      'login=1
      ';us_id=1
      ';emp_id=1
      ';strConnect=Provider=SQLOLEDB.1|Integrated Security=SSPI|Persist Security Info=False|Initial Catalog=cairoOlaen|Data Source=DAIMAKU\SQLEXPRESS
      ';autoStart=0
      ';cmiLogin=OFFICEBAIRES
      ';cmiModo=1
      
      strLogin = "login=1;"
      strEmpId = "emp_id=" & emp_id & ";"
      strUsId = "us_id=" & us_id & ";"
      strConnect = "strconnect=" & Replace(strConnect, ";", "|") & ";"
      strAutoStart = "autoStart=1;"
      strCmiLogin = "cmiLogin=" & gCMIUser & ";"
      strCmiModo = "cmiModo=" & m_modo & ";"
      strNextPage = "nextPage=" & (m_lastReadPage + 1)
      
      strCommandLine = fileGetPath(App.Path) & App.EXEName & " " _
                             & strLogin _
                             & strEmpId _
                             & strUsId _
                             & strConnect _
                             & strAutoStart _
                             & strCmiLogin _
                             & strCmiModo _
                             & strNextPage
  
      Shell strCommandLine
  
      Unload fInfo
      Unload Me
      
      Set gDb = Nothing
  
      End
      
    Else
    
      tmService.Enabled = False
      If pRelogin Then
        m_lastLogin = Now
      End If
      tmService.Enabled = True
      
    End If
    
  Else
  
    If m_modo <> OP Then
  
      tmService.Enabled = False
  
      If m_modo = VTA Then
        pSetPageVenta
        Navigate
        
        ' Esto sirve para mercado pago y ventas cuando estan automaticas
        '
        pCheckLoginPage
        
      ElseIf m_modo = MP Then
        pSetPageMercadoPago
        
        '
        ' Mercado Pago no ejecuta Navigate
        ' pues utiliza el submit del form
        ' salvo que estemos en la primera
        ' llamada despues de un autologin
        '
        If m_inFirstCallAfterAutoLogin Then
          m_inFirstCallAfterAutoLogin = False
          Navigate
        End If
      
        ' Esto sirve para mercado pago y ventas cuando estan automaticas
        '
        pCheckLoginPage
      
      ElseIf m_modo = ART Then
        pSetPageArticulo
        Navigate
        
      Else
        Navigate
        
      End If
      
      tmService.Enabled = True
    
    End If
    
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

  ShowHtmlInfo "Esperando a que se cargue la pagina ..."

  pCallManager True, False

  ShowLog "Abriendo", txAddress.Text '--lng
  Err.Clear
End Sub

Private Sub Navigate()
  On Error Resume Next
  m_bNavigateComplete = False
  wb.Navigate pGetDummyParam(txAddress.Text)
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

  m_bNavigateComplete = True

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
    
  LoadSysTray

  tbMain.Style = tbrFlat
  tbMain.ImageList = ilToolbar
  tbMain.buttons.Add , c_button_reload, "Refrezcar", , 3
  tbMain.buttons.Add , c_button_cancel, "Cancelar", , 2
  tbMain.buttons.Add , c_button_home, "Home", , 1
  
  With tbMain.buttons.Add(, c_button_type, "Modo: OP", 5, 4)
    .ButtonMenus.Add , c_button_ventas, "Ventas"
    .ButtonMenus.Add , c_button_mp, "MercadoPago"
    .ButtonMenus.Add , c_button_articulos, "Articulos"
    .ButtonMenus.Add , c_button_op, "Otras Paginas [x]"
    picAddress.Left = .Left + .Width + 100
    picAddress.Top = 100
  End With
  
  m_modo = OP
  
  m_firstCallToSetPageAfterRelogin = True
  
  shAddress.Move 0, 0, picAddress.Width - 40, picAddress.Height - 20
  txAddress.Move 10, 10, picAddress.Width - 80, picAddress.Height - 50
    
  lvInfo.Top = tbMain.Height
  lvLog.Height = 1500
  
  lvLog.ColumnHeaders.Add , , "Title", 1500 '--lng
  lvLog.ColumnHeaders.Add , , "Info", 2300 '--lng
  lvLog.view = lvwReport
  LV_FlatHeaders Me.hWnd, lvLog.hWnd
  
  lvInfo.ColumnHeaders.Add , , "Nick", 1500 '--lng
  lvInfo.ColumnHeaders.Add , , "Pregunta", 6300 '--lng
  lvInfo.ColumnHeaders.Add , , "PreguntaId", 0 '--lng
  lvInfo.ColumnHeaders.Add , , "ArticuloId", 0 '--lng
  lvInfo.ColumnHeaders.Add , , "ComunidadId", 0 '--lng
  
  lvInfo.view = lvwReport
  LV_FlatHeaders Me.hWnd, lvInfo.hWnd
  
  wb.Width = 15000
  wb.Top = tbMain.Height
  wb.Left = -10
  wb.Silent = True
  
  txAddress.Text = c_home_url
  Navigate
    
  CSKernelClient2.LoadForm Me, "fMain"
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  picAddress.Width = Me.ScaleWidth - picAddress.Left - 50
  shAddress.Width = picAddress.Width - 40
  txAddress.Width = picAddress.Width - 80
  lvLog.Width = Me.ScaleWidth - wb.Width
  lvLog.Left = Me.ScaleWidth - lvLog.Width - 10
  'lvInfo.Height = Me.ScaleHeight - lvInfo.Top - lvLog.Height - sbMain.Height
  lvLog.Top = Me.ScaleHeight - lvLog.Height - sbMain.Height ' lvInfo.Height + lvInfo.Top
  lvInfo.Left = lvLog.Left
  lvInfo.Width = lvLog.Width
  wb.Height = Me.ScaleHeight - wb.Top - sbMain.Height
  Err.Clear
  fInfo.SetPositionForm
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

'/////////////////////////////////////////////////////////////
' SysTray

Private Sub LoadSysTray()
    Set m_fSysTray = New fSysTray
    With m_fSysTray
        .AddMenuItem "&Abrir CVXI Browser", "open", True '--lng
        .AddMenuItem "-"
        .AddMenuItem "&Cerrar", "close" '--lng
        .AddMenuItem "&Cerrar y Terminar Programa", "superclose" '--lng
        .ToolTip = "CVXI Browser!"
        .IconHandle = Me.Icon.Handle
    End With
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  
  '
  ' Cuando la aplicacion detecta que se esta navegando la pagina de preguntas
  ' Al cerrar la ventana la aplicacion se oculta (Hide = True), Igual que cuando
  ' se minimiza la aplicacion, y se iconiza en el SysTray.
  ' Cuando la aplicacion no esta navegando la pagina de preguntas debe cerrarse
  ' (terminar el proceso) cuando se cierra la ventana.
  '
  If m_bInPreguntas Or m_bInArticulos Or m_bInMercadoPago Or m_bInVentas Then
  
    If UnloadMode = vbFormControlMenu Then
      pCallManager False, False
      Me.Hide
      fInfo.Hide
      Cancel = True
    Else
      Unload m_fSysTray
      Set m_fSysTray = Nothing
    End If
  
  Else
    Unload m_fSysTray
    Set m_fSysTray = Nothing
  End If
End Sub

Private Sub m_fSysTray_MenuClick(ByVal lIndex As Long, ByVal sKey As String)
    Select Case sKey
    Case "open" '--lng
        Me.Show
        Me.ZOrder
        fInfo.Show
    Case "close" '--lng
        Unload Me
    Case "superclose"
        End
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

Private Sub pPutPassword()
   
  On Error Resume Next

  Dim dummy As String

  ' Para que no se llame dos veces en el deactivate
  '
  If fLogin.Visible Then Exit Sub
  
  If (m_modo = ART Or m_modo = MP Or m_modo = VTA) And LenB(m_nick) > 0 Then
  
    ' este flag evita que me llamen
    ' por un evento de timer en medio de un
    ' envio del form
    '
    If m_bSendingLoginPage Then Exit Sub
  
    Err.Clear
    
    ' Con esto detecto si estoy en la pagina de login
    '
    dummy = wb.Document.Forms(0).All("password").Value
        
    If Err.Number = 0 Then
      
      wb.Document.Forms(0).All("user_id").Value = m_nick
      wb.Document.Forms(0).All("password").Value = gCMIPwd
      
      pGetUser False
      
      pSubmitFormLogin wb.Document.Forms(0)
      
    End If
  
  Else
  
    Err.Clear
    
    ' Con esto detecto si estoy en la pagina de login
    '
    dummy = wb.Document.Forms(0).All("password").Value
        
    If Err.Number = 0 Then
      
      fLogin.Show vbModal, Me
      
      If fLogin.lsLogin.ListIndex >= 0 Then
        m_nick = fLogin.lsLogin.Text
      End If
      
      Unload fLogin
      
      If m_nick <> "" Then
        wb.Document.Forms(0).All("user_id").Value = m_nick
      End If
        
      wb.Document.Forms(0).All("password").Value = gCMIPwd
      
      pGetUser False
      
    End If
    
  End If
    
  Err.Clear
End Sub

Private Sub pGetUser(ByVal inBeforeNavigate As Boolean)
   
  On Error Resume Next
  
  Err.Clear
      
  Dim dummy As String
  
  ' Con esto detecto si estoy en la pagina de login
  '
  dummy = wb.Document.Forms(0).All("password").Value
      
  If Err.Number = 0 Then
  
    If inBeforeNavigate Then
      If LenB(dummy) Then
        m_lastLogin = Now
      End If
    End If
    
    Dim comunidad As String
    
    If InStr(txAddress.Text, "mercadolibre") Then
      comunidad = "ML"
    End If
    
    If InStr(txAddress.Text, "masoportunidades") Then
      comunidad = "MP"
    End If
    
    dummy = UCase$(wb.Document.Forms(0).All("user_id").Value)
     
    If Len(dummy) Then
      m_nick = dummy
      gCMIUser = dummy
    End If
    
    Me.Caption = comunidad & "-" & dummy & "-" & gMainCaption
  
  End If
  
  Err.Clear
End Sub

Private Function pRelogin() As Boolean
  On Error Resume Next
  
  Dim i As Integer
  
  fInfo.NavigateComplete = False
  fInfo.wb.Navigate2 c_logout_url
  
  Dim start As Date
  start = Now
  Do
    DoEvents
    If fInfo.NavigateComplete Then
      Sleep 0.3
      Exit Do
    End If
    Sleep 0.3
  
    If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
      Exit Function
    End If
  
  Loop
  
  For i = 1 To 100
    DoEvents
    Sleep 30
  Next
  
  fInfo.NavigateComplete = False
  fInfo.wb.Navigate2 "https://www.mercadolibre.com/jms/mla/secureLogin?goNAP=%2Fjm%2FmyML%3Ffl%3DY&NAPHiddenfl=Y&showMenuNAP=Y&showFooterNAP=Y&isRelogin=N"
  
  start = Now
  Do
    DoEvents
    If fInfo.NavigateComplete Then
      Sleep 0.3
      Exit Do
    End If
    Sleep 0.3
    
    If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
      Exit Function
    End If
  Loop
  
  For i = 1 To 100
    DoEvents
    Sleep 30
  Next
  
  On Error Resume Next
    
  Dim dummy As String
  
  ' Con esto detecto si estoy en la pagina de login
  '
  dummy = fInfo.wb.Document.Forms(0).All("password").Value
      
  If Err.Number = 0 Then
    
    fInfo.NavigateComplete = False
    fInfo.wb.Document.Forms(0).All("user_id").Value = m_nick
    fInfo.wb.Document.Forms(0).All("password").Value = gCMIPwd
    
    fInfo.wb.Document.Forms(0).submit
    
    start = Now
    Do
      DoEvents
      If fInfo.NavigateComplete Then
        Sleep 0.3
        Exit Do
      End If
      Sleep 0.3
      
      If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
        Exit Function
      End If
    Loop
    
  End If
    
  For i = 1 To 100
    DoEvents
    Sleep 30
  Next
    
  Err.Clear
  
  pRelogin = True
  
End Function

Private Function pGetDummyParam(ByVal URL As String) As String
  Dim i As Long
  i = InStr(1, URL, "&dummy=")
  
  If i > 0 Then
    URL = Mid$(URL, 1, i - 1) & Mid$(URL, i + 13)
  End If
  pGetDummyParam = URL & "&dummy=" & Format(Timer, "000000")
End Function

'-----------------------------------------------------------------------
'-----------------------------------------------------------------------
Private Sub pSetPageVenta()
  On Error Resume Next
  
  Dim numberPage As Integer
  Dim URL As String
  Dim lastPage As Integer
  Dim i As Long
  Dim inVentas As Boolean
  Dim inVentasSinPage As Boolean
  
  ' Solo recorro automaticamente las paginas de ventas si esta en modo VENTAS
  '
  If m_modo <> VTA Then Exit Sub
  
  ' Si hay errores no hacemos nada
  '
  Err.Clear
  
  ' Si estamos en la pagina de ventas
  '
  If Mid$(txAddress.Text, 1, 64) = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS&page=" Then
    
    inVentas = True
    inVentasSinPage = False
    
  ' Si esta en la primera pagina, no hay parametro page en la pagina
  '
  ElseIf Mid$(txAddress.Text, 1, 65) = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS&dummy=" Then
  
    inVentas = True
    inVentasSinPage = True
  
  ' Si estoy en modo VTA y la pagina no es de ventas, lo redirecciono
  '
  ElseIf m_modo = VTA Then
    
    inVentas = True
    inVentasSinPage = True
    
    txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS"
  
  End If
  
  
  If inVentas Then
  
    ' Obtenemos la ultima pagina en ventas
    '
    lastPage = pGetLastPageVenta()
    
    ' Si no pudimos obtener la ultima pagina no hacemos nada
    '
    If lastPage = 0 Then Exit Sub
    
    If Not inVentasSinPage Then
    
      ' posicion del parametro page
      '
      i = InStr(64, txAddress.Text, "&")

      ' Cuando el sistema reinicia, lee la primera pagina y luego
      ' entra en esta funcion para determinar cual es la siguiente
      ' pagina a leer.
      '
      ' en nextPage tenemos la proxima pagina a leer
      '
      If m_nextPage > 0 And m_nextPage <= lastPage Then
      
        numberPage = m_nextPage - 1
        m_nextPage = 0

      ' Cada vez que m_readPages es igual a C_MAX_READ_PAGE_BY_LAP
      ' volvemos a leer la pagina 1.
      '
      ' Esto es para no dejar pasar mas de x tiempo sin leer nuevas
      ' ventas
      '
      ' Hacer este salto en la secuencia nos obliga a chequear si
      ' debemos continuar desde una lectura anterior a la ultima
      ' pagina leida, ya que esta pagina puede ser la 1 por que
      ' se llego a C_MAX_READ_PAGE_BY_LAP
      '
      ElseIf m_lastReadPage > 0 Then
      
        numberPage = m_lastReadPage
        m_lastReadPage = 0
      
      Else
        ' Obtenemos la pagina que ya leimos
        '
        numberPage = Val(Mid$(txAddress.Text, 65, i - 65))
      End If
      
      ' Si no pudimos obtener la pagina no hacemos nada
      '
      If numberPage = 0 Then Exit Sub
      
      If m_readPages > C_MAX_READ_PAGE_BY_LAP Then
        
        m_readPages = 0
        m_lastReadPage = numberPage
        numberPage = 1
      
      Else
      
        numberPage = numberPage + 1
        
        ' Si ya leimos la ultima, empesamos otra vez por la primera
        ' (cuando estamos en la ultima pagina pGetLastPage devuelve -1
        '  para no complicarme demasiado con el parseo del html)
        '
        If numberPage > lastPage Or lastPage = -1 Then
          numberPage = 1
        End If
      
      End If
    
      ' Modificamos la pagina
      '
      URL = Mid$(txAddress.Text, 1, 64) & numberPage & Mid$(txAddress.Text, i)
    
    Else
    
      ' after relogin la primera pagina a leer es la 1
      '
      If m_firstCallToSetPageAfterRelogin And m_startedByAutoLogin Then
        numberPage = 1
      Else
        numberPage = 2
      End If
      
      m_firstCallToSetPageAfterRelogin = False
      
      ' Modificamos la pagina
      '
      URL = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS&page=" & numberPage & Mid$(txAddress.Text, 59)
      
    End If
  
  End If
  
  ' Solo si no hubo errores navegamos la url modificada
  '
  If Err.Number = 0 And LenB(URL) > 0 Then
    m_readPages = m_readPages + 1
    txAddress.Text = URL
  End If
  
  pSetFormPosition
End Sub

Private Function pGetLastPageVenta() As Integer
  Dim lastPage As Integer
  Dim formObj As Object
  Dim body As String
  Dim bUpdated As Boolean
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i As Long
  Dim j As Long
  
  i = InStr(body, "Ver p")
  j = InStr(i + 1, body, "[Siguiente]")
  
  ' Si estamos en la ultima pagina devolvemos -1 para que lo resuelva
  ' el que invoca a esta funcion que ya tiene la pagina activa
  '
  If j = 0 And InStr(i + 1, body, "[Anterior]") Then
    
    lastPage = -1
    
  Else
  
    Dim links As String
    Dim closedTags As Integer
    Dim closeTagPos As Integer
    
    links = Mid$(body, i, j - i)
    
    For i = Len(links) To 1 Step -1
      If closedTags = 2 Then
        If Mid$(links, i, 1) = ">" Then
          lastPage = Val(Mid$(links, i + 1, closeTagPos - i - 1))
          Exit For
        End If
      Else
        If Mid$(links, i, 1) = "<" Then
          closedTags = closedTags + 1
          closeTagPos = i
        End If
      End If
    Next
  
  End If
  
  pGetLastPageVenta = lastPage
  
End Function

'-----------------------------------------------------------------------
'https://www.mercadopago.com/mla/collections?opGp=C_DFLT
'
'-----------------------------------------------------------------------
Private Sub pSetPageMercadoPago()
  On Error Resume Next
  
  Dim numberPage As Integer
  Dim URL As String
  Dim lastPage As Integer
  Dim i As Long
  Dim inMP As Boolean
  
  ' Solo recorro automaticamente las paginas de ventas si esta en modo MercadoPago
  '
  If m_modo <> MP Then Exit Sub
  
  ' Si hay errores no hacemos nada
  '
  Err.Clear
  
  ' Si estamos en la pagina de ventas
  '
  If Mid$(txAddress.Text, 1, 55) = "https://www.mercadopago.com/mla/collections?opGp=C_DFLT" Then
    
    inMP = True
    
  ' Si esta en la primera pagina, no hay parametro page en la pagina
  '
  ElseIf Mid$(txAddress.Text, 1, 43) = "https://www.mercadopago.com/mla/collections" Then
  
    inMP = True
  
  ' Si estoy en modo MP y la pagina no es de ventas, lo redirecciono
  '
  ElseIf m_modo = MP Then
    
    inMP = True
    
    txAddress.Text = "https://www.mercadopago.com/mla/collections?opGp=C_DFLT"
    
    ' Navegamos la pagina default de Cobros MercadoPago
    Exit Sub
  
  End If
  
  If inMP Then
  
    ' Obtenemos la ultima pagina en ventas
    '
    lastPage = pGetLastPageMercadoPago()
    
    ' Si no pudimos obtener la ultima pagina no hacemos nada
    '
    If lastPage = 0 Then Exit Sub
                
    ' Obtenemos la pagina que ya leimos
    '
    With wb.Document.Forms("frmlist")
      numberPage = .All("from").Value
    End With
        
    ' Si no pudimos obtener la pagina no hacemos nada
    '
    If numberPage = 0 Then
      numberPage = 1
    End If
    
    ' Buscamos el numero de pagaina para la pagina de MP
    '
    numberPage = pGetNumberPageFromMPPage(numberPage)
    
    ' la primera vez que entro aca debo leer la pagina 1
    '
    If numberPage = 1 And m_bFirstReadMP Then
    
      m_bFirstReadMP = False
    
    Else
    
      numberPage = numberPage + 1
      
    End If
    
    ' Si ya leimos la ultima, empesamos otra vez por la primera
    ' (cuando estamos en la ultima pagina pGetLastPage devuelve -1
    '  para no complicarme demasiado con el parseo del html)
    '
    If numberPage > lastPage Or lastPage = -1 Then
      numberPage = 1
    End If
  
    ' Buscamos la pagina de MP que corresponde al numero de pagina
    '
    numberPage = pGetMPPageFromNumberPage(numberPage)
  
    ' Modificamos la pagina y enviamos el formulario para
    ' que navegue la pagina
    '
    With wb.Document.Forms("frmlist")
      .All("from").Value = numberPage
      .submit
    End With
  
  End If
  
  pSetFormPosition

End Sub

Private Function pGetLastPageMercadoPago() As Integer
  Dim lastPage As Integer
  Dim formObj As Object
  Dim body As String
  Dim bUpdated As Boolean
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i As Long
  Dim j As Long
  
  i = InStr(body, "<DIV id=PagLow>")
  j = InStr(i + 1, body, "Siguiente &gt;&gt;")
  
  ' Si estamos en la ultima pagina devolvemos -1 para que lo resuelva
  ' el que invoca a esta funcion que ya tiene la pagina activa
  '
  If j = 0 And InStr(i + 1, body, ">&lt;&lt; Anterior<") Then
    
    lastPage = -1
    
  Else
  
    Dim links As String
    Dim closedTags As Integer
    Dim closeTagPos As Integer
    
    links = Mid$(body, i, j - i)
    
    For i = Len(links) To 1 Step -1
      If closedTags = 2 Then
        If Mid$(links, i, 1) = ">" Then
          lastPage = Val(Mid$(links, i + 1, closeTagPos - i - 1))
          Exit For
        End If
      Else
        If Mid$(links, i, 1) = "<" Then
          closedTags = closedTags + 1
          closeTagPos = i
        End If
      End If
    Next
  
  End If
  
  pGetLastPageMercadoPago = lastPage
  
End Function

Private Function pGetNumberPageFromMPPage(ByVal mpNumber As Integer) As Long
  
  pGetNumberPageFromMPPage = (mpNumber / 50) + 1

End Function

Private Function pGetMPPageFromNumberPage(ByVal pageNumber As Integer) As Long
  Dim mpPage As Integer
  Dim formObj As Object
  Dim body As String
  Dim bUpdated As Boolean
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i As Long
  Dim j As Long
  
  i = InStr(body, "<DIV id=PagLow>")
  j = InStr(i + 1, body, "Siguiente &gt;&gt;")
  
  ' Si estamos en la ultima pagina devolvemos -1 para que lo resuelva
  ' el que invoca a esta funcion que ya tiene la pagina activa
  '
  If j = 0 And InStr(i + 1, body, "[Anterior]") Then
    
    mpPage = -1
    
  Else
  
    Dim links As String
    Dim closedTags As Integer
    Dim closeTagPos As Integer
    
    links = Mid$(body, i, j - i)
    
    Dim k As Long
    k = InStr(1, links, ">" & pageNumber & "<")
    For i = k To 1 Step -1
      If closedTags = 1 Then
        If Mid$(links, i, 1) = "'" Then
          mpPage = Val(Mid$(links, i + 1, closeTagPos - i - 1))
          Exit For
        End If
      Else
        If Mid$(links, i, 1) = "'" Then
          closedTags = closedTags + 1
          closeTagPos = i
        End If
      End If
    Next
  
  End If
  
  pGetMPPageFromNumberPage = mpPage

End Function
'-----------------------------------------------------------------------
'-----------------------------------------------------------------------
Private Sub pSetPageArticulo()
  On Error Resume Next
  
  Dim numberPage As Integer
  Dim URL As String
  Dim lastPage As Integer
  Dim i As Long
  Dim inVentas As Boolean
  Dim inVentasSinPage As Boolean
  
  ' Solo recorro automaticamente las paginas de ventas si esta en modo VENTAS
  '
  If m_modo <> ART Then Exit Sub
  
  ' Si hay errores no hacemos nada
  '
  Err.Clear
  
  ' Si estamos en la pagina de ventas
  '
  If Mid$(txAddress.Text, 1, 64) = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS&page=" Then
    
    inVentas = True
    inVentasSinPage = False
    
  ' Si esta en la primera pagina, no hay parametro page en la pagina
  '
  ElseIf Mid$(txAddress.Text, 1, 65) = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS&dummy=" Then
  
    inVentas = True
    inVentasSinPage = True
  
  ' Si estoy en modo VTA y la pagina no es de ventas, lo redirecciono
  '
  ElseIf m_modo = ART Then
    
    inVentas = True
    inVentasSinPage = True
    
    txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS"
  
  End If
  
  
  If inVentas Then
  
    ' Obtenemos la ultima pagina en ventas
    '
    lastPage = pGetLastPageArticulo()
    
    ' Si no pudimos obtener la ultima pagina no hacemos nada
    '
    If lastPage = 0 Then Exit Sub
    
    If Not inVentasSinPage Then
    
      ' Obtenemos la pagina que ya leimos
      '
      i = InStr(64, txAddress.Text, "&")
      numberPage = Val(Mid$(txAddress.Text, 65, i - 65))
      
      ' Si no pudimos obtener la pagina no hacemos nada
      '
      If numberPage = 0 Then Exit Sub
      
      numberPage = numberPage + 1
      
      ' Si ya leimos la ultima, empesamos otra vez por la primera
      ' (cuando estamos en la ultima pagina pGetLastPage devuelve -1
      '  para no complicarme demasiado con el parseo del html)
      '
      If numberPage > lastPage Or lastPage = -1 Then
        numberPage = 1
      End If
    
      ' Modificamos la pagina
      '
      URL = Mid$(txAddress.Text, 1, 64) & numberPage & Mid$(txAddress.Text, i)
    
    Else
    
      numberPage = 2
      
      ' Modificamos la pagina
      '
      URL = "http://www.mercadolibre.com.ar/jm/myML?as_section=ACT_ITMS&page=" & numberPage & Mid$(txAddress.Text, 59)
      
    End If
    
  
  End If
  ' Solo si no hubo errores navegamos la url modificada
  '
  If Err.Number = 0 And LenB(URL) > 0 Then
    txAddress.Text = URL
  End If
End Sub

Private Function pGetLastPageArticulo() As Integer
  Dim lastPage As Integer
  Dim formObj As Object
  Dim body As String
  Dim bUpdated As Boolean
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i As Long
  Dim j As Long
  
  i = InStr(body, "Ver p")
  j = InStr(i + 1, body, "[Siguiente]")
  
  ' Si estamos en la ultima pagina devolvemos -1 para que lo resuelva
  ' el que invoca a esta funcion que ya tiene la pagina activa
  '
  If j = 0 And InStr(i + 1, body, "[Anterior]") Then
    
    lastPage = -1
    
  Else
  
    Dim links As String
    Dim closedTags As Integer
    Dim closeTagPos As Integer
    
    links = Mid$(body, i, j - i)
    
    For i = Len(links) To 1 Step -1
      If closedTags = 2 Then
        If Mid$(links, i, 1) = ">" Then
          lastPage = Val(Mid$(links, i + 1, closeTagPos - i - 1))
          Exit For
        End If
      Else
        If Mid$(links, i, 1) = "<" Then
          closedTags = closedTags + 1
          closeTagPos = i
        End If
      End If
    Next
  
  End If
  
  pGetLastPageArticulo = lastPage
  
End Function

Private Sub pSetBodyObject()
  On Error Resume Next
  Set m_body = wb.Document.body
End Sub

Private Sub pCheckLoginPage()
  On Error Resume Next
  
  ' este flag evita que me llamen
  ' por un evento de timer en medio de un
  ' envio del form
  '
  If m_bSendingLoginPage Then Exit Sub
  If m_modo = OP Then Exit Sub
  
  Dim formObj As Object
  For Each formObj In fMain.wb.Document.Forms
    Err.Clear
    formObj.All("login-user").Value = gCMIUser
    If Err.Number = 0 Then
      formObj.All("login-password").Value = gCMIPwd
      If Err.Number = 0 Then
        pSubmitFormLogin formObj
      End If
    End If
  Next
End Sub

Private Sub pSubmitFormLogin(ByVal formObj As Object)
  On Error Resume Next
  
  Dim start As Date
  Dim bSubmited As Boolean
  
  ' este flag evita que me llamen
  ' por un evento de timer en medio de un
  ' envio del form
  '
  m_bSendingLoginPage = True
  
  ' Este flag se apaga en el evento wb_NavigateComplete2
  '
  m_bNavigateComplete = True
  start = Now
  Do
    DoEvents
    If m_bNavigateComplete Then
              
      If bSubmited Then
        Exit Do
      Else
        m_bNavigateComplete = False
        bSubmited = True
        formObj.submit
      End If
    End If
    Sleep 0.3
    If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
      Exit Do
    End If
  Loop

  m_bSendingLoginPage = False
End Sub

Private Sub pSetFormPosition()
  If Me.WindowState = vbMinimized Then Exit Sub
  If m_modo = VTA Then
    Me.WindowState = vbNormal
    Me.Top = 0
    Me.Left = 0
    Me.Height = Screen.Height * 0.5
    Me.Width = Screen.Width
  End If
  If m_modo = MP Then
    Me.WindowState = vbNormal
    Me.Top = Screen.Height * 0.5
    Me.Left = 0
    Me.Height = Screen.Height * 0.5
    Me.Width = Screen.Width
  End If
End Sub
