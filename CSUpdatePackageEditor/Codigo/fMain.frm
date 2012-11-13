VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fMain 
   Caption         =   "CrowSoft Update Package Editor"
   ClientHeight    =   6390
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   9300
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6390
   ScaleWidth      =   9300
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.Toolbar tbMain 
      Align           =   1  'Align Top
      Height          =   570
      Left            =   0
      TabIndex        =   24
      Top             =   615
      Width           =   9300
      _ExtentX        =   16404
      _ExtentY        =   1005
      ButtonWidth     =   1826
      ButtonHeight    =   953
      Appearance      =   1
      Style           =   1
      ImageList       =   "ImgTbBar"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   4
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Nuevo CSAI"
            Key             =   "NEW_CSAI"
            ImageIndex      =   29
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Nuevo CSA"
            Key             =   "NEW_CSA"
            ImageIndex      =   1
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Guardar CSA"
            Key             =   "SAVE_CSA"
            ImageIndex      =   2
         EndProperty
      EndProperty
   End
   Begin VB.Frame frCSA 
      Height          =   1725
      Left            =   45
      TabIndex        =   7
      Top             =   1170
      Width           =   8340
      Begin CSButton.cButtonLigth cmdEditCSA 
         Height          =   330
         Left            =   6345
         TabIndex        =   12
         Top             =   225
         Width           =   1590
         _ExtentX        =   2805
         _ExtentY        =   582
         Caption         =   "&Editar ..."
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
         ForeColor       =   0
         Enabled         =   0   'False
      End
      Begin VB.TextBox txPackageName 
         BorderStyle     =   0  'None
         Height          =   285
         Left            =   2025
         TabIndex        =   8
         Text            =   "update.csa"
         Top             =   255
         Width           =   2805
      End
      Begin CSMaskEdit2.cMaskEdit txPackagePath 
         Height          =   285
         Left            =   2025
         TabIndex        =   9
         Top             =   690
         Width           =   5865
         _ExtentX        =   10345
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
         ForeColor       =   0
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   9
         csNotRaiseError =   -1  'True
      End
      Begin CSButton.cButtonLigth cmdAddFiles 
         Height          =   330
         Left            =   180
         TabIndex        =   13
         Top             =   1260
         Width           =   1905
         _ExtentX        =   3360
         _ExtentY        =   582
         Caption         =   "&Agregar Archivos ..."
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
         ForeColor       =   0
         Enabled         =   0   'False
      End
      Begin CSButton.cButtonLigth cmdAddScripts 
         Height          =   330
         Left            =   2205
         TabIndex        =   14
         Top             =   1260
         Width           =   1905
         _ExtentX        =   3360
         _ExtentY        =   582
         Caption         =   "&Agregar Scripts ..."
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
         ForeColor       =   0
         Enabled         =   0   'False
      End
      Begin CSButton.cButtonLigth cmdAddCsr 
         Height          =   330
         Left            =   4230
         TabIndex        =   15
         Top             =   1260
         Width           =   1905
         _ExtentX        =   3360
         _ExtentY        =   582
         Caption         =   "&Agregar Reportes ..."
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
         ForeColor       =   0
         Enabled         =   0   'False
      End
      Begin CSButton.cButtonLigth cmdRemove 
         Height          =   330
         Left            =   6255
         TabIndex        =   16
         Top             =   1260
         Width           =   1905
         _ExtentX        =   3360
         _ExtentY        =   582
         Caption         =   "&Remover ..."
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
         ForeColor       =   0
         Enabled         =   0   'False
      End
      Begin VB.Line Line2 
         BorderColor     =   &H80000014&
         X1              =   0
         X2              =   8325
         Y1              =   1145
         Y2              =   1145
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000010&
         X1              =   0
         X2              =   8325
         Y1              =   1125
         Y2              =   1125
      End
      Begin VB.Label Label1 
         Caption         =   "Nombre del Paquete:"
         Height          =   240
         Left            =   135
         TabIndex        =   11
         Top             =   255
         Width           =   1590
      End
      Begin VB.Shape Shape1 
         BorderColor     =   &H80000010&
         Height          =   345
         Left            =   1995
         Top             =   225
         Width           =   2865
      End
      Begin VB.Shape Shape4 
         BorderColor     =   &H80000010&
         Height          =   345
         Left            =   1995
         Top             =   660
         Width           =   5925
      End
      Begin VB.Label Label4 
         Caption         =   "Guardar el paquete en:"
         Height          =   240
         Left            =   135
         TabIndex        =   10
         Top             =   690
         Width           =   1770
      End
   End
   Begin VB.PictureBox picTop 
      Align           =   1  'Align Top
      BackColor       =   &H8000000C&
      BorderStyle     =   0  'None
      Height          =   615
      Left            =   0
      ScaleHeight     =   615
      ScaleWidth      =   9300
      TabIndex        =   4
      Top             =   0
      Width           =   9300
      Begin VB.Label lbTopTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Procesando ..."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000009&
         Height          =   195
         Left            =   150
         TabIndex        =   5
         Top             =   150
         Width           =   1260
      End
      Begin VB.Shape shTop 
         BorderColor     =   &H80000016&
         Height          =   465
         Left            =   75
         Shape           =   4  'Rounded Rectangle
         Top             =   75
         Width           =   6015
      End
   End
   Begin MSComDlg.CommonDialog cdFile 
      Left            =   4800
      Top             =   3540
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox picSplitter 
      BorderStyle     =   0  'None
      Height          =   60
      Left            =   225
      MousePointer    =   7  'Size N S
      ScaleHeight     =   60
      ScaleWidth      =   5115
      TabIndex        =   2
      Top             =   4110
      Visible         =   0   'False
      Width           =   5115
   End
   Begin VB.PictureBox picSplitterBar 
      BorderStyle     =   0  'None
      Height          =   60
      Left            =   150
      MousePointer    =   7  'Size N S
      ScaleHeight     =   60
      ScaleWidth      =   5115
      TabIndex        =   3
      Top             =   3255
      Width           =   5115
   End
   Begin RichTextLib.RichTextBox rtxInfo 
      Height          =   840
      Left            =   225
      TabIndex        =   1
      Top             =   4245
      Width           =   3390
      _ExtentX        =   5980
      _ExtentY        =   1482
      _Version        =   393217
      TextRTF         =   $"fMain.frx":1042
   End
   Begin MSComctlLib.ListView lvInfo 
      Height          =   1965
      Left            =   180
      TabIndex        =   0
      Top             =   3105
      Width           =   5040
      _ExtentX        =   8890
      _ExtentY        =   3466
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   240
      Left            =   0
      TabIndex        =   6
      Top             =   6150
      Width           =   9300
      _ExtentX        =   16404
      _ExtentY        =   423
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList ilsIcons16 
      Left            =   6480
      Top             =   3690
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":10C4
            Key             =   "DEFAULT"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":121E
            Key             =   "OPEN"
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picProgress 
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   1845
      ScaleHeight     =   4290
      ScaleWidth      =   6135
      TabIndex        =   17
      Top             =   1665
      Visible         =   0   'False
      Width           =   6135
      Begin VB.PictureBox picStatus 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ClipControls    =   0   'False
         FillColor       =   &H0080C0FF&
         Height          =   330
         Left            =   195
         ScaleHeight     =   330
         ScaleWidth      =   5730
         TabIndex        =   20
         TabStop         =   0   'False
         Top             =   1350
         Width           =   5730
      End
      Begin VB.ListBox lsFiles 
         Appearance      =   0  'Flat
         BackColor       =   &H8000000F&
         Height          =   1785
         Left            =   135
         TabIndex        =   18
         Top             =   1890
         Width           =   5865
      End
      Begin CSButton.cButtonLigth cmdCancel 
         Height          =   330
         Left            =   2385
         TabIndex        =   19
         Top             =   3825
         Width           =   1410
         _ExtentX        =   2487
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
         ForeColor       =   0
      End
      Begin VB.Label lbProcess 
         BackStyle       =   0  'Transparent
         BorderStyle     =   1  'Fixed Single
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   765
         Left            =   150
         TabIndex        =   23
         Top             =   465
         Width           =   5820
      End
      Begin VB.Label Label5 
         BackStyle       =   0  'Transparent
         Caption         =   "Procesando:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   150
         TabIndex        =   22
         Top             =   135
         Width           =   1470
      End
      Begin VB.Shape Shape5 
         BorderColor     =   &H0080C0FF&
         Height          =   435
         Left            =   135
         Top             =   1290
         Width           =   5850
      End
      Begin VB.Shape Shape6 
         BackColor       =   &H8000000F&
         BorderColor     =   &H0080C0FF&
         BorderWidth     =   3
         Height          =   4290
         Left            =   0
         Top             =   0
         Width           =   6135
      End
      Begin VB.Label lbClose 
         Alignment       =   2  'Center
         BackColor       =   &H000080FF&
         Caption         =   "X"
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
         Left            =   5715
         TabIndex        =   21
         Top             =   90
         Width           =   240
      End
   End
   Begin MSComctlLib.ImageList ImgTbBar 
      Left            =   225
      Top             =   5265
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   29
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1378
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1912
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1EAC
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2446
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":29E0
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2F7A
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":30D4
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":366E
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":3C08
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":419A
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4734
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4CCE
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":5268
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":5802
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":5D9C
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":5EF6
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":6490
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":6A2A
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":6FC4
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":711E
            Key             =   ""
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":76B8
            Key             =   ""
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":7C52
            Key             =   ""
         EndProperty
         BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":81EC
            Key             =   ""
         EndProperty
         BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":8786
            Key             =   ""
         EndProperty
         BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":8D20
            Key             =   ""
         EndProperty
         BeginProperty ListImage26 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":92BA
            Key             =   ""
         EndProperty
         BeginProperty ListImage27 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":9854
            Key             =   ""
         EndProperty
         BeginProperty ListImage28 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":9DEE
            Key             =   ""
         EndProperty
         BeginProperty ListImage29 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":A188
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuFileNew 
         Caption         =   "&Nuevo Paquete de Actualización..."
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Abrir Paquete de Actualización..."
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Guardar Paquete de Actualizacion..."
      End
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileNewCSAI 
         Caption         =   "Nuevo Paquete de Actualización de Reportes..."
      End
      Begin VB.Menu mnuFileOpenCSAI 
         Caption         =   "Abrir Paquete de Actualización de Reportes..."
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuHelpIndex 
         Caption         =   "&Indice..."
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&Acerca de CSUpdatePackageEditor..."
      End
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fMain
' 30-04-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "fMain"

