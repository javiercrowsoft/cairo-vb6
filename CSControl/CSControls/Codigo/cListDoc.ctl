VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.0#0"; "CSHelp2.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.1#0"; "CSMaskEdit2.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.8#0"; "CSGrid2.ocx"
Begin VB.UserControl cListDoc 
   ClientHeight    =   8220
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   10830
   KeyPreview      =   -1  'True
   ScaleHeight     =   8220
   ScaleWidth      =   10830
   Begin VB.PictureBox picMain 
      Appearance      =   0  'Flat
      BackColor       =   &H80000014&
      ForeColor       =   &H80000008&
      Height          =   3675
      Left            =   120
      ScaleHeight     =   3645
      ScaleWidth      =   4005
      TabIndex        =   5
      Top             =   480
      Width           =   4035
      Begin VB.VScrollBar vscParams 
         Height          =   3915
         Left            =   3765
         TabIndex        =   16
         Top             =   0
         Width           =   255
      End
      Begin VB.PictureBox picParams 
         Appearance      =   0  'Flat
         BackColor       =   &H80000014&
         ForeColor       =   &H80000008&
         Height          =   4575
         Left            =   0
         ScaleHeight     =   4545
         ScaleWidth      =   3765
         TabIndex        =   6
         Top             =   0
         Width           =   3795
         Begin VB.ComboBox ctlCBhock 
            Height          =   315
            Index           =   0
            Left            =   915
            Style           =   2  'Dropdown List
            TabIndex        =   18
            Top             =   3375
            Visible         =   0   'False
            Width           =   2295
         End
         Begin VB.ComboBox ctlCB 
            Height          =   315
            Index           =   0
            Left            =   915
            Style           =   2  'Dropdown List
            TabIndex        =   17
            Top             =   1455
            Visible         =   0   'False
            Width           =   2295
         End
         Begin VB.CheckBox ctlCHK 
            Appearance      =   0  'Flat
            BackColor       =   &H80000014&
            ForeColor       =   &H80000008&
            Height          =   285
            Index           =   0
            Left            =   915
            TabIndex        =   9
            Top             =   2220
            Visible         =   0   'False
            Width           =   2265
         End
         Begin VB.Frame ctlFR 
            BackColor       =   &H80000014&
            BorderStyle     =   0  'None
            Height          =   555
            Index           =   0
            Left            =   915
            TabIndex        =   7
            Top             =   870
            Visible         =   0   'False
            Width           =   2265
            Begin VB.OptionButton ctlOP 
               Alignment       =   1  'Right Justify
               Appearance      =   0  'Flat
               BackColor       =   &H80000014&
               ForeColor       =   &H80000008&
               Height          =   330
               Index           =   0
               Left            =   45
               TabIndex        =   8
               Top             =   90
               Visible         =   0   'False
               Width           =   2165
            End
         End
         Begin CSHelp2.cHelp ctlHL 
            Height          =   315
            Index           =   0
            Left            =   915
            TabIndex        =   10
            Top             =   0
            Visible         =   0   'False
            Width           =   2235
            _ExtentX        =   3942
            _ExtentY        =   556
            BorderColor     =   12164479
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
         End
         Begin CSMaskEdit2.cMaskEdit ctlMKE 
            Height          =   315
            Index           =   0
            Left            =   915
            TabIndex        =   11
            Top             =   450
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
            BorderColor     =   12164479
            BorderType      =   1
            csNotRaiseError =   -1  'True
            ButtonStyle     =   0
         End
         Begin CSMaskEdit2.cMaskEdit ctlMEFE 
            Height          =   315
            Index           =   0
            Left            =   915
            TabIndex        =   12
            Top             =   2535
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
            BorderColor     =   12164479
            BorderType      =   1
            csNotRaiseError =   -1  'True
            ButtonStyle     =   0
         End
         Begin CSMaskEdit2.cMaskEdit ctlTXPassword 
            Height          =   315
            Index           =   0
            Left            =   915
            TabIndex        =   13
            Top             =   1815
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
            BorderColor     =   12164479
            BorderType      =   1
            csNotRaiseError =   -1  'True
            ButtonStyle     =   0
         End
         Begin CSMaskEdit2.cMaskEdit ctlTX 
            Height          =   315
            Index           =   0
            Left            =   915
            TabIndex        =   14
            Top             =   2955
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
            BorderColor     =   12164479
            BorderType      =   1
            csNotRaiseError =   -1  'True
            ButtonStyle     =   0
         End
         Begin VB.Label ctlLB 
            BackColor       =   &H80000014&
            Caption         =   "pirulo en pirulo por pirulo"
            Height          =   420
            Index           =   0
            Left            =   0
            TabIndex        =   15
            Top             =   135
            Visible         =   0   'False
            Width           =   1185
         End
      End
   End
   Begin CSGrid2.cGrid grItems 
      Height          =   1770
      Left            =   6345
      TabIndex        =   3
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
   Begin CSButton.cButton ctlcbTab 
      Height          =   330
      Index           =   0
      Left            =   90
      TabIndex        =   0
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
   Begin CSButton.cButton cmdSave 
      Height          =   330
      Left            =   2340
      TabIndex        =   1
      Top             =   4455
      Visible         =   0   'False
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
      TabIndex        =   2
      Top             =   4455
      Visible         =   0   'False
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
   Begin CSButton.cButton cmdHideParameters 
      Height          =   195
      Left            =   3180
      TabIndex        =   4
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
   Begin CSImageList.cImageList iList 
      Left            =   4680
      Top             =   1140
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   940
      Images          =   "cListDoc.ctx":0000
      KeyCount        =   1
      Keys            =   ""
   End
   Begin VB.Shape ctlShTab 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   4875
      Left            =   90
      Top             =   45
      Width           =   4200
   End
   Begin VB.Menu popGrid 
      Caption         =   "popGrid"
      Visible         =   0   'False
      Begin VB.Menu popGridTaskItem 
         Caption         =   "Item"
         Index           =   0
      End
      Begin VB.Menu popGridSep2 
         Caption         =   "-"
         Visible         =   0   'False
      End
      Begin VB.Menu popGridGrid 
         Caption         =   "&Grilla"
         Begin VB.Menu popGridGroup 
            Caption         =   "&Grupos..."
         End
         Begin VB.Menu popGridGroupEpand 
            Caption         =   "&Expandir Grupos"
         End
         Begin VB.Menu popGridGroupCollapse 
            Caption         =   "&Contraer Grupos"
         End
         Begin VB.Menu popGridGridSep 
            Caption         =   "-"
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
         Begin VB.Menu popGridHideCols 
            Caption         =   "Ocultar/Mostrar &Columnas..."
         End
      End
      Begin VB.Menu popGridAutoWidthCol 
         Caption         =   "&Ajustar el Ancho de las Columnas"
      End
      Begin VB.Menu popGridSep3 
         Caption         =   "-"
      End
      Begin VB.Menu popGridExportToExel 
         Caption         =   "&Exportar a Excel..."
      End
      Begin VB.Menu popGridSep4 
         Caption         =   "-"
      End
      Begin VB.Menu popGridViews 
         Caption         =   "&Vistas"
         Begin VB.Menu popGridViewSave 
            Caption         =   "&Guardar Vista..."
         End
         Begin VB.Menu popGridViewSaveAs 
            Caption         =   "Guardar Vista &Como..."
         End
         Begin VB.Menu popGridViewSep2 
            Caption         =   "-"
         End
         Begin VB.Menu popGridViewEdit 
            Caption         =   "&Editar Vista..."
         End
         Begin VB.Menu popGridViewSep3 
            Caption         =   "-"
         End
         Begin VB.Menu popGridViewDelete 
            Caption         =   "&Borrar Vista..."
         End
         Begin VB.Menu popGridViewSepItem 
            Caption         =   "-"
            Visible         =   0   'False
         End
         Begin VB.Menu popGridViewItem 
            Caption         =   "Item"
            Index           =   0
            Visible         =   0   'False
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

