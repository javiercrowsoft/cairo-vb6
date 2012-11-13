VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.1#0"; "CSHelp2.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Object = "{059DDBAF-ED7D-4789-A31E-638692EFCEA2}#1.9#0"; "CSGridAdvanced2.ocx"
Begin VB.Form fWizard 
   ClientHeight    =   5040
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8520
   Icon            =   "fWizard.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   5040
   ScaleWidth      =   8520
   Begin VB.PictureBox FR 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   795
      Index           =   0
      Left            =   4740
      ScaleHeight     =   795
      ScaleWidth      =   1455
      TabIndex        =   21
      Top             =   960
      Visible         =   0   'False
      Width           =   1455
      Begin VB.OptionButton OP 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         BackColor       =   &H80000014&
         ForeColor       =   &H80000008&
         Height          =   330
         Index           =   0
         Left            =   45
         TabIndex        =   22
         Top             =   135
         Visible         =   0   'False
         Width           =   960
      End
   End
   Begin VB.ComboBox CB 
      Height          =   315
      Index           =   0
      Left            =   1755
      Style           =   2  'Dropdown List
      TabIndex        =   20
      Top             =   2880
      Visible         =   0   'False
      Width           =   2265
   End
   Begin CSButton.cButton CMD 
      Height          =   330
      Index           =   0
      Left            =   4725
      TabIndex        =   19
      Top             =   2880
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   582
      Caption         =   ""
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
   Begin CSButton.cButton cmdBack 
      Height          =   330
      Left            =   4140
      TabIndex        =   16
      Top             =   4620
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   582
      Caption         =   "&Atras"
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
   Begin CSMaskEdit2.cMultiLine TXM 
      Height          =   285
      Index           =   0
      Left            =   4740
      TabIndex        =   15
      Top             =   3300
      Visible         =   0   'False
      Width           =   2235
      _ExtentX        =   3942
      _ExtentY        =   503
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
      MultiLine       =   -1  'True
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      BorderColor     =   12164479
      BorderType      =   1
   End
   Begin MSComctlLib.ProgressBar prgBar 
      Height          =   285
      Index           =   0
      Left            =   1710
      TabIndex        =   9
      Top             =   3285
      Visible         =   0   'False
      Width           =   2400
      _ExtentX        =   4233
      _ExtentY        =   503
      _Version        =   393216
      Appearance      =   0
      Scrolling       =   1
   End
   Begin VB.CheckBox CHK 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   285
      Index           =   0
      Left            =   1755
      TabIndex        =   2
      Top             =   2475
      Visible         =   0   'False
      Width           =   345
   End
   Begin CSMaskEdit2.cMaskEdit ME 
      Height          =   285
      Index           =   0
      Left            =   1620
      TabIndex        =   1
      Top             =   1620
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
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
   Begin CSMaskEdit2.cMaskEdit MEFE 
      Height          =   285
      Index           =   0
      Left            =   4725
      TabIndex        =   4
      Top             =   2160
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
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
   Begin CSMaskEdit2.cMaskEdit txPassword 
      Height          =   285
      Index           =   0
      Left            =   4725
      TabIndex        =   5
      Top             =   1800
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
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
      PasswordChar    =   "*"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit TX 
      Height          =   285
      Index           =   0
      Left            =   4725
      TabIndex        =   6
      Top             =   2520
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
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
      PasswordChar    =   "*"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   0
      Left            =   60
      TabIndex        =   12
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   2963
      _ExtentY        =   582
      Caption         =   ""
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
      TabButton       =   -1  'True
      TabSelected     =   -1  'True
      BackColor       =   -2147483643
      BackColorPressed=   -2147483643
   End
   Begin CSHelp2.cHelp HL 
      Height          =   315
      Index           =   0
      Left            =   1680
      TabIndex        =   14
      Top             =   1035
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
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
   Begin CSGridAdvanced2.cGridAdvanced GR 
      Height          =   3015
      Index           =   0
      Left            =   7080
      TabIndex        =   13
      Top             =   1080
      Visible         =   0   'False
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   5318
   End
   Begin CSButton.cButton cmdNext 
      Height          =   330
      Left            =   5490
      TabIndex        =   17
      Top             =   4620
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Siguiente"
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
   Begin CSButton.cButton cmdCancel 
      Height          =   330
      Left            =   7155
      TabIndex        =   18
      Top             =   4620
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Cancelar"
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
   Begin VB.Image ImgWiz3 
      Height          =   765
      Left            =   3540
      Picture         =   "fWizard.frx":058A
      Top             =   1440
      Visible         =   0   'False
      Width           =   1065
   End
   Begin VB.Shape shBack 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   330
      Left            =   7695
      Top             =   270
      Width           =   285
   End
   Begin VB.Image ImgWiz5 
      Height          =   480
      Left            =   0
      Picture         =   "fWizard.frx":0D71
      Top             =   0
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImgWiz1 
      Height          =   4365
      Left            =   0
      Picture         =   "fWizard.frx":163B
      Top             =   0
      Visible         =   0   'False
      Width           =   2505
   End
   Begin VB.Label lbTitleEx2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   330
      Left            =   4635
      TabIndex        =   11
      Top             =   45
      Width           =   75
   End
   Begin VB.Label LBDescrip 
      BackStyle       =   0  'Transparent
      Caption         =   "pirulo en pirulo por pirulo"
      ForeColor       =   &H00000000&
      Height          =   690
      Left            =   1710
      TabIndex        =   10
      Top             =   945
      Visible         =   0   'False
      Width           =   6090
   End
   Begin VB.Image Img 
      Height          =   375
      Index           =   0
      Left            =   405
      Top             =   3375
      Visible         =   0   'False
      Width           =   555
   End
   Begin VB.Label lbTitle2 
      BackStyle       =   0  'Transparent
      Caption         =   "Tercero"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   330
      Index           =   0
      Left            =   720
      TabIndex        =   8
      Top             =   45
      Visible         =   0   'False
      Width           =   1005
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "pirulo en pirulo por pirulo"
      ForeColor       =   &H00000000&
      Height          =   420
      Index           =   0
      Left            =   360
      TabIndex        =   7
      Top             =   1845
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      Caption         =   "pirulo en pirulo por pirulo"
      ForeColor       =   &H00000000&
      Height          =   420
      Index           =   0
      Left            =   360
      TabIndex        =   3
      Top             =   1035
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000E&
      X1              =   135
      X2              =   6660
      Y1              =   4500
      Y2              =   4500
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   135
      X2              =   6660
      Y1              =   4485
      Y2              =   4485
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   90
      Picture         =   "fWizard.frx":45BC
      Top             =   0
      Width           =   480
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Tercero"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   330
      Left            =   720
      TabIndex        =   0
      Top             =   45
      Width           =   1005
   End
   Begin VB.Shape shTitle 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   510
      Left            =   -45
      Tag             =   "-1000"
      Top             =   0
      Width           =   6975
   End
   Begin VB.Shape ShTab 
      BackColor       =   &H00C0E0FF&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   3390
      Left            =   90
      Top             =   855
      Width           =   8340
   End
   Begin VB.Menu popGrid 
      Caption         =   "popGrid"
      Visible         =   0   'False
      Begin VB.Menu popGridAutoSizeWidth 
         Caption         =   "&Ajustar el Ancho de las Columnas"
      End
      Begin VB.Menu popGridSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popGridExportToExcel 
         Caption         =   "&Exportar a Excel..."
      End
   End