Private Const c_sbrOperation = "k1"
Private Const c_sbrPercent = "k2"
Private Const c_sbrStatus = "k3"
Private Const c_sbrInfo = "k4"

' estructuras
' variables privadas
Private WithEvents m_Client   As cTCPIPClient
Attribute m_Client.VB_VarHelpID = -1

Private m_bCSAIsOpen          As Boolean

' eventos
' propiedadades publicas

Public Property Get bCSAIsOpen() As Boolean
   bCSAIsOpen = m_bCSAIsOpen
End Property

Public Property Let bCSAIsOpen(ByRef rhs As Boolean)
   m_bCSAIsOpen = rhs
End Property

Public Property Get Client() As cTCPIPClient
   Set Client = m_Client
End Property

Public Property Set Client(ByRef rhs As cTCPIPClient)
   Set m_Client = rhs
End Property

Public Property Let Operation(ByVal rhs As String)
   sbrMain.Panels(c_sbrOperation).Text = rhs & "..."
End Property

Public Sub AddCsr()
  On Error GoTo ControlError
  
  fAddFiles.lbTarget.Visible = False
  fAddFiles.cbTarget.Visible = False
  fAddFiles.cbTarget.ListIndex = 1
  fAddFiles.cdFiles.Filter = "Archivos de Reportes|*.csr;*.csai;*.xml|" & _
                             "Archivos de CSR|*.csr|" & _
                             "Definiciones de Navegación|*.xml|" & _
                             "Paquetes de Reportes|*.csai"
  
  Dim i As Long
  
  With fAddFiles.lsFiles
    .Clear
    For i = 1 To UBound(g_SetupCfg.Reports)
      .AddItem GetValidPath( _
                  g_SetupCfg.Reports(i).SourcePath) _
                  & g_SetupCfg.Reports(i).Filename
      .ItemData(.NewIndex) = g_SetupCfg.Reports(i).idFile
    Next
  End With
  
  fAddFiles.Show vbModal
  
  If fAddFiles.Ok Then
  
    lvInfo.Sorted = False
  
    UpdateSetupReports
    
    UpdateLvInfoCsr Me.lvInfo
  End If
  
  Exit Sub
