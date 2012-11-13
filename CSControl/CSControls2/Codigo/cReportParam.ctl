VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#4.3#0"; "CSMaskEdit.ocx"
Object = "{C3B62925-B0EA-11D7-8204-00D0090360E2}#7.2#0"; "CSComboBox.ocx"
Begin VB.UserControl cReportParam 
   ClientHeight    =   6015
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5490
   KeyPreview      =   -1  'True
   ScaleHeight     =   6015
   ScaleWidth      =   5490
   Begin VB.Frame ctlFR 
      BorderStyle     =   0  'None
      Height          =   555
      Index           =   0
      Left            =   2610
      TabIndex        =   1
      Top             =   2460
      Visible         =   0   'False
      Width           =   2265
      Begin VB.OptionButton ctlOP 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         ForeColor       =   &H80000008&
         Height          =   330
         Index           =   0
         Left            =   45
         TabIndex        =   2
         Top             =   90
         Visible         =   0   'False
         Width           =   2165
      End
   End
   Begin VB.CheckBox ctlCHK 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   285
      Index           =   0
      Left            =   2610
      TabIndex        =   0
      Top             =   3810
      Visible         =   0   'False
      Width           =   2265
   End
   Begin CSControls.cHelp ctlHL 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   3
      Top             =   1605
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   556
      BorderColor     =   -2147483633
      BorderType      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit ctlMKE 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   4
      Top             =   2040
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   556
      Alignment       =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   "$ 0.00"
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton ctlcbTab 
      Height          =   330
      Index           =   0
      Left            =   1980
      TabIndex        =   5
      Top             =   960
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   2963
      _ExtentY        =   582
      Caption         =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSMaskEdit.cMaskEdit ctlMEFE 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   6
      Top             =   4125
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   556
      Alignment       =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   "$ 0.00"
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdSave 
      Height          =   330
      Left            =   3870
      TabIndex        =   7
      Top             =   5505
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   582
      Caption         =   "&Guardar"
      Style           =   3
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButton cmdDefaults 
      Height          =   330
      Left            =   2355
      TabIndex        =   8
      Top             =   5505
      Width           =   1425
      _ExtentX        =   2514
      _ExtentY        =   582
      Caption         =   "&Cargar Defaults"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSMaskEdit.cMaskEdit ctlTXPassword 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   9
      Top             =   3405
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit ctlTX 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   10
      Top             =   4545
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSComboBox.cComboBox ctlCBhock 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   11
      Top             =   4965
      Visible         =   0   'False
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   ""
   End
   Begin CSComboBox.cComboBox ctlCB 
      Height          =   315
      Index           =   0
      Left            =   2610
      TabIndex        =   12
      Top             =   3045
      Visible         =   0   'False
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   ""
   End
   Begin VB.Label ctlLB 
      BackStyle       =   0  'Transparent
      Caption         =   "pirulo en pirulo por pirulo"
      Height          =   420
      Index           =   0
      Left            =   1215
      TabIndex        =   13
      Top             =   1605
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label lbReport 
      BackStyle       =   0  'Transparent
      Caption         =   "Resumen de produccion y Pagos a proveedores"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   180
      TabIndex        =   14
      Top             =   540
      Width           =   5040
   End
   Begin VB.Shape shReportTitle 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      FillColor       =   &H80000010&
      Height          =   375
      Left            =   120
      Shape           =   4  'Rounded Rectangle
      Top             =   480
      Width           =   5235
   End
   Begin VB.Image imgCorner 
      Height          =   2025
      Left            =   15
      Picture         =   "cReportParam.ctx":0000
      Top             =   435
      Width           =   3120
   End
   Begin VB.Shape ctlShTab 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   5475
      Left            =   0
      Top             =   420
      Width           =   5415
   End
End
Attribute VB_Name = "cReportParam"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportParam
' 04-10-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' eventos
Public Event CBChange(ByVal Index As Integer)
Public Event CBhockChange(ByVal Index As Integer)
Public Event CHKClick(ByVal Index As Integer)
Public Event cmdRefresh(ByRef sqlstmt As String)
Public Event cmdSave()
Public Event cmdDescartar()
Public Event HLChange(ByVal Index As Integer)
Public Event MKEChange(ByVal Index As Integer)
Public Event MEFEChange(ByVal Index As Integer)
Public Event OPClick(ByVal Index As Integer)
Public Event TXChange(ByVal Index As Integer)
Public Event TXPasswordChange(ByVal Index As Integer)
Public Event cbTabClick(ByVal Index As Integer)
Public Event ToolBarClick(ByVal Button As Object)
Public Event ToolBarClickEx(ByVal ToolBar As Object, ByVal lButton As Long)

