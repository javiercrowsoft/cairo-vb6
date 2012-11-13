VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.MDIForm fMain 
   AutoShowChildren=   0   'False
   BackColor       =   &H8000000C&
   Caption         =   "CrowSoft Reports"
   ClientHeight    =   6705
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   9450
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picToolBar 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   615
      Left            =   0
      ScaleHeight     =   615
      ScaleWidth      =   9450
      TabIndex        =   4
      Top             =   0
      Width           =   9450
      Begin MSComctlLib.Toolbar tbMain 
         Height          =   330
         Left            =   225
         TabIndex        =   5
         Top             =   90
         Width           =   9210
         _ExtentX        =   16245
         _ExtentY        =   582
         ButtonWidth     =   609
         ButtonHeight    =   582
         Style           =   1
         ImageList       =   "iltbMain"
         _Version        =   393216
         BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
            NumButtons      =   30
            BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "NEW"
               ImageIndex      =   6
            EndProperty
            BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "OPEN"
               ImageIndex      =   5
            EndProperty
            BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "SAVE"
               ImageIndex      =   3
            EndProperty
            BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "DB"
               ImageIndex      =   1
            EndProperty
            BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "PREV"
               ImageIndex      =   9
            EndProperty
            BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "PRINT"
               ImageIndex      =   8
            EndProperty
            BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "PROPERTIES"
               ImageIndex      =   4
            EndProperty
            BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "TOOL"
               ImageIndex      =   7
            EndProperty
            BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button13 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "ALIGN_LEFT"
               ImageIndex      =   10
            EndProperty
            BeginProperty Button14 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "ALIGN_CENTER"
               ImageIndex      =   11
            EndProperty
            BeginProperty Button15 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "ALIGN_RIGHT"
               ImageIndex      =   12
            EndProperty
            BeginProperty Button16 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button17 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_ALIGN_TOP"
               ImageIndex      =   14
            EndProperty
            BeginProperty Button18 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_ALIGN_VERTICAL"
               ImageIndex      =   18
            EndProperty
            BeginProperty Button19 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_ALIGN_BOTTOM"
               ImageIndex      =   13
            EndProperty
            BeginProperty Button20 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button21 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_ALIGN_LEFT"
               ImageIndex      =   16
            EndProperty
            BeginProperty Button22 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_ALIGN_HORIZONTAL"
               ImageIndex      =   19
            EndProperty
            BeginProperty Button23 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_ALIGN_RIGHT"
               ImageIndex      =   17
            EndProperty
            BeginProperty Button24 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button25 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_WIDTH"
               ImageIndex      =   20
            EndProperty
            BeginProperty Button26 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "CTL_HEIGHT"
               ImageIndex      =   21
            EndProperty
            BeginProperty Button27 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button28 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "FONT_BOLD"
               ImageIndex      =   15
            EndProperty
            BeginProperty Button29 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button30 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "SEARCH"
               ImageIndex      =   22
            EndProperty
         EndProperty
      End
      Begin VB.Shape shToolBar 
         BorderColor     =   &H80000010&
         Height          =   495
         Index           =   0
         Left            =   0
         Top             =   0
         Width           =   9375
      End
      Begin VB.Line Line4 
         BorderColor     =   &H80000010&
         X1              =   150
         X2              =   150
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Line Line3 
         BorderColor     =   &H80000014&
         X1              =   135
         X2              =   135
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000014&
         X1              =   80
         X2              =   80
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Line Line2 
         BorderColor     =   &H80000010&
         X1              =   90
         X2              =   90
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Shape shToolBar 
         BackColor       =   &H8000000F&
         BackStyle       =   1  'Opaque
         BorderColor     =   &H8000000F&
         Height          =   495
         Index           =   1
         Left            =   0
         Top             =   0
         Width           =   9375
      End
   End
   Begin MSComctlLib.StatusBar sbPanel 
      Align           =   2  'Align Bottom
      Height          =   315
      Left            =   0
      TabIndex        =   2
      Top             =   6390
      Width           =   9450
      _ExtentX        =   16669
      _ExtentY        =   556
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picBar 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   0
      ScaleHeight     =   510
      ScaleWidth      =   9450
      TabIndex        =   0
      Top             =   615
      Width           =   9450
      Begin VB.Label lbStatus 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   285
         Left            =   0
         TabIndex        =   3
         Top             =   90
         Width           =   4635
      End
      Begin VB.Label lbBar 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   285
         Left            =   270
         TabIndex        =   1
         Top             =   90
         Width           =   1635
      End
      Begin VB.Shape shBar 
         BackColor       =   &H80000010&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         Height          =   375
         Left            =   45
         Shape           =   4  'Rounded Rectangle
         Top             =   90
         Width           =   3255
      End
   End
   Begin MSComDlg.CommonDialog cmDialog 
      Left            =   4500
      Top             =   3105
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList iltbMain 
      Left            =   3780
      Top             =   3060
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   22
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
            Picture         =   "fMain.frx":12D0
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":166A
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1A04
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1D9E
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2138
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":24D2
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":286C
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2C06
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2FA0
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":333A
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":36D4
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":3A6E
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4008
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":43A2
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":473C
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4AD6
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4E70
            Key             =   ""
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":520A
            Key             =   ""
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":55A4
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuFileNew 
         Caption         =   "&Nuevo"
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Abrir..."
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Guardar..."
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "&Guardar Como..."
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFilePrinterConfig 
         Caption         =   "&Configurar Impresora..."
      End
      Begin VB.Menu mnuFilePageConfig 
         Caption         =   "Configurar &Pagina..."
      End
      Begin VB.Menu mnuFileSep10 
         Caption         =   "-"
      End
      Begin VB.Menu mnuReportPreview 
         Caption         =   "&Vista Preliminar..."
         Shortcut        =   {F5}
      End
      Begin VB.Menu mnuReportPrint 
         Caption         =   "&Imprimir..."
      End
      Begin VB.Menu mnuFileSepRecentList 
         Caption         =   "-"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileRecentList 
         Caption         =   ""
         Index           =   0
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edición"
      Begin VB.Menu mnuEditAddSec 
         Caption         =   "Agregar una &Sección"
         Begin VB.Menu mnuEditAddHeader 
            Caption         =   "&Encabezado..."
         End
         Begin VB.Menu mnuEditAddGroup 
            Caption         =   "&Grupo..."
         End
         Begin VB.Menu mnuEditAddFooter 
            Caption         =   "&Pie de Página..."
         End
      End
      Begin VB.Menu mnuEditAddControl 
         Caption         =   "Agregar un &Control"
         Begin VB.Menu mnuEditAddLabel 
            Caption         =   "&Etiqueta"
         End
         Begin VB.Menu mnuEditAddLine 
            Caption         =   "&Linea"
         End
         Begin VB.Menu mnuEditAddDbField 
            Caption         =   "&Campo de la Base de Datos"
         End
         Begin VB.Menu mnuEditAddImage 
            Caption         =   "&Imagen"
         End
         Begin VB.Menu mnuEditAddChart 
            Caption         =   "&Gráfico"
         End
      End
      Begin VB.Menu mnuEditSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditMove 
         Caption         =   "&Mover"
         Begin VB.Menu mnuEditHorizontal 
            Caption         =   "Horizontal"
         End
         Begin VB.Menu mnuEditVertical 
            Caption         =   "Vertical"
         End
         Begin VB.Menu mnuEditNoMove 
            Caption         =   "Bloquear"
         End
         Begin VB.Menu mnuEditMoveAll 
            Caption         =   "En todas Direcciones"
         End
      End
      Begin VB.Menu mnuEditSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditKeyboardStepMove 
         Caption         =   "Tamaño del Paso al Mover con el Teclado..."
      End
      Begin VB.Menu mnuEditSep3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditSearch 
         Caption         =   "Buscar..."
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&Ver"
      Begin VB.Menu mnuViewToolbar 
         Caption         =   "&Caja de Herramientas..."
      End
      Begin VB.Menu mnuViewControls 
         Caption         =   "&Controles en Grilla..."
      End
      Begin VB.Menu mnuViewTreeViewCtrls 
         Caption         =   "Controles en &Arbol..."
      End
      Begin VB.Menu mnuViewSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewGridMain 
         Caption         =   "&Ver Grilla"
         Begin VB.Menu mnuViewGridPoints 
            Caption         =   "Ver &Puntos"
         End
         Begin VB.Menu mnuViewGridLines 
            Caption         =   "Ver &Lineas"
            Begin VB.Menu mnuViewGridLinesV 
               Caption         =   "Verticales"
            End
            Begin VB.Menu mnuViewGridLinesH 
               Caption         =   "Horizontales"
            End
            Begin VB.Menu mnuViewGridLinesBoth 
               Caption         =   "Ambas"
            End
         End
         Begin VB.Menu mnuViewGridNone 
            Caption         =   "&Sin grilla"
         End
      End
      Begin VB.Menu mnuViewSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewSumary 
         Caption         =   "&Resumen ..."
      End
   End
   Begin VB.Menu mnuDataBase 
      Caption         =   "&Base de datos"
      Begin VB.Menu mnuDataBaseConnectConfig 
         Caption         =   "&Configurar Conexión..."
      End
      Begin VB.Menu mnuDataBaseSetParameters 
         Caption         =   "&Definir Parametros..."
      End
      Begin VB.Menu mnuDataBaseSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDataBaseConnectsAuxCfg 
         Caption         =   "&Conexiones Adicionales..."
      End
      Begin VB.Menu mnuDataBaseSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDataBaseSetDisconnected 
         Caption         =   "&Reporte sin Conexión"
      End
      Begin VB.Menu mnuDataBaseSep3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDataBaseEditEx 
         Caption         =   "Edicion Maual"
         Begin VB.Menu mnuDataBaseSetToSQL 
            Caption         =   "Definir Conexión a SQL Server"
         End
         Begin VB.Menu mnuDataBaseShowStrConnect 
            Caption         =   "Ver String de Conexión"
         End
         Begin VB.Menu mnuDataBaseEditStrConnect 
            Caption         =   "Modificar String de Conexión"
         End
         Begin VB.Menu mnuDataBaseEditDataSource 
            Caption         =   "Modificar DataSource"
         End
      End
      Begin VB.Menu mnuDataBaseSep4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDataBaseSetToMainConnect 
         Caption         =   "Asignar a Conexiones Adicionales la Conexión Principal"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Herramientas"
      Begin VB.Menu mnuToolOptions 
         Caption         =   "&Opciones..."
      End
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "&Ventana"
      WindowList      =   -1  'True
      Begin VB.Menu mnuWindowCascade 
         Caption         =   "&Cascada"
      End
      Begin VB.Menu mnuWindowHorizontal 
         Caption         =   "Mosaico &Horizontal"
      End
      Begin VB.Menu mnuWindowVertical 
         Caption         =   "Mosaico &Vertical"
      End
      Begin VB.Menu mnuWindowArrange 
         Caption         =   "Organizar Ventanas"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Ayuda"
      Begin VB.Menu mnuHelpIndex 
         Caption         =   "&Indice..."
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&Acerca de CrowSoft Reports..."
      End
   End
   Begin VB.Menu popSec 
      Caption         =   "Section Popup"
      Begin VB.Menu popSecDelete 
         Caption         =   "&Borrar Sección..."
      End
      Begin VB.Menu popSecDeleteSecLn 
         Caption         =   "&Borrar Renglón..."
      End
      Begin VB.Menu popSecAddSecLn 
         Caption         =   "&Agregar un Renglón..."
      End
      Begin VB.Menu popSecSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popSecProperties 
         Caption         =   "&Propiedades de la Sección..."
      End
      Begin VB.Menu popSecPropSecLn 
         Caption         =   "&Propiedades del Renglón..."
      End
      Begin VB.Menu popSecPropGroup 
         Caption         =   "&Propiedades del Grupo..."
      End
      Begin VB.Menu popSecMoveGroup 
         Caption         =   "&Mover el Grupo..."
      End
   End
   Begin VB.Menu popObj 
      Caption         =   "Object Popup"
      Begin VB.Menu popObjCut 
         Caption         =   "&Cortar"
      End
      Begin VB.Menu popObjCopy 
         Caption         =   "C&opiar"
      End
      Begin VB.Menu popObjPaste 
         Caption         =   "&Pegar"
      End
      Begin VB.Menu popObjPasteEx 
         Caption         =   "Pegar Sin Mover"
      End
      Begin VB.Menu popObjDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popObjSep2 
         Caption         =   "-"
      End
      Begin VB.Menu popObjEditText 
         Caption         =   "&Editar Texto..."
      End
      Begin VB.Menu popObjSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popObjBringToFront 
         Caption         =   "Traer al &Frente"
      End
      Begin VB.Menu popObjSendToBack 
         Caption         =   "Enviar al &Fondo"
      End
      Begin VB.Menu popObjSep3 
         Caption         =   "-"
      End
      Begin VB.Menu popObjProperties 
         Caption         =   "&Propiedades..."
      End
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const c_Name = "fmain.ReportEditor"