ControlError:
  MngError Err, "AddCsr", C_Module, ""
End Sub

Private Sub cmdAddCsr_Click()
  AddCsr
End Sub

Private Sub cmdAddFiles_Click()
  On Error GoTo ControlError
  
  fAddFiles.IdTypeFile = c_id_file_files_new
  fAddFiles.lbTarget.Visible = True
  fAddFiles.cbTarget.Visible = True
  fAddFiles.cbTarget.ListIndex = 0
  fAddFiles.cdFiles.Filter = "Todos los Archivos|*.*"
  
  Dim i As Long
  
  With fAddFiles.lsFiles
    .Clear
    For i = 1 To UBound(g_SetupCfg.Files)
      .AddItem GetValidPath( _
                  g_SetupCfg.Files(i).SourcePath) _
                  & g_SetupCfg.Files(i).Filename
      .ItemData(.NewIndex) = g_SetupCfg.Files(i).idFile
    Next
  End With
  
  fAddFiles.Show vbModal
  
  If fAddFiles.Ok Then
    
    lvInfo.Sorted = False
    
    UpdateSetupFiles
    
    UpdateLvInfoFiles Me.lvInfo
  End If
  
  Exit Sub
ControlError:
  MngError Err, "cmdAddFiles_Click", C_Module, ""