' propiedades publicas
Public ABMObject As Object
' propiedades privadas
Private m_oldCB()          As String
Private m_oldCBhock()      As String
Private m_oldMKE()         As String
Private m_oldMEFE()        As String
Private m_oldOP()          As String
Private m_oldTX()          As String
Private m_oldTXPassword()  As String

Private m_ClientProperties As Object

'///////////////////////////////////////////////////////////////////////////////////
Private m_Name      As String
Private m_sqlstmt   As String
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long

Private m_HelpType       As csHelpType
' eventos
'///////////////////////////////////////////////////////////////////////////////////

' funciones publicas
Public Property Get HelpType() As csHelpType
  HelpType = m_HelpType
End Property
Public Property Let HelpType(ByVal rhs As csHelpType)
  m_HelpType = rhs
End Property

Public Property Get ReportTitle() As String
  ReportTitle = lbReport.Caption
End Property

Public Property Let ReportTitle(ByVal rhs As String)
  lbReport.Caption = rhs
End Property

Public Property Get Buttons1() As Long
  Buttons1 = m_Buttons1
End Property

Public Property Let Buttons1(ByVal rhs As Long)
  m_Buttons1 = rhs
End Property

Public Property Get Buttons2() As Long
  Buttons2 = m_Buttons2
End Property

Public Property Let Buttons2(ByVal rhs As Long)
  m_Buttons2 = rhs
End Property

Public Property Get Buttons3() As Long
  Buttons3 = m_Buttons3
End Property

Public Property Let Buttons3(ByVal rhs As Long)
  m_Buttons3 = rhs
End Property

Public Property Get ParamVisible() As Boolean
  ParamVisible = True
End Property

Public Property Get ClientProperties() As Object
   Set ClientProperties = m_ClientProperties
End Property

Public Property Set ClientProperties(ByRef rhs As Object)
   Set m_ClientProperties = rhs
End Property

Public Property Get hWnd() As Long
  hWnd = UserControl.hWnd
End Property

Public Property Get NameClient() As String
    NameClient = m_Name
End Property
Public Property Let NameClient(ByVal rhs As String)
    m_Name = rhs
End Property

Public Property Let sqlstmt(ByVal rhs As String)
  m_sqlstmt = rhs
End Property
'///////////////////////////////////////////////////////////////////////

Public Property Get MKE() As Object
  Set MKE = ctlMKE
End Property
Public Property Get MEFE() As Object
  Set MEFE = ctlMEFE
End Property
Public Property Get HL() As Object
  Set HL = ctlHL
End Property
Public Property Get OP() As Object
  Set OP = ctlOP
End Property
Public Property Get FR() As Object
  Set FR = ctlFR
End Property
Public Property Get CHK() As Object
  Set CHK = ctlCHK
End Property
Public Property Get CB() As Object
  Set CB = ctlCB
End Property
Public Property Get CBhock() As Object
  Set CBhock = ctlCBhock
End Property
Public Property Get TX() As Object
  Set TX = ctlTX
End Property
Public Property Get TXPassword() As Object
  Set TXPassword = ctlTXPassword
End Property
Public Property Get LB() As Object
  Set LB = ctlLB
End Property
Public Property Get cbTab() As Object
  Set cbTab = ctlcbTab
End Property
Public Property Get ShTab() As Object
  Set ShTab = ctlShTab
End Property
Public Property Get BackColor() As OLE_COLOR
  BackColor = UserControl.BackColor
End Property
Public Property Get Controls() As Object
  Set Controls = UserControl.Controls
End Property
Public Property Let lbTitle(ByVal rhs As String)

End Property
Public Property Let Caption(ByVal rhs As String)
  
End Property

Public Sub Update()
  Dim sqlstmt As String
  RaiseEvent cmdRefresh(sqlstmt)