Public Enum IconList
  csIMG_PERSON = 5
  csIMG_REDCUBE = 6
  csIMG_ROLS = 7
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
Public Event TXButtonClick(Index As Integer, Cancel As Boolean)
Public Event TXPasswordChange(ByVal Index As Integer)
Public Event cbTabClick(ByVal Index As Integer)
Public Event GRClick(ByVal Index As Integer)
Public Event GrDblClick(ByVal Index As Integer)
Public Event HideParams()
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
Private m_Grid      As CSOAPI2.cGridManager
Private m_IconText  As Integer

Private m_ParamVisible As Boolean

Private m_sqlstmt As String

Private m_MaxHeightParam As Long

Private m_HelpType       As csHelpType

Private m_ObjClientMenu  As Object

Private m_grdv_id        As Long
Private m_ViewLoaded     As Boolean

Private m_bViewSelectedByMenu As Boolean

' eventos
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

Public Property Get SelectedRow() As Long
  SelectedRow = grItems.SelectedRow
End Property

Public Property Get RowIsGroup(ByVal iRow As Long) As Boolean
  RowIsGroup = grItems.RowIsGroup(iRow)
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

Public Property Get SelectedItemsLongColumn(ByVal strColName As String) As Long()
  Dim rtn() As Long
  
  If Not m_Grid.IdsLongColumn(grItems, strColName, rtn) Then
    ReDim rtn(0)
  End If
  
  SelectedItemsLongColumn = rtn
