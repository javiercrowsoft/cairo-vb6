VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#4.3#0"; "CSMaskEdit.ocx"
Object = "{0B7EBB95-21B3-4493-8B5C-1319674D4CF8}#2.0#0"; "CSControls.ocx"
Begin VB.Form fAsiento 
   ClientHeight    =   6630
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   10665
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   6630
   ScaleWidth      =   10665
   Begin CSControls.cHelp HL 
      Height          =   330
      Index           =   1
      Left            =   3600
      TabIndex        =   16
      Top             =   80
      Width           =   3500
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   330
      Index           =   1
      Left            =   7300
      TabIndex        =   1
      Top             =   80
      Width           =   1200
      _ExtentX        =   3519
      _ExtentY        =   556
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit MEFE 
      Height          =   285
      Index           =   1
      Left            =   700
      TabIndex        =   3
      Top             =   1575
      Width           =   1400
      _ExtentX        =   3519
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
   End
   Begin CSMaskEdit.cMaskEdit TX 
      Height          =   285
      Index           =   1
      Left            =   700
      TabIndex        =   5
      Top             =   2015
      Width           =   2265
      _ExtentX        =   3519
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
   Begin CSMaskEdit.cMaskEdit TX 
      Height          =   800
      Index           =   2
      Left            =   700
      TabIndex        =   7
      Top             =   2455
      Width           =   7450
      _ExtentX        =   3519
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
   Begin CSControls.cGridAdvanced GR 
      Height          =   1775
      Index           =   1
      Left            =   180
      TabIndex        =   9
      Top             =   3925
      Width           =   10305
      _ExtentX        =   0
      _ExtentY        =   0
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   2
      Left            =   290
      TabIndex        =   11
      Top             =   6180
      Width           =   1100
      _ExtentX        =   3519
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
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   3
      Left            =   1590
      TabIndex        =   14
      Top             =   6180
      Width           =   1100
      _ExtentX        =   3519
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
   Begin MSComctlLib.Toolbar tbMain 
      Height          =   330
      Left            =   60
      TabIndex        =   18
      Top             =   600
      Width           =   8160
      _ExtentX        =   14393
      _ExtentY        =   582
      ButtonWidth     =   609
      ButtonHeight    =   582
      Style           =   1
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   31
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "NEW"
            Object.ToolTipText     =   "Nuevo"
            ImageIndex      =   2
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "SAVE"
            Object.ToolTipText     =   "Guardar"
            ImageIndex      =   1
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "RELOAD"
            Object.ToolTipText     =   "Descartar los cambios"
            ImageIndex      =   17
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ANULAR"
            ImageIndex      =   18
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "COPY"
            Object.ToolTipText     =   "Copiar"
            ImageIndex      =   3
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "SEARCH"
            Object.ToolTipText     =   "Buscar"
            ImageIndex      =   11
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "FIRST"
            Object.ToolTipText     =   "Ir al primer documento"
            ImageIndex      =   12
         EndProperty
         BeginProperty Button13 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "PREVIOUS"
            Object.ToolTipText     =   "Ir al documento anterior"
            ImageIndex      =   13
         EndProperty
         BeginProperty Button14 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "NEXT"
            Object.ToolTipText     =   "Ir al siguiente documento"
            ImageIndex      =   14
         EndProperty
         BeginProperty Button15 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "LAST"
            Object.ToolTipText     =   "Ir al ultimo documento"
            ImageIndex      =   15
         EndProperty
         BeginProperty Button16 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button17 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "DELETE"
            Object.ToolTipText     =   "Borrar"
            ImageIndex      =   4
         EndProperty
         BeginProperty Button18 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button19 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "PRINT"
            Object.ToolTipText     =   "Imprimir"
            ImageIndex      =   5
         EndProperty
         BeginProperty Button20 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button21 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "SIGNATURE"
            Object.ToolTipText     =   "Firmar el documento"
            ImageIndex      =   7
         EndProperty
         BeginProperty Button22 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "HISTORY"
            Object.ToolTipText     =   "Ver quien modifico el documento"
            ImageIndex      =   10
         EndProperty
         BeginProperty Button23 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "APPLY"
            Object.ToolTipText     =   "Ver aplicaciones"
            ImageIndex      =   9
         EndProperty
         BeginProperty Button24 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button25 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ATTACH"
            Object.ToolTipText     =   "Asociar archivos"
            ImageIndex      =   16
         EndProperty
         BeginProperty Button26 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button27 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "EDIT_STATE"
            ImageIndex      =   19
         EndProperty
         BeginProperty Button28 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button29 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "HELP"
            Object.ToolTipText     =   "Ayuda"
            ImageIndex      =   8
         EndProperty
         BeginProperty Button30 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button31 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "CLOSE"
            Object.ToolTipText     =   "Cerrar"
            ImageIndex      =   6
         EndProperty
      EndProperty
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   0
      Left            =   85
      TabIndex        =   19
      Top             =   1080
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&1-General"
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
      BackColor       =   -2147483628
      BackColorPressed=   -2147483628
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   0
      Picture         =   "fAsiento.frx":0000
      Top             =   0
      Width           =   480
   End
   Begin VB.Shape shToolbar 
      BorderColor     =   &H80000010&
      Height          =   435
      Left            =   0
      Top             =   540
      Width           =   10665
   End
   Begin VB.Label lbTitleEx2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   4410
      TabIndex        =   13
      Top             =   45
      Width           =   75
   End
   Begin VB.Shape shTabItems 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   1975
      Left            =   90
      Top             =   3825
      Width           =   10485
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Asiento Contable"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   330
      Left            =   540
      TabIndex        =   0
      Top             =   45
      Width           =   2175
   End
   Begin VB.Shape shTitle 
      BackColor       =   &H8000000C&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   540
      Left            =   0
      Top             =   0
      Width           =   10665
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Documento"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   1
      Left            =   180
      TabIndex        =   17
      Top             =   1575
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Número"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   2
      Left            =   180
      TabIndex        =   2
      Top             =   1575
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Fecha"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   3
      Left            =   120
      TabIndex        =   4
      Top             =   1575
      Width           =   580
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Numero"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   4
      Left            =   120
      TabIndex        =   6
      Top             =   2015
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Observ."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   5
      Left            =   100
      TabIndex        =   8
      Top             =   2455
      Width           =   600
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "ITEMS"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   420
      Index           =   6
      Left            =   180
      TabIndex        =   10
      Top             =   1575
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Total Debe"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   7
      Left            =   290
      TabIndex        =   12
      Top             =   5955
      Width           =   1000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Total Haber"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   8
      Left            =   1590
      TabIndex        =   15
      Top             =   5955
      Width           =   1000
   End
   Begin VB.Shape ShTab 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   1995
      Left            =   90
      Top             =   1395
      Width           =   10485
   End
   Begin VB.Shape shTabFooter 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   630
      Left            =   90
      Top             =   5900
      Width           =   10485
   End
