VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#4.3#0"; "CSMaskEdit.ocx"
Object = "{D5E078F9-5926-4845-9172-73CD66955B2C}#2.4#0"; "CSGrid.ocx"
Object = "{C3B62925-B0EA-11D7-8204-00D0090360E2}#7.2#0"; "CSComboBox.ocx"
Begin VB.UserControl cListDoc 
   ClientHeight    =   5640
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   8820
   KeyPreview      =   -1  'True
   ScaleHeight     =   5640
   ScaleWidth      =   8820
   Begin CSGrid.cGrid grItems 
      Height          =   1770
      Left            =   6345
      TabIndex        =   10
      Top             =   810
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   3122
      AutomaticSort   =   -1  'True
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      DisableIcons    =   -1  'True
   End
   Begin VB.CheckBox ctlCHK 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   285
      Index           =   0
      Left            =   1140
      TabIndex        =   2
      Top             =   2580
      Visible         =   0   'False
      Width           =   2265
   End
   Begin VB.Frame ctlFR 
      BorderStyle     =   0  'None
      Height          =   555
      Index           =   0
      Left            =   1140
      TabIndex        =   0
      Top             =   1230
      Visible         =   0   'False
      Width           =   2265
      Begin VB.OptionButton ctlOP 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         ForeColor       =   &H80000008&
         Height          =   330
         Index           =   0
         Left            =   45
         TabIndex        =   1
         Top             =   90
         Visible         =   0   'False
         Width           =   2165
      End
   End
   Begin CSControls.cHelp ctlHL 
      Height          =   315
      Index           =   0
      Left            =   1140
      TabIndex        =   3
      Top             =   375
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   556
      BorderColor     =   -2147483633
      BorderType      =   1
      HelpType        =   0
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
      Left            =   1140
      TabIndex        =   4
      Top             =   810
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
      Left            =   90
      TabIndex        =   5
      Top             =   135
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
      Left            =   1140
      TabIndex        =   6
      Top             =   2895
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
      Left            =   2340
      TabIndex        =   8
      Top             =   4455
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
      Left            =   765
      TabIndex        =   9
      Top             =   4455
      Width           =   1485
      _ExtentX        =   2619
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
      Left            =   1140
      TabIndex        =   11
      Top             =   2175
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
      Left            =   1140
      TabIndex        =   12
      Top             =   3315
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
   Begin CSButton.cButton cmdHideParameters 
      Height          =   195
      Left            =   3180
      TabIndex        =   13
      Top             =   135
      Width           =   195
      _ExtentX        =   344
      _ExtentY        =   344
      Caption         =   "X"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSComboBox.cComboBox ctlCBhock 
      Height          =   315
      Index           =   0
      Left            =   1140
      TabIndex        =   14
      Top             =   3735
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
      Left            =   1140
      TabIndex        =   15
      Top             =   1815
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
      Caption         =   "pirulo en pirulo por pirulo"
      Height          =   420
      Index           =   0
      Left            =   225
      TabIndex        =   7
      Top             =   495
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Shape ctlShTab 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   4875
      Left            =   90
      Top             =   45
      Width           =   3435
   End
   Begin VB.Menu popGrid 
      Caption         =   "popGrid"
      Visible         =   0   'False
      Begin VB.Menu popGridGroup 
         Caption         =   "&Grupos..."
      End
      Begin VB.Menu popGridFormulas 
         Caption         =   "&Formulas..."
      End
      Begin VB.Menu popGridFormats 
         Caption         =   "F&ormatos Condicionales..."
      End
      Begin VB.Menu popGridFilters 
         Caption         =   "F&iltros..."
      End
      Begin VB.Menu popGridSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popGridExportToExel 
         Caption         =   "&Exportar a Excel..."
      End
      Begin VB.Menu popGridSep2 
         Caption         =   "-"
         Visible         =   0   'False
      End
      Begin VB.Menu popGridTask 
         Caption         =   "&Tareas"
         Visible         =   0   'False
         Begin VB.Menu popGridTaskItem 
            Caption         =   "Item"
            Index           =   0
         End
      End
   End
End
Attribute VB_Name = "cListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cListDoc
' 14-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListDoc"

Private Const IMG_FOLDER_OPEN = 2
Private Const IMG_FOLDER_CLOSE = 1
Private Const IMG_ACTIVE_TRUE = 3
Private Const IMG_ACTIVE_FALSE = 4

Private Enum csTvImage
  c_img_down = 8
  c_img_up
End Enum

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
Public Event GRClick(ByVal Index As Integer)
Public Event GrDblClick(ByVal Index As Integer)

' propiedades publicas
Public ABMObject As Object
' propiedades privadas
Private m_oldCB()       As String
Private m_oldCBhock()   As String
Private m_oldMKE()      As String
Private m_oldMEFE()     As String
Private m_oldOP()       As String
Private m_oldTX()       As String
Private m_oldTXPassword()  As String