End Property

Public Sub ReloadParams()
  cmdDefaults_Click
End Sub

Public Sub SaveParams()
  cmdSave_Click
End Sub

Public Sub AddLine(ByVal Id As Long)
  On Error GoTo ControlError
  
  If Not m_ColumnsPresent Then Update False
  m_Grid.AddFromSqlstmt grItems, m_sqlstmt & " " & Id, m_ClientProperties
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddLine", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub RefreshLine(ByVal Id As Long)
  On Error GoTo ControlError
  
  If Not m_ColumnsPresent Then
    Update False
  End If
  
  m_Grid.UpdateFromSqlstmt grItems, m_sqlstmt & " " & Id, m_ClientProperties

  GoTo ExitProc
ControlError:
  MngError Err, "RefreshLine", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub CloseForm()

End Sub

Public Sub Update(Optional ByVal bSetFocus As Boolean = True)
  Dim sqlstmt   As String
  Dim bSetView  As Boolean
  Dim grdv_id   As Long
  
  RaiseEvent cmdRefresh(sqlstmt)
  
  pLoadViews bSetView
  
  m_Grid.LoadFromSqlstmtView grItems, _
                             sqlstmt, _
                             m_ClientProperties, _
                             bSetView, _
                             grdv_id
                             
  If bSetView Then
    SetActiveView grdv_id
  End If
  
  m_ColumnsPresent = True
  If bSetFocus Then SetFocusControl grItems
End Sub

Private Sub SetActiveView(ByVal grdv_id As Long)
  Dim i As Long
  
  pSetUncheckedViewItems
  
  With popGridViewItem
    For i = 1 To .Count - 1
      With .Item(i)
        If grdv_id = Abs(Val(.Tag)) Then
          m_grdv_id = grdv_id
          .Checked = True
        End If
      End With
    Next
  End With
  
  pSetViewEditDelete

End Sub

Private Function pLoadViews(ByRef bSetView As Boolean) As Boolean
  
  If Not m_ViewLoaded Then
    
    m_ViewLoaded = True
    m_Grid.LoadViews m_Name
    pCreateMenuViews
    pSetViewEditDelete
  
  End If
  
  bSetView = Not m_bViewSelectedByMenu
  
  pLoadViews = True
End Function

Public Sub ShowParameters()
  On Error Resume Next
  Dim c As Control
  
  For Each c In UserControl.Controls
    If LenB(c.Tag) _
       Or TypeOf c Is Shape _
       Or c Is picMain _
       Or c Is picParams Then
      
      If Not TypeOf c Is Menu Then
        c.Visible = True
      End If
    End If
  Next
    
  m_ParamVisible = True
  UserControl_Resize
End Sub