End
Attribute VB_Name = "fWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fABM
' 14-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
'    Private Const conHwndTopmost = -1
'    Private Const conHwndNoTopmost = -2
'    Private Const conSwpNoActivate = &H10
'    Private Const conSwpShowWindow = &H40
'    ' estructuras
'    ' funciones
'    Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fWizard"

Private Const c_margin_bottom_grid = 250

' estructuras
Private Type T_GridInfo
  GridObj             As Object
  OriginalHeight      As Long
  OriginalBottom      As Long
  OriginalWidth       As Long
  OriginalTop         As Long
  OriginalLeft        As Long
  TabIndex            As Long
  TabFatherInex       As Long
  bDontResize         As Boolean
  bDontResizeHeight   As Boolean
End Type

Private Type t_CtrlsUnderGrid
  ctrlName    As String
  ctrlBottom  As Long
  ctrlIndex   As Long
End Type

' variables privadas
Private m_oldCB()           As String
'Private m_oldCBhock()      As String
Private m_oldME()           As String
Private m_oldMEFE()         As String
Private m_oldOP()           As String
Private m_oldTX()           As String
Private m_oldTXM()          As String
Private m_oldTXPassword()   As String
Private m_WasActivated      As Boolean

Private m_ActiveGrid          As cGridAdvanced
Private m_vGridInfo()         As T_GridInfo
Private m_vCtrlsUnderGrid()   As t_CtrlsUnderGrid

' Controles
Private WithEvents m_Toolbar  As Toolbar
Attribute m_Toolbar.VB_VarHelpID = -1
Private m_ToolBars            As Collection
Private m_FramesToolBar       As Collection
Private m_NextToolBar         As Integer
Private m_NextFrameToolBar    As Integer

