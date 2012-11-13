VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Object = "{BCCC02F6-B545-408C-8A20-3D6A1C5B26DB}#1.2#0"; "CSTextEditor.ocx"
Begin VB.Form fEditScript 
   ClientHeight    =   4440
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   8070
   Icon            =   "fEditScript.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   4440
   ScaleWidth      =   8070
   StartUpPosition =   3  'Windows Default
   Begin CSTextEditor.cTextEditor ctxCode 
      Height          =   1515
      Left            =   1200
      TabIndex        =   13
      Top             =   900
      Width           =   5175
      _ExtentX        =   9128
      _ExtentY        =   2672
   End
   Begin RichTextLib.RichTextBox txResult 
      Height          =   555
      Left            =   1440
      TabIndex        =   12
      Top             =   3015
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   979
      _Version        =   393217
      ScrollBars      =   3
      TextRTF         =   $"fEditScript.frx":000C
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComctlLib.ImageList iltv 
      Left            =   7335
      Top             =   2520
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
            Picture         =   "fEditScript.frx":008C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":0626
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TabStrip tabResult 
      Height          =   330
      Left            =   225
      TabIndex        =   11
      Top             =   3420
      Width           =   7620
      _ExtentX        =   13441
      _ExtentY        =   582
      MultiRow        =   -1  'True
      Placement       =   1
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   1
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvResult 
      Height          =   780
      Index           =   0
      Left            =   4410
      TabIndex        =   10
      Top             =   2970
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   1376
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.PictureBox picBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   105
      Left            =   1170
      ScaleHeight     =   105
      ScaleWidth      =   3930
      TabIndex        =   8
      Top             =   2340
      Visible         =   0   'False
      Width           =   3930
   End
   Begin VB.PictureBox picSplitter 
      BorderStyle     =   0  'None
      Height          =   105
      Left            =   45
      MousePointer    =   7  'Size N S
      ScaleHeight     =   105
      ScaleWidth      =   3840
      TabIndex        =   9
      Top             =   2385
      Width           =   3840
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   3780
      Top             =   1980
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Timer trInfo 
      Enabled         =   0   'False
      Left            =   585
      Top             =   2700
   End
   Begin MSComctlLib.ImageList ilTbEdit 
      Left            =   2070
      Top             =   1305
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   30
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":0BC0
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":115A
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":16F4
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":1C8E
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":2228
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":27C2
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":2D5C
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":32F6
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":3890
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":3CE2
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":427C
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":4816
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":4DB0
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":534A
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":58E4
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":5E7E
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":6418
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":69B2
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":6F4C
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":74E6
            Key             =   ""
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":7800
            Key             =   ""
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":7D9A
            Key             =   ""
         EndProperty
         BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":8334
            Key             =   ""
         EndProperty
         BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":88CE
            Key             =   ""
         EndProperty
         BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":8E68
            Key             =   ""
         EndProperty
         BeginProperty ListImage26 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":9402
            Key             =   ""
         EndProperty
         BeginProperty ListImage27 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":999C
            Key             =   ""
         EndProperty
         BeginProperty ListImage28 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":9F36
            Key             =   ""
         EndProperty
         BeginProperty ListImage29 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":A4D0
            Key             =   ""
         EndProperty
         BeginProperty ListImage30 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":A62A
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbEdit 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Width           =   8070
      _ExtentX        =   14235
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
      Begin MSComctlLib.ImageCombo cbDbs 
         Height          =   330
         Left            =   2655
         TabIndex        =   4
         Top             =   45
         Width           =   1860
         _ExtentX        =   3281
         _ExtentY        =   582
         _Version        =   393216
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
      End
   End
   Begin VB.PictureBox picProgress 
      Align           =   2  'Align Bottom
      AutoRedraw      =   -1  'True
      ClipControls    =   0   'False
      FillColor       =   &H00FF0000&
      Height          =   270
      Left            =   0
      ScaleHeight     =   210
      ScaleWidth      =   8010
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   3885
      Width           =   8070
   End
   Begin MSComctlLib.ImageList ilIS 
      Left            =   180
      Top             =   1170
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   15
      ImageHeight     =   11
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   7
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":A784
            Key             =   "enum"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":A9E6
            Key             =   "basic"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":AF08
            Key             =   "module"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":B42A
            Key             =   "table"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":B94C
            Key             =   "type"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":BE6E
            Key             =   "sp"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditScript.frx":C390
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.StatusBar sbEdit 
      Align           =   2  'Align Bottom
      Height          =   285
      Left            =   0
      TabIndex        =   0
      Top             =   4155
      Width           =   8070
      _ExtentX        =   14235
      _ExtentY        =   503
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.Timer trPaint 
      Left            =   585
      Top             =   2115
   End
   Begin MSComctlLib.ListView lvIS 
      Height          =   2040
      Left            =   1665
      TabIndex        =   1
      Top             =   720
      Width           =   2040
      _ExtentX        =   3598
      _ExtentY        =   3598
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   0
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvISSP 
      Height          =   2040
      Left            =   3870
      TabIndex        =   5
      Top             =   720
      Width           =   3930
      _ExtentX        =   6932
      _ExtentY        =   3598
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   0
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvISTBL 
      Height          =   2040
      Left            =   3150
      TabIndex        =   6
      Top             =   1485
      Width           =   2625
      _ExtentX        =   4630
      _ExtentY        =   3598
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   0
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvISVW 
      Height          =   2040
      Left            =   4725
      TabIndex        =   7
      Top             =   1440
      Width           =   2490
      _ExtentX        =   4392
      _ExtentY        =   3598
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   0
      NumItems        =   0
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuFileOpen 
         Caption         =   "Abrir..."
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Guardar..."
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "&Guardar como..."
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Editar"
      Begin VB.Menu mnuEditFind 
         Caption         =   "&Buscar..."
         Shortcut        =   ^B
      End
      Begin VB.Menu mnuEditReplace 
         Caption         =   "&Reemplazar..."
         Shortcut        =   ^H
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&Ver"
      Begin VB.Menu mnuViewResultPanel 
         Caption         =   "&Panel de resultados"
      End
      Begin VB.Menu mnuViewText 
         Caption         =   "Resultados &texto"
      End
      Begin VB.Menu mnuViewGrid 
         Caption         =   "Resultados en &grilla"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Ayuda"
      Begin VB.Menu mnuHelpSql 
         Caption         =   "Transact-SQL Help"
      End
   End
End
Attribute VB_Name = "fEditScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
  Option Explicit

'--------------------------------------------------------------------------------
' fEditScript
' 24-06-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    'Private Type POINTAPI
    '        x As Long
    '        Y As Long
    'End Type
    
    ' funciones
    'Private Declare Function GetCaretPos Lib "user32" (lpPoint As POINTAPI) As Long
    'Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal length As Long)

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fEditScript"

Private Const c_panel_message = "m"
Private Const c_panel_line = "l"
Private Const c_panel_col = "c"
Private Const c_panel_upper = "u"
Private Const c_panel_insert = "i"
Private Const c_panel_numlock = "n"

Private Const sglSplitLimit = 500

Private Const vbCrLfRTF = vbCrLf & "\par "
Private Const c_EndRTF = "\par }"

' Iconos de la toolbar
Private Const c_img_col = 1
Private Const c_img_db = 2
Private Const c_img_erase = 3
Private Const c_img_dep = 4
Private Const c_img_obj = 5
Private Const c_img_find = 6
Private Const c_img_finddb = 7
Private Const c_img_index = 8
Private Const c_img_idea = 9
Private Const c_img_new = 10
Private Const c_img_ok = 11
Private Const c_img_open = 12
Private Const c_img_paste = 13
Private Const c_img_plan = 14
Private Const c_img_play = 15
Private Const c_img_print = 16
Private Const c_img_property = 17
Private Const c_img_save = 18
Private Const c_img_sp2 = 19
Private Const c_img_cut = 20
Private Const c_img_stop = 21
Private Const c_img_vtable = 22
Private Const c_img_vtext = 23
Private Const c_img_vfile = 24
Private Const c_img_tool = 25
Private Const c_img_trigger = 26
Private Const c_img_udt = 27
Private Const c_img_undo = 28
Private Const c_img_view2 = 29
Private Const c_img_copy = 30

Private Const c_k_col = "col"
Private Const c_k_db = "db"
Private Const c_k_erase = "erase"
Private Const c_k_dep = "dep"
Private Const c_k_obj = "obj"
Private Const c_k_find = "find"
Private Const c_k_finddb = "finddb"
Private Const c_k_index = "index"
Private Const c_k_idea = "idea"
Private Const c_k_new = "new"
Private Const c_k_ok = "ok"
Private Const c_k_open = "open"
Private Const c_k_paste = "paste"
Private Const c_k_plan = "plan"
Private Const c_k_play = "play"
Private Const c_k_print = "print"
Private Const c_k_property = "property"
Private Const c_k_save = "save"
Private Const c_k_sp2 = "sp2"
Private Const c_k_cut = "cut"
Private Const c_k_stop = "stop"
Private Const c_k_vtable = "vtable"
Private Const c_k_vtext = "vtext"
Private Const c_k_vfile = "vfile"
Private Const c_k_tool = "tool"
Private Const c_k_trigger = "trigger"
Private Const c_k_udt = "udt"
Private Const c_k_undo = "undo"
Private Const c_k_view = "view"
Private Const c_k_cbdb = "cbdb"
Private Const c_k_copy = "copy"

Private Enum csImgIS
  c_img_enum = 1
  c_img_basic = 2
  c_img_module = 3
  c_img_table = 4
  c_img_type = 5
  c_img_Sp = 6
  c_img_view = 7
End Enum

Private Enum csTvImage
  c_img_up = 1
  c_img_down
End Enum