Private m_Done          As Boolean
Private m_Closing       As Boolean

Private Const c_sbPnlControl = "ctl"
Private Const c_sbPnlAction = "action"


Private Const C_Module = "fMain"

Private WithEvents m_Wizard As cNewWizard
Attribute m_Wizard.VB_VarHelpID = -1
Private m_ShowingWizard     As Boolean
Private m_PrinterName       As String
Private m_DriverName        As String
Private m_Port              As String
Private m_PaperSize         As Long
Private m_Orientation       As Long
Private m_CustomHeight      As Single
Private m_CustomWidth       As Single

Private m_ReportCopySource  As fReporte

Public Property Get ReportCopySource() As fReporte
  Set ReportCopySource = m_ReportCopySource
End Property

Public Property Set ReportCopySource(ByVal rhs As fReporte)
  Set m_ReportCopySource = rhs
End Property

Public Property Get CustomHeight() As Single
   CustomHeight = m_CustomHeight
End Property

Public Property Let CustomHeight(ByVal rhs As Single)
   m_CustomHeight = rhs
End Property

Public Property Get CustomWidth() As Single
   CustomWidth = m_CustomWidth
End Property

Public Property Let CustomWidth(ByVal rhs As Single)
   m_CustomWidth = rhs
End Property

Public Property Get PrinterName() As String
  PrinterName = m_PrinterName