Public Sub HideParameters()
  On Error Resume Next
  Dim c As Control
  
  For Each c In UserControl.Controls
    If LenB(c.Tag) _
       Or TypeOf c Is Shape _
       Or c Is picMain _
       Or c Is picParams Then
       
      If Not TypeOf c Is Menu Then
        c.Visible = False
      End If
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
  MngError Err, "SavePreference", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub Remove(ByVal Id As Long)
  m_Grid.Remove grItems, Id
End Sub

Public Property Let MaxHeightParam(ByVal rhs As Long)
  m_MaxHeightParam = rhs
  UserControl_Resize
End Property

Public Sub SetForAbm()
  
  On Error Resume Next
  
  Dim c As Control
  
  For Each c In Me.Controls
    If TypeOf c Is CSHelp2.cHelp Then
      c.ForAbm = True
    End If
  Next
End Sub

Public Sub SetFocusFirstControl()
  On Error Resume Next
  
  Dim c As Control
  
  For Each c In UserControl.Controls
    If c.TabIndex = 0 And Not TypeOf c Is Label Then
      If c.Visible Then
        c.SetFocus
      End If
      Exit For
    End If
  Next
  Err.Clear
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
      MngError Err, "AddMenu", C_Module, LNGGetText(3221, vbNullString, MenuName)
                                         'Error al agregar un menú. Menu: & MenuName
      Exit Function
    End If
    SetVisibleMenu .UBound, True
    .Item(.UBound).Caption = MenuName
    AddMenu = .UBound
  End With
End Function

Public Function AddView(ByVal MenuName As String, _
                        ByVal Id As Long) As Long
  AddView = pAddView(MenuName, Id, False)
End Function

Private Function pAddView(ByVal MenuName As String, _
                          ByVal Id As Long, _
                          ByVal bPublica As Boolean) As Long
  On Error Resume Next
  Err.Clear
  With popGridViewItem
    Load .Item(.UBound + 1)
    If Err.Number Then
      MngError Err, "AddMenu", C_Module, LNGGetText(3221, vbNullString, MenuName)
                                          'Error al agregar un menu. Menu:  & MenuName
      Exit Function
    End If
    With .Item(.UBound)
      If bPublica Then
        .Caption = LNGGetText(3222, vbNullString, MenuName) 'MenuName &  (Publica)
        .Tag = -Id
      Else
        .Caption = MenuName
        .Tag = Id
      End If
      .Visible = True
    End With
    pAddView = .UBound
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
    If Index >= .LBound And Index <= .UBound Then
      .Item(Index).Visible = bState
    End If
    For i = .LBound + 1 To .UBound
      If .Item(i).Visible Then
        bVisible = True
        Err.Clear
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
End Sub

Private Sub pSetVisiblePopGridView()
  On Error Resume Next
  popGridViewSepItem.Visible = pExistsViewItemsVisible()
End Sub

Private Function pExistsViewItemsVisible() As Boolean
  On Error Resume Next
  
  Dim i         As Long
  Dim bVisible  As Boolean
  
  With popGridViewItem
    
    For i = .LBound + 1 To .UBound
      If .Item(i).Visible Then
        pExistsViewItemsVisible = True
        Err.Clear
        Exit Function
      End If
    Next
  End With
End Function

Private Sub cmdDefaults_Click()
  On Error Resume Next
  RaiseEvent cmdDescartar
End Sub

Private Sub cmdHideParameters_Click()
  On Error Resume Next
  RaiseEvent HideParams
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

Private Sub ctlTX_ButtonClick(Index As Integer, Cancel As Boolean)
  RaiseEvent TXButtonClick(Index, Cancel)
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

Private Sub popGridAutoWidthCol_Click()
  On Error Resume Next
  grItems.AutoWidthColumns
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

Private Sub popGridGroupCollapse_Click()
  On Error Resume Next
  grItems.CollapseAllGroups
End Sub

Private Sub popGridGroupEpand_Click()
  On Error Resume Next
  grItems.ExpandAllGroups
End Sub

Private Sub popGridHideCols_Click()
  On Error Resume Next
  grItems.HideColumns
End Sub