' estructuras
Private Type csSqlKeyWords
  word  As String
  Color As ColorConstants
  Icon  As csImgIS
End Type
' variables privadas
Private m_vKeyWords(200) As csSqlKeyWords

Private m_Index       As Integer
'Private m_NotChange   As Boolean
'Private m_WasCopy     As Boolean
'Private m_WasTab      As Boolean
'Private m_Shift       As Boolean
'Private m_TabLen      As Integer

'Private m_LastEdit      As Single ' Indica cuanto hace que el usuario presiono una tecla
'Private m_LastDbClick   As Single

'Private m_OldKeyCode As Integer

'Private m_SelStart    As Long
'Private m_SelLength   As Long
Private m_DataHasChanged As Boolean

Private WithEvents m_SQLServer         As cSQLServer
Attribute m_SQLServer.VB_VarHelpID = -1

Private m_File        As String
Private m_Filter      As String
Private m_IsNew       As Boolean

Private m_moving            As Boolean
Private m_ResultInText      As Boolean
Private m_ResultInTextAux   As Boolean

Private m_TabText As Integer
Private m_Tabs    As Integer
Private m_Grids   As Integer

Private m_IdxResults As Long
Private m_vResults() As String

Private m_cancel As Boolean

Private WithEvents m_cSql As cSQLScript
Attribute m_cSql.VB_VarHelpID = -1

' eventos
' propiedadades publicas
Public Property Let File(ByVal rhs As String)
  m_File = rhs
  SetCaption
End Property
' propiedadades friend
Public Property Set SQLServer(ByRef rhs As cSQLServer)
  Set m_SQLServer = rhs
End Property

Public Property Let Database(ByVal rhs As String)
  On Error Resume Next
  SelectItemByText2 cbDbs, rhs
End Property

Public Property Let Script(ByVal rhs As String)
  On Error Resume Next
  ctxCode.Text = rhs
  'PaintText
End Property


' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

'---------------------------------------------------------------------------------------------------------
' Tamaño de la ventana y posicion de los controles
'---------------------------------------------------------------------------------------------------------
Private Sub SetTabResult()
  With lvResult(0)
    Set .ColumnHeaderIcons = iltv
    .LabelEdit = lvwManual
    .View = lvwReport
    .GridLines = True
    .FullRowSelect = True
    .HideSelection = False
    .Sorted = True
  End With
End Sub

Private Sub ShowResult(ByVal Show As Boolean)
  Dim i As Integer
  
  picSplitter.Visible = Show
  If Show Then
    txResult.Visible = m_ResultInTextAux
    For i = 1 To lvResult.Count - 1
      lvResult(i).Visible = m_Grids > 0
    Next
    tabResult.Visible = m_Grids > 0
  Else
    txResult.Visible = False
    For i = 0 To lvResult.Count - 1
      lvResult(i).Visible = False
    Next
  End If
  SizeControls
End Sub