End Property

Public Property Get DriverName() As String
  DriverName = m_DriverName
End Property

Public Property Get Port() As String
  Port = m_Port
End Property

Public Property Get PaperSize() As Long
  PaperSize = m_PaperSize
End Property

Public Property Get Orientation() As Long
  Orientation = m_Orientation
End Property

Public Property Get IsClosing() As Boolean
  IsClosing = m_Closing
End Property

Private Sub MDIForm_Activate()
  If m_Done Then Exit Sub
  m_Done = True
  fSplash.Show
  
  pAssocFile
  
  If Command$ <> "" Then
    pOpenFile Command$
  End If

End Sub

Private Sub MDIForm_Load()
  m_Done = False
  m_Closing = False
  LoadRecentList
  CSKernelClient2.LoadForm Me, c_Name
  pClearToolbarCaptions
  popSec.Visible = False
  popObj.Visible = False
  pSetGridStyle csEGridPoints
  GetDefaultPrinter m_PrinterName, m_DriverName, m_Port, m_PaperSize, m_Orientation
  pSetStatusBar
  SetEditAlignTextState False
  SetEditAlignCtlState False
  gbFirstOpen = True
  
  ' Barritas de la Toolbar que quedan chebere :)
  '
  Line1.y1 = 130
  Line2.y1 = Line1.y1
  Line3.y1 = Line1.y1
  Line4.y1 = Line1.y1
  Line1.Y2 = 480
  Line2.Y2 = Line1.Y2
  Line3.Y2 = Line1.Y2
  Line4.Y2 = Line1.Y2
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  m_Closing = True
  mnuFileExit_Click
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
  Unload fSearch
  SaveRecentList
  CSKernelClient2.UnloadForm Me, c_Name
  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
  Set m_ReportCopySource = Nothing