End Sub

Public Sub ShowParameters()
  On Error Resume Next
  Dim c As Control
  For Each c In Controls
    If CanHide(c) Then
      If c.Tag <> "" Or c Is cmdSave Or c Is cmdDefaults Or TypeOf c Is Shape Then c.Visible = True
    End If
  Next
  UserControl_Resize
End Sub

'-----------------------
' Para que no chille
Public Sub Edit()
End Sub
Public Sub NewObj()
End Sub
Public Sub Delete()
End Sub

Public Function CtrlKeySave() As Boolean
  cmdSave_Click
  CtrlKeySave = True
End Function

Public Function CtrlKeyNew() As Boolean
  CtrlKeyNew = True
End Function

Public Function CtrlKeyCopy() As Boolean
  CtrlKeyCopy = True
End Function

Public Function CtrlKeyRefresh() As Boolean
  Update
  CtrlKeyRefresh = True
End Function

Public Function CtrlKeyClose() As Boolean
  CtrlKeyClose = True
End Function
'-----------------------

Private Function CanHide(ByRef c As Control) As Boolean
  CanHide = Not TypeOf c Is ListView And Not TypeOf c Is ToolBar
End Function
' funciones privadas
' construccion - destruccion

Private Sub cmdDefaults_Click()
  RaiseEvent cmdDescartar
End Sub

Private Sub cmdSave_Click()
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  RaiseEvent cmdSave

ControlError:
End Sub

'----------------
Private Sub ctlCB_Click(Index As Integer)
  On Error Resume Next
  If UBound(m_oldCB) < Index Then ReDim Preserve m_oldCB(Index)
  If m_oldCB(Index) <> ctlCB(Index).Text Then RaiseEvent CBChange(Index)
  m_oldCB(Index) = ctlCB(Index).Text
End Sub
Private Sub ctlCB_GotFocus(Index As Integer)
  On Error Resume Next
  If UBound(m_oldCB) < Index Then ReDim Preserve m_oldCB(Index)
  m_oldCB(Index) = ctlCB(Index).Text
End Sub
Private Sub ctlCB_LostFocus(Index As Integer)
  On Error Resume Next
  If m_oldCB(Index) = ctlCB(Index).Text Then Exit Sub
  RaiseEvent CBChange(Index)
End Sub
Private Sub ctlCBhock_GotFocus(Index As Integer)
  On Error Resume Next
  If UBound(m_oldCBhock) < Index Then ReDim Preserve m_oldCBhock(Index)
  m_oldCBhock(Index) = ctlCBhock(Index).Text
End Sub
Private Sub ctlCBhock_LostFocus(Index As Integer)
  On Error Resume Next
  If m_oldCBhock(Index) = ctlCBhock(Index).Text Then Exit Sub
  RaiseEvent CBhockChange(Index)
End Sub

Private Sub ctlcbTab_Click(Index As Integer)
  On Error Resume Next
  RaiseEvent cbTabClick(Index)
End Sub

Private Sub ctlCHK_Click(Index As Integer)
  On Error Resume Next
  RaiseEvent CHKClick(Index)
End Sub

Private Sub ctlHL_Change(Index As Integer)
  On Error Resume Next
  RaiseEvent HLChange(Index)
End Sub

Private Sub ctlMEFE_ReturnFromHelp(Index As Integer)
  On Error Resume Next
  If m_oldMEFE(Index) = ctlMEFE(Index).Text Then Exit Sub
  RaiseEvent MEFEChange(Index)
End Sub

Private Sub ctlMEFE_GotFocus(Index As Integer)
  On Error Resume Next
  If UBound(m_oldMEFE) < Index Then ReDim Preserve m_oldMEFE(Index)
  m_oldMEFE(Index) = ctlMEFE(Index).Text
End Sub

Private Sub ctlMEFE_LostFocus(Index As Integer)
  On Error Resume Next
  If m_oldMEFE(Index) = ctlMEFE(Index).Text Then Exit Sub
  RaiseEvent MEFEChange(Index)
End Sub

Private Sub ctlMKE_GotFocus(Index As Integer)
  On Error Resume Next
  If UBound(m_oldMKE) < Index Then ReDim Preserve m_oldMKE(Index)
  m_oldMKE(Index) = ctlMKE(Index).csValue