End Sub

Private Sub cmdAddScripts_Click()
  On Error GoTo ControlError
  
  fAddFiles.IdTypeFile = c_id_file_scripts_new
  fAddFiles.lbTarget.Visible = False
  fAddFiles.cbTarget.Visible = False
  fAddFiles.cdFiles.Filter = "Archivos de SQL|*.sql"
  
  Dim i As Long
  
  With fAddFiles.lsFiles
    .Clear
    For i = 1 To UBound(g_SetupCfg.Scripts)
      .AddItem GetValidPath( _
                  g_SetupCfg.Scripts(i).SourcePath) _
                  & g_SetupCfg.Scripts(i).Filename
      .ItemData(.NewIndex) = g_SetupCfg.Scripts(i).idFile
    Next
  End With
  
  fAddFiles.Show vbModal
  
  If fAddFiles.Ok Then
  
    lvInfo.Sorted = False
    
    UpdateSetupScripts
    
    UpdateLvInfoScripts Me.lvInfo
  End If
  
  Exit Sub
ControlError:
  MngError Err, "cmdAddScripts_Click", C_Module, ""
End Sub

Private Sub cmdEditCSA_Click()
  On Error GoTo ControlError
  
  tCSAtofCSA
  fCSA.Show vbModal
  If fCSA.Ok Then
    fCSAtotCSA
  End If
  
  Exit Sub
ControlError:
  MngError Err, "cmdEditCSA_Click", C_Module, ""
End Sub