Private m_OriginalShapeBottom       As Integer
Private m_OriginalButtonsBottom     As Integer
Private m_OriginalLinesBottom       As Integer

Private m_lastTabIndex As Long

' eventos
Public Event CBChange(ByVal Index As Integer)
'Public Event CBhockChange(ByVal Index As Integer)
Public Event CHKClick(ByVal Index As Integer)
Public Event cmdNextClick()
Public Event cmdBackClick()
Public Event cmdCancelClick()
Public Event HLChange(ByVal Index As Integer)
Public Event MEChange(ByVal Index As Integer)
Public Event MEDateChange(ByVal Index As Integer)
Public Event OPClick(ByVal Index As Integer)
Public Event TXChange(ByVal Index As Integer)
Public Event TXMChange(ByVal Index As Integer)
Public Event TXPasswordChange(ByVal Index As Integer)
Public Event FormUnload(ByRef Cancel As Integer)
Public Event FormLoad()
Public Event FormQueryUnload(ByRef Cancel As Integer, ByVal UnloadMode As Integer)
Public Event cbTabClick(ByVal Index As Integer)
Public Event CMDClick(ByVal Index As Integer)

Public Event ToolBarButtonClick(ByVal Button As MSComctlLib.Button)

Public Event GRColumnAfterEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, ByRef bCancel As Boolean)
Public Event GRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
Public Event GRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)

Public Event GRClick(ByVal Index As Integer)
Public Event GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)
Public Event GRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, ByRef bCancel As Boolean)
Public Event GRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
Public Event GRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
Public Event GRRowWasDeleted(ByVal Index As Integer, ByVal RowIndex As Long)
Public Event GRSelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
Public Event GRSelectionColChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
Public Event GRSelectionRowChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
Public Event GRColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)

Public Event TabGetFirstCtrl(ByVal Index As Integer, ByRef ctrl As Control)

' propiedades publicas
Public ABMObject As Object

' NO BORRAR es parte de la interfaz generica de los forms de abm
'           solo se usa en fABMDoc
Public Property Let Loading(ByVal rhs As Boolean)
End Property

' propiedades privadas
' funciones publicas
Public Function GetToolBar() As Toolbar
  Set GetToolBar = m_Toolbar
End Function

Public Sub UnLoadToolbar()
  Dim o As Control
  
  With Me.Controls
    For Each o In m_ToolBars
      .Remove o
    Next
    For Each o In m_FramesToolBar
      .Remove o
    Next
  End With
  
  CollClear m_FramesToolBar
  CollClear m_ToolBars
End Sub

Public Sub SetToolbar(ByRef Tbl As Toolbar)
  Set m_Toolbar = Tbl
End Sub

Public Function LoadToolbar(ByRef frToolBar As Frame) As Toolbar
  Dim f As Frame
  Dim t As Toolbar
  
  With Me.Controls
    Set f = .Add("VB.Frame", pGetFrameToolBarName)
    m_FramesToolBar.Add f
    Set t = .Add("MSComctlLib.Toolbar", pGetToolBarName, f)
    m_ToolBars.Add t
  End With
  
  Set frToolBar = f
  Set LoadToolbar = t
End Function

Public Sub SetFocusFirstControl()
  On Error Resume Next
  
  Dim c As Control
  
  For Each c In Me.Controls
    If Not TypeOf c Is Timer Then
      With c
        If .TabIndex = 0 And Not TypeOf c Is Label Then
          If c.Visible Then
            .SetFocus
            Exit For
          End If
        End If
      End With
    End If
  Next
End Sub

Public Function CtrlKeySave() As Boolean
  CtrlKeySave = True
End Function

Public Function CtrlKeyNew() As Boolean
  CtrlKeyNew = True
End Function

Public Function CtrlKeyCopy() As Boolean
  CtrlKeyCopy = True
End Function

Public Function CtrlKeyRefresh() As Boolean
  CtrlKeyRefresh = True
End Function

Public Function CtrlKeyClose() As Boolean
  CtrlKeyClose = True
End Function

Public Sub ShowForm()
  pCreateGridVector
End Sub

Public Property Let SetDontResize(ByVal Index As Long, ByVal rhs As Boolean)
  If UBound(m_vGridInfo) < Index Then
  
    ' Inicialmente cuando solo existia
    ' una grilla, siempre se redimencionaba
    ' ahora si en un form con una sola grilla
    ' se indica que no se redimencione se
    ' crea en este punto el vector gridinfo
    ' y listo
    '
    If Index = 1 And UBound(m_vGridInfo) = 0 Then
      pCreateGridVecAux
    Else
      Exit Property
    End If
  End If
  m_vGridInfo(Index).bDontResize = rhs
