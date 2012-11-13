VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.1#0"; "CSHelp2.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Object = "{059DDBAF-ED7D-4789-A31E-638692EFCEA2}#1.9#0"; "CSGridAdvanced2.ocx"
Begin VB.Form fABMDoc 
   ClientHeight    =   6645
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11595
   Icon            =   "fABMDoc.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6645
   ScaleWidth      =   11595
   Begin MSComctlLib.ImageList imIcon 
      Left            =   3960
      Top             =   3060
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
            Picture         =   "fABMDoc.frx":0E42
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fABMDoc.frx":11DC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fABMDoc.frx":1576
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fABMDoc.frx":1910
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fABMDoc.frx":1CAA
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox FR 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   615
      Index           =   0
      Left            =   4680
      ScaleHeight     =   615
      ScaleWidth      =   1455
      TabIndex        =   18
      Top             =   1500
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
         TabIndex        =   19
         Top             =   135
         Visible         =   0   'False
         Width           =   960
      End
   End
   Begin VB.ComboBox CB 
      Height          =   315
      Index           =   0
      Left            =   1665
      Style           =   2  'Dropdown List
      TabIndex        =   17
      Top             =   2295
      Visible         =   0   'False
      Width           =   2265
   End
   Begin VB.PictureBox picMsg 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1455
      Left            =   1920
      ScaleHeight     =   1455
      ScaleWidth      =   6135
      TabIndex        =   15
      Top             =   3420
      Visible         =   0   'False
      Width           =   6135
      Begin VB.Image Image1 
         Height          =   930
         Left            =   180
         Picture         =   "fABMDoc.frx":2044
         Top             =   240
         Width           =   915
      End
      Begin VB.Shape Shape1 
         BorderColor     =   &H0080C0FF&
         BorderWidth     =   3
         Height          =   1425
         Left            =   15
         Top             =   15
         Width           =   6105
      End
      Begin VB.Label lbMsg 
         BackStyle       =   0  'Transparent
         Caption         =   "Grabando ..."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00000000&
         Height          =   555
         Left            =   1080
         TabIndex        =   16
         Top             =   540
         Width           =   4935
      End
   End
   Begin VB.Timer tmEvents 
      Left            =   4320
      Top             =   900
   End
   Begin CSMaskEdit2.cMultiLine TXM 
      Height          =   285
      Index           =   0
      Left            =   1680
      TabIndex        =   14
      Top             =   3360
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
   Begin CSButton.cButton cbTabItems 
      Height          =   330
      Index           =   1
      Left            =   0
      TabIndex        =   9
      Top             =   3510
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
      TabButton       =   -1  'True
      TabSelected     =   -1  'True
      BackColor       =   -2147483643
      BackColorPressed=   -2147483643
   End
   Begin VB.CheckBox CHK 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   285
      Index           =   0
      Left            =   1665
      TabIndex        =   2
      Top             =   2655
      Visible         =   0   'False
      Width           =   2265
   End
   Begin CSMaskEdit2.cMaskEdit ME 
      Height          =   285
      Index           =   0
      Left            =   1665
      TabIndex        =   1
      Top             =   1935
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
      Top             =   2520
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
      Top             =   2160
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
      Top             =   2880
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
   Begin CSButton.cButton CMD 
      Height          =   330
      Index           =   0
      Left            =   4725
      TabIndex        =   7
      Top             =   3240
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
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   0
      Left            =   0
      TabIndex        =   10
      Top             =   1080
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
   Begin MSComctlLib.Toolbar tbMain 
      Height          =   330
      Left            =   60
      TabIndex        =   11
      Top             =   600
      Width           =   8160
      _ExtentX        =   14393
      _ExtentY        =   582
      ButtonWidth     =   609
      ButtonHeight    =   582
      Style           =   1
      _Version        =   393216
   End
   Begin CSHelp2.cHelp HL 
      Height          =   315
      Index           =   0
      Left            =   1675
      TabIndex        =   12
      Top             =   1565
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
      Height          =   1815
      Index           =   0
      Left            =   225
      TabIndex        =   13
      Top             =   3915
      Visible         =   0   'False
      Width           =   8115
      _ExtentX        =   14314
      _ExtentY        =   3201
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "pirulo en pirulo por pirulo"
      Height          =   420
      Index           =   0
      Left            =   180
      TabIndex        =   20
      Top             =   2400
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Shape shToolbar 
      BorderColor     =   &H80000010&
      Height          =   435
      Left            =   0
      Top             =   540
      Width           =   8295
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
      Height          =   330
      Left            =   4410
      TabIndex        =   8
      Top             =   45
      Width           =   75
   End
   Begin VB.Shape shTabFooter 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   630
      Left            =   90
      Top             =   5940
      Width           =   8340
   End
   Begin VB.Shape shTabItems 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   2040
      Left            =   90
      Top             =   3825
      Width           =   8340
   End
   Begin VB.Label LB 
      BackColor       =   &H80000005&
      Caption         =   "pirulo en pirulo por pirulo"
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   0
      Left            =   180
      TabIndex        =   3
      Top             =   1575
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000E&
      Visible         =   0   'False
      X1              =   135
      X2              =   6660
      Y1              =   3435
      Y2              =   3435
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      Visible         =   0   'False
      X1              =   135
      X2              =   6660
      Y1              =   3420
      Y2              =   3420
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Pedidos de Venta"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Top             =   105
      Width           =   2010
   End
   Begin VB.Shape shTitle 
      BackColor       =   &H8000000C&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   540
      Left            =   -45
      Top             =   0
      Width           =   6975
   End
   Begin VB.Shape ShTab 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   1995
      Left            =   90
      Top             =   1395
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
      Begin VB.Menu popGridSep2 
         Caption         =   "-"
      End
      Begin VB.Menu popGridShowCell 
         Caption         =   "&Mostrar Celda..."
      End
   End