Private Sub cmdRemove_Click()
  On Error GoTo ControlError
  
  Dim Item    As ListItem
  Dim i       As Long
  Dim k       As Long
  Dim bFound  As Boolean
  Dim idFile  As Long

  k = 1
  While k <= lvInfo.ListItems.Count
  
    Set Item = lvInfo.ListItems(k)
  
    If Item.Selected Then

      idFile = Val(Item.Tag)
        
      With g_SetupCfg
        If idFile < c_id_file_files Then
          For i = 1 To UBound(.Files)
            If idFile = .Files(i).idFile Then
              bFound = True
              Exit For
            End If
          Next
        
          If bFound Then
            For i = i To UBound(.Files) - 1
              .Files(i) = .Files(i + 1)
            Next
          End If
          
          ReDim Preserve .Files(UBound(.Files) - 1)
          
        ElseIf idFile < c_id_file_scripts Then
          For i = 1 To UBound(.Scripts)
            If idFile = .Scripts(i).idFile Then
              bFound = True
              Exit For
            End If
          Next
        
          If bFound Then
            For i = i To UBound(.Scripts) - 1
              .Scripts(i) = .Scripts(i + 1)
            Next
          End If
          
          ReDim Preserve .Scripts(UBound(.Scripts) - 1)
          
        ElseIf idFile < c_id_file_csrs Then
          For i = 1 To UBound(.Reports)
            If idFile = .Reports(i).idFile Then
              bFound = True
              Exit For
            End If
          Next
        
          If bFound Then
            For i = i To UBound(.Reports) - 1
              .Reports(i) = .Reports(i + 1)
            Next
          End If
          
          ReDim Preserve .Reports(UBound(.Reports) - 1)
        End If
      End With
    
      lvInfo.ListItems.Remove k
          
    Else
      k = k + 1
    End If
  Wend
  
  Exit Sub
ControlError:
  MngError Err, "cmdRemove_Click", C_Module, ""
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError
  
  Dim Top As Single
  
  frCSA.Left = 0
  Top = frCSA.Top + frCSA.Height + 10
  
  txPackagePath.Text = GetValidPath(GetEspecialFolders(sfidDESKTOP)) & "package"
  
  pInitForm
  
  picSplitter.Left = 0
  
  With lvInfo
    .View = lvwReport
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .HideSelection = False
    .MultiSelect = True
    .Left = 0
    .Top = Top
    .SmallIcons = ilsIcons16
    With .ColumnHeaders
      .Add , , "Nombre", 2200
      .Add , , "Archivo", 2200
      .Add , , "Origen", 4000
      .Add , , "Destino", 1000
      .Add , , "Tipo", 800
    End With
  End With
  
  rtxInfo.Left = 0
  picSplitterBar.Left = 0
  picSplitterBar.Top = Top + (Me.ScaleHeight - Top) * 0.5
  
  g_SetupCfg.CSA_File = txPackageName.Text
  
  CSKernelClient2.LoadForm Me, Me.name
  
  Exit Sub
ControlError:
  MngError Err, "Form_Load", C_Module, ""
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim Height As Single
  
  frCSA.Width = Me.ScaleWidth
  
  Height = Me.ScaleHeight - sbrMain.Height
  
  picSplitterBar.Width = Me.ScaleWidth
  shTop.Width = ScaleWidth - shTop.Left * 2
  
  lvInfo.Width = Me.ScaleWidth
  lvInfo.Height = picSplitterBar.Top - lvInfo.Top

  rtxInfo.Width = Me.ScaleWidth
  rtxInfo.Height = Height - picSplitterBar.Top - picSplitterBar.Height
  rtxInfo.Top = picSplitterBar.Top + picSplitterBar.Height

  Line1.X2 = frCSA.Width - 20
  Line2.X2 = Line1.X2

End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  CSKernelClient2.UnloadForm Me, Me.name
  CloseApp

  Exit Sub
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
End Sub

Private Sub lvInfo_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  If lvInfo.Sorted And _
    ColumnHeader.Index - 1 = lvInfo.SortKey Then
    ' Already sorted on this column, just invert the sort order.
    lvInfo.SortOrder = 1 - lvInfo.SortOrder
  Else
    lvInfo.SortOrder = lvwAscending
    lvInfo.SortKey = ColumnHeader.Index - 1
  End If
  lvInfo.Sorted = True
End Sub