End Property

Public Property Let SetDontResizeHeight(ByVal Index As Long, ByVal rhs As Boolean)
  If UBound(m_vGridInfo) < Index Then
  
    ' Inicialmente cuando solo existia
    ' una grilla, siempre se redimencionaba
    ' ahora si en un form con una sola grilla
    ' se indica que no se redimencione se
    ' crea en este punto el vector gridinfo
    ' y listo
    '
    If Index = 1 And UBound(m_vGridInfo) = 0 Then
      pCreateGridVecAux
    Else
      Exit Property
    End If
  End If
  m_vGridInfo(Index).bDontResizeHeight = rhs
End Property

Private Sub pCreateGridVecAux()
  ReDim Preserve m_vGridInfo(1)
  With m_vGridInfo(UBound(m_vGridInfo))
    Dim ctl As Control
    Set ctl = GR(0)
    Set .GridObj = ctl
    .OriginalHeight = ctl.Height
    .OriginalBottom = Line1.Y1 - ctl.Top - ctl.Height
    .OriginalLeft = ctl.Left
    .OriginalTop = ctl.Top
    .OriginalWidth = ctl.Width
    .TabIndex = Val(ctl.Tag)
    .TabFatherInex = pGetFatherIndex(Val(ctl.Tag))
  End With
End Sub

Public Sub FirstResize()
  Form_Resize
End Sub

' funciones privadas
Private Sub CB_Click(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldCB) < Index Then ReDim Preserve m_oldCB(Index)
  RaiseEvent CBChange(Index)
  m_oldCB(Index) = CB(Index).Text
ControlError:
End Sub
Private Sub CB_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldCB) < Index Then ReDim Preserve m_oldCB(Index)
  m_oldCB(Index) = CB(Index).Text
ControlError:
End Sub
Private Sub CB_LostFocus(Index As Integer)
  If m_oldCB(Index) = CB(Index).Text Then Exit Sub
  RaiseEvent CBChange(Index)
End Sub

'Private Sub CBhock_GotFocus(Index As Integer)
'  On Error GoTo ControlError
'  If UBound(m_oldCBhock) < Index Then ReDim Preserve m_oldCBhock(Index)
'  m_oldCBhock(Index) = CBhock(Index).Text
'ControlError:
'End Sub
'Private Sub CBhock_LostFocus(Index As Integer)
'  If m_oldCBhock(Index) = CBhock(Index).Text Then Exit Sub
'  RaiseEvent CBhockChange(Index)
'End Sub

Private Sub cbTab_Click(Index As Integer)
  RaiseEvent cbTabClick(Index)
End Sub

Private Sub CHK_Click(Index As Integer)
  RaiseEvent CHKClick(Index)
End Sub

Private Sub CMD_Click(Index As Integer)
  RaiseEvent CMDClick(Index)
End Sub

Private Sub cmdNext_Click()
  RaiseEvent cmdNextClick
End Sub

Private Sub cmdCancel_Click()
  RaiseEvent cmdCancelClick
End Sub

Private Sub cmdBack_Click()
  RaiseEvent cmdBackClick
End Sub

Private Sub GR_MouseDown(Index As Integer, Button As Integer, Shift As Integer, x As Single, y As Single, bDoDefault As Boolean)
  On Error Resume Next
  Set m_ActiveGrid = GR(Index)
  If Button = vbRightButton Then
    Me.PopupMenu popGrid
    bDoDefault = False
  End If
End Sub

Private Sub popGridAutoSizeWidth_Click()
  On Error Resume Next
  m_ActiveGrid.AutoWidthColumns
End Sub

Private Sub popGridExportToExcel_Click()
  On Error Resume Next
  Dim Export As cExporToExcel
  Set Export = New cExporToExcel
  
  Export.ShowDialog = True
  Export.Export dblExGridAdvanced, "", m_ActiveGrid
End Sub

Private Sub Form_Activate()
  If m_WasActivated Then Exit Sub
  m_WasActivated = True
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me

  On Error Resume Next
  
  If Shift And vbCtrlMask Then
    Select Case KeyCode
      Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9
        pMoveTab KeyCode - vbKey0
        KeyCode = 0
        
      Case vbKeyPageDown
        pMoveTab c_tab_move_next
        
      Case vbKeyPageUp
        pMoveTab c_tab_move_previous
        
      Case vbKeyTab
        If Shift And vbShiftMask Then
          pMoveTab c_tab_move_previous
        Else
          pMoveTab c_tab_move_next
        End If
        KeyCode = 0
    End Select
  
  End If

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  RaiseEvent FormQueryUnload(Cancel, UnloadMode)
  If Cancel Then
    gUnloadCancel = True
  End If