End
Attribute VB_Name = "fAsiento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements CSIABMForm.cIABMDocForm
'--------------------------------------------------------------------------------
' fAsiento
' 16-05-04

'--------------------------------------------------------------------------------
' notas:

'        Al agregar tabs hay que tener en cuenta que cambia el tab de items
'        y footers por tanto hay que modificar la funcion cbTab_Click

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fAsiento"

' estructuras
' variables privadas
Private m_oldME()       As String
Private m_oldMEFE()     As String
Private m_oldTX()       As String

Private m_WasActivated    As Boolean

Private m_Loading         As Boolean

' eventos
Private Type CtlInfo
  ctl     As Control
  Offset  As Integer
End Type

Private m_ItemsControls()         As CtlInfo
Private m_FootersControls()       As CtlInfo

Private m_CancelUnload         As Boolean

Private m_WasChanged           As Boolean

Private m_ObjHeader            As cIABMDocEvent
Private m_ObjItems             As cIABMDocEvent
Private m_ObjFooter            As cIABMDocEvent

Private m_ABMObject            As Object

' Indices de controles para el ObjClient
Private m_CBhockUbound                  As Long
Private m_CBUbound                      As Long
Private m_HLUbound                      As Long
Private m_MEUbound                      As Long
Private m_MEFEUbound                    As Long
Private m_LB2Ubound                     As Long
Private m_LbTitle2Ubound                As Long
Private m_PrgBarUbound                  As Long
Private m_LBDescripUbound               As Long
Private m_ImgUbound                     As Long
Private m_TXUbound                      As Long
Private m_CHKUbound                     As Long
Private m_GRUbound                      As Long
Private m_CMDUbound                     As Long
Private m_LBUbound                      As Long