End
Attribute VB_Name = "fABMDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fABMDoc
' 14-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fABMDoc"

' estructuras
' variables privadas
Private m_oldCB()           As String
'Private m_oldCBhock()       As String
Private m_oldME()           As String
Private m_oldMEFE()         As String
Private m_oldOP()           As String
Private m_oldTX()           As String
Private m_oldTXM()          As String
Private m_oldTXPassword()   As String

Private m_WasActivated    As Boolean

Private m_Loading         As Boolean

' Para que se completen los eventos
' de lostfocus ya que cuando se hace
' click sobre la toolbar, el foco no se
' traslada, agregue este mecanismo
' que en conjunto con un timer permite
' que se produsca el lostfocus y se
' establezca el valor de waschanged
'
Private m_Button          As Object
Private m_ctlFocus        As Control

' eventos
Public Event CBChange(ByVal Index As Integer)
'Public Event CBhockChange(ByVal Index As Integer)
Public Event CHKClick(ByVal Index As Integer)
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
Public Event cbTabClick(ByVal Index As Integer, ByVal Tag As String)

Public Event CMDClick(ByVal Index As Integer)

Public Event GRColumnAfterEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, ByRef bCancel As Boolean)
Public Event GRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
Public Event GRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)
Public Event GRColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)

Public Event GRClick(ByVal Index As Integer)
Public Event GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)
Public Event GRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, ByRef bCancel As Boolean)
Public Event GRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
Public Event GRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
Public Event GRRowWasDeleted(ByVal Index As Integer, ByVal RowIndex As Long)
Public Event GRSelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
Public Event GRSelectionColChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
Public Event GRSelectionRowChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)

Public Event ToolBarClick(ByVal Button As MSComctlLib.Button)

Public Event TabGetFirstCtrl(ByVal Index As Integer, ByVal Tag As String, ByRef ctrl As Control)

Public Event HLKeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

Private Type CtlInfo
  ctl     As Control
  Offset  As Integer
End Type

Private m_ItemsControls()         As CtlInfo
Private m_FootersControls()       As CtlInfo

Private m_CancelUnload         As Boolean

Private m_WasChanged           As Boolean

Private m_ActiveGrid           As cGridAdvanced

' Me permite saber si estoy en la ultima
' llamada del evento unload de los documentos (m_FormDoc)
Private m_UnloadCount     As Long

Private m_iRowMenu        As Long
Private m_iColMenu        As Long