Private Sub lvResult_ColumnClick(Index As Integer, ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  Dim i As Integer
  
  With lvResult(Index)
    For i = 1 To .ColumnHeaders.Count
      .ColumnHeaders(i).Icon = 0
    Next
    
    .SortKey = ColumnHeader.Index - 1
    If .SortOrder = lvwAscending Then
      .SortOrder = lvwDescending
      ColumnHeader.Icon = c_img_down
    Else
      .SortOrder = lvwAscending
      ColumnHeader.Icon = c_img_up
      ColumnHeader.Alignment = lvwColumnLeft
    End If
    .Sorted = True
  End With
End Sub

Private Sub m_cSql_BeforeResult()
  InitResult
End Sub

Private Sub m_cSql_ErrorOccurs(ByVal Messages As String)
  On Error GoTo ControlError
  Dim SelStart As Long
  
  Messages = SqlReplaceComments(Messages) & vbCrLfRTF & vbCrLfRTF
  
  AddTextToRTF Messages
'
'  With txResult
'    SelStart = .SelStart
'    .Text = .Text & Messages & vbCrLf & vbCrLf
'    .SelStart = SelStart
'    .SelLength = Len(Messages)
'    .SelColor = vbRed
'    .SelStart = Len(.Text)
'    .SelLength = 0
'  End With

  GoTo ExitProc
ControlError:
  MngError Err, "m_cSql_ErrorOccurs", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_cSql_Progress(ByVal Percent As Integer, ByVal Descrip As String, Cancel As Boolean)
  Cancel = m_cancel
  sbMsg Format(Percent / 100, "00%")
End Sub

Private Sub m_cSql_ResultAndMessage(Result As Object, ByVal Message As String)
  Execute2 Result, Message
End Sub

Private Sub mnuEditFind_Click()
  ctxCode.Find
End Sub

Private Sub mnuEditReplace_Click()
  ctxCode.Replace
End Sub

Private Sub mnuFileExit_Click()
  Unload Me
End Sub

Private Sub mnuFileOpen_Click()
  OpenQuery
End Sub

Private Sub mnuFileSave_Click()
  Save False
End Sub

Private Sub mnuFileSaveAs_Click()
  Save True
End Sub

Private Sub mnuViewGrid_Click()
  On Error Resume Next
  mnuViewText.Checked = False
  mnuViewGrid.Checked = True
  m_ResultInText = False
End Sub

Private Sub mnuViewText_Click()
  On Error Resume Next
  mnuViewText.Checked = True
  mnuViewGrid.Checked = False
  m_ResultInText = True
End Sub

Private Sub picSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
  With picSplitter
    picBar.Move .Left, .Top, .Width, .Height - 40
  End With
  picBar.Visible = True
  picBar.ZOrder
  m_moving = True
End Sub

Private Sub picSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
  Dim sglPos As Single
  
  If m_moving Then
    sglPos = Y + picSplitter.Top
    If sglPos < sglSplitLimit Then
      picBar.Top = sglSplitLimit
    ElseIf sglPos > Width - sglSplitLimit Then
      picBar.Top = Width - sglSplitLimit
    Else
      picBar.Top = sglPos
    End If
  End If
End Sub

Private Sub picSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  SizeControls
  picBar.Visible = False
  m_moving = False
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub SizeControls()
  On Error Resume Next
  
  If Me.WindowState = vbNormal Then
    
    Dim b As MSComctlLib.Button
    Set b = tbEdit.buttons(c_k_cbdb)
    b.Width = 2400
    cbDbs.Left = b.Left
    cbDbs.Top = 10
    cbDbs.Width = b.Width
    cbDbs.Top = b.Top
  
  End If
  
  picSplitter.Left = 0
  picSplitter.Width = ScaleWidth
  picSplitter.Top = picBar.Top
  
  Dim Bottom As Integer
  Dim Top As Integer
  
  Top = tbEdit.Height
  
  If picProgress.Visible Then
    Bottom = picProgress.Height + sbEdit.Height
  Else
    Bottom = sbEdit.Height
  End If
  
  If picSplitter.Visible Then
    Dim Top2 As Integer
    
    If m_Grids > 0 Then
      Bottom = Bottom + tabResult.Height
    End If
    
    Top2 = picSplitter.Top + picSplitter.Height
    ctxCode.Move 0, Top, ScaleWidth, picSplitter.Top - tbEdit.Height
    txResult.Move 0, Top2, ScaleWidth, ScaleHeight - Top2 - Bottom
    
    Dim i As Integer
    For i = 0 To lvResult.Count
      lvResult(i).Move 0, Top2, ScaleWidth, ScaleHeight - Top2 - Bottom
    Next
    tabResult.Move 0, lvResult(0).Top + lvResult(0).Height - 10, ScaleWidth
  Else
    ctxCode.Move 0, Top, ScaleWidth, ScaleHeight - Top - Bottom
  End If
End Sub

Private Sub InitProgressBar()
  On Error Resume Next
  picProgress.Visible = True
  Form_Resize
End Sub

Private Sub HideProgressBar()
  On Error Resume Next
  picProgress.Visible = False
  Form_Resize
End Sub

'---------------------------------------------------------------------------------------------------------
' Accesos por teclado
'---------------------------------------------------------------------------------------------------------

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error GoTo ControlError

  Select Case KeyCode
    Case vbKeyF9
      LoadIntelisense
    Case vbKeyR
      ' ctrl + R
      If Shift = 2 Then
        ShowResult Not picSplitter.Visible
        KeyCode = 0
      End If
    Case vbKeyT
      If Shift = 2 Then
        m_ResultInText = True
      End If
    Case vbKeyD
      If Shift = 2 Then
        m_ResultInText = False
      End If
    Case vbKeyU
      If Shift = 2 Then
        On Error Resume Next
        cbDbs.SetFocus
        SendKeys "{F4}"
        KeyCode = 0
        ctxCode.TabIndex = cbDbs.TabIndex
      End If
    Case vbKeyF5
      Execute1
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "Form_KeyDown", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'---------------------------------------------------------------------------------------------------------
' Eleccion de base de datos
'---------------------------------------------------------------------------------------------------------

'Private Sub cbDbs_Click()
'  On Error Resume Next
'  m_LastDbClick = Timer
'  trInfo.Enabled = True
'End Sub

'---------------------------------------------------------------------------------------------------------
' Manejo de edicion - Colores
'---------------------------------------------------------------------------------------------------------

'Private Sub ProcessIntelisenseCall(ByRef lv As ListView)
'  Dim p As POINTAPI
'  GetCaretPos p
'  lv.Left = ctxCode.Left + p.x * Screen.TwipsPerPixelX + 80
'  lv.Top = ctxCode.Top + p.Y * Screen.TwipsPerPixelY + 200
'  If lv.Top + lv.Height > ScaleHeight - 200 Then lv.Top = ScaleHeight - 200 - lv.Height
'  If lv.Left + lv.Width > ScaleWidth - 200 Then lv.Left = ScaleWidth - 200 - lv.Width
'  If lv.ListItems.Count > 0 Then lv.ListItems(1).Selected = True
'  lv.Visible = True
'  lv.ZOrder
'  lv.SetFocus
'End Sub

Private Sub tabResult_Click()
  On Error Resume Next
  
  If tabResult.SelectedItem Is Nothing Then Exit Sub
  
  If tabResult.SelectedItem.Index < m_TabText Then
    With lvResult(tabResult.SelectedItem.Index)
      .Visible = True
      .ZOrder
    End With
  Else
    txResult.Visible = True
    txResult.ZOrder
  End If
End Sub

'Private Sub trPaint_Timer()
'  On Error Resume Next
'
'  Dim wLock   As cLockUpdateWindow
'  Dim i       As Integer
'  Dim Mouse   As cMouseWait
'  Dim q       As Integer
'
'  ' Espero al menos medio segundo a que el usuario termine de escribir
'  If Timer - m_LastEdit < 0.5 Then Exit Sub
'
'  trPaint.Enabled = False
'
'  If m_WasCopy Then
'
'    m_WasCopy = False
'    m_NotChange = True
'
'    Set Mouse = New cMouseWait
'
'    SavePosCaret
'
'    'SetColor
'
'    RestorePosCaret
'
'    Set wLock = Nothing
'    m_NotChange = False
'
'  ElseIf m_WasTab Then
'    m_WasTab = False
'    'ProcessTabKey
'  End If
'
'  ShowLineAndCol
'End Sub

Private Function WasSeparator() As Boolean
  On Error Resume Next
  
  ' Si es menor a tres atras no puede haber nada
  If ctxCode.SelStart < 3 Then Exit Function
  
  WasSeparator = IsSeparator(Mid(ctxCode.Text, ctxCode.SelStart, 1))
End Function

Private Function IsSeparator(ByVal s As String) As Boolean
  Select Case s
    Case ".", "(", ")", "[", "]", vbCr, vbLf, vbTab, " "
      IsSeparator = True
  End Select
End Function

'---------------------------------------------
' Function SetColor
' Proposito: Poner color al texto sql

'    ' Notas:
'    ' Tengo que ir leyendo caracter por caracter y
'    ' reconocer las palabras claves para formatearlas
'    ' Hay dos strings de formato posibles: color o negro.
'    ' negro es '\cf0 ' (incluye el espacio), y color es:
'    ' '\cf1 ', ..,'\cf3 ' esto esta definido en la tabla de color
'    ' del rtf: {\colortbl ;\red0\green0\blue255;\red0\green192\blue0;\red255\green0\blue0;\red255\green0\blue255;}
'
'    ' Lo que conozco del rtf
'    ' La estructura del rtf empieza con una llave que envuelve todo el documento '{' terminando con un cierre '}'
'    ' El encabezado define que es un rtf, el codigo de pagina a usar, el lenguaje
'    ' y un font:
'    ' \rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Courier New;}}
'    ' luego viene la tabla de colores
'    ' {\colortbl ;\red0\green0\blue255;\red0\green192\blue0;\red255\green0\blue0;\red255\green0\blue255;}
'    ' Finalmente tenemos el tipo de vista y el comienzo del primer parrafo delimitado por el codigo '\par'
'    ' \viewkind4\uc1\pard\cf1\f0\fs20
'    ' Este fragmento:  'd\cf1\f0\fs20' aun no se que define. Dedusco que 'cf1' es color y 'f0' es font
'    ' '\pard' indica que el que se resetean todas los formatos de este parrafo.
'    ' 'fs20' indica font size 20 es el tamaño en half-points
'
'Private Sub SetColor()
'  Dim Txt As String     ' Buffer auxiliar
'  Dim vCopy() As Byte   ' Buffer de trabajo
'  Dim vWork() As Byte   ' Buffer de trabajo
'  Dim q   As Long       ' indice para vWork
'  Dim i   As Long       ' indice para vCopy
'
'  Dim word  As String   ' Para guardar la palabra que estoy parseando
'  Dim c     As String   ' Letra
'  Dim Block As Integer  ' Contador de llaves '{' abiertas
'  Dim Ln    As Long     ' Tamaño del texto luego de formatearlo
'
'  Dim InHeader    As Boolean  ' Flag que indica que estoy en el header
'  Dim ResetWord   As Boolean  ' Flag que indica que empieza otra palabra
'  Dim Init        As String
'  Dim Color       As Long
'  Dim BlkChr      As Boolean  ' Flag que indica que estamos dentro de texto 'esto es un texto'
'  Dim BlkComment  As Boolean  ' Flag que indica que estoy dentro de un comentario -- Esto es un comentario
'  Dim BlkComment2 As Boolean  ' Flag que indica que estoy dentro de un comentario /* Esto es otro comentario */
'
'  Dim SelLength   As Long
'
'  Const c_Color_Default = "\cf0 "
'  Const c_Color_Comment = "\cf4 "
'  Const c_Color_Blue = "\cf1 "
'  Const c_Color_Green = "\cf2 "
'  Const c_Color_Red = "\cf3 "
'
'  ' Para evitar eventos recursivos
'  m_NotChange = True
'
'  m_OldKeyCode = 0
'
'  ' Obtengo el rtf
'  Txt = ctxCode.TextRTF
'
'  ' Obtengo el tamaño del texto
'  Ln = Len(Txt)
'
'  ' Preveo un buffer un 50 % mas grande que txt
'  ReDim vCopy(Ln)
'  ReDim vWork(Ln * 2)
'
'  ' Cargo el buffer de trabajo
'  CopyMemory vCopy(0), ByVal Txt, Len(Txt)
'
'  ' Inicializo el contador de llaves
'  Block = -1
'
'  ' Empiezo en 0
'  q = 0
'
'  ' Prendo el flag que se apagara cuando termine con el header
'  InHeader = True
'
'  ' Aqui voy
'  For i = 0 To Ln - 1
'
'    ' Obtengo el caracter
'    c = chr(vCopy(i))
'
'    Select Case c
'      Case "{"
'        Block = Block + 1
'      Case "}"
'        Block = Block - 1
'
'      ' Comienza y termina un codigo rtf
'      Case "\"
'        ResetWord = True
'        Init = "\"
'        c = "" ' Limpio c para no poner un separador demas
'
'      ' El espacio es un separador especial ya que tambien
'      ' finaliza codigos rtf
'      Case " "
'        ResetWord = True
'
'      Case ".", "(", ")", "[", "]", vbCr, vbLf, ","
'        ResetWord = True
'
'      Case Else
'        word = word & c
'    End Select
'
'    ' Block = 0 significa cuerpo del documento
'    ' si es mayor a 0 estoy dentro de un bloque de
'    ' formato por ej. colortbl donde no me interesa
'    ' parsear nada
'    If Block = 0 Then
'
'      ' Si aun estoy en header busco el codigo rtf "\pard"
'      If InHeader Then
'        If word = "\pard" And ResetWord Then
'
'          word = "{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Courier New;}}" & vbCrLf
'          word = word & "{\colortbl ;\red0\green0\blue255;\red0\green215\blue0;\red255\green0\blue0;\red128\green188\blue155;}" & vbCrLf
'          word = word & "\viewkind4\uc1\pard"
'          q = PutWordInBuffer(word, vWork(), q)
'
'          InHeader = False
'
'        End If
'      Else
'
'        ' Si no estoy en un blocke de texto 'bloque de texto'
'        If Not BlkChr Then
'          ' Si tengo una palabra
'          Select Case Left$(word, 2)
'            Case "/*"
'              word = c_Color_Comment & word
'              BlkComment2 = True
'            Case "--"
'              If Not BlkComment2 Then
'                word = c_Color_Comment & word
'                BlkComment = True
'              End If
'          End Select
'
'          If Right$(word, 2) = "*/" Then
'            If BlkComment2 Then
'              word = word & c_Color_Default
'              BlkComment2 = False
'            End If
'          End If
'        End If
'
'
'        If c = vbLf Then
'          ' Si no estoy en un comentario /* */ ni estoy en un bloque de texto ' '
'          If BlkComment And Not BlkComment2 And Not BlkChr Then
'            word = word & c_Color_Default
'            BlkComment = False
'          End If
'
'        ' (word <> "\'") => Se trata de vocales con acento
'        ElseIf (c = "'") And (word <> "\'") Then
'          If Not (BlkComment Or BlkComment2) Then
'            If BlkChr Then
'              word = word & c_Color_Default
'              BlkChr = False
'              c = ""
'              ResetWord = True
'            Else
'              word = c_Color_Red & word
'              BlkChr = True
'            End If
'          End If
'        End If
'
'        If ResetWord Then
'
'          ' Si estoy en un bloque no analizo
'          If Not (BlkComment2 Or BlkComment Or BlkChr) Then
'
'            ' Termine con el Header
'            Select Case word
'              Case "\par"
'                q = PutWordInBuffer(word, vWork(), q)
'
'              Case "\cf0", "\cf1", "\cf2", "\cf3"
'                ' No hago nada
'                c = ""
'
'              Case "\tab"
'                q = PutWordInBuffer("\tab ", vWork(), q)
'                c = ""
'
'              Case Else
'
'                  If IsWord(word, Color) Then
'                    Select Case Color
'                      Case vbRed
'                        word = c_Color_Red & word
'                      Case vbBlue
'                        word = c_Color_Blue & word
'                      Case vbGreen, &HC000&
'                        word = c_Color_Green & word
'                    End Select
'
'                    word = word & c_Color_Default
'                  End If
'
'                  q = PutWordInBuffer(word, vWork(), q)
'
'            End Select
'          Else
'            Select Case word
'              Case "\cf0", "\cf1", "\cf2", "\cf3"
'                ' No hago nada
'                c = ""
'
'              ' Si era un comando tab le agrego un separador
'              Case "\tab"
'                q = PutWordInBuffer("\tab ", vWork(), q)
'                c = ""
'              Case Else
'                q = PutWordInBuffer(word, vWork(), q)
'            End Select
'          End If
'
'          ' Pongo el separador
'          q = PutWordInBuffer(c, vWork(), q)
'        End If
'      End If
'
'    Else
'      ' Lo que no esta en el bloque de documento va sin que
'      ' yo lo modifique
'      If Not InHeader Then
'        vWork(q) = vCopy(i)
'        q = q + 1
'      End If
'    End If
'
'    ' Limpio la palabra
'    If ResetWord Then
'      word = Init
'      Init = ""
'      ResetWord = False
'    End If
'  Next
'
'  Txt = String(q, " ")
'
'  CopyMemory ByVal Txt, vWork(0), Len(Txt)
'
'  ctxCode.TextRTF = Txt
'  DoEvents
'
'  m_NotChange = False
'End Sub
'
'Private Function PutWordInBuffer(ByRef word As String, ByRef vWork() As Byte, ByVal q As Long) As Long
'  Dim i As Integer
'
'  For i = 1 To Len(word)
'    vWork(q) = Asc(Mid(word, i, 1))
'    q = q + 1
'  Next
'
'  PutWordInBuffer = q
'End Function