End Sub

Private Sub GR_ColumnAfterEdit(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  RaiseEvent GRColumnAfterEdit(Index, lRow, lCol, NewValue, NewValueID, bCancel)
End Sub

Private Sub GR_ColumnAfterUpdate(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  RaiseEvent GRColumnAfterUpdate(Index, lRow, lCol, NewValue, NewValueID)
End Sub

Private Sub GR_ColumnBeforeEdit(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  RaiseEvent GRColumnBeforeEdit(Index, lRow, lCol, iKeyAscii, bCancel)
End Sub

Private Sub GR_ColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  RaiseEvent GRColumnButtonClick(Index, lRow, lCol, iKeyAscii, bCancel)
End Sub

Private Sub GR_ColumnClick(Index As Integer, ByVal lCol As Long)
  RaiseEvent GRClick(Index)
End Sub

Private Sub GR_DblClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  RaiseEvent GRDblClick(Index, lRow, lCol)
End Sub

Private Sub GR_DeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  RaiseEvent GRDeleteRow(Index, lRow, bCancel)
End Sub

Private Sub GR_GotFocus(Index As Integer)
  On Error Resume Next
  
  If GR(Index).SelectedRow = 0 Then
    GR(Index).SelectedRow = 1
    GR(Index).SelectedCol = 2
  End If
End Sub

Private Sub GR_RowWasDeleted(Index As Integer, ByVal lRow As Long)
  RaiseEvent GRRowWasDeleted(Index, lRow)
End Sub

Private Sub GR_NewRow(Index As Integer, ByVal lRow As Long)
  RaiseEvent GRNewRow(Index, lRow)
End Sub

Private Sub GR_SelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  RaiseEvent GRSelectionChange(Index, lRow, lCol)
End Sub

Private Sub GR_SelectionColChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  RaiseEvent GRSelectionColChange(Index, lRow, lCol)
End Sub

Private Sub GR_SelectionRowChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  RaiseEvent GRSelectionRowChange(Index, lRow, lCol)
End Sub

Private Sub GR_ValidateRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  RaiseEvent GRValidateRow(Index, lRow, bCancel)
End Sub

Private Sub HL_Change(Index As Integer)
  RaiseEvent HLChange(Index)
End Sub

Private Sub m_ToolBar_ButtonClick(ByVal Button As MSComctlLib.Button)
  RaiseEvent ToolBarButtonClick(Button)
End Sub

Private Sub ME_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldME) < Index Then ReDim Preserve m_oldME(Index)
  m_oldME(Index) = Me.ME(Index).csValue
ControlError:
End Sub

Private Sub ME_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldME(Index) = Me.ME(Index).csValue Then Exit Sub
  RaiseEvent MEChange(Index)
ControlError:
End Sub

Private Sub MEFE_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldMEFE) < Index Then ReDim Preserve m_oldMEFE(Index)
  m_oldMEFE(Index) = Me.MEFE(Index).csValue
ControlError:
End Sub

Private Sub MEFE_LostFocus(Index As Integer)
  If m_oldMEFE(Index) = Me.MEFE(Index).csValue Then Exit Sub
  RaiseEvent MEDateChange(Index)
End Sub

Private Sub OP_Click(Index As Integer)
  RaiseEvent OPClick(Index)
End Sub

Private Sub TX_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTX) < Index Then ReDim Preserve m_oldTX(Index)
  m_oldTX(Index) = TX(Index).Text
ControlError:
End Sub

Private Sub TX_ReturnFromHelp(Index As Integer)
  On Error GoTo ControlError
  
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  RaiseEvent TXChange(Index)
  m_oldTX(Index) = TX(Index).Text

  Exit Sub
ControlError:
  MngError Err, "m_FormWizard_TXChange", C_Module, ""
End Sub

Private Sub TXM_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTXM) < Index Then ReDim Preserve m_oldTXM(Index)
  m_oldTXM(Index) = TXM(Index).Text
ControlError:
End Sub

Private Sub TXM_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldTXM(Index) = TXM(Index).Text Then Exit Sub
  RaiseEvent TXMChange(Index)
ControlError:
End Sub

