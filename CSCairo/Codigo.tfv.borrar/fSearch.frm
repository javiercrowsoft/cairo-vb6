VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "tabctl32.ocx"
Begin VB.Form fSearch 
   Caption         =   "Busqueda"
   ClientHeight    =   4410
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7200
   Icon            =   "fSearch.frx":0000
   LinkTopic       =   "Form2"
   ScaleHeight     =   4410
   ScaleWidth      =   7200
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdSeleccionar 
      Caption         =   "&Seleccionar"
      Height          =   270
      Left            =   5400
      TabIndex        =   3
      Top             =   2400
      Width           =   1335
   End
   Begin VB.CommandButton CmdParar 
      Caption         =   "&Parar"
      Height          =   270
      Left            =   5400
      TabIndex        =   2
      Top             =   1680
      Width           =   1335
   End
   Begin VB.CommandButton CmdBuscar 
      Caption         =   "&Buscar"
      Height          =   270
      Left            =   5400
      TabIndex        =   1
      Top             =   1320
      Width           =   1335
   End
   Begin MSComctlLib.ListView LvBuscar 
      Height          =   1215
      Left            =   120
      TabIndex        =   7
      Top             =   2880
      Width           =   6255
      _ExtentX        =   11033
      _ExtentY        =   2143
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin TabDlg.SSTab TabBuscar 
      Height          =   1815
      Left            =   720
      TabIndex        =   4
      Top             =   960
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   3201
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "General"
      TabPicture(0)   =   "fSearch.frx":030A
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "LbBuscar"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "CbBuscar"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).ControlCount=   2
      TabCaption(1)   =   "Avanzado"
      TabPicture(1)   =   "fSearch.frx":0326
      Tab(1).ControlEnabled=   0   'False
      Tab(1).ControlCount=   0
      Begin VB.ComboBox CbBuscar 
         Height          =   315
         Left            =   1920
         TabIndex        =   0
         Top             =   600
         Width           =   2415
      End
      Begin VB.Label LbBuscar 
         Alignment       =   2  'Center
         Caption         =   "Buscar"
         Height          =   375
         Left            =   360
         TabIndex        =   6
         Top             =   600
         Width           =   855
      End
   End
   Begin VB.Line LineWt 
      BorderColor     =   &H80000009&
      X1              =   5640
      X2              =   6960
      Y1              =   2160
      Y2              =   2160
   End
   Begin VB.Line LineBlk 
      X1              =   5640
      X2              =   6960
      Y1              =   2150
      Y2              =   2150
   End
   Begin VB.Image ImgIcon 
      Height          =   480
      Left            =   120
      Picture         =   "fSearch.frx":0342
      Top             =   120
      Width           =   480
   End
   Begin VB.Label LbHeader 
      BackColor       =   &H8000000E&
      Caption         =   "Buscando pirulo, en busca del pirulo perdido...."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   960
      TabIndex        =   5
      Top             =   240
      Width           =   5295
   End
   Begin VB.Shape ShHeader 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   855
      Left            =   0
      Top             =   0
      Width           =   6495
   End
End
Attribute VB_Name = "fSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fBusqueda
' 22-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas

Private Sub Form_Load()
    ShHeader.Left = 0
    ShHeader.Top = 0
    ShHeader.Height = 735
    ImgIcon.Left = 120
    ImgIcon.Top = 120
    LbHeader.Top = 240
    CbBuscar.Left = 1920
    CbBuscar.Top = 600
    TabBuscar.Height = 1815
    TabBuscar.Left = 40
    LvBuscar.Left = 40
    LbHeader.Caption = ""
End Sub

Private Sub Form_Resize()
    ShHeader.Width = ScaleWidth
    TabBuscar.Width = ScaleWidth - 1800
    LvBuscar.Height = ScaleHeight - LvBuscar.Top - 80
    LvBuscar.Width = ScaleWidth - 80
    CmdBuscar.Left = TabBuscar.Width + TabBuscar.Left + 150
    CmdParar.Left = TabBuscar.Width + TabBuscar.Left + 150
    CmdSeleccionar.Left = TabBuscar.Width + TabBuscar.Left + 150
    LineWt.X1 = TabBuscar.Width + TabBuscar.Left + 150
    LineWt.X2 = LineWt.X1 + 1320
    LineBlk.X1 = TabBuscar.Width + TabBuscar.Left + 150
    LineBlk.X2 = LineWt.X1 + 1320
End Sub





' construccion - destruccion