'Private Sub PaintText()
'  m_NotChange = True
'  m_WasCopy = True
'  trPaint.Enabled = True
'End Sub

'Private Function MustRepaint(ByVal KeyCode As Integer) As Boolean
'
'  ' 219 = '
'  If KeyCode = 219 Then
'
'    MustRepaint = True
'
'  ' 109 y 189 = -
'  ElseIf (KeyCode = 109 Or KeyCode = 189) And (m_OldKeyCode = 109 Or m_OldKeyCode = 189) Then
'
'    MustRepaint = True
'
'  ' 111 y 55 = /
'  ' 106 y 187 = *
'  ' /*
'  ElseIf (KeyCode = 111 Or KeyCode = 55) And (m_OldKeyCode = 106 Or m_OldKeyCode = 187) Then
'
'    MustRepaint = True
'
'  ' */
'  ElseIf (m_OldKeyCode = 111 Or m_OldKeyCode = 55) And (KeyCode = 106 Or KeyCode = 187) Then
'
'    MustRepaint = True
'
'  ElseIf KeyCode = vbKeyDelete Or KeyCode = vbKeyBack Then
'
'    MustRepaint = True
'
'  End If
'
'  m_OldKeyCode = KeyCode
'
'End Function
'
'Private Sub ColorText(rch As RichTextBox)
'  Dim tag_open  As Long
'  Dim tag_close As Long
'  Dim Pos       As Long
'
'  DoEvents: DoEvents: DoEvents
'
'  Pos = rch.SelStart
'  Do
'    ' See where the next tag starts.
'    tag_open = InStr(tag_close + 1, rch.Text, "'")
'    If tag_open = 0 Then Exit Do
'
'    ' See where the tag ends.
'    tag_close = InStr(tag_open + 1, rch.Text, "'")
'    If tag_close = 0 Then tag_close = Len(rch.Text)
'
'    ' Color the tag.
'    rch.SelStart = tag_open - 1
'    rch.SelLength = tag_close - tag_open + 1
'    rch.SelColor = vbRed
'  Loop
'
'  rch.SelStart = Pos
'  rch.SelLength = 0
'  rch.SelColor = vbWindowText
'End Sub
'
'Private Function GetWord(ByRef length As Integer) As String
'  Dim i     As Long
'  Dim j     As Long
'  Dim k     As Long
'  Dim word  As String
'  Dim c     As String
'
'  k = Len(ctxCode.Text)
'  i = ctxCode.SelStart
'  j = i + 1
'
'  ' Primero voy hasta un espacio o un enter, etc
'  Do While j <= k
'    c = Mid(ctxCode.Text, j, 1)
'    j = j + 1
'    If IsSeparator(c) Then Exit Do
'    word = word & c
'  Loop
'
'  length = Len(word)
'
'  Do While i > 0
'    c = Mid(ctxCode.Text, i, 1)
'    i = i - 1
'    If IsSeparator(c) Then Exit Do
'    word = c & word
'  Loop
'
'  GetWord = word
'End Function
'
'Private Function IsWord(ByVal word As String, ByRef Color As ColorConstants) As Boolean
'  Dim found As Boolean
'  Dim i As Integer
'  Dim Max As Integer
'  Dim Min As Integer
'
'  Max = UBound(m_vKeyWords)
'  Min = 1
'  i = Max / 2
'
'  Do While i <= Max And i >= Min
'    If LCase(word) = m_vKeyWords(i).word Then
'      Color = m_vKeyWords(i).Color
'      found = True
'      Exit Do
'    End If
'
'    ' Menor
'    If LCase(word) < LCase(m_vKeyWords(i).word) Then
'      Max = i - 1
'
'    ' Mayor
'    Else
'      Min = i + 1
'    End If
'
'    i = (Max - Min) / 2 + Min
'
'  Loop
'
'  IsWord = found
'End Function

'---------------------------------------------------------------------------------------------------------
' Manejo de edicion - Posicion del punto de edicion
'---------------------------------------------------------------------------------------------------------

'Private Sub SavePosCaret()
'  m_SelStart = ctxCode.SelStart
'  m_SelLength = ctxCode.SelLength
'End Sub
'
'Private Sub RestorePosCaret()
'  ctxCode.SelStart = m_SelStart
'  ctxCode.SelLength = m_SelLength
'End Sub

'---------------------------------------------------------------------------------------------------------
' Manejo de edicion - Tab
'---------------------------------------------------------------------------------------------------------

'Private Sub ProcessTabKey()
'  On Error Resume Next
'
'  Const bp = "\par"
'
'  With ctxCode
'    If .SelLength > 0 Then
'
'      Dim j   As Long
'      Dim q   As Integer
'
'      ' Voy buscar un principio de parrafo
'      If Left$(.SelRTF, 1) <> bp Then
'        Dim SelLen As Long
'        SelLen = .SelStart + .SelLength
'
'        j = GetFirstCol() + 1
'        SelLen = GetLastCol() - j
'      End If
'
'      If m_Shift Then
'        .SelText = SubstracTab(SelLen)
'      Else
'        .SelText = AddTab(SelLen)
'      End If
'
'      ctxCode.SelStart = j
'      ctxCode.SelLength = SelLen
'
'      PaintText
'
'    Else
'      SendKeys GetTab()
'    End If
'  End With
'End Sub
'
'Private Function GetTab() As String
'  GetTab = "  "
'End Function
'
'Private Function AddTab(ByRef SelLen As Long) As String
'  Dim Txt As String
'  Dim j   As Long
'
'  j = 1
'
'  ' Agrego un tab a cada linea de texto
'  Do
'    Txt = Txt & GetTab() & GetLine(ctxCode.SelText, j, j)
'
'  Loop Until j > SelLen
'
'  SelLen = Len(Txt)
'
'  AddTab = Txt
'End Function
'
'Private Function SubstracTab(ByRef SelLen As Long) As String
'  Dim Txt As String
'  Dim j   As Long
'  Dim c   As String
'  Dim q   As Integer
'
'  j = 1
'  q = 0
'
'  Do
'
'    ' Este bucle lee el primer caracter de cada linea
'    Do
'      c = GetChar(ctxCode.SelText, j)
'      j = j + 1
'
'      Select Case c
'        ' Si fue un tab lo saco y ya no leo mas en
'        ' este bucle
'        Case vbTab
'          c = ""    ' Saco el caracter
'          Exit Do   ' Salgo del bucle
'
'        ' Si es un espacio lo saco y si q no es mayor
'        ' a la cantidad de espacio que equivalen a un tab
'        ' leo el proximo caracter para hacer lo mismo
'        Case " "
'          q = q + 1 ' Incremento q que tiene la cantidad de espacios
'                    ' que he sacado hasta ahora del principio de la
'                    ' linea
'          If q > m_TabLen Then Exit Do ' Si ya saque tantos caracteres
'                                       ' como el ancho del tab salgo del
'                                       ' bucle
'
'        ' Si no es un espacio ni un tab
'        ' salgo del bucle
'        Case Else
'          Exit Do
'      End Select
'    Loop
'
'    ' Agrego el caracter
'    Txt = Txt & c
'
'    ' Obtengo el resto de la linea
'    Txt = Txt & GetLine(ctxCode.SelText, j, j)
'
'    ' Reseteo el contador de espacios
'    q = 0
'  Loop Until j > SelLen
'
'  SelLen = Len(Txt)
'
'  SubstracTab = Txt
'End Function

' Txt es byref por velocidad, pero no se modifica
' NewPos es byref y si se modifica, ya que devuelve
' la posicion del primer caracter de la proxima linea
Private Function GetLine(ByRef Txt As String, ByVal Pos As Long, ByRef NewPos As Long)
  Dim rtn As String
  Dim c   As String
  Dim EndTxt As Long
  Dim j   As Long
  
  EndTxt = Len(Txt)
  
  j = Pos
  Do
    c = GetChar(Txt, j)
    j = j + 1
    rtn = rtn & c

  Loop Until c = vbLf Or j > EndTxt
  
  NewPos = j
  
  GetLine = rtn
End Function

Private Function GetCharEx(ByVal Pos As Long) As String
  On Error Resume Next
  GetCharEx = Mid(ctxCode.Text, Pos, 1)
End Function

' Txt es byref por velocidad, pero no se modifica
Private Function GetChar(ByRef Txt As String, ByVal Pos As Long) As String
  GetChar = Mid(Txt, Pos, 1)