' Propiedades publicas
Public Property Get CBhockUbound() As Long
   CBhockUbound = m_CBhockUbound
End Property

Public Property Let CBhockUbound(ByVal rhs As Long)
   m_CBhockUbound = rhs
End Property

Public Property Get CBUbound() As Long
   CBUbound = m_CBUbound
End Property

Public Property Let CBUbound(ByVal rhs As Long)
   m_CBUbound = rhs
End Property

Public Property Get HLUbound() As Long
   HLUbound = m_HLUbound
End Property

Public Property Let HLUbound(ByVal rhs As Long)
   m_HLUbound = rhs
End Property

Public Property Get MEUbound() As Long
   MEUbound = m_MEUbound
End Property

Public Property Let MEUbound(ByVal rhs As Long)
   m_MEUbound = rhs
End Property

Public Property Get MEFEUbound() As Long
   MEFEUbound = m_MEFEUbound
End Property

Public Property Let MEFEUbound(ByVal rhs As Long)
   m_MEFEUbound = rhs
End Property

Public Property Get LB2Ubound() As Long
   LB2Ubound = m_LB2Ubound
End Property

Public Property Let LB2Ubound(ByVal rhs As Long)
   m_LB2Ubound = rhs
End Property

Public Property Get LbTitle2Ubound() As Long
   LbTitle2Ubound = m_LbTitle2Ubound
End Property

Public Property Let LbTitle2Ubound(ByVal rhs As Long)
   m_LbTitle2Ubound = rhs
End Property

Public Property Get PrgBarUbound() As Long
   PrgBarUbound = m_PrgBarUbound
End Property

Public Property Let PrgBarUbound(ByVal rhs As Long)
   m_PrgBarUbound = rhs
End Property

Public Property Get LBDescripUbound() As Long
   LBDescripUbound = m_LBDescripUbound
End Property

Public Property Let LBDescripUbound(ByVal rhs As Long)
   m_LBDescripUbound = rhs
End Property

Public Property Get ImgUbound() As Long
   ImgUbound = m_ImgUbound
End Property

Public Property Let ImgUbound(ByVal rhs As Long)
   m_ImgUbound = rhs
End Property

Public Property Get TXUbound() As Long
   TXUbound = m_TXUbound
End Property

Public Property Let TXUbound(ByVal rhs As Long)
   m_TXUbound = rhs
End Property

Public Property Get CHKUbound() As Long
   CHKUbound = m_CHKUbound
End Property

Public Property Let CHKUbound(ByVal rhs As Long)
   m_CHKUbound = rhs
End Property

Public Property Get GRUbound() As Long
   GRUbound = m_GRUbound
End Property

Public Property Let GRUbound(ByVal rhs As Long)
   m_GRUbound = rhs
End Property

Public Property Get CMDUbound() As Long
   CMDUbound = m_CMDUbound
End Property

Public Property Let CMDUbound(ByVal rhs As Long)
   m_CMDUbound = rhs
End Property

Public Property Get LBUbound() As Long
   LBUbound = m_LBUbound
End Property

Public Property Let LBUbound(ByVal rhs As Long)
   m_LBUbound = rhs
End Property

Public Property Set ObjHeader(ByRef rhs As cIABMDocEvent)
  Set m_ObjHeader = rhs
End Property

Public Property Set ObjItems(ByRef rhs As cIABMDocEvent)
  Set m_ObjItems = rhs
End Property

Public Property Set ObjFooter(ByRef rhs As cIABMDocEvent)
  Set m_ObjFooter = rhs