Private Sub popGridTaskItem_Click(Index As Integer)
  On Error Resume Next
  
  If m_ObjClientMenu Is Nothing Then Exit Sub
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  m_ObjClientMenu.ProcessMenu Index
End Sub

Private Sub popGridViewDelete_Click()
  On Error GoTo ControlError
  
  If m_grdv_id <> csNO_ID And m_grdv_id > 0 Then
    If m_Grid.DeleteView(m_grdv_id) Then
    
      pSetDeleteViewItem
      m_grdv_id = csNO_ID
      pSetViewEditDelete
    End If
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "popGridViewSave_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popGridViewEdit_Click()
  On Error GoTo ControlError

  pEditView m_grdv_id

  GoTo ExitProc
ControlError:
  MngError Err, "popGridViewSave_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popGridViewItem_Click(Index As Integer)
  On Error GoTo ControlError
  
  Dim grdv_id As Long
  
  pSetUncheckedViewItems
  
  grdv_id = Val(popGridViewItem.Item(Index).Tag)
  If m_Grid.SelectView(grItems, Abs(grdv_id)) Then
    m_grdv_id = grdv_id
    popGridViewItem.Item(Index).Checked = True
    m_bViewSelectedByMenu = True
  End If
  
  pSetViewEditDelete
  
  GoTo ExitProc
ControlError:
  MngError Err, "popGridViewItem_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popGridViewSave_Click()
  On Error GoTo ControlError

  If m_grdv_id = csNO_ID Or m_grdv_id < 0 Then

    pEditView csNO_ID
  
  Else
  
    pSaveView m_grdv_id
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "popGridViewSave_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popGridViewSaveAs_Click()
  On Error GoTo ControlError

  pEditView csNO_ID

  GoTo ExitProc
ControlError:
  MngError Err, "popGridViewSaveAs_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pCreateMenuViews()
  Dim View As cGridView
  
  For Each View In m_Grid.Views
    If Not (View.Publica And View.us_id <> User.Id) Then
      AddView View.Nombre, View.Id
    End If
  Next
  
  For Each View In m_Grid.Views
    If (View.Publica And View.us_id <> User.Id) Then
      pAddView View.Nombre, View.Id, True
    End If
  Next
  
  pSetVisiblePopGridView
End Sub

Private Function pEditView(ByVal grdv_id As Long) As Boolean
  On Error GoTo ControlError

  Dim objEdit As Object
  Dim IsNew   As Boolean
  Dim View    As cGridView
  
  Set objEdit = CSKernelClient2.CreateObject("CSGeneralEx2.cGridViewEdit")
  
  If grdv_id < 0 Then grdv_id = csNO_ID
  
  IsNew = grdv_id = csNO_ID
  
  objEdit.us_id = User.Id
  objEdit.grid_name = m_Name
  
  If objEdit.EditView(grdv_id) Then
  
    If IsNew Then
      
      pEditView = pSaveView(objEdit.Id)
      
      If m_Grid.LoadView(objEdit.Id, View) Then
      
        If Not View Is Nothing Then
          AddView View.Nombre, View.Id
          pSetVisiblePopGridView
        End If
      End If
    Else
      If Not View Is Nothing Then
        pUpdateViewItem View.Nombre
      End If
    End If
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSaveView", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSaveView(ByVal grdv_id As Long) As Boolean
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not m_Grid.SaveView(grItems, grdv_id) Then
    Exit Function
  End If

  pSaveView = True

  GoTo ExitProc
ControlError:
  MngError Err, "pSaveView", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSetViewEditDelete()
  If m_grdv_id = csNO_ID Or m_grdv_id < 0 Then
    popGridViewDelete.Caption = LNGGetText(3223, vbNullString) '&Borrar Vista
    popGridViewDelete.Enabled = False
    popGridViewEdit.Caption = LNGGetText(3224, vbNullString) '&Editar Vista...
    pSetVisiblePopGridView
  Else
    Dim ViewName As String
    ViewName = pGetSelectedView()
    popGridViewDelete.Caption = LNGGetText(3225, vbNullString, ViewName) '&Borrar Vista  & ViewName
    popGridViewDelete.Enabled = True
    popGridViewEdit.Caption = LNGGetText(3226, vbNullString, ViewName) '&Editar Vista & ViewName & ...
  End If