End Function

'---------------------------------------------------------------------------------------------------------
' Manejo de palabras claves
'---------------------------------------------------------------------------------------------------------

Private Sub AddKeyWord(ByVal word As String, ByVal Color As ColorConstants, ByVal Icon As csImgIS)
  m_Index = m_Index + 1
  m_vKeyWords(m_Index).Color = Color
  m_vKeyWords(m_Index).word = LCase(word)
  m_vKeyWords(m_Index).Icon = Icon
End Sub

'Private Sub FillColKeyWords()
'  m_Index = 0
'  AddKeyWord "ADD", vbBlue, c_img_enum
'  AddKeyWord "ALL", vbBlue, c_img_enum
'  AddKeyWord "ALTER", vbBlue, c_img_enum
'  AddKeyWord "AND", vbBlue, c_img_enum
'  AddKeyWord "ANY", vbBlue, c_img_enum
'  AddKeyWord "AS", vbBlue, c_img_enum
'  AddKeyWord "ASC", vbBlue, c_img_enum
'  AddKeyWord "AUTHORIZATION", vbBlue, c_img_enum
'  AddKeyWord "BACKUP", vbBlue, c_img_enum
'  AddKeyWord "BEGIN", vbBlue, c_img_enum
'  AddKeyWord "BETWEEN", vbBlue, c_img_enum
'  AddKeyWord "BREAK", vbBlue, c_img_enum
'  AddKeyWord "BROWSE", vbBlue, c_img_enum
'  AddKeyWord "BULK", vbBlue, c_img_enum
'  AddKeyWord "BY", vbBlue, c_img_enum
'  AddKeyWord "CASCADE", vbBlue, c_img_enum
'  AddKeyWord "CASE", vbBlue, c_img_enum
'  AddKeyWord "CHECK", vbBlue, c_img_enum
'  AddKeyWord "CHECKPOINT", vbBlue, c_img_enum
'  AddKeyWord "CLOSE", vbBlue, c_img_enum
'  AddKeyWord "CLUSTERED", vbBlue, c_img_enum
'  AddKeyWord "COALESCE", vbBlue, c_img_enum
'  AddKeyWord "COLLATE", vbBlue, c_img_enum
'  AddKeyWord "COLUMN", vbBlue, c_img_enum
'  AddKeyWord "COMMIT", vbBlue, c_img_enum
'  AddKeyWord "COMPUTE", vbBlue, c_img_enum
'  AddKeyWord "CONSTRAINT", vbBlue, c_img_enum
'  AddKeyWord "CONTAINS", vbBlue, c_img_enum
'  AddKeyWord "CONTAINSTABLE", vbBlue, c_img_enum
'  AddKeyWord "CONTINUE", vbBlue, c_img_enum
'  AddKeyWord "CONVERT", vbBlue, c_img_enum
'  AddKeyWord "CREATE", vbBlue, c_img_enum
'  AddKeyWord "CROSS", vbBlue, c_img_enum
'  AddKeyWord "CURRENT", vbBlue, c_img_enum
'  AddKeyWord "CURRENT_DATE", vbBlue, c_img_enum
'  AddKeyWord "CURRENT_TIME", vbBlue, c_img_enum
'  AddKeyWord "CURRENT_TIMESTAMP", vbBlue, c_img_enum
'  AddKeyWord "CURRENT_USER", vbBlue, c_img_enum
'  AddKeyWord "CURSOR", vbBlue, c_img_enum
'  AddKeyWord "DATABASE", vbBlue, c_img_enum
'  AddKeyWord "DBCC", vbBlue, c_img_enum
'  AddKeyWord "DEALLOCATE", vbBlue, c_img_enum
'  AddKeyWord "DECLARE", vbBlue, c_img_enum
'  AddKeyWord "DEFAULT", vbBlue, c_img_enum
'  AddKeyWord "DELETE", vbBlue, c_img_enum
'  AddKeyWord "DENY", vbBlue, c_img_enum
'  AddKeyWord "DESC", vbBlue, c_img_enum
'  AddKeyWord "DISK", vbBlue, c_img_enum
'  AddKeyWord "DISTINCT", vbBlue, c_img_enum
'  AddKeyWord "DISTRIBUTED", vbBlue, c_img_enum
'  AddKeyWord "DOUBLE", vbBlue, c_img_enum
'  AddKeyWord "DROP", vbBlue, c_img_enum
'  AddKeyWord "DUMMY", vbBlue, c_img_enum
'  AddKeyWord "DUMP", vbBlue, c_img_enum
'  AddKeyWord "ELSE", vbBlue, c_img_enum
'  AddKeyWord "END", vbBlue, c_img_enum
'  AddKeyWord "ERRLVL", vbBlue, c_img_enum
'  AddKeyWord "ESCAPE", vbBlue, c_img_enum
'
'  AddKeyWord "EXCEPT", vbBlue, c_img_enum
'  AddKeyWord "EXEC", vbBlue, c_img_enum
'  AddKeyWord "EXECUTE", vbBlue, c_img_enum
'  AddKeyWord "EXISTS", vbBlue, c_img_enum
'  AddKeyWord "EXIT", vbBlue, c_img_enum
'  AddKeyWord "FETCH", vbBlue, c_img_enum
'  AddKeyWord "FILE", vbBlue, c_img_enum
'  AddKeyWord "FILLFACTOR", vbBlue, c_img_enum
'  AddKeyWord "FOR", vbBlue, c_img_enum
'  AddKeyWord "FOREIGN", vbBlue, c_img_enum
'  AddKeyWord "FREETEXT", vbBlue, c_img_enum
'  AddKeyWord "FREETEXTTABLE", vbBlue, c_img_enum
'  AddKeyWord "FROM", vbBlue, c_img_enum
'  AddKeyWord "FULL", vbBlue, c_img_enum
'  AddKeyWord "FUNCTION", vbBlue, c_img_enum
'  AddKeyWord "GOTO", vbBlue, c_img_enum
'  AddKeyWord "GRANT", vbBlue, c_img_enum
'  AddKeyWord "GROUP", vbBlue, c_img_enum
'  AddKeyWord "HAVING", vbBlue, c_img_enum
'  AddKeyWord "HOLDLOCK", vbBlue, c_img_enum
'  AddKeyWord "IDENTITY", vbBlue, c_img_enum
'  AddKeyWord "IDENTITY_INSERT", vbBlue, c_img_enum
'  AddKeyWord "IDENTITYCOL", vbBlue, c_img_enum
'  AddKeyWord "IF", vbBlue, c_img_enum
'  AddKeyWord "IN", vbBlue, c_img_enum
'  AddKeyWord "INDEX", vbBlue, c_img_enum
'  AddKeyWord "INNER", vbBlue, c_img_enum
'  AddKeyWord "INSERT", vbBlue, c_img_enum
'  AddKeyWord "INTERSECT", vbBlue, c_img_enum
'  AddKeyWord "INTO", vbBlue, c_img_enum
'  AddKeyWord "IS", vbBlue, c_img_enum
'  AddKeyWord "JOIN", vbBlue, c_img_enum
'  AddKeyWord "KEY", vbBlue, c_img_enum
'  AddKeyWord "KILL", vbBlue, c_img_enum
'  AddKeyWord "LEFT", vbBlue, c_img_enum
'  AddKeyWord "LIKE", vbBlue, c_img_enum
'  AddKeyWord "LINENO", vbBlue, c_img_enum
'  AddKeyWord "LOAD", vbBlue, c_img_enum
'  AddKeyWord "NATIONAL", vbBlue, c_img_enum
'  AddKeyWord "NOCHECK", vbBlue, c_img_enum
'  AddKeyWord "NONCLUSTERED", vbBlue, c_img_enum
'  AddKeyWord "NOT", vbBlue, c_img_enum
'  AddKeyWord "NULL", vbBlue, c_img_enum
'  AddKeyWord "NULLIF", vbBlue, c_img_enum
'  AddKeyWord "OF", vbBlue, c_img_enum
'  AddKeyWord "OFF", vbBlue, c_img_enum
'  AddKeyWord "OFFSETS", vbBlue, c_img_enum
'  AddKeyWord "ON", vbBlue, c_img_enum
'  AddKeyWord "OPEN", vbBlue, c_img_enum
'  AddKeyWord "OPENDATASOURCE", vbBlue, c_img_enum
'  AddKeyWord "OPENQUERY", vbBlue, c_img_enum
'  AddKeyWord "OPENROWSET", vbBlue, c_img_enum
'  AddKeyWord "OPENXML", vbBlue, c_img_enum
'  AddKeyWord "OPTION", vbBlue, c_img_enum
'  AddKeyWord "OR", vbBlue, c_img_enum
'  AddKeyWord "ORDER", vbBlue, c_img_enum
'  AddKeyWord "OUTER", vbBlue, c_img_enum
'  AddKeyWord "OVER", vbBlue, c_img_enum
'
'  AddKeyWord "PERCENT", vbBlue, c_img_enum
'  AddKeyWord "PLAN", vbBlue, c_img_enum
'  AddKeyWord "PRECISION", vbBlue, c_img_enum
'  AddKeyWord "PRIMARY", vbBlue, c_img_enum
'  AddKeyWord "PRINT", vbBlue, c_img_enum
'  AddKeyWord "PROC", vbBlue, c_img_enum
'  AddKeyWord "PROCEDURE", vbBlue, c_img_enum
'  AddKeyWord "PUBLIC", vbBlue, c_img_enum
'  AddKeyWord "RAISERROR", vbBlue, c_img_enum
'  AddKeyWord "READ", vbBlue, c_img_enum
'  AddKeyWord "READTEXT", vbBlue, c_img_enum
'  AddKeyWord "RECONFIGURE", vbBlue, c_img_enum
'  AddKeyWord "REFERENCES", vbBlue, c_img_enum
'  AddKeyWord "REPLICATION", vbBlue, c_img_enum
'  AddKeyWord "RESTORE", vbBlue, c_img_enum
'  AddKeyWord "RESTRICT", vbBlue, c_img_enum
'  AddKeyWord "RETURN", vbBlue, c_img_enum
'  AddKeyWord "REVOKE", vbBlue, c_img_enum
'  AddKeyWord "RIGHT", vbBlue, c_img_enum
'  AddKeyWord "ROLLBACK", vbBlue, c_img_enum
'  AddKeyWord "ROWCOUNT", vbBlue, c_img_enum
'  AddKeyWord "ROWGUIDCOL", vbBlue, c_img_enum
'  AddKeyWord "RULE", vbBlue, c_img_enum
'  AddKeyWord "SAVE", vbBlue, c_img_enum
'  AddKeyWord "SCHEMA", vbBlue, c_img_enum
'  AddKeyWord "SELECT", vbBlue, c_img_enum
'  AddKeyWord "SESSION_USER", vbBlue, c_img_enum
'  AddKeyWord "SET", vbBlue, c_img_enum
'  AddKeyWord "SETUSER", vbBlue, c_img_enum
'  AddKeyWord "SHUTDOWN", vbBlue, c_img_enum
'  AddKeyWord "SOME", vbBlue, c_img_enum
'  AddKeyWord "STATISTICS", vbBlue, c_img_enum
'  AddKeyWord "SYSTEM_USER", vbBlue, c_img_enum
'  AddKeyWord "TABLE", vbBlue, c_img_enum
'  AddKeyWord "TEXTSIZE", vbBlue, c_img_enum
'  AddKeyWord "THEN", vbBlue, c_img_enum
'  AddKeyWord "TO", vbBlue, c_img_enum
'  AddKeyWord "TOP", vbBlue, c_img_enum
'  AddKeyWord "TRAN", vbBlue, c_img_enum
'  AddKeyWord "TRANSACTION", vbBlue, c_img_enum
'  AddKeyWord "TRIGGER", vbBlue, c_img_enum
'  AddKeyWord "TRUNCATE", vbBlue, c_img_enum
'  AddKeyWord "TSEQUAL", vbBlue, c_img_enum
'  AddKeyWord "UNION", vbBlue, c_img_enum
'  AddKeyWord "UNIQUE", vbBlue, c_img_enum
'  AddKeyWord "UPDATE", vbBlue, c_img_enum
'  AddKeyWord "UPDATETEXT", vbBlue, c_img_enum
'  AddKeyWord "USE", vbBlue, c_img_enum
'  AddKeyWord "USER", vbBlue, c_img_enum
'  AddKeyWord "VALUES", vbBlue, c_img_enum
'  AddKeyWord "VARYING", vbBlue, c_img_enum
'  AddKeyWord "VIEW", vbBlue, c_img_enum
'  AddKeyWord "WAITFOR", vbBlue, c_img_enum
'  AddKeyWord "WHEN", vbBlue, c_img_enum
'  AddKeyWord "WHERE", vbBlue, c_img_enum
'  AddKeyWord "WHILE", vbBlue, c_img_enum
'  AddKeyWord "WITH", vbBlue, c_img_enum
'  AddKeyWord "WRITETEXT", vbBlue, c_img_enum
'
'  AddKeyWord "bigint", vbBlue, c_img_basic
'  AddKeyWord "datetime", vbBlue, c_img_basic
'  AddKeyWord "money", vbBlue, c_img_basic
'  AddKeyWord "smalldatetime", vbBlue, c_img_basic
'  AddKeyWord "tinyint", vbBlue, c_img_basic
'
'  AddKeyWord "Binary", vbBlue, c_img_basic
'  AddKeyWord "Decimal", vbBlue, c_img_basic
'  AddKeyWord "Nchar", vbBlue, c_img_basic
'  AddKeyWord "Smallint", vbBlue, c_img_basic
'  AddKeyWord "Varbinary", vbBlue, c_img_basic
'
'  AddKeyWord "bit", vbBlue, c_img_basic
'  AddKeyWord "float", vbBlue, c_img_basic
'  AddKeyWord "ntext", vbBlue, c_img_basic
'  AddKeyWord "smallmoney", vbBlue, c_img_basic
'  AddKeyWord "Varchar", vbBlue, c_img_basic
'
'  AddKeyWord "char", vbBlue, c_img_basic
'  AddKeyWord "image", vbBlue, c_img_basic
'  AddKeyWord "nvarchar", vbBlue, c_img_basic
'  AddKeyWord "text", vbBlue, c_img_basic
'  AddKeyWord "uniqueidentifier", vbBlue, c_img_basic
'
'  AddKeyWord "cursor", vbBlue, c_img_basic
'  AddKeyWord "int", vbBlue, c_img_basic
'  AddKeyWord "real", vbBlue, c_img_basic
'  AddKeyWord "timestamp", vbBlue, c_img_basic
'
'  AddKeyWord "sysobjects", &HC000&, c_img_basic
'  AddKeyWord "OBJECTPROPERTY", vbMagenta, c_img_basic
'End Sub