End Sub

Private Sub mnuDataBaseConnectsAuxCfg_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  GetDocActive().ShowConnectsAux
End Sub

Private Sub mnuDataBaseEditDataSource_Click()
  Dim Value As String
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive().Report.Connect
    Value = .DataSource
    Value = InputBox("DataSource", "CSReport", Value)
    If Value = "" Then Exit Sub
    .DataSource = Value
  End With
End Sub

Private Sub mnuDataBaseEditStrConnect_Click()
  Dim Value As String
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive().Report.Connect
    Value = .strConnect
    Value = InputBox("String de conexión", "CSReport", Value)
    If Value = "" Then Exit Sub
    .strConnect = Value
  End With
End Sub

Private Sub mnuDataBaseSetDisconnected_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With mnuDataBaseSetDisconnected
    .Checked = Not .Checked
    GetDocActive().Report.ReportDisconnected = .Checked
  End With
End Sub

Private Sub mnuDataBaseSetToMainConnect_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .SetAllConnectToMainConnect
  End With
End Sub

Private Sub mnuDataBaseSetToSQL_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .SetSimpleConnection
  End With
End Sub

Private Sub mnuDataBaseShowStrConnect_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive().Report.Connect
    MsgInfo .strConnect & ";" & .DataSource
  End With