Private Sub lvInfo_DblClick()
  On Error GoTo ControlError

  If lvInfo.SelectedItem Is Nothing Then Exit Sub
  
  Dim idFile As Long
  
  idFile = Val(lvInfo.SelectedItem.Tag)
  
  If CSAEditFile(lvInfo.SelectedItem.Text, idFile) Then
    
    Dim i       As Long
    Dim bFound  As Boolean
    
    With g_SetupCfg
      If idFile < c_id_file_files Then
        For i = 1 To UBound(.Files)
          If idFile = .Files(i).idFile Then
            bFound = True
            Exit For
          End If
        Next
      
        If bFound Then
          lvInfo.SelectedItem.Text = .Files(i).name
          lvInfo.SelectedItem.SubItems(1) = .Files(i).Filename
          lvInfo.SelectedItem.SubItems(2) = .Files(i).SourcePath
          lvInfo.SelectedItem.SubItems(3) = .Files(i).FolderTarget
        End If
      
      ElseIf idFile < c_id_file_scripts Then
        For i = 1 To UBound(.Scripts)
          If idFile = .Scripts(i).idFile Then
            bFound = True
            Exit For
          End If
        Next
      
        If bFound Then
          lvInfo.SelectedItem.Text = .Scripts(i).name
          lvInfo.SelectedItem.SubItems(1) = .Scripts(i).Filename
          lvInfo.SelectedItem.SubItems(2) = .Scripts(i).SourcePath
        End If
        
      ElseIf idFile < c_id_file_csrs Then
        For i = 1 To UBound(.Reports)
          If idFile = .Reports(i).idFile Then
            bFound = True
            Exit For
          End If
        Next
        If bFound Then
          lvInfo.SelectedItem.Text = .Reports(i).name
          lvInfo.SelectedItem.SubItems(1) = .Reports(i).Filename
          lvInfo.SelectedItem.SubItems(2) = .Reports(i).SourcePath
        End If
      End If
    End With
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "lvInfo_DblClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lvInfo_ItemClick(ByVal Item As MSComctlLib.ListItem)
  On Error Resume Next
  cmdRemove.Enabled = Not Item Is Nothing
End Sub

Private Sub mnuFileExit_Click()
  Unload Me
End Sub

Private Sub mnuFileNew_Click()
  NewCSA
End Sub

Private Sub mnuFileNewCSAI_Click()
  NewCSAI
End Sub

Private Sub mnuFileOpen_Click()
  MsgWarning "Aun no esta implementado"
End Sub

Private Sub mnuFileOpenCSAI_Click()
  MsgWarning "Aun no esta implementado"
End Sub

Private Sub mnuFileSave_Click()
  CSASave
End Sub

Private Sub mnuHelpAbout_Click()
  Load fSplash
  fSplash.IsSplash = False
  fSplash.Show vbModal
End Sub

Private Sub picSplitterBar_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  If Button = vbLeftButton Then
    picSplitter.Top = picSplitterBar.Top
    picSplitter.Width = picSplitterBar.Width
    picSplitter.Visible = True
  End If
End Sub

Private Sub picSplitterBar_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  If Button = vbLeftButton Then
    picSplitter.Top = picSplitterBar.Top + y
  End If
End Sub

Private Sub picSplitterBar_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  picSplitterBar.Top = picSplitter.Top
  picSplitter.Visible = False
  Form_Resize
End Sub

Private Sub pAddMessage(ByVal msg As String)

End Sub

Private Sub pInitForm()
  On Error GoTo ControlError

  With sbrMain
    
    .Panels.Clear
    
    With .Panels.Add(, c_sbrOperation)
      .Width = 3000
      .Style = sbrText
    End With
    With .Panels.Add(, c_sbrPercent)
      .Width = 800
      .Style = sbrText
    End With
    With .Panels.Add(, c_sbrStatus)
      .Width = 1000
      .Style = sbrText
    End With
    With .Panels.Add(, c_sbrInfo)
      .AutoSize = sbrSpring
      .Style = sbrText
    End With
    With .Panels.Add
      .AutoSize = sbrContents
      .Style = sbrTime
    End With
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "pInitForm", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  Select Case Button.Key
    Case "NEW_CSA"
      NewCSA
    Case "NEW_CSAI"
      NewCSAI
    Case "SAVE_CSA"
      CSASave
  End Select
End Sub