'Private Sub LoadKeyWords(ByRef lvIS As ListView)
'  Dim i As Integer
'
'  lvIS.ListItems.Clear
'
'  For i = 1 To UBound(m_vKeyWords)
'    lvIS.ListItems.Add , , m_vKeyWords(i).word, , m_vKeyWords(i).Icon
'  Next
'End Sub
'
'Private Sub SortKeyWords()
'  Dim i As Integer
'  Dim j As Integer
'  Dim s As csSqlKeyWords
'
'  m_vKeyWords(0).word = ""
'
'  For i = 2 To UBound(m_vKeyWords)
'    j = i
'    While m_vKeyWords(j).word < m_vKeyWords(j - 1).word
'      s = m_vKeyWords(j)
'      m_vKeyWords(j) = m_vKeyWords(j - 1)
'      m_vKeyWords(j - 1) = s
'      j = j - 1
'    Wend
'  Next
'
'End Sub

'---------------------------------------------------------------------------------------------------------
' Status Bar
'---------------------------------------------------------------------------------------------------------

Private Sub FormatStatusBar()
  Dim Panel As Panel
  sbEdit.Panels.Clear
  Set Panel = sbEdit.Panels.Add(, c_panel_message)
  Panel.Style = sbrText
  Panel.AutoSize = sbrSpring
  Set Panel = sbEdit.Panels.Add(, c_panel_line)
  Panel.MinWidth = 800
  Panel.AutoSize = sbrContents
  Set Panel = sbEdit.Panels.Add(, c_panel_col)
  Panel.MinWidth = 800
  Panel.AutoSize = sbrContents
  Set Panel = sbEdit.Panels.Add(, c_panel_upper)
  Panel.Style = sbrCaps
  Panel.Width = 600
  Set Panel = sbEdit.Panels.Add(, c_panel_insert)
  Panel.Style = sbrIns
  Panel.Width = 600
  Set Panel = sbEdit.Panels.Add(, c_panel_numlock)
  Panel.Style = sbrNum
  Panel.Width = 600
End Sub

'Private Sub ShowLineAndCol()
'  On Error Resume Next
'  With sbEdit.Panels(c_panel_line)
'    .Text = "ln: " & GetRow()
'  End With
'  With sbEdit.Panels(c_panel_col)
'    .Text = "c: " & GetCol()
'  End With
'End Sub

'Private Function GetRow() As Long
'  GetRow = ctxCode.GetLineFromChar(ctxCode.SelStart) + 1
'End Function
'
'Private Function GetCol() As Long
'  GetCol = ctxCode.SelStart - GetFirstCol()
'End Function

' Devuelve la posicion del primer caracter de una linea
'Private Function GetFirstCol() As Long
'  On Error Resume Next
'  Dim i As Long
'  Dim l As Long
'
'  i = ctxCode.SelStart
'  If i > 0 Then
'    l = ctxCode.GetLineFromChar(i)
'    i = i - 1
'    Do While i > 1
'      If l > ctxCode.GetLineFromChar(i) Then
'        Exit Do
'      End If
'      i = i - 1
'    Loop
'  End If
'  GetFirstCol = i
'End Function
'
'Private Function GetLastCol() As Long
'  On Error Resume Next
'  Dim i As Long
'  Dim l As Long
'  Dim lText As Long
'
'  lText = Len(ctxCode.Text)
'  i = ctxCode.SelStart + ctxCode.SelLength - 1
'  If i > 0 And i < lText Then
'    l = ctxCode.GetLineFromChar(i)
'    Do While i < lText
'      If l < ctxCode.GetLineFromChar(i) Then
'        Exit Do
'      End If
'      i = i + 1
'    Loop
'  End If
'  GetLastCol = i
'End Function

'---------------------------------------------------------------------------------------------------------
' Intelisense
'---------------------------------------------------------------------------------------------------------

'Private Function MustLoadIntelisense() As Boolean
'  On Error GoTo ControlError
'  If Val(GetMainIniEdit(c_K_EditQuestionAgain, 1)) = 0 Then Exit Function
'
'  Dim f As fQuestion
'  Set f = New fQuestion
'
'  f.Show vbModal
'
'  If Not f.Ok Then GoTo ExitProc
'
'  MustLoadIntelisense = True
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'  Unload f
'  Set f = Nothing
'  Me.Refresh
'  DoEvents
'End Function

'Private Sub InitializeIntelliSenese(ByRef lvIS As ListView)
'  InitListView lvIS
'  InitListView lvISSP
'  InitListView lvISTBL
'  InitListView lvISVW
'
'  LoadKeyWords lvIS
'  Set lvIS.SelectedItem = Nothing
'End Sub