Private Sub TXPassword_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTXPassword) < Index Then ReDim Preserve m_oldTXPassword(Index)
  m_oldTXPassword(Index) = txPassword(Index).Text
ControlError:
End Sub

Private Sub TX_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  RaiseEvent TXChange(Index)
ControlError:
End Sub

Private Sub TXPassword_LostFocus(Index As Integer)
  If m_oldTXPassword(Index) = txPassword(Index).Text Then Exit Sub
  RaiseEvent TXPasswordChange(Index)
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim lockwnd As cLockUpdateWindow
  Set lockwnd = New cLockUpdateWindow
  
  lockwnd.LockW Me.hWnd
  
  If WindowState = vbMinimized Then Exit Sub
  
  shTitle.Move 0, 0, ScaleWidth
  
  Dim i As Long
  Dim ctl As Control
  
  For i = 1 To UBound(m_vCtrlsUnderGrid)
    For Each ctl In Me.Controls
      If m_vCtrlsUnderGrid(i).ctrlName = ctl.Name _
         And m_vCtrlsUnderGrid(i).ctrlIndex = pGetIndex(ctl) Then
        
        pSetTop ctl, Me.ScaleHeight - m_vCtrlsUnderGrid(i).ctrlBottom
        Exit For
      End If
    Next
  Next
  
  With Line1
    .Y1 = Me.ScaleHeight - m_OriginalLinesBottom
    .Y2 = .Y1
    Line2.Y1 = .Y1 + 10
    Line2.Y2 = Line2.Y1
  
    .X1 = 0
    .X2 = ScaleWidth
    Line2.X1 = 0
    Line2.X2 = ScaleWidth
  End With
  
  With cmdCancel
    .Top = Me.ScaleHeight - m_OriginalButtonsBottom - .Height
    cmdNext.Top = .Top
    cmdBack.Top = .Top
    
    .Left = ScaleWidth - 480 - .Width
  End With
  
  With cmdNext
    .Left = cmdCancel.Left - .Width - 250
    cmdBack.Left = .Left - cmdBack.Width - 80
  End With

  With shBack
    .Move 0, 0, Me.ScaleWidth, Line2.Y1 - 20
  End With
  
  For Each ctl In Controls
    If TypeOf ctl Is cGridAdvanced Then
      
      Dim nHeight As Long
    
      With ctl
        If Not pInGridInfo(ctl) Then
          
          .Height = ScaleHeight - .Top - m_OriginalShapeBottom - c_margin_bottom_grid
          
          If .Left < 3000 Then
            .Width = Me.ScaleWidth - .Left * 2
          Else
            .Width = Me.ScaleWidth - .Left - 300
          End If
        Else
          With pGetGridInfo(ctl)
            If Not .bDontResize Then
              ctl.Width = Me.ScaleWidth - ctl.Left * 2
            End If
            If Not .bDontResizeHeight Then
              
              nHeight = ScaleHeight - ctl.Top - m_OriginalShapeBottom - c_margin_bottom_grid
            
              If ctl.Top + nHeight > Me.Line1.Y1 - .OriginalBottom Then
                ctl.Height = Me.Line1.Y1 - .OriginalBottom - ctl.Top
              Else
                ctl.Height = nHeight
              End If
            
            End If
          End With
        End If
      End With
    End If
  Next
  
  With Me.ShTab
    .Move .Left, .Top, Me.ScaleWidth - .Left * 2, Line1.Y1 - 20
  End With
End Sub

Private Function pGetFrameToolBarName() As String
  pGetFrameToolBarName = "FrameToolBar" & m_NextFrameToolBar
  m_NextFrameToolBar = m_NextFrameToolBar + 1
End Function

Private Function pGetToolBarName() As String
  pGetToolBarName = "ToolBar" & m_NextToolBar
  m_NextToolBar = m_NextToolBar + 1
End Function

Private Function pInGridInfo(ByVal ctl As Control) As Boolean
  pInGridInfo = pGetGridInfoIndex(ctl)
End Function

Private Function pGetGridInfo(ByVal ctl As Control) As T_GridInfo
  Dim i As Long
  i = pGetGridInfoIndex(ctl)
  pGetGridInfo = m_vGridInfo(i)
End Function

Private Function pGetGridInfoIndex(ByVal ctl As Control) As Long
  Dim i As Long
  For i = 1 To UBound(m_vGridInfo)
    If m_vGridInfo(i).GridObj Is ctl Then
      pGetGridInfoIndex = i
      Exit Function
    End If
  Next
End Function