Private m_NoButtons1  As Long
Private m_NoButtons2  As Long
Private m_NoButtons3  As Long

Private m_ButtonsEx2  As Long
Private m_ButtonsEx3  As Long

Private m_lastTabIndex As Long

' propiedades publicas
Public ABMObject As Object

Public Property Let NoButtons1(ByVal rhs As Long)
  m_NoButtons1 = rhs
End Property

Public Property Let NoButtons2(ByVal rhs As Long)
  m_NoButtons2 = rhs
End Property

Public Property Let NoButtons3(ByVal rhs As Long)
  m_NoButtons3 = rhs
End Property

Public Property Let ButtonsEx2(ByVal rhs As Long)
  m_ButtonsEx2 = rhs
End Property

Public Property Let ButtonsEx3(ByVal rhs As Long)
  m_ButtonsEx3 = rhs
End Property

Public Property Get UnloadCount() As Long
  UnloadCount = m_UnloadCount
End Property

Public Property Let UnloadCount(ByVal rhs As Long)
  m_UnloadCount = rhs
End Property

Public Property Let Loading(ByVal rhs As Boolean)
  m_Loading = rhs
  If Not m_Loading Then
    pFillColControls
    Form_Resize
  End If
End Property

Public Property Get CancelUnload() As Boolean
  CancelUnload = m_CancelUnload
End Property

Public Property Let CancelUnload(ByVal rhs As Boolean)
  m_CancelUnload = rhs
End Property

Public Property Get WasChanged() As Boolean
  WasChanged = m_WasChanged
End Property

Public Property Let WasChanged(ByVal rhs As Boolean)
  m_WasChanged = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub SetHeightToDocWithDescrip()
  ShTab.Height = 2595
  cbTabItems(1).Top = 4050
  GR(0).Top = 4455
  shTabItems.Top = 4365
End Sub

Public Sub SetToolbarButtons()
  
  ' SetToolbar soporta tres grupos de hasta 32 botones cada uno
  '
  Dim Buttons1 As Long
  Dim Buttons2 As Long
  Dim Buttons3 As Long

  Buttons1 = BUTTON_NEW + BUTTON_SAVE + BUTTON_RELOAD + BUTTON_ANULAR + BUTTON_COPY + BUTTON_SEARCH
  Buttons1 = Buttons1 + BUTTON_DOC_FIRST + BUTTON_DOC_PREVIOUS + BUTTON_DOC_NEXT + BUTTON_DOC_LAST
  Buttons1 = Buttons1 + BUTTON_DELETE + BUTTON_PRINTOBJ + BUTTON_DOC_SIGNATURE + BUTTON_DOC_MODIFY
  Buttons1 = Buttons1 + BUTTON_DOC_APLIC + BUTTON_ATTACH + BUTTON_EDIT_STATE + BUTTON_DOC_HELP + BUTTON_EXIT
    
  Buttons1 = Buttons1 - m_NoButtons1
  
  Buttons2 = BUTTON_DOC_AUX + BUTTON_DOC_EDIT + BUTTON_DOC_ALERT + BUTTON_DOC_TIP + BUTTON_DOC_ACTION + BUTTON_DOC_MAIL
  Buttons2 = Buttons2 - m_NoButtons2
 
  Buttons2 = Buttons2 + m_ButtonsEx2
  
  Buttons3 = m_ButtonsEx3
  
  CSKernelClient2.SetToolBar16 tbMain, Buttons1, Buttons2, Buttons3, False, True

  tbMain.BorderStyle = ccNone

End Sub

Public Sub doPropertyChange()
  If Me.ActiveControl Is Nothing Then Exit Sub

  With Me.ActiveControl

    Select Case .Name
      Case "CB"
        CB_LostFocus .Index
      'Case "CBhock"
      '  CBhock_LostFocus .Index
      Case "ME"
        ME_LostFocus .Index
      Case "MEFE"
        MEFE_LostFocus .Index
      Case "TX"
        TX_LostFocus .Index
      Case "TXPassword"
        TXPassword_LostFocus .Index
      Case "HL"
        HL(.Index).Validate
        HL_Change .Index
    End Select
  End With
End Sub