End Sub

Private Sub ctlMKE_LostFocus(Index As Integer)
  On Error Resume Next
  If m_oldMKE(Index) = ctlMKE(Index).csValue Then Exit Sub
  RaiseEvent MKEChange(Index)
End Sub

Private Sub ctlMKE_ReturnFromHelp(Index As Integer)
  On Error Resume Next
  If m_oldMKE(Index) = ctlMKE(Index).csValue Then Exit Sub
  RaiseEvent MKEChange(Index)
End Sub

Private Sub ctlOP_Click(Index As Integer)
  On Error Resume Next
  RaiseEvent OPClick(Index)
End Sub

Private Sub ctlTX_GotFocus(Index As Integer)
  On Error Resume Next
  If UBound(m_oldTX) < Index Then ReDim Preserve m_oldTX(Index)
  m_oldTX(Index) = ctlTX(Index).Text
End Sub

Private Sub ctlTXPassword_GotFocus(Index As Integer)
  On Error Resume Next
  If UBound(m_oldTXPassword) < Index Then ReDim Preserve m_oldTXPassword(Index)
  m_oldTXPassword(Index) = ctlTXPassword(Index).Text
End Sub

Private Sub ctlTX_LostFocus(Index As Integer)
  On Error Resume Next
  If m_oldTX(Index) = ctlTX(Index).Text Then Exit Sub
  RaiseEvent TXChange(Index)
End Sub

Private Sub ctlTXPassword_LostFocus(Index As Integer)
  On Error Resume Next
  If m_oldTXPassword(Index) = ctlTXPassword(Index).Text Then Exit Sub
  RaiseEvent TXPasswordChange(Index)
End Sub

'--------------------------------
Private Sub UserControl_Initialize()
  On Error Resume Next
  
  ReDim m_oldCB(0)
  ReDim m_oldCBhock(0)
  ReDim m_oldMKE(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldOP(0)
  ReDim m_oldTX(0)
  ReDim m_oldTXPassword(0)
  
  ctlFR(0).BackColor = vb3DHighlight
  ctlOP(0).BackColor = vb3DHighlight
  
  m_HelpType = csNormal
  
  ctlHL(0).ButtonStyle = cHelpButtonSingle
  ctlMEFE(0).ButtonStyle = cButtonSingle
  ctlMKE(0).ButtonStyle = cButtonSingle
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, UserControl.ActiveControl
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  
  With UserControl
    ctlShTab.Move 40, 0, .ScaleWidth - 80, .ScaleHeight - 60
    imgCorner.Top = ctlShTab.Top + 10
    imgCorner.Left = ctlShTab.Left + 20
    cmdSave.Move ctlShTab.Width - 160 - cmdSave.Width, .Height - (160 + cmdSave.Height)
    cmdDefaults.Move cmdSave.Left - 60 - cmdDefaults.Width, .Height - (160 + cmdDefaults.Height)
    shReportTitle.Top = ctlShTab.Top + 60
    lbReport.Top = ctlShTab.Top + 100
    shReportTitle.Width = .ScaleWidth - shReportTitle.Left * 2
    lbReport.Width = .ScaleWidth - lbReport.Left * 2
  End With
End Sub

Public Function SetToolBar()
End Function

Public Sub SetFocusFirstControl()
  On Error Resume Next
  
  Dim c As Control
  
  For Each c In UserControl.Controls
    If c.TabIndex = 0 And Not TypeOf c Is Label Then
      c.SetFocus
      Exit For
    End If
  Next
End Sub

Private Sub UserControl_Terminate()
  On Error Resume Next

  ReDim m_oldCB(0)
  ReDim m_oldCBhock(0)
  ReDim m_oldMKE(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldOP(0)
  ReDim m_oldTX(0)
  ReDim m_oldTXPassword(0)
  Set ABMObject = Nothing
End Sub

Private Sub tbrTool_ButtonClick(ByVal lButton As Long)
End Sub

Private Sub tbBar_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  RaiseEvent ToolBarClick(Button)
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  On Error Resume Next
  HelpType = PropBag.ReadProperty("HelpType", csNormal)
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error Resume Next
  PropBag.WriteProperty "HelpType", m_HelpType, csNormal
End Sub