End Property

Public Property Get cIABMDocForm_ABMObject() As Object
  Set cIABMDocForm_ABMObject = m_ABMObject
End Property

Public Property Set cIABMDocForm_ABMObject(ByRef rhs As Object)
  Set m_ABMObject = rhs
End Property

Public Property Let cIABMDocForm_Loading(ByVal rhs As Boolean)
  m_Loading = rhs
  If Not m_Loading Then
    pFillColControls
    Form_Resize
  End If
End Property

Public Property Get cIABMDocForm_CancelUnload() As Boolean
  cIABMDocForm_CancelUnload = m_CancelUnload
End Property

Public Property Let cIABMDocForm_CancelUnload(ByVal rhs As Boolean)
  m_CancelUnload = rhs
End Property

Public Property Get cIABMDocForm_WasChanged() As Boolean
  cIABMDocForm_WasChanged = m_WasChanged
End Property

Public Property Let cIABMDocForm_WasChanged(ByVal rhs As Boolean)
  m_WasChanged = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub cIABMDocForm_doPropertyChange()
  If Me.ActiveControl Is Nothing Then Exit Sub

  With Me.ActiveControl

    Select Case .Name
      Case "ME"
        ME_LostFocus .Index
      Case "MEFE"
        MEFE_LostFocus .Index
      Case "TX"
        TX_LostFocus .Index
      Case "HL"
        HL(.Index).Validate
        HL_Change .Index
    End Select
  End With
End Sub

Public Sub cIABMDocForm_InitMembers()
  ReDim m_oldME(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldTX(0)
  ReDim m_ItemsControls(0)
  ReDim m_FootersControls(0)
  ReDim m_ItemsControlsOffset(0)
  
  m_CBhockUbound = 0
  m_CBUbound = 0
  m_HLUbound = 0
  m_MEUbound = 0
  m_MEFEUbound = 0
  m_LB2Ubound = 0
  m_LbTitle2Ubound = 0
  m_PrgBarUbound = 0
  m_LBDescripUbound = 0
  m_ImgUbound = 0
  m_TXUbound = 0
  m_CHKUbound = 0
  m_GRUbound = 0
  m_CMDUbound = 0
  m_LBUbound = 0
End Sub

Public Function cIABMDocForm_CtrlKeySave() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbSave)
  cIABMDocForm_CtrlKeySave = True
End Function

Public Function cIABMDocForm_CtrlKeyNew() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbNew)
  cIABMDocForm_CtrlKeyNew = True
End Function

Public Function cIABMDocForm_CtrlKeyCopy() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbCopy)
  cIABMDocForm_CtrlKeyCopy = True
End Function

Public Function cIABMDocForm_CtrlKeyRefresh() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbReload)
  cIABMDocForm_CtrlKeyRefresh = True
End Function

Public Function cIABMDocForm_CtrlKeyClose() As Boolean
  tbMain_ButtonClick tbMain.Buttons(c_KeyTbClose)
  cIABMDocForm_CtrlKeyClose = True
End Function

Public Sub cIABMDocForm_SetToolbar(ByRef Tbl As Object)

End Sub
Public Sub cIABMDocForm_UnLoadToolbar()

End Sub
Public Sub cIABMDocForm_SetFocusFirstControl()
  On Error Resume Next
  
  Dim c As Control
  Dim MinTab As Long
  Dim MaxTab As Long
  
  MaxTab = 0
  MinTab = 10000
  
  For Each c In Me.Controls
    Err.Clear
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
  Next
  
  Do
    For Each c In Me.Controls
      Err.Clear
      With c
        If .TabIndex = MinTab Then
          If Err.Number = 0 Then
            .SetFocus
            Exit For
          End If
        End If
      End With
    Next
    MinTab = MinTab + 1
  Loop Until MinTab > MaxTab Or Err.Number = 0
End Sub
' funciones privadas
'----------------
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me
End Sub