Private Sub pCreateGridVector()
  On Error GoTo ControlError

  Dim ctl       As Control
  Dim i         As Long
  Dim j         As Long
  Dim bFound    As Boolean
  
  ReDim m_vGridInfo(0)
  
  For Each ctl In Controls
    If TypeOf ctl Is cGridAdvanced Then
      ReDim Preserve m_vGridInfo(UBound(m_vGridInfo) + 1)
      With m_vGridInfo(UBound(m_vGridInfo))
        Set .GridObj = ctl
        .OriginalHeight = ctl.Height
        .OriginalBottom = Line1.Y1 - ctl.Top - ctl.Height
        .OriginalLeft = ctl.Left
        .OriginalTop = ctl.Top
        .OriginalWidth = ctl.Width
        .TabIndex = Val(ctl.Tag)
        .TabFatherInex = pGetFatherIndex(Val(ctl.Tag))
      End With
    End If
  Next
  
  Dim TabIndex As Long
  
  For i = 1 To UBound(m_vGridInfo) - 1
    TabIndex = m_vGridInfo(i).TabIndex
    For j = i + 1 To UBound(m_vGridInfo)
      If TabIndex = m_vGridInfo(j).TabIndex Then
        With m_vGridInfo(i)
          .bDontResizeHeight = True
        End With
        With m_vGridInfo(j)
          .bDontResizeHeight = True
        End With
      End If
    Next
  Next
  
  ' Armo un vector con todos los
  ' controles que estan debajo de una grilla
  '
  For Each ctl In Me.Controls
    For i = 1 To UBound(m_vGridInfo)
      
'      Debug.Print ctl.Name
'      If TypeOf ctl Is Label Then Debug.Print ctl.Caption
'      If TypeOf ctl Is cButton Or TypeOf ctl Is cButtonLigth Then
'        If ctl.Caption = "Marcar Todas" Then Stop
'      End If
      
      If Val(ctl.Tag) = m_vGridInfo(i).TabIndex _
        Or Val(ctl.Tag) = m_vGridInfo(i).TabFatherInex Then
        If pGetTop(ctl) + 300 > m_vGridInfo(i).OriginalTop _
                        + m_vGridInfo(i).OriginalHeight Then
          
          If i = 1 Then
            With m_vGridInfo(i)
              If pGetTop(ctl) < (.OriginalTop + .OriginalHeight) Then
                              
                .OriginalHeight = pGetTop(ctl) - .OriginalTop - 100
                .OriginalBottom = Line1.Y1 - .OriginalTop - .OriginalHeight
                If Not .GridObj Is Nothing Then
                  .GridObj.Height = .OriginalHeight
                End If
              End If
            End With
          End If
          
          ReDim Preserve m_vCtrlsUnderGrid(UBound(m_vCtrlsUnderGrid) + 1)
          With m_vCtrlsUnderGrid(UBound(m_vCtrlsUnderGrid))
            .ctrlName = ctl.Name
            .ctrlIndex = pGetIndex(ctl)
            
            ' Me guardo su bottom para que siempre
            ' esten a la misma distancia del borde
            ' inferior de la ventana
            '
            .ctrlBottom = Me.ScaleHeight - pGetTop(ctl) - pGetHeight(ctl)
          End With
        End If
      End If
    Next
  Next
  
  Dim LastGridIndex As Long
  
  For i = 1 To UBound(m_vGridInfo)
    TabIndex = m_vGridInfo(i).TabIndex
    LastGridIndex = i
    For j = i + 1 To UBound(m_vGridInfo)
      If TabIndex = m_vGridInfo(j).TabIndex Then
        LastGridIndex = j
      End If
    Next
  
    m_vGridInfo(LastGridIndex).bDontResizeHeight = False
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "pCreateGridVector", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetTop(ByRef ctl As Control) As Long
  On Error Resume Next
  pGetTop = ctl.Top
  Err.Clear
End Function

Private Function pGetHeight(ByRef ctl As Control) As Long
  On Error Resume Next
  pGetHeight = ctl.Height
  Err.Clear
End Function

Private Function pGetIndex(ByRef ctl As Control) As Long
  On Error Resume Next
  pGetIndex = ctl.Index
  If Err.Number Then
    Err.Clear
    pGetIndex = -1
  End If
End Function

Private Sub pSetTop(ByRef ctl As Control, ByVal Top As Long)
  On Error Resume Next
  ctl.Top = Top - ctl.Height
  Err.Clear
End Sub