End Sub

Private Sub mnuEditAddChart_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddChart
  End With
End Sub

Private Sub mnuEditAddImage_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddImage
  End With
End Sub

Private Sub mnuEditHorizontal_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .MoveHorizontal
  End With
End Sub

Private Sub mnuEditKeyboardStepMove_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  
  Dim n As String
  
  If Not GetInput(n, "Indique un valor entre 10 y 100") Then Exit Sub
  
  If Val(n) < 10 Or Val(n) > 100 Then Exit Sub
  
  With GetDocActive()
    .KeyboardMoveStep = Val(n)
  End With
End Sub

Private Sub mnuEditMoveAll_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .MoveAll
  End With
End Sub

Private Sub mnuEditNoMove_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .MoveNoMove
  End With
End Sub

Private Sub mnuEditSearch_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .Search
  End With
End Sub

Private Sub mnuEditVertical_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .MoveVertical
  End With
End Sub

Public Sub mnuFileOpen_Click()
  On Error GoTo ControlError

  Dim f As fReporte
  Set f = New fReporte
  gNextReport = gNextReport + 1
  f.Caption = "Reporte" & gNextReport & ".csr"
  f.Init
  If f.OpenDocument() Then
    AddToRecentList f.FileName
    SaveRecentList
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuFileOpen_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuFilePageConfig_Click()

  Load fPageSetup

  If Not GetDocActive() Is Nothing Then
    With GetDocActive()
      fPageSetup.InitDialog .PaperSize, .CustomWidth, .CustomHeight, .Orientation
    End With
  End If

  With fPageSetup
    
    .Show vbModal
    
    If .Ok Then
    
      m_PaperSize = .PaperSize
      
      m_CustomHeight = .CustomHeigth
      m_CustomWidth = .CustomWidth
      m_Orientation = IIf(.opHorizontal.Value, vbPRORLandscape, vbPRORPortrait)
  
      If Not GetDocActive() Is Nothing Then
        With GetDocActive()
          '.PrinterName = m_PrinterName
          '.DriverName = m_DriverName
          '.Port = m_Port
          .PaperSize = m_PaperSize
          .Orientation = m_Orientation
          .CustomHeight = m_CustomHeight
          .CustomWidth = m_CustomWidth
          .RefreshReport
        End With
      End If
    End If
  End With
  Unload fPageSetup
End Sub

Public Sub mnuFilePrinterConfig_Click()
  PrintConfig
End Sub

Public Sub SetsbPnlCtrl(ByVal Ctl As String)
  sbPanel.Panels(c_sbPnlControl).Text = Ctl
End Sub