Public Sub InitMembers()
  ReDim m_oldCB(0)
  'ReDim m_oldCBhock(0)
  ReDim m_oldME(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldOP(0)
  ReDim m_oldTX(0)
  ReDim m_oldTXM(0)
  ReDim m_oldTXPassword(0)
  ReDim m_ItemsControls(0)
  ReDim m_FootersControls(0)
  ReDim m_ItemsControlsOffset(0)
End Sub

Public Function CtrlKeySave() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbSave)
  CtrlKeySave = True
End Function

Public Function CtrlKeyNew() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbNew)
  CtrlKeyNew = True
End Function

Public Function CtrlKeyCopy() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbCopy)
  CtrlKeyCopy = True
End Function

Public Function CtrlKeyRefresh() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbReload)
  CtrlKeyRefresh = True
End Function

Public Function CtrlKeyClose() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbClose)
  CtrlKeyClose = True
End Function

Public Function CtrlKeyPrint() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbPrint)
  CtrlKeyPrint = True
End Function

Public Function CtrlKeySearch() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbSearch)
  CtrlKeySearch = True
End Function

Public Function CtrlKeyApply() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbApply)
  CtrlKeyApply = True
End Function

Public Function CtrlKeyHistory() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbHistory)
  CtrlKeyHistory = True
End Function

Public Function CtrlKeyHelp() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbHelp)
  CtrlKeyHelp = True
End Function

Public Sub SetToolbar(ByRef Tbl As Toolbar)

End Sub
Public Sub UnLoadToolbar()

End Sub
Public Sub SetFocusFirstControl()
  On Error Resume Next
  
  Dim c As Control
  Dim MinTab As Long
  Dim MaxTab As Long
  
  MaxTab = 0
  MinTab = 10000
  
  For Each c In Me.Controls
    Err.Clear
    If Not TypeOf c Is Timer Then
      With c
        If MinTab > .TabIndex Then
          If Err.Number = 0 Then
            MinTab = .TabIndex
          End If
        End If
        If MaxTab < .TabIndex Then
          If Err.Number = 0 Then
            MaxTab = .TabIndex
          End If
        End If
      End With
    End If
  Next
  
  Do
    For Each c In Me.Controls
      Err.Clear
      If Not TypeOf c Is Timer Then
        With c
          If .TabIndex = MinTab Then
            If Err.Number = 0 Then
              If c.Visible Then
                .SetFocus
                Exit For
              End If
            End If
          End If
        End With
      End If
    Next
    MinTab = MinTab + 1
  Loop Until MinTab > MaxTab Or Err.Number = 0
End Sub
' funciones privadas
'----------------
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
  RaiseEvent cbTabClick(Index, cbTab(Index).Tag)
End Sub

Private Sub CHK_Click(Index As Integer)
  RaiseEvent CHKClick(Index)
End Sub

Private Sub CMD_Click(Index As Integer)
  RaiseEvent CMDClick(Index)
End Sub

Private Sub GR_MouseDown(Index As Integer, Button As Integer, Shift As Integer, x As Single, y As Single, bDoDefault As Boolean)
  On Error Resume Next
  Set m_ActiveGrid = GR(Index)
  If Button = vbRightButton Then
  
    GR(Index).CellFromPoint x / Screen.TwipsPerPixelX, y / Screen.TwipsPerPixelY, m_iRowMenu, m_iColMenu
    Me.PopupMenu popGrid
    bDoDefault = False
  End If
End Sub

Private Sub HL_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
  RaiseEvent HLKeyDown(Index, KeyCode, Shift)
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

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me
  
  On Error Resume Next
  
  Select Case KeyCode
  
    ' Para pasar a Documento con F5
    '
    Case vbKeyF5
      If HL.UBound >= 1 Then
        If HL(1).Visible Then
          If HL(1).Enabled Then
            HL(1).SetFocus
          End If
        End If
      End If
  
    ' Para pasar a Documento con F6
    '
    Case vbKeyF6
      If HL.UBound >= 2 Then
        If HL(2).Visible Then
          If HL(2).Enabled Then
            HL(2).SetFocus
          End If
        End If
      End If
  
    ' Para pasar a Items con F7
    '
    Case vbKeyF7
      If GR(0).Visible Then
        If GR(0).Enabled Then
          GR(0).SetFocus
          If GR(0).SelectedCol = 0 And GR(0).SelectedRow = 0 Then
            SendKeys "{ENTER}"
          End If
        End If
      End If
      
    Case Else
    
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
      
  End Select