Private Sub InitListView(ByRef lv As ListView)
  lv.ColumnHeaders.Clear
  lv.ColumnHeaders.Add().Width = lv.Width - 40
  lv.HideColumnHeaders = True
  lv.View = lvwReport
  lv.LabelEdit = lvwManual
  lv.FlatScrollBar = False
  lv.Appearance = ccFlat
  lv.BorderStyle = ccFixedSingle
  lv.SmallIcons = ilIS
End Sub

'Private Sub trInfo_Timer()
'  On Error GoTo ControlError
'  ' Espero al menos medio segundo a que el usuario termine de elegir
'  If Timer - m_LastDbClick < 0.5 Then Exit Sub
'
'  trInfo.Enabled = False
'
'  If Not MustLoadIntelisense Then Exit Sub
'
'  LoadIntelisense
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "trInfo_Timer", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub

Private Sub LoadIntelisense()
  On Error GoTo ControlError
  
  If cbDbs.SelectedItem Is Nothing Then Exit Sub
  
  InitProgressBar
  
  Dim Db As cDataBase
  Set Db = m_SQLServer.GetDataBaseInfo(cbDbs.SelectedItem.Text)
  
  Dim p As cStoredProcedure
  Dim t As cTable
  Dim v As cView
  Dim s As String
  Dim pr As cParameter
  
  lvISSP.ListItems.Clear
  lvISTBL.ListItems.Clear
  lvISVW.ListItems.Clear
  
  For Each p In Db.Procedures
    s = p.Name & " "
    For Each pr In p.Parameters
      s = s & pr.Name & ", "
    Next
    s = RemoveLastColon(s)
    AddToListView lvISSP, s, c_img_Sp
  Next
  
  For Each t In Db.Tables
    AddToListView lvISTBL, t.Name, c_img_table
  Next
  
  For Each v In Db.Views
    AddToListView lvISTBL, v.Name, c_img_view
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  sbMsg ""
  HideProgressBar
End Sub

Private Sub AddToListView(ByRef lv As ListView, ByVal Text As String, ByVal Img As csImgIS)
  lv.ListItems.Add , , Text, , Img
End Sub

Private Sub lvIS_DblClick()
  ProcessKeyIntelisense vbKeyReturn, lvIS
End Sub

Private Sub lvISSP_DblClick()
  ProcessKeyIntelisense vbKeyReturn, lvISSP
End Sub

Private Sub lvISTBL_DblClick()
  ProcessKeyIntelisense vbKeyReturn, lvISTBL
End Sub

Private Sub lvISVW_DblClick()
  ProcessKeyIntelisense vbKeyReturn, lvISVW
End Sub

Private Sub lvIS_KeyPress(KeyAscii As Integer)
  ProcessKeyIntelisense KeyAscii, lvIS
End Sub

Private Sub lvISSP_KeyPress(KeyAscii As Integer)
  ProcessKeyIntelisense KeyAscii, lvISSP
End Sub

Private Sub lvISTBL_KeyPress(KeyAscii As Integer)
  ProcessKeyIntelisense KeyAscii, lvISTBL
End Sub

Private Sub lvISVW_KeyPress(KeyAscii As Integer)
  ProcessKeyIntelisense KeyAscii, lvISVW
End Sub

Private Sub ProcessKeyIntelisense(ByVal KeyAscii As Integer, ByRef lv As ListView)
  Select Case KeyAscii
    Case vbKeyReturn, vbKeyTab
      ctxCode.ZOrder
      ctxCode.SetFocus
      If Not lv.SelectedItem Is Nothing Then
        SendKeys lv.SelectedItem.Text
        Set lv.SelectedItem = Nothing
      End If
      lv.Visible = False
    
    Case vbKeyEscape
      ctxCode.ZOrder
      ctxCode.SetFocus
      Set lv.SelectedItem = Nothing
      lv.Visible = False
  End Select
End Sub

Private Sub m_SQLServer_Msg(ByVal Msg As String)
  sbMsg Msg
End Sub

Private Sub m_SQLServer_ShowProgress(ByVal Percent As Single)
  ShowProgress Percent
End Sub

'---------------------------------------------------------------------------------------------------------
' Progreso y Mensajes en StatusBar
'---------------------------------------------------------------------------------------------------------

Private Sub ShowProgress(ByVal Percent As Single)
  UpdateStatus picProgress, Percent
End Sub

Private Sub sbMsg(ByVal Msg As String)
  On Error Resume Next
  sbEdit.Panels(c_panel_message).Text = Msg
  DoEvents
End Sub

'---------------------------------------------------------------------------------------------------------
' Database Objects
'---------------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------------
' Toolbar
'---------------------------------------------------------------------------------------------------------

Private Function SetCaption()
  Me.Caption = "[" & m_SQLServer.Conn.Server.Name & " - " & cbDbs.Text & "] " & m_File
End Function

Private Function SaveChanges() As Boolean
  On Error GoTo ControlError
  
  Dim rtn As VbMsgBoxResult
  
  If m_DataHasChanged Then
  
    rtn = Ask2("El documento " & m_File & " ha cambiado.;;¿Desea guardar los cambios?", True)
    
    If rtn = vbYes Then
      If Not Save(False) Then Exit Function
    ElseIf rtn = vbCancel Then
      Exit Function
    End If
  End If
  
  SaveChanges = True
  GoTo ExitProc
ControlError:
  MngError Err, "SaveChanges", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub OpenQuery()
  On Error GoTo ControlError

  If Not SaveChanges() Then Exit Sub
  
  Dim File As String
  
  If Not ShowOpenFileDLG(cd, File, m_Filter) Then Exit Sub
  
  Dim Code As String
  If Not FileReadFullFile(File, Code) Then Exit Sub
  
  m_IsNew = False
      
  ctxCode.Text = Code
  m_DataHasChanged = False
  
  'PaintText
  
  Me.File = File
  
  GoTo ExitProc
ControlError:
  MngError Err, "OpenQuery", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub NewQuery()
  On Error GoTo ControlError

  Dim f As fEditScript
  Set f = New fEditScript
  Set f.SQLServer = m_SQLServer
  f.Show

  GoTo ExitProc
ControlError:
  MngError Err, "NewQuery", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function Undo() As Boolean
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Undo", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function Save(ByVal bSaveAs As Boolean) As Boolean
  On Error GoTo ControlError
  
  Dim ShowOpenDialog As Boolean
  
  If m_IsNew Or bSaveAs Then
    ShowOpenDialog = True
  Else
    If FileExists(m_File) Then
      If Not FileIsWriteable(m_File) Then
        ShowOpenDialog = True
      Else
        ShowOpenDialog = False
      End If
    Else
      ShowOpenDialog = False
    End If
  End If

  If Not FileSaveTextTofile(m_File, ctxCode.Text, ShowOpenDialog, cd, True) Then Exit Function
  
  m_IsNew = False
  m_DataHasChanged = False
  
  Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "Save", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'Private Sub Cut()
'  On Error GoTo ControlError
'
'  If ctxCode.SelLength = 0 Then Exit Sub
'
'  Copy
'
'  SavePosCaret
'
'  ctxCode.Text = Mid(ctxCode.Text, 1, ctxCode.SelStart - 1) & Mid(ctxCode.Text, ctxCode.SelStart + ctxCode.SelLength + 1)
'
'  PaintText
'
'  RestorePosCaret
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "Cut", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub
'
'Private Sub Paste()
'  On Error GoTo ControlError
'
'  Dim Text As String
'
'  SavePosCaret
'
'  Text = Clipboard.GetText
'  ctxCode.Text = Mid(ctxCode.Text, 1, ctxCode.SelStart) & Text & Mid(ctxCode.Text, ctxCode.SelStart + 1)
'
'  PaintText
'
'  RestorePosCaret
'
'  ctxCode.SelStart = ctxCode.SelStart + Len(Text)
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "Paste", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub
'
'Private Sub Copy()
'  On Error GoTo ControlError
'
'  If ctxCode.SelLength = 0 Then Exit Sub
'
'  Clipboard.SetText ctxCode.SelText
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "Copy", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub
'
'Private Function Find() As Boolean
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "Find", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Function

Private Function Execute1() As Boolean
  On Error GoTo ControlError
  
  Set m_cSql = New cSQLScript
  
  m_cancel = False
  
  Dim sqlstmt As String
  
  SetToolbarExecuting True
  InitResult
  
  sbMsg "Cargando la consulta ..."
  
  If ctxCode.SelLength > 0 Then
    sqlstmt = ctxCode.SelText
  Else
    sqlstmt = ctxCode.Text
  End If
  
  sbMsg "Ejecutando ..."

  Set m_cSql.Conn = m_SQLServer.Conn
  m_cSql.ExecuteBatchWithResultAndMessage sqlstmt, cbDbs.Text
  
  ' Esta llamada descarga las grillas no usadas
  UnloadGrids
  
  If m_Grids = 0 Then
    m_ResultInTextAux = True
    
    If m_cancel Then
      m_vResults(m_IdxResults) = "El comando fue cancelado por el usuario" & vbCrLfRTF & vbCrLfRTF
    ElseIf m_IdxResults = 0 Then
      m_vResults(m_IdxResults) = "El comando se ejecuto con éxito" & vbCrLfRTF & vbCrLfRTF
    End If
    
    AddTextToRTF2 txResult
  End If
  
  tabResult.Tabs.Add , , "Detalle"
  tabResult.Tabs(1).Selected = True
  ShowResult True
  
  sbMsg vbNullString
  Execute1 = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Execute", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  SetToolbarExecuting False
  Set m_cSql = Nothing
End Function