End Sub

Private Function pGetSelectedView() As String
  On Error Resume Next
  Dim i   As Long
  Dim Id  As Long
  
  For i = 1 To popGridViewItem.Count
    Id = 0
    Id = Val(popGridViewItem.Item(i).Tag)
    If Err.Number Then
      Err.Clear
    Else
      If Id = m_grdv_id Then
        pGetSelectedView = popGridViewItem.Item(i).Caption
        Exit Function
      End If
    End If
  Next
  Err.Clear
End Function

Private Sub pUpdateViewItem(ByVal ViewName As String)
  On Error Resume Next
  Dim i   As Long
  Dim Id  As Long
  
  For i = 1 To popGridViewItem.Count
    Id = 0
    Id = Val(popGridViewItem.Item(i).Tag)
    If Err.Number Then
      Err.Clear
    Else
      If Id = m_grdv_id Then
        popGridViewItem.Item(i).Caption = ViewName
        Exit Sub
      End If
    End If
  Next
  Err.Clear
End Sub

Private Sub pSetDeleteViewItem()
  On Error Resume Next
  Dim i   As Long
  Dim Id  As Long
  
  For i = 1 To popGridViewItem.Count
    Id = 0
    Id = Val(popGridViewItem.Item(i).Tag)
    If Err.Number Then
      Err.Clear
    Else
      If Id = m_grdv_id Then
        popGridViewItem.Item(i).Visible = False
        Exit Sub
      End If
    End If
  Next
  Err.Clear
End Sub

Private Sub pSetUncheckedViewItems()
  On Error Resume Next
  Dim i As Long
  For i = 1 To popGridViewItem.Count
    popGridViewItem.Item(i).Checked = False
  Next
  Err.Clear
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  
  With UserControl
    If m_ParamVisible Then
      ctlShTab.Move 40, 0, 4200, .ScaleHeight
      cmdHideParameters.Move 3785, 100
      grItems.Move ctlShTab.Width + 80, 0, .Width - (ctlShTab.Width + 80), .ScaleHeight
      cmdSave.Move ctlShTab.Width - 160 - cmdSave.Width, .Height - (160 + cmdSave.Height)
      cmdDefaults.Move cmdSave.Left - 60 - cmdDefaults.Width, .Height - (160 + cmdDefaults.Height)
  
      picMain.Height = cmdSave.Top - picMain.Top - 120
    
      If m_MaxHeightParam > picMain.ScaleHeight Then
        vscParams.Height = picMain.ScaleHeight
        
        ' Maximo desplazamiento vertical
        '
        If picMain.ScaleHeight > 1 Then
          vscParams.Max = m_MaxHeightParam - (picMain.ScaleHeight - 10)
        End If
        
        ' Tamaño de los desplazamientos maximo y minimo
        '
        vscParams.LargeChange = vscParams.Max / 2
        vscParams.SmallChange = vscParams.Max / 100
        
        vscParams.Visible = True
      Else
        vscParams.Visible = False
      End If
  
    Else
      grItems.Move 20, 0, .Width - 20, .ScaleHeight
    End If
  End With
End Sub

Private Sub vscParams_Change()
  On Error Resume Next
  picParams.Top = vscParams.Value * -1
End Sub

Private Sub vscParams_Scroll()
  On Error Resume Next
  picParams.Top = vscParams.Value * -1
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
  
  picMain.BorderStyle = 0
  picParams.BorderStyle = 0
  picParams.Height = 20000
  
  ctlFR(0).BackColor = vb3DHighlight
  ctlOP(0).BackColor = vb3DHighlight
  
  m_HelpType = csNormal
  
  ctlHL(0).ButtonStyle = cHelpButtonSingle
  ctlMEFE(0).ButtonStyle = cButtonSingle
  ctlMKE(0).ButtonStyle = cButtonSingle
  ctlHL(0).ForAbm = True

  grItems.ImageList = iList

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