End Sub

Private Sub Form_Activate()
  If m_WasActivated Then Exit Sub
  m_WasActivated = True
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  m_UnloadCount = 0
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

Private Sub GR_RowWasDeleted(Index As Integer, ByVal lRow As Long)
  RaiseEvent GRRowWasDeleted(Index, lRow)
End Sub

Private Sub GR_GotFocus(Index As Integer)
  On Error Resume Next
  
  If GR(Index).SelectedRow = 0 Then
    GR(Index).SelectedRow = 1
    GR(Index).SelectedCol = 2
  End If
End Sub

Private Sub GR_NewRow(Index As Integer, ByVal lRow As Long)
  RaiseEvent GRNewRow(Index, lRow)
End Sub

Private Sub GR_ValidateRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  RaiseEvent GRValidateRow(Index, lRow, bCancel)
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

Private Sub HL_Change(Index As Integer)
  RaiseEvent HLChange(Index)
End Sub

Private Sub ME_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldME) < Index Then ReDim Preserve m_oldME(Index)
  m_oldME(Index) = Me.ME(Index).csValue
ControlError:
End Sub

Private Sub ME_LostFocus(Index As Integer)
  If m_oldME(Index) = Me.ME(Index).csValue Then Exit Sub
  RaiseEvent MEChange(Index)
End Sub

Private Sub MEFE_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldMEFE) < Index Then ReDim Preserve m_oldMEFE(Index)
  m_oldMEFE(Index) = Me.MEFE(Index).csValue
ControlError:
End Sub

Private Sub MEFE_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldMEFE(Index) = Me.MEFE(Index).csValue Then Exit Sub
  RaiseEvent MEDateChange(Index)
ControlError:
End Sub

Private Sub OP_Click(Index As Integer)
  RaiseEvent OPClick(Index)
End Sub

Private Sub popGridShowCell_Click()
  On Error Resume Next
  If m_ActiveGrid Is Nothing Then Exit Sub
  With m_ActiveGrid
  
    If m_iRowMenu > .Rows Or _
       m_iRowMenu < 1 Then m_iRowMenu = .SelectedRow
       
    If m_iColMenu > .Columns.Count Or _
       m_iColMenu < 1 Then m_iColMenu = .SelectedCol
  
    MsgInfoEx .Cell(m_iRowMenu, m_iColMenu).Text
  End With
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  DoEvents: DoEvents
  tbMain.Enabled = False
  Set m_Button = Button
  Set m_ctlFocus = Me.ActiveControl
  If m_ctlFocus Is MEFE(0) Then
    HL(0).SetFocus
  Else
    MEFE(0).SetFocus
  End If
  tmEvents.Interval = 300
End Sub

Private Sub tmEvents_Timer()
  On Error Resume Next
  tmEvents.Interval = 0
  m_ctlFocus.SetFocus
  RaiseEvent ToolBarClick(m_Button)
  Set m_Button = Nothing
  tbMain.Enabled = True
End Sub

Private Sub TX_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTX) < Index Then ReDim Preserve m_oldTX(Index)
  m_oldTX(Index) = TX(Index).Text
ControlError:
End Sub

Private Sub TXM_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTXM) < Index Then ReDim Preserve m_oldTXM(Index)
  m_oldTXM(Index) = TXM(Index).Text
ControlError:
End Sub

Private Sub TX_ReturnFromHelp(Index As Integer)
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  RaiseEvent TXChange(Index)
  m_oldTX(Index) = TX(Index).Text
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

Private Sub TXM_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldTXM(Index) = TXM(Index).Text Then Exit Sub
  RaiseEvent TXMChange(Index)
ControlError:
End Sub