Public Sub PrintConfig()
  Dim PrinterName As String
  Dim DriverName  As String
  Dim Port        As String
  Dim PaperSize   As Long
  Dim Orientation As Long
  Dim Copies      As Long

  PrinterName = m_PrinterName
  DriverName = m_DriverName
  Port = m_Port
  
  If Not ShowPrintDialog(Me.hwnd, PrinterName, DriverName, Port, PaperSize, Orientation, 0, 0, Copies, 0) Then Exit Sub
  m_PrinterName = PrinterName
  m_DriverName = DriverName
  m_Port = Port
  
  If PaperSize = 0 Then PaperSize = m_PaperSize
  If Orientation = 0 Then Orientation = m_Orientation
  
  m_PaperSize = PaperSize
  m_Orientation = Orientation

  If m_PaperSize = 0 Then m_PaperSize = 1
  If m_Orientation = 0 Then m_Orientation = 1


  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    '.PrinterName = m_PrinterName
    '.DriverName = m_DriverName
    '.Port = m_Port
    .PaperSize = m_PaperSize
    .Orientation = m_Orientation
    .RefreshReport
    .Copies = Copies
  End With
End Sub

Public Sub mnuFileSave_Click()
  On Error GoTo ControlError
  
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    If .SaveDocument() Then AddToRecentList .FileName
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuFileSave_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuFileSaveAs_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    If .SaveDocument(True) Then AddToRecentList .FileName
  End With
End Sub

Public Sub mnuFileNew_Click()
  Set m_Wizard = New cNewWizard
  m_Wizard.Show
End Sub

Public Sub mnuFileRecentList_Click(Index As Integer)
'  Dim f As Object
'
'  For Each f In Forms
'    If TypeOf f Is fReporte Then
'      If f.FileName = mnuFileRecentList(Index).Caption Then
'        AddToRecentList f.FileName
'        f.Show
'        f.ZOrder
'        Exit Sub
'      End If
'    End If
'  Next f
'
'  Set f = New fReporte
'  gNextReport = gNextReport + 1
'  f.Caption = "Reporte" & gNextReport & ".csr"
'  f.Init
'
'  If f.OpenDocument(mnuFileRecentList(Index).Caption) Then AddToRecentList f.FileName

  pOpenFile mnuFileRecentList(Index).Caption
End Sub

Public Sub mnuFileExit_Click()
  Unload Me
End Sub

Public Sub mnuHelpAbout_Click()
  fAbout.Show
End Sub

Public Sub mnuDataBaseConnectConfig_Click()
  On Error GoTo ControlError
  
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ConfigConnection
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "mnuDataBaseConnectConfig_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuDataBaseSetParameters_Click()
  On Error GoTo ControlError

  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .SetParameters
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuDataBaseSetParameters_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuEditAddDbField_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddDBField
  End With
End Sub

Public Sub mnuEditAddHeader_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddSection (CSReportDll2.csRptTypeSection.csRptTpScHeader)
  End With
End Sub

Public Sub mnuEditAddLabel_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddLabel
  End With
End Sub

Public Sub mnuEditAddGroup_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddGroup
  End With
End Sub

Public Sub mnuEditAddFooter_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddSection (CSReportDll2.csRptTypeSection.csRptTpScFooter)
  End With
End Sub

Private Sub mnuResumen_Click()

End Sub

Private Sub mnuToolOptions_Click()
  fToolsOptions.Show , Me
End Sub

Private Sub mnuViewTreeViewCtrls_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowControlsTree
  End With
End Sub

Private Sub mnuViewControls_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowControls
  End With
End Sub

Private Sub mnuViewGridLinesBoth_Click()
  pSetGridStyle csEGridLines
End Sub

Private Sub mnuViewGridLinesH_Click()
  pSetGridStyle csEGridLinesHorizontal
End Sub

Private Sub mnuViewGridLinesV_Click()
  pSetGridStyle csEGridLinesVertical
End Sub

Private Sub mnuViewGridNone_Click()
  pSetGridStyle csEGridNone
End Sub

Private Sub mnuViewGridPoints_Click()
  pSetGridStyle csEGridPoints
End Sub

Private Sub mnuViewSumary_Click()
  fReportSumary.Show vbModal
End Sub

Private Sub mnuViewToolbar_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowToolBox
  End With