Private m_ColumnsPresent As Boolean

Private m_ClientProperties As Object

'///////////////////////////////////////////////////////////////////////////////////
Private m_Name      As String
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long
Private m_Grid      As CSOAPI.cGridManager
Private m_IconText  As Integer

Private m_ParamVisible As Boolean

Private m_sqlstmt As String

Private m_HelpType       As csHelpType

Private m_ObjClientMenu  As Object

' eventos
Public Event ToolBarClick(ByVal Button As Object)
Public Event ToolBarClickEx(ByVal ToolBar As Object, ByVal lButton As Long)
Public Event DblClick()

'///////////////////////////////////////////////////////////////////////////////////

' funciones publicas
Public Property Set ObjClientMenu(ByRef rhs As Object)
  Set m_ObjClientMenu = rhs
End Property

Public Property Get ParamVisible() As Boolean
  ParamVisible = m_ParamVisible
End Property

Public Property Get ClientProperties() As Object
  Set ClientProperties = m_ClientProperties
End Property

Public Property Set ClientProperties(ByRef rhs As Object)
  On Error Resume Next
  Set m_ClientProperties = rhs
  Set m_Grid.Properties(grItems) = rhs
End Property

Public Property Get hWnd() As Long
  hWnd = UserControl.hWnd
End Property

Public Property Get Id() As Long
  On Error Resume Next
  Id = m_Grid.Id(grItems)
End Property

Public Property Get NameClient() As String
  NameClient = m_Name
End Property
Public Property Let NameClient(ByVal rhs As String)
  m_Name = rhs
  m_Grid.Name = rhs
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

Public Property Let IconText(ByVal rhs As IconList)
  m_IconText = rhs
  m_Grid.IMG_Item = m_IconText
End Property

Public Property Get IconText() As IconList
  IconText = m_IconText
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

Public Property Get HelpType() As csHelpType
  HelpType = m_HelpType
End Property
Public Property Let HelpType(ByVal rhs As csHelpType)
  m_HelpType = rhs
End Property

Public Property Get SelectedItems() As Long()
  Dim rtn() As Long
  
  If Not m_Grid.Ids(grItems, rtn) Then
    ReDim rtn(0)
  End If
  
  SelectedItems = rtn
End Property

Public Sub AddLine(ByVal Id As Long)
  If Not m_ColumnsPresent Then Update False
  m_Grid.AddFromSqlstmt grItems, m_sqlstmt & " " & Id
End Sub

Public Sub RefreshLine(ByVal Id As Long)
  On Error GoTo ControlError
  m_Grid.UpdateFromSqlstmt grItems, m_sqlstmt & " " & Id

  GoTo ExitProc
ControlError:
  MngError Err, "RefreshLine", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub CloseForm()

End Sub

Public Sub Update(Optional ByVal bSetFocus As Boolean = True)
  Dim sqlstmt As String
  RaiseEvent cmdRefresh(sqlstmt)
  m_Grid.LoadFromSqlstmt grItems, sqlstmt
  m_ColumnsPresent = True
  If bSetFocus Then SetFocusControl grItems
End Sub

Public Sub ShowParameters()
  On Error Resume Next
  Dim c As Control
  
  For Each c In UserControl.Controls
    If CanHide(c) Then
      If c.Tag <> "" Or c Is cmdSave Or c Is cmdDefaults Or TypeOf c Is Shape Then c.Visible = True
    End If
  Next
  m_ParamVisible = True
  UserControl_Resize
End Sub

Public Sub HideParameters()
  On Error Resume Next
  Dim c As Control
  
  For Each c In UserControl.Controls
    If CanHide(c) Then
      If c.Tag <> "" Or c Is cmdSave Or c Is cmdDefaults Or TypeOf c Is Shape Then c.Visible = False
    End If
  Next
  m_ParamVisible = False
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

Public Function SetToolBar()
  m_ParamVisible = True
  
  DoEvents
  UserControl_Resize
End Function

Public Sub SavePreference(ByVal WinState As Integer)
  On Error GoTo ControlError
  
  If WinState = vbMinimized Then Exit Sub
  m_Grid.SaveColumnWidth grItems, m_Name
  
  GoTo ExitProc
ControlError:
  MngError Err, "SavePreference", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub Remove(ByVal Id As Long)
  m_Grid.Remove grItems, Id
End Sub

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

' Menus
Public Sub ClearMenus()
  On Error Resume Next
  
  Dim i As Long
  
  pSetVisiblePopGridTask False
  With popGridTaskItem
    .Item(0).Visible = True
    For i = .LBound + 1 To .UBound
      Unload .Item(i)
    Next
  End With
End Sub