Private Sub TXPassword_LostFocus(Index As Integer)
  If m_oldTXPassword(Index) = txPassword(Index).Text Then Exit Sub
  RaiseEvent TXPasswordChange(Index)
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim i As Integer

  If WindowState = vbMinimized Then Exit Sub

  shTitle.Move 0, 0, ScaleWidth
  With Line1
    .X1 = 0
    .X2 = ScaleWidth
  End With
  With Line2
    .X1 = 0
    .X2 = ScaleWidth
  End With
  
  If m_Loading Then Exit Sub
  
  If Me.WindowState = vbMinimized Then Exit Sub
  
  If Me.Width >= c_MinWidth Then
    With shTabFooter
      .Width = Me.ScaleWidth - .Left * 2
      ShTab.Width = .Width
      shTabItems.Width = .Width
    End With
    With shToolbar
      .Width = Me.ScaleWidth - .Left * 2
    End With
    With tbMain
      .Width = Me.ScaleWidth - .Left * 2
    End With
    
    For i = 1 To UBound(m_ItemsControls)
      With m_ItemsControls(i)
        If TypeOf .ctl Is cGridAdvanced Then
          .ctl.Width = Me.ScaleWidth - .ctl.Left * 2
        End If
      End With
    Next
  End If
  
  If Me.Height >= c_MinHeight Then
    
    With shTabFooter
      .Top = Me.ScaleHeight - .Height - 100
      shTabItems.Height = .Top - shTabItems.Top - 100
    End With
    
    For i = 1 To UBound(m_ItemsControls)
      With m_ItemsControls(i)
        If TypeOf .ctl Is cGridAdvanced Then
          .ctl.Height = shTabItems.Height - .Offset - 100
        End If
        .ctl.Top = shTabItems.Top + .Offset
      End With
    Next
    
    For i = 1 To UBound(m_FootersControls)
      With m_FootersControls(i)
        .ctl.Top = shTabFooter.Top + .Offset
      End With
    Next
  End If
End Sub

Private Sub pFillColControls()
  Dim ctl As Control
  
  For Each ctl In Me.Controls
    With ctl
      If Not (TypeOf ctl Is Line Or TypeOf ctl Is Menu Or TypeOf ctl Is Toolbar Or TypeOf ctl Is ImageList Or TypeOf ctl Is Timer) Then
        If .Top > shTabItems.Top And .Top < shTabFooter.Top Then
          
          ReDim Preserve m_ItemsControls(UBound(m_ItemsControls) + 1)
          With m_ItemsControls(UBound(m_ItemsControls))
            Set .ctl = ctl
            .Offset = ctl.Top - shTabItems.Top
          End With
          
        ElseIf .Top > shTabFooter.Top Then
          
          ReDim Preserve m_FootersControls(UBound(m_FootersControls) + 1)
          With m_FootersControls(UBound(m_FootersControls))
            Set .ctl = ctl
            .Offset = ctl.Top - shTabFooter.Top
          End With
        End If
      End If
    End With
  Next
End Sub

Private Sub pMoveTab(ByVal iWhere As Integer)
  On Error Resume Next
  
  If iWhere = 0 Then Exit Sub
  
  Err.Clear
  
  Dim ctl         As Control
  Dim cTab        As cButton
  Dim iTabIndex   As Long
  
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
    iTabIndex = iWhere - 1
  End If
  
  If iTabIndex >= 0 Then
    If iTabIndex >= cbTab.LBound And iTabIndex <= cbTab.UBound Then
      Me.cbTab(iTabIndex).Push
      If Err.Number = 0 Then
        Dim ctrl As Control
        RaiseEvent TabGetFirstCtrl(iTabIndex, cbTab(iTabIndex).Tag, ctrl)
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
  
  InitMembers
  
  Me.FR(0).BackColor = vb3DHighlight
  Me.OP(0).BackColor = vb3DHighlight
  
  m_WasActivated = False
  m_Loading = True
  m_CancelUnload = False
  m_WasChanged = False
  
  SetToolbarButtons
  
  RaiseEvent FormLoad

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  InitMembers
  
  Set ABMObject = Nothing
  Set m_Button = Nothing
  Set m_ActiveGrid = Nothing
  
  RaiseEvent FormUnload(Cancel)
  
  CSKernelClient2.UnloadForm Me, "ABM_" & Me.lbTitle.Caption
  
  Set fABMDoc = Nothing
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbTerminateInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbInitInstance C_Module
End Sub
#End If