End Sub

Private Sub picBar_Resize()
  On Error Resume Next
  shBar.Width = picBar.ScaleWidth - shBar.Left * 2
  lbBar.Width = picBar.ScaleWidth - lbBar.Left * 2
  lbStatus.Left = picBar.Width - lbStatus.Width - 400
End Sub

Private Sub picToolBar_Resize()
  On Error Resume Next
  shToolBar(0).Move -20, 80, picToolBar.Width + 40, picToolBar.Height - 160
  shToolBar(1).Move -20, 90, picToolBar.Width + 40, picToolBar.Height - 160
  tbMain.Move 190, 120, picToolBar.Width - 220
End Sub

Private Sub popObjCopy_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .Copy
  End With
End Sub

Public Sub popObjEditText_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .EditText
  End With
End Sub

Private Sub popObjPasteEx_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .Paste True
  End With
End Sub

Public Sub popObjSendToBack_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .SendToBack
  End With
End Sub

Private Sub popObjPaste_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .Paste False
  End With
End Sub

Public Sub popObjProperties_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowProperties
  End With
End Sub

Public Sub popObjBringToFront_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .BringToFront
  End With
End Sub

Public Sub mnuReportPreview_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .Preview
  End With
End Sub

Public Sub mnuReportPrint_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .PrintReport
  End With
End Sub

Private Sub popSecAddSecLn_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .AddSectionLine
  End With
End Sub

Private Sub popSecMoveGroup_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .MoveGroup
  End With
End Sub

Public Sub popSecProperties_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowSectionProperties
  End With
End Sub

Public Sub mnuWindowCascade_Click()
  Me.Arrange vbCascade
End Sub

Public Sub mnuWindowHorizontal_Click()
  Me.Arrange vbTileHorizontal
End Sub

Public Sub mnuWindowArrange_Click()
  Me.Arrange vbArrangeIcons
End Sub

Public Sub mnuWindowVertical_Click()
  Me.Arrange vbTileVertical
End Sub

Public Sub popObjDelete_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .DeleteObj
  End With
End Sub

Private Sub popSecDeleteSecLn_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .DeleteObj True
  End With
End Sub

Public Sub popSecDelete_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .DeleteObj
  End With
End Sub

Private Sub popSecPropGroup_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowGroupProperties
  End With
End Sub

Private Sub popSecPropSecLn_Click()
  If GetDocActive() Is Nothing Then Exit Sub
  With GetDocActive()
    .ShowSecLnProperties
  End With
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  Select Case Button.Key
    Case c_BTN_DB
      mnuDataBaseConnectConfig_Click
    Case c_BTN_PRINT
      mnuReportPrint_Click
    Case c_BTN_PROPERTIES
      popObjProperties_Click
    Case c_BTN_SAVE
      mnuFileSave_Click
    Case c_BTN_OPEN
      mnuFileOpen_Click
    Case c_BTN_TOOL
      mnuViewToolbar_Click
    Case c_BTN_NEW
      mnuFileNew_Click
    Case c_BTN_PREV
      mnuReportPreview_Click
    
    Case c_BTN_CTL_ALIGN_BOTTOM
      pEditAlign csEAlignCtlBottom
    Case c_BTN_CTL_ALIGN_TOP
      pEditAlign csEAlignCtlTop
    Case c_BTN_CTL_ALIGN_HORIZONTAL
      pEditAlign csEAlignCtlHorizontal
    Case c_BTN_CTL_WIDTH
      pEditAlign csEAlignCtlWidth
    Case c_BTN_CTL_HEIGHT
      pEditAlign csEAlignCtlHeight
    Case c_BTN_CTL_ALIGN_RIGHT
      pEditAlign csEAlignCtlRight
    Case c_BTN_CTL_ALIGN_LEFT
      pEditAlign csEAlignCtlLeft
    Case c_BTN_CTL_ALIGN_VERTICAL
      pEditAlign csEAlignCtlVertical
    
    Case c_BTN_ALIGN_CENTER
      pEditAlign csEAlignTextCenter
    Case c_BTN_ALIGN_LEFT
      pEditAlign csEAlignTextLeft
    Case c_BTN_ALIGN_RIGHT
      pEditAlign csEAlignTextRight
      
    Case c_BTN_FONT_BOLD
      pSetFontBold
      
    Case c_BTN_SEARCH
      mnuEditSearch_Click
  End Select