Public Function AddMenu(ByVal MenuName As String) As Long
  On Error Resume Next
  Err.Clear
  With popGridTaskItem
    Load .Item(.UBound + 1)
    If Err.Number Then
      MngError Err, "AddMenu", C_Module, "Error al agregar un menu. Menu: " & MenuName
      Exit Function
    End If
    SetVisibleMenu .UBound, True
    .Item(.UBound).Caption = MenuName
    AddMenu = .UBound
  End With
End Function

Public Sub SetEnabledMenu(ByVal Index As Long, ByVal bState As Boolean)
  On Error Resume Next
  popGridTaskItem.Item(Index).Enabled = bState
End Sub

Public Sub SetVisibleMenu(ByVal Index As Long, ByVal bState As Boolean)
  On Error Resume Next
  
  Dim i         As Long
  Dim bVisible  As Boolean
  
  With popGridTaskItem
  
    .Item(0).Visible = True
    .Item(Index).Visible = bState
    
    For i = .LBound + 1 To .UBound
      If .Item(i).Visible Then
        bVisible = True
        Exit For
      End If
    Next
        
    ' Al menos un item tiene que estar visible
    .Item(0).Visible = Not bVisible
    pSetVisiblePopGridTask bVisible
  End With
End Sub

' funciones privadas
Private Sub pSetVisiblePopGridTask(ByVal bState As Boolean)
  On Error Resume Next
  popGridSep2.Visible = bState
  popGridTask.Visible = bState
End Sub

Private Function CanHide(ByRef c As Control) As Boolean
  On Error Resume Next
  CanHide = Not TypeOf c Is ListView And Not TypeOf c Is ToolBar
End Function

Private Sub cmdDefaults_Click()
  On Error Resume Next
  RaiseEvent cmdDescartar
End Sub

Private Sub cmdHideParameters_Click()
  On Error Resume Next
  HideParameters
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

Private Sub ctlGR_Click(Index As Integer)
  On Error Resume Next
  RaiseEvent GRClick(Index)
End Sub

Private Sub ctlGR_DblClick(Index As Integer)
  On Error Resume Next
  RaiseEvent GrDblClick(Index)
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

Private Sub grItems_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent DblClick
End Sub

Private Sub grItems_KeyDown(KeyCode As Integer, Shift As Integer, bDoDefault As Boolean)
  On Error Resume Next
  
  If KeyCode = vbKeyReturn Then
    bDoDefault = False

    RaiseEvent DblClick
  End If
End Sub

Private Sub grItems_ShowPopMenu(Cancel As Boolean)
  On Error Resume Next
  UserControl.PopupMenu popGrid
  Cancel = True
End Sub

Private Sub popGridExportToExel_Click()
  On Error Resume Next
  Dim Export As cExporToExcel
  Set Export = New cExporToExcel
  
  Export.ShowDialog = True
  Export.Export dblExGrid, "", grItems
End Sub

Private Sub popGridFilters_Click()
  On Error Resume Next
  grItems.ShowFilters
End Sub

Private Sub popGridFormats_Click()
  On Error Resume Next
  grItems.ShowFormats
End Sub

Private Sub popGridFormulas_Click()
  On Error Resume Next
  grItems.ShowFormulas
End Sub

Private Sub popGridGroup_Click()
  On Error Resume Next
  grItems.GroupColumns
End Sub

Private Sub popGridTaskItem_Click(Index As Integer)
  On Error Resume Next
  If m_ObjClientMenu Is Nothing Then Exit Sub
  m_ObjClientMenu.ProcessMenu Index
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, UserControl.ActiveControl
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  
  With UserControl
    If m_ParamVisible Then
      ctlShTab.Move 40, 0, 4000, .ScaleHeight
      cmdHideParameters.Move 3785, 100
      grItems.Move ctlShTab.Width + 80, 0, .Width - (ctlShTab.Width + 80), .ScaleHeight
      cmdSave.Move ctlShTab.Width - 160 - cmdSave.Width, .Height - (160 + cmdSave.Height)
      cmdDefaults.Move cmdSave.Left - 60 - cmdDefaults.Width, .Height - (160 + cmdDefaults.Height)
    Else
      grItems.Move 20, 0, .Width - 20, .ScaleHeight
    End If
  End With
End Sub

' construccion - destruccion
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  On Error Resume Next
  HelpType = PropBag.ReadProperty("HelpType", csNormal)
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error Resume Next
  PropBag.WriteProperty "HelpType", m_HelpType, csNormal
End Sub

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
  
  Set m_Grid = New cGridManager
  m_Grid.SetPropertys grItems
  m_Grid.IMG_ACTIVE_FALSE = IMG_ACTIVE_FALSE
  m_Grid.IMG_ACTIVE_TRUE = IMG_ACTIVE_TRUE
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
  Set m_Grid = Nothing
  Set m_ClientProperties = Nothing
  Set m_ObjClientMenu = Nothing
End Sub