Private Sub Form_Activate()
  If m_WasActivated Then Exit Sub
  m_WasActivated = True
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Call m_ObjHeader.FormQueryUnload(Cancel, UnloadMode)
  If Cancel Then
    gUnloadCancel = True
  End If
End Sub

Private Sub GR_ColumnAfterEdit(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  Call m_ObjItems.GRColumnAfterEdit(Index, lRow, lCol, NewValue, NewValueID, bCancel)
End Sub

Private Sub GR_ColumnAfterUpdate(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Call m_ObjItems.GRColumnAfterUpdate(Index, lRow, lCol, NewValue, NewValueID)
End Sub

Private Sub GR_ColumnBeforeEdit(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  Call m_ObjItems.GRColumnBeforeEdit(Index, lRow, lCol, iKeyAscii, bCancel)
End Sub

Private Sub GR_ColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  Call m_ObjItems.GRColumnButtonClick(Index, lRow, lCol, iKeyAscii, bCancel)
End Sub

Private Sub GR_ColumnClick(Index As Integer, ByVal lCol As Long)
  Call m_ObjItems.GRClick(Index)
End Sub

Private Sub GR_DblClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Call m_ObjItems.GRDblClick(Index, lRow, lCol)
End Sub

Private Sub GR_DeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  Call m_ObjItems.GRDeleteRow(Index, lRow, bCancel)
End Sub

Private Sub GR_GotFocus(Index As Integer)
  On Error Resume Next
  
  If GR(Index).SelectedRow = 0 Then
    GR(Index).SelectedRow = 1
    GR(Index).SelectedCol = 2
  End If
End Sub

Private Sub GR_NewRow(Index As Integer, ByVal lRow As Long)
  Call m_ObjItems.GRNewRow(Index, lRow)
End Sub

Private Sub GR_ValidateRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  Call m_ObjItems.GRValidateRow(Index, lRow, bCancel)
End Sub

Private Sub HL_Change(Index As Integer)
  Call m_ObjHeader.HLChange(Index)
End Sub

Private Sub ME_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldME) < Index Then ReDim Preserve m_oldME(Index)
  m_oldME(Index) = Me.ME(Index).csValue
ControlError:
End Sub

Private Sub ME_LostFocus(Index As Integer)
  If m_oldME(Index) = Me.ME(Index).csValue Then Exit Sub
  Call m_ObjHeader.MEChange(Index)
End Sub

Private Sub MEFE_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldMEFE) < Index Then ReDim Preserve m_oldMEFE(Index)
  m_oldMEFE(Index) = Me.MEFE(Index).csValue
ControlError:
End Sub

Private Sub MEFE_LostFocus(Index As Integer)
  If m_oldMEFE(Index) = Me.MEFE(Index).csValue Then Exit Sub
  Call m_ObjHeader.MEDateChange(Index)
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  Call m_ObjHeader.ToolBarClick(Button)
End Sub

Private Sub TX_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTX) < Index Then ReDim Preserve m_oldTX(Index)
  m_oldTX(Index) = TX(Index).Text
ControlError:
End Sub

Private Sub TX_ReturnFromHelp(Index As Integer)
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  Call m_ObjHeader.TXChange(Index)
  m_oldTX(Index) = TX(Index).Text
End Sub

Private Sub TX_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  Call m_ObjHeader.TXChange(Index)
ControlError:
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim i As Integer

  If WindowState = vbMinimized Then Exit Sub

  shTitle.Move 0, 0, ScaleWidth
 
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
      If Not (TypeOf ctl Is Line Or TypeOf ctl Is Menu Or TypeOf ctl Is Toolbar Or TypeOf ctl Is ImageList) Then
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

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  cIABMDocForm_InitMembers
  
  m_WasActivated = False
  m_Loading = True
  m_CancelUnload = False
  m_WasChanged = False

  Call m_ObjHeader.FormLoad

  SetToolbarIcons tbMain

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  
  cIABMDocForm_InitMembers
  
  Set m_ABMObject = Nothing
  Call m_ObjHeader.FormUnload(Cancel)
  
  CSKernelClient.UnloadForm Me, "ABM_" & Me.lbTitle.Caption
End Sub