End Sub

Private Sub pSetFontBold()
  If GetDocActive() Is Nothing Then Exit Sub
  GetDocActive().SetFontBold
End Sub

Private Sub pEditAlign(ByVal Align As csEAlignConst)
  If GetDocActive() Is Nothing Then Exit Sub
  
  With GetDocActive()
    Select Case Align
      Case csEAlignTextCenter
        .TextAlign vbCenter
        
      Case csEAlignTextLeft
        .TextAlign vbLeftJustify
        
      Case csEAlignTextRight
        .TextAlign vbRightJustify
    
      Case Else
        .ControlsAlign Align
    End Select
  End With
End Sub

Private Sub m_Wizard_NewReport(ByVal Report As CSReportDll2.cReport)
  Dim Mouse As New CSKernelClient2.cMouseWait


  Dim f As fReporte
  Set f = New fReporte

  gNextReport = gNextReport + 1
  f.Caption = "Reporte" & gNextReport & ".csr"
  f.Init
  f.NewReport Report

  Set m_Wizard = Nothing
End Sub

Private Sub m_Wizard_Cancel()
  Set m_Wizard = Nothing
End Sub

Private Sub pClearToolbarCaptions()
  Dim i As Long
  For i = 1 To tbMain.Buttons.Count
    tbMain.Buttons(i).Caption = ""
  Next
End Sub

Private Sub pSetStatusBar()
  With sbPanel.Panels
    .Clear
    With .Add(, c_sbPnlAction)
      .Style = sbrText
      .Alignment = sbrLeft
      .Width = 900
    End With
    With .Add(, c_sbPnlControl)
      .Style = sbrText
      .Alignment = sbrLeft
      .AutoSize = sbrSpring
    End With
    
    .Add(, , , PanelStyleConstants.sbrCaps).Width = 600
    .Add(, , , PanelStyleConstants.sbrIns).Width = 600
    .Add(, , , PanelStyleConstants.sbrNum).Width = 600
  End With
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

Private Sub pSetGridStyle(ByVal Style As csETypeGrid)
  On Error GoTo ControlError
  Dim f As fReporte
  
  mnuViewGridPoints.Checked = Style = csEGridPoints
  mnuViewGridNone.Checked = Style = csEGridNone
  mnuViewGridLinesBoth.Checked = Style = csEGridLines
  mnuViewGridLinesH.Checked = Style = csEGridLinesHorizontal
  mnuViewGridLinesV.Checked = Style = csEGridLinesVertical
  
  Set f = GetDocActive()
  If f Is Nothing Then Exit Sub
  
  f.ShowGrid Style
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSetGridStyle", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pAssocFile()
  Dim o As cAssocFile
  Set o = New cAssocFile
  
  o.DontAsk = "No volver a preguntar"
  o.YesButton = "&Si"
  o.NoButton = "&No"
  o.Question = App.Title & " no es la aplicacion por defecto encargada de editar los archivos %1." & vbCrLf & vbCrLf & "¿Desea que " & App.Title & " sea el editor por defecto?."
  
  o.ValidateAssociation "csr", App.Path & "\" & App.EXEName & ".exe", App.Title
  o.ValidateAssociation "csd", App.Path & "\" & App.EXEName & ".exe", App.Title
End Sub

Private Sub pOpenFile(ByVal FullFileName As String)
  Dim f As Object

  For Each f In Forms
    If TypeOf f Is fReporte Then
      If f.FileName = FullFileName Then
        AddToRecentList f.FileName
        f.Show
        f.ZOrder
        Exit Sub
      End If
    End If
  Next f

  Set f = New fReporte
  gNextReport = gNextReport + 1
  f.Caption = "Reporte" & gNextReport & ".csr"
  f.Init

  If f.OpenDocument(FullFileName) Then AddToRecentList f.FileName

End Sub