Private Function pGetFatherIndex(ByVal Tag As Long) As Long
  If Tag > 0 Then Exit Function
  
  Dim ctl As Control
  Dim ChildIndex  As Long
  Dim FatherIndex As Long
  
  For Each ctl In Me.Controls
    If TypeOf ctl Is CSButton.cButton Then
      If ctl.Name = "cbTab" Then
        
        If InStr(1, ctl.Tag, c_InerTab) Then
          
          ChildIndex = GetTagChildIndex(ctl.Tag)
          FatherIndex = GetTagFatherIndex(ctl.Tag)
          
          If ChildIndex = Tag Then
          
            pGetFatherIndex = FatherIndex
            Exit Function
          End If
        End If
      End If
    End If
  Next
  
  pGetFatherIndex = -1000
  
End Function

Private Sub pMoveTab(ByVal iWhere As Integer)
  On Error Resume Next
  
  If iWhere = 0 Then Exit Sub
  
  Err.Clear
  
  Dim ctl         As Control
  Dim cTab        As cButton
  Dim iTabIndex   As Long
  Dim TabIndexTab As Long
  Dim i           As Long
  Dim n           As Long
  
  iTabIndex = -1
  
  If iWhere = c_tab_move_next Or iWhere = c_tab_move_previous Then
  
    If iWhere = c_tab_move_next Then
  
      iTabIndex = m_lastTabIndex + 1
      If iTabIndex > cbTab.UBound Then iTabIndex = cbTab.LBound
  
    Else 'c_tab_move_previous Then
    
      iTabIndex = m_lastTabIndex - 1
      If iTabIndex < cbTab.LBound Then iTabIndex = cbTab.UBound

    End If
  
  Else
    iTabIndex = iWhere
  End If
  
  If iTabIndex >= 0 Then
    If iTabIndex >= cbTab.LBound And iTabIndex <= cbTab.UBound Then
      
      For i = cbTab.LBound To cbTab.UBound
        If cbTab(i).Visible Then
          n = InStr(1, cbTab(i).Caption, "-")
          TabIndexTab = Val(Mid$(cbTab(i).Caption, 2, n - 2))
          If TabIndexTab = iTabIndex Then
            iTabIndex = cbTab(i).Index
            Exit For
          End If
        End If
      Next
      
      If Me.cbTab(iTabIndex).Visible = False Then Exit Sub
      
      Me.cbTab(iTabIndex).Push
      If Err.Number = 0 Then
        Dim ctrl As Control
        RaiseEvent TabGetFirstCtrl(iTabIndex, ctrl)
        If Not ctrl Is Nothing Then
          SetFocusControl ctrl
          DoEvents
          If TypeOf ctrl Is cGridAdvanced Then
            If ctrl.SelectedCol = 2 And ctrl.SelectedRow = 1 Then
              SendKeys "{ENTER}"
            End If
          End If
        End If
      End If
      m_lastTabIndex = iTabIndex
    End If
  End If
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  ReDim m_oldCB(0)
  'ReDim m_oldCBhock(0)
  ReDim m_oldME(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldOP(0)
  ReDim m_oldTX(0)
  ReDim m_oldTXM(0)
  ReDim m_oldTXPassword(0)
  ReDim m_vGridInfo(0)
  ReDim m_vCtrlsUnderGrid(0)
    
  With Me
    
    .FR(0).BackColor = vb3DHighlight
    .OP(0).BackColor = vb3DHighlight
    
    Set m_FramesToolBar = New Collection
    Set m_ToolBars = New Collection
    
    m_WasActivated = False
  
    m_OriginalShapeBottom = .ScaleHeight - ShTab.Height - ShTab.Top
    m_OriginalButtonsBottom = .ScaleHeight - cmdCancel.Height - cmdCancel.Top
    m_OriginalLinesBottom = .ScaleHeight - Line1.Y1 - Line1.BorderWidth
  End With

  RaiseEvent FormLoad
  
  shTitle.ZOrder
  shTitle.Height = 1000
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  ReDim m_oldCB(0)
  'ReDim m_oldCBhock(0)
  ReDim m_oldME(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldOP(0)
  ReDim m_oldTX(0)
  ReDim m_oldTXM(0)
  ReDim m_oldTXPassword(0)
  ReDim m_vGridInfo(0)
  ReDim m_vCtrlsUnderGrid(0)
  
  Set ABMObject = Nothing
  
  Set m_FramesToolBar = Nothing
  Set m_ToolBars = Nothing
  Set m_Toolbar = Nothing
  Set m_ActiveGrid = Nothing

  RaiseEvent FormUnload(Cancel)
  CSKernelClient2.UnloadForm Me, "ABM_" & Me.Caption
  
  Set fWizard = Nothing
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbTerminateInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbInitInstance C_Module
End Sub
#End If