Private Sub InitResult()
  txResult.Text = ""
  tabResult.Tabs.Clear
  
  m_ResultInTextAux = m_ResultInText
  m_Grids = 0
  m_Tabs = 0
  UnloadGrids False
  
  ReDim m_vResults(200)
  m_IdxResults = 0
End Sub

Private Function Execute2(ByRef Rslt As SQLDMO.QueryResults, ByVal Msg As String) As Boolean
  On Error GoTo ControlError
  
  Dim i As Long
  Dim j As Long
  Dim k As Long
  Dim l() As Long
  Dim l2 As Long
  Dim li As ListItem
  Dim Txt As String
  Dim vCols() As String
  Dim vRows() As String
  Dim idxRow As Long
  Dim n As Integer
  
  ReDim vCols(0)
  ReDim vRows(0)
  
  If Not Rslt Is Nothing Then
  
    If Rslt.ResultSets = 0 Then
      m_ResultInTextAux = True
    ElseIf Rslt.ResultSets > 15 Then
      m_ResultInTextAux = True
    Else
      m_ResultInTextAux = m_ResultInText
    End If
  
    m_TabText = m_Tabs + Rslt.ResultSets + 1
    
    If Not m_ResultInTextAux Then
      m_Grids = m_Grids + Rslt.ResultSets
      LoadGrids
    End If
    
    For k = 1 To Rslt.ResultSets
      
      Rslt.CurrentResultSet = k
      
      If Not m_ResultInTextAux Then
        tabResult.Tabs.Add , , "Panel " & (m_Tabs + k)
      Else
        ReDim vCols(Rslt.Columns)
        ReDim l(Rslt.Columns)
      End If
      
      For j = 1 To Rslt.Columns
      
        If m_ResultInTextAux Then
          l(j) = Rslt.ColumnMaxLength(j)
          If l(j) > 100 Then l(j) = 100
          
          Txt = Rslt.ColumnName(j)
          l2 = Len(Txt)
          If l2 > l(j) Then l(j) = l2
          
          vCols(j) = Txt & String$(l(j) - l2 + 1, " ")
        
        Else
          lvResult(m_Tabs + k).ColumnHeaders.Add , , Rslt.ColumnName(j)
        End If
      Next
      
      If m_ResultInTextAux Then
      
        ReDim Preserve vRows(idxRow + Rslt.Rows + 2)
      
        vRows(idxRow) = Join(vCols, vbNullString)
        idxRow = idxRow + 1
        
        For j = 1 To Rslt.Columns
          vCols(j) = String$(l(j), "-") & " "
        Next
        
        vRows(idxRow) = Join(vCols, vbNullString)
        idxRow = idxRow + 1
      
      End If
      
      For i = 1 To Rslt.Rows
        If m_ResultInTextAux Then
          For j = 1 To Rslt.Columns
          
            Txt = Rslt.GetColumnString(i, j)
            vCols(j) = Txt & String$(l(j) - Len(Txt) + 1, " ")
          Next
          
          vRows(idxRow) = Join(vCols, vbNullString)
          idxRow = idxRow + 1
          
        Else
          Set li = lvResult(m_Tabs + k).ListItems.Add(, , Rslt.GetColumnString(i, 1))
          For j = 2 To Rslt.Columns
            li.ListSubItems.Add , , Rslt.GetColumnString(i, j)
          Next
        End If
        
        If i Mod 100 = 0 Then
          sbMsg i
        End If
      Next
        
      If m_ResultInTextAux Then
        
        vRows(idxRow) = vbCrLfRTF & "(" & Rslt.Rows & " Filas)" & vbCrLfRTF & vbCrLfRTF & vbCrLfRTF
        idxRow = idxRow + 1
      
      End If
    Next
  
    m_Tabs = m_Tabs + Rslt.ResultSets
  End If
  
  ReDim Preserve vRows(UBound(vRows) + 1)
  vRows(idxRow) = SqlReplaceComments(Msg)
  idxRow = idxRow + 1
  
  If Not (Msg = vbNullString And UBound(vRows) = 1) Then
    AddTextToRTF Join(vRows, vbCrLfRTF)
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Execute", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function AddTextToRTF(ByRef Txt As String)
  
  m_IdxResults = m_IdxResults + 1
  If UBound(m_vResults) < m_IdxResults Then
    ReDim Preserve m_vResults(UBound(m_vResults) + 200)
  End If

  m_vResults(m_IdxResults) = Txt
End Function

Private Function AddTextToRTF2(ByRef rtControl As RichTextBox)
  Dim ss As Long
  With rtControl
    .TextRTF = GetRTFText(txResult) & Join(m_vResults, vbCrLf) & c_EndRTF
    .SelLength = 0
  End With
End Function

Private Function GetRTFText(ByRef rtControl As RichTextBox) As String
  With rtControl
    GetRTFText = Left$(.TextRTF, Len(.TextRTF) - 8)
  End With
End Function

Private Sub SetToolbarExecuting(ByVal Executing As Boolean)
  tbEdit.buttons(c_k_play).Enabled = Not Executing
  tbEdit.buttons(c_k_stop).Enabled = Executing
  DoEvents
End Sub

Private Function LoadGrids()
  Dim k As Integer
  
  For k = lvResult.Count To m_Grids
    Load lvResult(k)
  Next
End Function

Private Function UnloadGrids(Optional ByVal bUnload As Boolean = True)
  On Error Resume Next
  Dim n As Integer
  For n = m_Grids + 1 To lvResult.Count - 1
    With lvResult(n)
      .ColumnHeaders.Clear
      .ListItems.Clear
    End With
    If bUnload Then Unload lvResult(n)
  Next
End Function

Private Function Cancel() As Boolean
  On Error GoTo ControlError

  m_cancel = True

  GoTo ExitProc
ControlError:
  MngError Err, "Cancel", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function


Private Sub tbEdit_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  Select Case Button.Key
    Case c_k_new
      NewQuery
    Case c_k_open
      OpenQuery
    Case c_k_save
      Save False
    Case c_k_copy
      ctxCode.Copy
    Case c_k_cut
      ctxCode.Cut
    Case c_k_paste
      ctxCode.Cut
    Case c_k_find
      ctxCode.Find
    Case c_k_erase
      ctxCode.Text = ""
    Case c_k_print
    Case c_k_undo
      Undo
    Case c_k_ok
      
    Case c_k_play
      Execute1
    Case c_k_stop
      Cancel
  End Select
End Sub

Private Sub CreateToolbar()
  Dim b As MSComctlLib.Button
  
  Set tbEdit.ImageList = ilTbEdit
  tbEdit.Style = tbrFlat
  
  With tbEdit.buttons
    .Clear
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_new, "", , c_img_new)
    b.ToolTipText = "Nuevo"
    Set b = .Add(, c_k_open, "", , c_img_open)
    b.ToolTipText = "Abrir"
    Set b = .Add(, c_k_save, "", , c_img_save)
    b.ToolTipText = "Guardar"
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_copy, "", , c_img_copy)
    b.ToolTipText = "Copiar"
    Set b = .Add(, c_k_cut, "", , c_img_cut)
    b.ToolTipText = "Cortar"
    Set b = .Add(, c_k_paste, "", , c_img_paste)
    b.ToolTipText = "Pegar"
    Set b = .Add(, c_k_find, "", , c_img_find)
    b.ToolTipText = "Buscar"
    Set b = .Add(, c_k_erase, "", , c_img_erase)
    b.ToolTipText = "Limpiar la ventana"
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_print, "", , c_img_print)
    b.ToolTipText = "Imprimir"
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_undo, "", , c_img_undo)
    b.ToolTipText = "Deshacer"
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_ok, "", , c_img_ok)
    b.ToolTipText = "Validar sintaxis"
    Set b = .Add(, c_k_play, "", , c_img_play)
    b.ToolTipText = "Ejecutar"
    Set b = .Add(, c_k_stop, "", , c_img_stop)
    b.ToolTipText = "Parar"
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_cbdb, , tbrPlaceholder)
    b.Width = 2400
    cbDbs.Left = b.Left
    cbDbs.Top = b.Top
    cbDbs.Width = b.Width
    
    .Add , , , tbrSeparator
    
    Set b = .Add(, c_k_finddb, "", , c_img_finddb)
    b.ToolTipText = "Buscar objeto"


    Dim c As Collection
    Dim Db As cListDataBaseInfo
    
    Set c = m_SQLServer.ListDataBases()
    
    With cbDbs
      Set .ImageList = ilTbEdit
      With .ComboItems
        .Clear
        For Each Db In c
          .Add , , Db.Name, c_img_db
        Next
      End With
      .ComboItems(1).Selected = True
    End With
    
    
    
    
'    Set b = .Add(, c_k_, "", c_img_)
'    b.ToolTipText = ""
'    Set b = .Add(, c_k_, "", c_img_)
'    b.ToolTipText = ""
  End With
  
  SetToolbarExecuting False
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  
  ctxCode.Initialize vbNullString, vbNullString
  
  m_Filter = "Archivos de script|*.sql;*.prc"
  m_File = "script1.sql"
  m_IsNew = True
  'm_TabLen = 2
  
  trPaint.Interval = 50
  trInfo.Interval = 50
  picProgress.Visible = False
  'ctxCode.RightMargin = Screen.TwipsPerPixelX * Screen.Width * 10  '3.402823E+38 '
  ctxCode.ZOrder
  
  txResult.RightMargin = Screen.TwipsPerPixelX * Screen.Width * 10  '3.402823E+38 '
  
  'FillColKeyWords
  'SortKeyWords
  
  If UBound(m_vKeyWords) < m_Index Then info "Hay palabras claves que no se han podido agregar al vector m_vKeyWords por que esta mal dimensionado"
  FormatStatusBar
  'InitializeIntelliSenese lvIS
  CreateToolbar
  SetCaption
  ShowResult False
  SetTabResult
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
