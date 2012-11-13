VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fMain 
   Caption         =   "SQL Admin"
   ClientHeight    =   4275
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   4680
   Icon            =   "fMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   4275
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog cd 
      Left            =   2385
      Top             =   495
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox picTlb 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   465
      Left            =   0
      ScaleHeight     =   465
      ScaleWidth      =   4680
      TabIndex        =   6
      Top             =   0
      Width           =   4680
      Begin MSComctlLib.Toolbar tbTools 
         Height          =   390
         Left            =   45
         TabIndex        =   7
         Top             =   45
         Width           =   4680
         _ExtentX        =   8255
         _ExtentY        =   688
         ButtonWidth     =   609
         ButtonHeight    =   582
         Appearance      =   1
         _Version        =   393216
      End
   End
   Begin MSComctlLib.ImageList ilToolBar 
      Left            =   2520
      Top             =   3060
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
            Picture         =   "fMain.frx":0442
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":059C
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList iltv 
      Left            =   3780
      Top             =   2970
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   25
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":06F6
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":0C92
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":122E
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1388
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":14E2
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":163C
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1796
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":18F0
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1A4A
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":1BA4
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":213E
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2298
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2832
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":2DCC
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":3366
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":3900
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":3E9A
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4434
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":49CE
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":4F68
            Key             =   ""
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":5502
            Key             =   ""
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":5A9C
            Key             =   ""
         EndProperty
         BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":6036
            Key             =   ""
         EndProperty
         BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":65D0
            Key             =   ""
         EndProperty
         BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain.frx":6B6A
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picProgress 
      Align           =   2  'Align Bottom
      AutoRedraw      =   -1  'True
      ClipControls    =   0   'False
      FillColor       =   &H00FF0000&
      Height          =   270
      Left            =   0
      ScaleHeight     =   210
      ScaleWidth      =   4620
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   3720
      Width           =   4680
   End
   Begin VB.PictureBox picSplitter 
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   1845
      MousePointer    =   9  'Size W E
      ScaleHeight     =   4290
      ScaleWidth      =   60
      TabIndex        =   2
      Top             =   45
      Width           =   60
   End
   Begin VB.PictureBox picBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   2025
      ScaleHeight     =   4290
      ScaleWidth      =   60
      TabIndex        =   3
      Top             =   0
      Width           =   60
   End
   Begin MSComctlLib.ListView lv 
      Height          =   2355
      Left            =   2205
      TabIndex        =   1
      Top             =   945
      Width           =   2220
      _ExtentX        =   3916
      _ExtentY        =   4154
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.StatusBar sbEdit 
      Align           =   2  'Align Bottom
      Height          =   285
      Left            =   0
      TabIndex        =   5
      Top             =   3990
      Width           =   4680
      _ExtentX        =   8255
      _ExtentY        =   503
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TreeView tv 
      Height          =   3075
      Left            =   45
      TabIndex        =   0
      Top             =   720
      Width           =   1680
      _ExtentX        =   2963
      _ExtentY        =   5424
      _Version        =   393217
      HideSelection   =   0   'False
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuFileOpenConection 
         Caption         =   "&Conectar..."
      End
      Begin VB.Menu mnufilesep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Herramientas"
      Begin VB.Menu mnuToolsEditSQL 
         Caption         =   "&Editor SQL..."
      End
      Begin VB.Menu mnuToolsSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsBackup 
         Caption         =   "&Backup..."
      End
      Begin VB.Menu mnuToolsRestore 
         Caption         =   "&Restore..."
      End
      Begin VB.Menu mnuToolsSep6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsNewDataBase 
         Caption         =   "&Nueva base de datos..."
      End
      Begin VB.Menu mnuToolNewDatabaseFromScript 
         Caption         =   "Nueva base de  datos desde un script..."
      End
      Begin VB.Menu mnuToolsSep5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsNewScriptDataBase 
         Caption         =   "Nuevo script de creación de base de datos..."
      End
      Begin VB.Menu mnuToolsSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsNewScriptBatch 
         Caption         =   "Script de comandos..."
      End
      Begin VB.Menu mnuToolsSep3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsDBCompare 
         Caption         =   "Comparar bases de datos..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "Acerca de SQL Admin"
      End
   End
   Begin VB.Menu popServer 
      Caption         =   "popServer"
      Visible         =   0   'False
      Begin VB.Menu popServerStop 
         Caption         =   "&Detener"
      End
      Begin VB.Menu popServerStopAndStart 
         Caption         =   "Detener y Luego &Arrancar"
      End
      Begin VB.Menu popServerProperties 
         Caption         =   "&Propiedades..."
      End
   End
   Begin VB.Menu popDb 
      Caption         =   "popDb"
      Visible         =   0   'False
      Begin VB.Menu popDbBackup 
         Caption         =   "Backup..."
      End
      Begin VB.Menu popDbRestore 
         Caption         =   "Restore..."
      End
      Begin VB.Menu popDbSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popDbScript 
         Caption         =   "Script..."
      End
      Begin VB.Menu popDbSep3 
         Caption         =   "-"
      End
      Begin VB.Menu popDbDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popDbSep2 
         Caption         =   "-"
      End
      Begin VB.Menu popDbNewDB 
         Caption         =   "Nueva base..."
      End
      Begin VB.Menu popDbSep23 
         Caption         =   "-"
      End
      Begin VB.Menu popToolsRunScriptFile 
         Caption         =   "&Ejecutar archivo de script..."
      End
   End
   Begin VB.Menu popTbl 
      Caption         =   "popTbl"
      Visible         =   0   'False
      Begin VB.Menu popTblOpen 
         Caption         =   "Abrir..."
      End
      Begin VB.Menu popTblEdit 
         Caption         =   "Editar..."
      End
      Begin VB.Menu popTblDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popTblSep 
         Caption         =   "-"
      End
      Begin VB.Menu popTblNew 
         Caption         =   "Nueva tabla..."
      End
      Begin VB.Menu popTblSep2 
         Caption         =   "-"
      End
      Begin VB.Menu popTblImportExcel 
         Caption         =   "&Crear tabla desde Excel"
      End
   End
   Begin VB.Menu popTrigger 
      Caption         =   "popTrigger"
      Visible         =   0   'False
      Begin VB.Menu popTriggerEdit 
         Caption         =   "&Editar..."
      End
      Begin VB.Menu popTriggerDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popTriggerSep 
         Caption         =   "-"
      End
      Begin VB.Menu popTriggerNew 
         Caption         =   "&Nuevo Trigger..."
      End
   End
   Begin VB.Menu popSp 
      Caption         =   "popSp"
      Visible         =   0   'False
      Begin VB.Menu popSpEdit 
         Caption         =   "Editar..."
      End
      Begin VB.Menu popSpDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popSpSep 
         Caption         =   "-"
      End
      Begin VB.Menu popSpNew 
         Caption         =   "Nuevo stored procedure..."
      End
      Begin VB.Menu popSpSep2 
         Caption         =   "-"
      End
      Begin VB.Menu popSpCreateScript 
         Caption         =   "Generar Scripts..."
      End
      Begin VB.Menu popSpCreateScript2 
         Caption         =   "Generar Scripts por Diferencia de Fechas..."
      End
   End
   Begin VB.Menu popView 
      Caption         =   "popView"
      Visible         =   0   'False
      Begin VB.Menu popViewOpen 
         Caption         =   "Abrir..."
      End
      Begin VB.Menu popViewEdit 
         Caption         =   "Editar..."
      End
      Begin VB.Menu popViewDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popViewSep 
         Caption         =   "-"
      End
      Begin VB.Menu popViewNew 
         Caption         =   "Nueva vista..."
      End
   End
   Begin VB.Menu popTask 
      Caption         =   "popTask"
      Visible         =   0   'False
      Begin VB.Menu popTaskEdit 
         Caption         =   "&Editar..."
      End
      Begin VB.Menu popTaskDelete 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popTaskSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popTaskNewTask 
         Caption         =   "&Nueva tarea..."
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
' 23-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fMain"

Private Const sglSplitLimit = 500

Private Const c_ktlb_open_cn = "opc"
Private Const c_ktlb_edit_script = "escr"

Private Enum c_img_tlb
  c_img_tlb_open_cn = 1
  c_img_tlb_edit
End Enum

Private Enum csTvImage
  c_img_FolderClose = 1
  c_img_FolderOpen
  c_img_db
  c_img_ServerDown
  c_img_ServerUp
  c_img_Managment
  c_img_Job
  c_img_dbsys
  c_img_tbl
  c_img_Sp
  c_img_vw
  c_img_up
  c_img_down
  c_img_trigger
  c_img_activity
  c_img_info
  c_img_lockp
  c_img_locko
  c_img_background
  c_img_runable
  c_img_sleeping
  c_img_logs
  c_img_log
  c_img_process
  c_img_property
End Enum

Private Const c_k_server = "sv"
Private Const c_k_managment = "m"
Private Const c_k_jobs = "js"
Private Const c_k_jobsf = "jf"
Private Const c_k_db = "dbs"
Private Const c_k_dbname = "dbn"
Private Const c_k_dbf = "dbf"
Private Const c_k_tbl = "tbl"
Private Const c_k_trg = "trg"
Private Const c_k_sp = "sp"
Private Const c_k_vw = "vw"
Private Const c_k_loaded = "ld"
Private Const c_k_task = "tk"

Private Const c_k_activity = "ac"
Private Const c_k_info = "inf"
Private Const c_k_lockp = "lp"
Private Const c_k_locko = "lo"
Private Const c_k_background = "bk"
Private Const c_k_runable = "rb"
Private Const c_k_sleeping = "sl"
Private Const c_k_logs = "lgs"
Private Const c_k_log = "log"
Private Const c_k_process = "pr"

Private Const c_panel_message = "m"
Private Const c_panel_upper = "u"
Private Const c_panel_insert = "i"
Private Const c_panel_numlock = "n"

Private Const c_path_template = "Template\"
Private Const c_path_template_sp = "Create Procedure\"
Private Const c_path_template_tbl = "Create Table\"
Private Const c_path_template_tr = "Create Trigger\"
Private Const c_path_template_vw = "Create View\"

' estructuras
' variables privadas

' Objeto de conexión a SQL SERVER
Private WithEvents m_SQLServer As CSTools.cSQLServer
Attribute m_SQLServer.VB_VarHelpID = -1

Private m_Jobs      As Collection
Private m_DataBases As Collection

Private WithEvents m_Login     As fLogin
Attribute m_Login.VB_VarHelpID = -1

Private m_moving    As Boolean

Private m_OldNode As Integer
Private m_bCancel As Boolean

' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

'-------------------------------------------------
' Objetos sql
'-------------------------------------------------
Private Sub LoadSQLObjects()
  
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  
  With tv
    .Nodes.Clear
    m_OldNode = 0
    
    If Not m_SQLServer.Conn.Connected Then Exit Sub
    
    Set .ImageList = iltv
    With .Nodes.Add(, , c_k_server, "Servers", c_img_ServerUp)
      .Expanded = True
      .Tag = SetInfoString_(.Tag, c_k_server, 1)
    End With
    
    With AddChildNode(tv, c_k_server, "Databases", c_k_dbf, c_img_FolderClose, c_img_FolderOpen)
      .Expanded = True
      .Tag = SetInfoString_(.Tag, c_k_dbf, 1)
    End With
    
    With AddChildNode(tv, c_k_server, "Managment", c_k_managment, c_img_Managment)
      .Expanded = True
      .Tag = SetInfoString_(.Tag, c_k_managment, 1)
    End With
    
    With AddChildNode(tv, c_k_managment, "Jobs", c_k_jobs, c_img_Job)
      .Expanded = True
      .Tag = SetInfoString_(.Tag, c_k_jobsf, 1)
    End With
    
    Dim o As cListDataBaseInfo
    Dim Coll As Collection
    
    Set Coll = m_SQLServer.ListDataBases()
    
    For Each o In Coll
      AddDbToTree o.Name
    Next
    
    Set m_Jobs = m_SQLServer.ListTasks()
    
    With AddChildNode(tv, c_k_server, "Actividad", c_k_activity, c_img_activity)
      .Expanded = True
      .Tag = SetInfoString_(.Tag, c_k_activity, 1)
    End With
    
    With AddChildNode(tv, c_k_activity, "Procesos", c_k_info, c_img_info)
      .Expanded = False
      .Tag = SetInfoString_(.Tag, c_k_process, 1)
    End With
    
'    With AddChildNode(tv, c_k_activity, "Locks / Process ID", c_k_lockp, c_img_lockp)
    With AddChildNode(tv, c_k_activity, "Locks", c_k_lockp, c_img_lockp)
      .Expanded = False
      .Tag = SetInfoString_(.Tag, c_k_lockp, 1)
    End With
    
'    With AddChildNode(tv, c_k_activity, "Locks / Objeto", c_k_locko, c_img_locko)
'      .Expanded = False
'      .Tag = SetInfoString_(.Tag, c_k_locko, 1)
'    End With
  
    With AddChildNode(tv, c_k_activity, "Logs", c_k_logs, c_img_logs)
      .Expanded = False
      .Tag = SetInfoString_(.Tag, c_k_logs, 1)
      
      Dim Logs As Collection
      Dim log  As cLogInfo
      Set Logs = m_SQLServer.GetLogs()
      
      For Each log In Logs
        With AddChildNode(tv, c_k_logs, IIf(log.File = 0, "Actual", "Archivo") & " #" & log.File & " " & log.Created, "", c_img_log)
          .Expanded = False
          .Tag = SetInfoString_(.Tag, c_k_log, log.File + 1)
        End With
      Next
      
    End With
    
  End With
  
  With lv
    Set .SmallIcons = iltv
    Set .ColumnHeaderIcons = iltv
    .LabelEdit = lvwManual
    .View = lvwReport
    .GridLines = True
    .FullRowSelect = True
    .HideSelection = False
    .Sorted = True
  End With
  
  Set m_DataBases = New Collection
  
End Sub

Private Function dbExistsInTree(ByVal dbName As String) As Boolean
  On Error Resume Next
  Err.Clear
  dbExistsInTree = Not tv.Nodes(dbName) Is Nothing
End Function

Private Sub RemoveDbFromTree(ByVal dbName As String)
  On Error Resume Next
  Dim Node As Node
  Set Node = tv.Nodes(dbName)
  
  If Not (Node Is Nothing) Then
    While Not Node.Child Is Nothing
      tv.Nodes.Remove Node.Child.Index
    Wend
    
    tv.Nodes.Remove Node.Index
  End If
  
  m_DataBases.Remove dbName
End Sub

Private Sub AddDbToTree(ByVal dbName As String)
  Dim Node  As Node
  Dim node2 As Node
  
  If dbExistsInTree(dbName) Then RemoveDbFromTree dbName
  
  Select Case LCase(dbName)
    Case "master", "msdb", "tempdb", "model"
      Set Node = AddChildNode(tv, c_k_dbf, dbName, dbName, c_img_dbsys)
    Case Else
      Set Node = AddChildNode(tv, c_k_dbf, dbName, dbName, c_img_db)
  End Select
  
  Node.Tag = SetInfoString_(Node.Tag, c_k_db, 1)
  Node.Tag = SetInfoString_(Node.Tag, c_k_dbname, dbName)
  
  Set node2 = AddChildNode(tv, Node.Index, "Tables", "", c_img_FolderClose, c_img_FolderOpen)
  node2.Tag = SetInfoString_(node2.Tag, c_k_tbl, 1)
  node2.Tag = SetInfoString_(node2.Tag, c_k_dbname, dbName)
  
  Set node2 = AddChildNode(tv, node2.Index, "Triggers", "", c_img_FolderClose, c_img_FolderOpen)
  node2.Tag = SetInfoString_(node2.Tag, c_k_trg, 1)
  node2.Tag = SetInfoString_(node2.Tag, c_k_dbname, dbName)
  
  Set node2 = AddChildNode(tv, Node.Index, "Stored Procedures", "", c_img_FolderClose, c_img_FolderOpen)
  node2.Tag = SetInfoString_(node2.Tag, c_k_sp, 1)
  node2.Tag = SetInfoString_(node2.Tag, c_k_dbname, dbName)
  
  Set node2 = AddChildNode(tv, Node.Index, "Views", "", c_img_FolderClose, c_img_FolderOpen)
  node2.Tag = SetInfoString_(node2.Tag, c_k_vw, 1)
  node2.Tag = SetInfoString_(node2.Tag, c_k_dbname, dbName)
End Sub

Private Function SetLoaded(ByVal info As String) As String
  SetLoaded = SetInfoString_(info, c_k_loaded, 1)
End Function

Private Function SetUnLoaded(ByVal info As String) As String
  SetUnLoaded = SetInfoString_(info, c_k_loaded, 0)
End Function

Private Function LoadTriggers(ByRef Node As Node) As Boolean
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  If Not m_SQLServer.LoadTriggers(m_DataBases(GetDataBaseName(Node.Tag))) Then Exit Function
  
  LoadTriggers = True
End Function

Private Function GetDbAndObj(ByRef db As String, ByRef obj As String) As Boolean
  If lv.SelectedItem Is Nothing Then Exit Function
  If tv.SelectedItem Is Nothing Then Exit Function
  
  db = GetDataBaseName(tv.SelectedItem.Tag)
  obj = lv.SelectedItem.Text
  
  GetDbAndObj = True
End Function

Private Function GetDBName() As String
  If tv.SelectedItem Is Nothing Then Exit Function
  GetDBName = GetDataBaseName(tv.SelectedItem.Tag)
End Function

Private Function GetDataBaseName(ByVal Tag As String) As String
  GetDataBaseName = GetInfoString_(Tag, c_k_dbname)
End Function

Private Function LoadDataBase(ByRef Node As Node) As Boolean
  Dim db As cDataBase
  Dim dbLoaded As Boolean
  Dim dbIsNew As Boolean
  
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  If ExistsObjInCollection(m_DataBases, Node.Text) Then
    Set db = m_DataBases(Node.Text)
    dbLoaded = db.Loaded
  Else
    dbIsNew = True
  End If
    
  If Not dbLoaded Then
    Set db = m_SQLServer.GetDataBaseInfo(Node.Text, True, False, db)
    
    If dbIsNew Then m_DataBases.Add db, Node.Text
  End If
  
  LoadDataBase = True
End Function

Private Sub ShowJobs(ByVal Refresh As Boolean)
  Dim t As cListTaskInfo
  Dim vDummy(0) As String
  Dim LItem As ListItem
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Nombre", 3000
  
  If Refresh Then
    pReconnect
    Set m_Jobs = m_SQLServer.ListTasks()
  End If
  
  For Each t In m_Jobs
    Set LItem = AddToListView(lv, t.Name, "", vDummy(), c_img_Job)
    LItem.Tag = SetInfoString_(LItem.Tag, c_k_jobs, 1)
  Next
End Sub

Private Sub pReconnect()
  With m_SQLServer
    .OpenConnection .Conn.ServerName, .Conn.UserName, .Conn.Password, .Conn.NTSecurity
  End With
End Sub

Private Sub ShowServer(ByVal Refresh As Boolean)
  Dim vDummy(1) As String
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Propiedad", 3000
  AddHeaderToListView lv, "Valor", 5000
  
  With m_SQLServer.Conn.Server
    vDummy(1) = .Name
    AddToListView lv, "Nombre", "", vDummy(), c_img_property
    vDummy(1) = .VersionString
    AddToListView lv, "Versión", "", vDummy(), c_img_property
    vDummy(1) = .LoginTimeout
    AddToListView lv, "Login Time out", "", vDummy(), c_img_property
    vDummy(1) = .CodePage
    AddToListView lv, "Código de pagina", "", vDummy(), c_img_property
    vDummy(1) = .ApplicationName
    AddToListView lv, "Nombre del producto", "", vDummy(), c_img_property
  End With
End Sub

Private Sub ShowDb(ByVal Refresh As Boolean)
  Dim vDummy(1) As String
  Dim db As String
  Dim dbProperty As cDataBaseInfo
  Dim info  As Collection
  Dim dbObj As cDataBase
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Propiedad", 3000
  AddHeaderToListView lv, "Valor", 5000
  
  db = tv.SelectedItem.Text
  If db = "" Then Exit Sub
  
  If ExistsObjInCollection(m_DataBases, db) Then
    Set dbObj = m_DataBases(db)
    If Refresh Then
      pReconnect
      Set dbObj = m_SQLServer.GetDataBaseInfoObj(db, dbObj)
    End If
  Else
    Set dbObj = m_SQLServer.GetDataBaseInfoObj(db)
    m_DataBases.Add dbObj, db
  End If
  
  Set info = dbObj.GetInfo
  
  For Each dbProperty In info
    vDummy(1) = dbProperty.Value
    AddToListView lv, dbProperty.Name, "", vDummy(), c_img_property
  Next
End Sub

Private Sub ShowTables(ByRef db As cDataBase, ByVal Refresh As Boolean)
  Dim vItems(2) As String
  Dim tbl As cTable
  Dim LItem As ListItem
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Nombre", 3000
  AddHeaderToListView lv, "Tipo", 1200
  AddHeaderToListView lv, "Fecha", 2000
  
  If Refresh Then
    pReconnect
    m_SQLServer.GetTables db.Name, db, False
  End If
  
  For Each tbl In db.Tables
    If tbl.TblType = csTblUser Then
      vItems(1) = "Usuario"
    Else
      vItems(1) = "Sistema"
    End If
    vItems(2) = tbl.CreateDate
    
    Set LItem = AddToListView(lv, tbl.Name, tbl.Name, vItems(), c_img_tbl)
    LItem.Tag = SetInfoString_(LItem.Tag, c_k_tbl, 1)
  Next
End Sub

Private Sub ShowSps(ByRef db As cDataBase, ByVal Refresh As Boolean)
  Dim vItems(2) As String
  Dim sp As cStoredProcedure
  Dim LItem As ListItem
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Nombre", 3000
  AddHeaderToListView lv, "Tipo", 1200
  AddHeaderToListView lv, "Fecha", 2000
  
  If Refresh Then
    pReconnect
    m_SQLServer.GetSps db.Name, db, True
  End If
  
  For Each sp In db.Procedures
    If sp.SpType = csSpUser Then
      vItems(1) = "Usuario"
    Else
      vItems(1) = "Sistema"
    End If
    vItems(2) = sp.CreateDate
    
    Set LItem = AddToListView(lv, sp.Name, sp.Name, vItems(), c_img_Sp)
    LItem.Tag = SetInfoString_(LItem.Tag, c_k_sp, 1)
  Next
End Sub

Private Sub ShowViews(ByRef db As cDataBase, ByVal Refresh As Boolean)
  Dim vItems(2) As String
  Dim vw As cView
  Dim LItem As ListItem
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Nombre", 3000
  AddHeaderToListView lv, "Tipo", 1200
  AddHeaderToListView lv, "Fecha", 2000
  
  If Refresh Then
    pReconnect
    m_SQLServer.GetViews db.Name, db, True
  End If
  
  For Each vw In db.Views
    If vw.VwType = csVwUser Then
      vItems(1) = "Usuario"
    Else
      vItems(1) = "Sistema"
    End If
    vItems(2) = vw.CreateDate
    
    Set LItem = AddToListView(lv, vw.Name, vw.Name, vItems(), c_img_vw)
    LItem.Tag = SetInfoString_(LItem.Tag, c_k_vw, 1)
  Next
End Sub

Private Sub ShowLogs(ByRef Node As Node)
  Dim vItems(2) As String
  Dim nLog As Integer
  Dim Logs As Collection
  Dim iLog As cLogInfo
  
  lv.ColumnHeaders.Clear
  AddHeaderToListView lv, "Fecha", 2500
  AddHeaderToListView lv, "Fuente", 1200
  AddHeaderToListView lv, "Detalle", 6000
  
  nLog = Val(GetInfoString_(Node.Tag, c_k_log, 0)) - 1
  If nLog >= 0 Then
    Set Logs = m_SQLServer.GetLogInfo(nLog)
  End If
  
  For Each iLog In Logs
    vItems(1) = iLog.Source
    vItems(2) = iLog.Message
    AddToListView lv, iLog.Occurs, "", vItems(), c_img_log
  Next
End Sub

Private Sub ShowLocks(ByVal PerObject As Boolean)
  Dim vItems(5) As String
  Dim Locks As Collection
  Dim lk As cLock
  Dim img As Integer
  
  lv.ColumnHeaders.Clear
  AddHeaderToListView lv, "Spid", 1000
  AddHeaderToListView lv, "Estado", 2200
  AddHeaderToListView lv, "Data base", 1400
  AddHeaderToListView lv, "Tipo", 1400
  AddHeaderToListView lv, "Tabla", 1400
  AddHeaderToListView lv, "Indice", 1200
  
  Set Locks = m_SQLServer.GetLocks()
  
  For Each lk In Locks
    With lk
      Select Case .Status
        Case 1
          vItems(1) = "Granted"
        Case 2
          vItems(1) = "Converting"
        Case 3
          vItems(1) = "Waiting"
      End Select
      vItems(2) = .dbName
      vItems(3) = .LockType
      vItems(4) = .TableName
      vItems(5) = .IndexName
    End With
    
    If PerObject Then
      img = c_img_locko
    Else
      img = c_img_lockp
    End If
    
    AddToListView lv, lk.ReqSpid, "", vItems(), img
  Next
End Sub

Private Sub ShowProcess()
  Dim vItems(9) As String
  Dim Process As Collection
  Dim Pr As cProcess
  Dim img As Integer
  
  lv.ColumnHeaders.Clear
  AddHeaderToListView lv, "Spid", 1000
  AddHeaderToListView lv, "Estado", 2200
  AddHeaderToListView lv, "Comando", 2400
  AddHeaderToListView lv, "Cpu", 1000
  AddHeaderToListView lv, "Data base", 1400
  AddHeaderToListView lv, "Server", 1400
  AddHeaderToListView lv, "Login", 1400
  AddHeaderToListView lv, "Memoria", 1200
  AddHeaderToListView lv, "Aplicación", 1400
  AddHeaderToListView lv, "Bloqueado", 1600
  
  Set Process = m_SQLServer.GetCurrentActivity()
  
  For Each Pr In Process
    With Pr
      vItems(1) = .Status
      vItems(2) = .Cmd
      vItems(3) = .Cpu
      vItems(4) = .dbName
      vItems(5) = .HostName
      vItems(6) = .Loginname
      vItems(7) = .Memusage
      vItems(8) = .ProgramName
      vItems(9) = .Blocked
    End With
    
    Select Case Trim(Pr.Status)
      Case "background"
        img = c_img_background
      Case "runnable"
        img = c_img_runable
      Case Else
        img = c_img_sleeping
    End Select
    
    AddToListView lv, Pr.Spid, "", vItems(), img
  Next
End Sub

Private Function IsTable(ByVal Tag As String) As Boolean
  IsTable = Val(GetInfoString_(Tag, c_k_tbl, 0))
End Function

Private Function IsSp(ByVal Tag As String) As Boolean
  IsSp = Val(GetInfoString_(Tag, c_k_sp, 0))
End Function

Private Function IsView(ByVal Tag As String) As Boolean
  IsView = Val(GetInfoString_(Tag, c_k_vw, 0))
End Function

Private Function IsJob(ByVal Tag As String) As Boolean
  IsJob = Val(GetInfoString_(Tag, c_k_jobs, 0))
End Function

Private Function IsJobFolder(ByVal Tag As String) As Boolean
  IsJobFolder = Val(GetInfoString_(Tag, c_k_jobsf, 0))
End Function

Private Function IsServer(ByVal Tag As String) As Boolean
  IsServer = Val(GetInfoString_(Tag, c_k_server, 0))
End Function

Private Function IsLoaded(ByVal Tag As String) As Boolean
  IsLoaded = Val(GetInfoString_(Tag, c_k_loaded, 0))
End Function

Private Function IsTrigger(ByVal Tag As String) As Boolean
  IsTrigger = Val(GetInfoString_(Tag, c_k_trg, 0))
End Function

Private Sub loadTriggersAux(ByRef Node As Node, ByVal Refresh As Boolean)
  On Error GoTo ControlError
  
  ' Esto es por que entro demas
  If Not IsLoaded(Node.Tag) Or Refresh Then
    
    InitProgressBar
    
    If LoadTriggers(Node) Then Node.Tag = SetLoaded(Node.Tag)
  End If
  
  lv.ColumnHeaders.Clear
  lv.ListItems.Clear
  AddHeaderToListView lv, "Nombre", 3000
  AddHeaderToListView lv, "Tabla", 1200
  
  Dim tb As cTable
  Dim tg As cTrigger
  Dim v(1) As String
  Dim li As ListItem
  Dim db As String
  
  db = GetDataBaseName(Node.Tag)
  
  For Each tb In m_DataBases(db).Tables
    v(1) = tb.Name
    For Each tg In tb.Triggers
      Set li = AddToListView(lv, tg.Name, tg.Name, v(), c_img_trigger)
      li.Tag = SetInfoString_(li.Tag, c_k_trg, 1)
    Next
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDataBaseAux", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  HideProgressBar
  sbMsg ""
End Sub

Private Sub LoadDataBaseAux(ByRef Node As Node)
  On Error GoTo ControlError
  
  ' Esto es por que entro demas
  If IsDatabaseFolder(Node.Tag) Then Exit Sub
  If Not IsLoaded(Node.Tag) Then
    
    InitProgressBar
    
    If LoadDataBase(Node) Then Node.Tag = SetLoaded(Node.Tag)
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDataBaseAux", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  HideProgressBar
  sbMsg ""
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  Static done As Boolean
  
  If done Then Exit Sub
  done = True
  
  DoEvents: DoEvents: DoEvents
  Form_Resize
  DoEvents: DoEvents: DoEvents
  SizeControls
  
  mnuFileOpenConection_Click
End Sub

Private Sub ShowObjects(ByVal Tag As String, ByRef Node As Node, ByVal Refresh As Boolean)
  If IsServer(Tag) Then
    ShowServer Refresh
  ElseIf IsDatabase(Tag) Then
    ShowDb Refresh
  ElseIf IsJobFolder(Tag) Then
    ShowJobs Refresh
  ElseIf IsTable(Tag) Then
    ShowTables m_DataBases.Item(Node.Parent.Text), Refresh
  ElseIf IsSp(Tag) Then
    ShowSps m_DataBases.Item(Node.Parent.Text), Refresh
  ElseIf IsView(Tag) Then
    ShowViews m_DataBases.Item(Node.Parent.Text), Refresh
  ElseIf IsTriggers(Tag) Then
    loadTriggersAux Node, Refresh
  ElseIf IsLog(Tag) Then
    ShowLogs Node
  ElseIf IsProcess(Tag) Then
    ShowProcess
  ElseIf IsLocksPerObj(Tag) Then
    ShowLocks True
  ElseIf IsLocksPerId(Tag) Then
    ShowLocks False
  End If
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error GoTo ControlError
  
  If KeyCode = vbKeyF5 Then
    If ActiveControl Is lv Then
      If lv.SelectedItem Is Nothing Then Exit Sub
      With lv.SelectedItem
        ShowObjects .Tag, tv.SelectedItem, True
      End With
    ElseIf ActiveControl Is tv Then
      LoadSQLObjects
    End If
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_KeyDown", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  If KeyAscii = vbKeyEscape Then
    m_bCancel = Ask("¿Confirma que desea cancelar el proceso?")
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lv_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  On Error GoTo ControlError

  Dim i As Integer
  
  For i = 1 To lv.ColumnHeaders.Count
    lv.ColumnHeaders(i).Icon = 0
  Next
  
  lv.SortKey = ColumnHeader.Index - 1
  If lv.SortOrder = lvwAscending Then
    lv.SortOrder = lvwDescending
    ColumnHeader.Icon = c_img_down
  Else
    lv.SortOrder = lvwAscending
    ColumnHeader.Icon = c_img_up
    ColumnHeader.Alignment = lvwColumnLeft
  End If
  lv.Sorted = True

  GoTo ExitProc
ControlError:
  MngError Err, "lv_ColumnClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lv_DblClick()
  On Error GoTo ControlError
  
  With lv.SelectedItem
  
    If IsTable(.Tag) Then
      popTblOpen_Click
    ElseIf IsSp(.Tag) Then
      popSpEdit_Click
    ElseIf IsView(.Tag) Then
      popViewOpen_Click
    ElseIf IsJob(.Tag) Then
      popTaskEdit_Click
    End If
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "lv_DblClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lv_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  If Button = vbRightButton Then
    ShowPopMenu
  End If
End Sub

Private Sub m_SQLServer_Msg(ByVal msg As String)
  sbMsg msg
End Sub

Private Sub m_SQLServer_ShowProgress(ByVal Percent As Single)
  ShowProgress Percent
End Sub

Private Sub m_SQLServer_ShowProgress2(ByVal Percent As Single, ByVal msg As String, Cancel As Boolean)
  If msg <> "" Then sbMsg msg
  Cancel = m_bCancel
End Sub

Private Sub ShowPopMenu()
  If Me.ActiveControl Is tv Then
    If tv.SelectedItem Is Nothing Then Exit Sub
    
    With tv.SelectedItem
      If IsServer(.Tag) Then
        ShowPopMenuAux popServer, False
      ElseIf IsDatabaseFolder(.Tag) Then
        ShowPopMenuAux popDb, True
      ElseIf IsDatabase(.Tag) Then
        ShowPopMenuAux popDb
      ElseIf IsTable(.Tag) Then
        ShowPopMenuAux popTbl, True
      ElseIf IsSp(.Tag) Then
        ShowPopMenuAux popSp, True
      ElseIf IsView(.Tag) Then
        ShowPopMenuAux popView, True
      ElseIf IsJobFolder(.Tag) Then
        ShowPopMenuAux popTask, True
      ElseIf IsTrigger(.Tag) Then
        ShowPopMenuAux popTrigger, True
      End If
    End With
    
  ElseIf Me.ActiveControl Is lv Then
    If lv.SelectedItem Is Nothing Then Exit Sub
    With lv.SelectedItem
    
      If IsTable(.Tag) Then
        ShowPopMenuAux popTbl
      ElseIf IsSp(.Tag) Then
        ShowPopMenuAux popSp
      ElseIf IsView(.Tag) Then
        ShowPopMenuAux popView
      ElseIf IsJob(.Tag) Then
        ShowPopMenuAux popTask
      ElseIf IsTrigger(.Tag) Then
        ShowPopMenuAux popTrigger
      End If
    End With
  End If
End Sub

Private Sub ShowPopMenuAux(ByRef Pop As Menu, Optional ByVal OnlyNew As Boolean)
  If Pop Is popTbl Then
    popTblSep.Visible = Not OnlyNew
    popTblEdit.Visible = Not OnlyNew
    popTblOpen.Visible = Not OnlyNew
  ElseIf Pop Is popDb Then
    popDbSep1.Visible = Not OnlyNew
    popDbSep2.Visible = Not OnlyNew
    popDbSep3.Visible = Not OnlyNew
    popDbDelete.Visible = Not OnlyNew
    popDbBackup.Visible = Not OnlyNew
    popDbRestore.Visible = Not OnlyNew
    popDbScript.Visible = Not OnlyNew
  ElseIf Pop Is popView Then
    popViewSep.Visible = Not OnlyNew
    popViewEdit.Visible = Not OnlyNew
    popViewOpen.Visible = Not OnlyNew
  ElseIf Pop Is popSp Then
    popSpSep.Visible = Not OnlyNew
    popSpEdit.Visible = Not OnlyNew
  ElseIf Pop Is popTask Then
    popTaskSep1.Visible = Not OnlyNew
    popTaskEdit.Visible = Not OnlyNew
    popTaskDelete.Visible = Not OnlyNew
  ElseIf Pop Is popTrigger Then
    popTriggerDelete.Visible = Not OnlyNew
    popTriggerEdit.Visible = Not OnlyNew
    popTriggerSep.Visible = Not OnlyNew
  End If
  
  PopupMenu Pop
End Sub

Private Sub mnuToolNewDatabaseFromScript_Click()
  On Error GoTo ControlError
  
  Dim dbName As String
  Dim f As fNewDatabaseFromScript
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  Set f = New fNewDatabaseFromScript
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc
  
  If Not m_SQLServer.CreateDataBaseWithWizard(dbName, f.txFiledb.Text, , f.txFile.Text, True) Then GoTo ExitProc
    
  LoadSQLObjects
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsNewScriptDataBase_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
  Set f = Nothing
End Sub

Private Sub mnuToolsDBCompare_Click()
  On Error GoTo ControlError
  
  Dim dbcompare As cDBCompare
  Set dbcompare = New cDBCompare
  
  dbcompare.Show
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsDBCompare_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuToolsNewScriptBatch_Click()
  On Error GoTo ControlError
  
  Dim File As String
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  File = "def_script." & csStrDefScriptBatchExt
  If Not GetFile(cd, File, c_str_defCommand) Then Exit Sub
  m_SQLServer.EditDefScriptIni File

  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsNewScriptBatch_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuToolsNewScriptDataBase_Click()
  On Error GoTo ControlError
  
  Dim dbName As String
  Dim File As String
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  File = "script1." & csStrDefDataBaseExt
  If Not GetFile(cd, File, c_str_defDb) Then Exit Sub
  
  If Not m_SQLServer.CreateDataBaseWithWizard(dbName, File, , , True) Then Exit Sub
    
  LoadSQLObjects
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsNewScriptDataBase_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuToolsRestore_Click()
  On Error GoTo ControlError

  Dim db As String
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait

  If ActiveControl Is tv Then
    If IsDatabase(tv.SelectedItem.Tag) Then
      db = tv.SelectedItem.Text
    End If
  End If

  Dim File As String
  
  File = FileGetValidPath(m_SQLServer.Conn.Server.Registry.SQLDataRoot) & "Backup\" & db & ".bak"
  
  m_SQLServer.ShowRestore db, False, False, File
  
  pReconnect
  
  LoadSQLObjects
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsRestore_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popToolsRunScriptFile_Click()
  pRunScriptFile
End Sub

Private Sub popDbBackup_Click()
  mnuToolsBackup_Click
End Sub

Private Sub popDbDelete_Click()
  On Error GoTo ControlError
  
  Dim db As String
  
  If ActiveControl Is tv Then
    If IsDatabase(tv.SelectedItem.Tag) Then
      db = tv.SelectedItem.Text
    End If
  End If
  
  If Ask("¿Confirma que desea borrar la base de datos " & db & "?.;;TODA LA INFORMACION QUE CONTIENE SERA ELIMINADA") Then
    If m_SQLServer.DeleteDataBase(db) Then
      RemoveDbFromTree db
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "popDbDelete_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popDbNewDB_Click()
  mnuToolsNewDataBase_Click
End Sub

Private Sub popDbRestore_Click()
  mnuToolsRestore_Click
End Sub

Private Sub popDbScript_Click()
  Dim dbName As String
  dbName = GetDBName
  If dbName = "" Then
    info "Debe seleccionar una base de datos"
    Exit Sub
  End If
  m_SQLServer.GenerateScript dbName
End Sub

Private Sub popServerProperties_Click()
  On Error GoTo ControlError
  
  m_SQLServer.ShowProperties

  GoTo ExitProc
ControlError:
  MngError Err, "popServerProperties_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popServerStop_Click()
  On Error GoTo ControlError
  
  m_SQLServer.StopServer
  LoadSQLObjects
  
  GoTo ExitProc
ControlError:
  MngError Err, "popServerStop_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Sub

Private Sub popServerStopAndStart_Click()
  On Error GoTo ControlError
  
  m_SQLServer.StopAndStartServer

  GoTo ExitProc
ControlError:
  MngError Err, "popServerStopAndStart_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popSpCreateScript_Click()
  On Error GoTo ControlError
  
  Dim n      As Integer
  Dim i      As Integer
  Dim db     As String
  Dim sp     As String
  Dim File   As CSKernelFile.cFile
  Dim Script As String
  
  Set File = New CSKernelFile.cFile
  File.Init "popSpCreateScript", C_Module, Me.cd
  
  File.Filter = "SQL Files|*.sql"
  
  If Not File.FSave("sp.sql", False, True) Then Exit Sub
  If Not File.FOpen(File.FullName, csWrite, True, True, csLockWrite, False, False) Then Exit Sub
  
  db = GetDBName()
  
  Dim bEncrypt      As String
  Dim bEncryptFile  As String
  
  bEncrypt = Ask("¿Agregar with encrypt al codigo del sp?")
  bEncryptFile = Ask("¿Encriptar el archivo?")
  
  Dim signature As String
  #If PREPROC_CROWSOFT Then
    signature = c_LoginSignature
  #Else
    If Not GetInput(signature, "Indique la semilla de encriptacion") Then Exit Sub
  #End If
  
  Dim Encrypt As cEncrypt
  If bEncryptFile Then Set Encrypt = New cEncrypt
  
  For i = 1 To lv.ListItems.Count
    If lv.ListItems.Item(i).Selected Then
      sp = lv.ListItems.Item(i).Text
      Script = m_SQLServer.GetSpCode(db, sp, bEncrypt)
      
      If bEncryptFile Then
        Script = Encrypt.Encrypt(Script, signature)
      End If
      
      If Not File.FWrite(Script) Then Exit Sub
      n = n + 1
      sbMsg "Van: " & n
    End If
  Next
  
  MsgInfo "Proceso terminado con éxito"
  
  GoTo ExitProc
ControlError:
  MngError Err, "popSpCreateScript_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popSpCreateScript2_Click()
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  Dim base As String
  
  If Not GetInput(base, "Ingrese el nombre de la base") Then Exit Sub
  
  sqlstmt = "sp_sqlcomparesp " & base
  
  Dim db As cDataSource
  Set db = New cDataSource
  
  With m_SQLServer.Conn.Server
  
    If Not db.OpenConnection(.Name, GetDBName(), .Login, .Password, .LoginSecure) Then Exit Sub
  
  End With
  
  If Not db.OpenRs(rs, sqlstmt) Then Exit Sub
  
  If rs.EOF Then
    MsgInfo "No se encontraron SPs"
    Exit Sub
  End If
  
  Dim i As Long
  
  For i = 1 To lv.ListItems.Count
  
    lv.ListItems.Item(i).Selected = False

  Next
  
  While Not rs.EOF
  
    For i = 1 To lv.ListItems.Count
    
      If LCase$(lv.ListItems.Item(i).Text) = LCase$(rs.Fields(0).Value) Then
    
        lv.ListItems.Item(i).Selected = True
        Exit For
      End If
    Next
  
    rs.MoveNext
  Wend
  
  MsgInfo "Los sp han sido seleccionados"
End Sub

Private Sub popSpDelete_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim sp As String
  
  If Not AskDelete(" el stored procedure ") Then Exit Sub
  
  If Not GetDbAndObj(db, sp) Then Exit Sub
  If Not m_SQLServer.DeleteTable(db, sp) Then Exit Sub
  
  m_SQLServer.GetSps db, m_DataBases
  
  If tv.SelectedItem Is Nothing Then Exit Sub
  
  If IsSp(tv.SelectedItem.Tag) Then
    ShowSps m_DataBases(db), False
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "popSpDelete_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popSpEdit_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim sp As String
  
  If Not GetDbAndObj(db, sp) Then Exit Sub
  
  m_SQLServer.EditSp db, sp

  GoTo ExitProc
ControlError:
  MngError Err, "popSpEdit_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popSpNew_Click()
  On Error GoTo ControlError

  Dim Script As String
  Dim File As String
  
  File = FileGetValidPath(App.Path) & c_path_template & c_path_template_sp & "Create Procedure Basic Template.tql"
  
  If Not FileReadFullFile(File, Script, False, cd) Then Exit Sub

  m_SQLServer.EditScript GetDBName(), Script

  GoTo ExitProc
ControlError:
  MngError Err, "popSpNew_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTblDelete_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim tb As String
  
  If Not AskDelete(" la tabla ") Then Exit Sub
  
  If Not GetDbAndObj(db, tb) Then Exit Sub
  If Not m_SQLServer.DeleteTable(db, tb) Then Exit Sub
  
  m_SQLServer.GetTables db, m_DataBases
  
  If tv.SelectedItem Is Nothing Then Exit Sub
  
  If IsTable(tv.SelectedItem.Tag) Then
    ShowTables m_DataBases(db), False
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "popTblDelete_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTblEdit_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim tb As String
  
  If Not GetDbAndObj(db, tb) Then Exit Sub
  
  m_SQLServer.EditTable db, tb

  GoTo ExitProc
ControlError:
  MngError Err, "popTblEdit_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTblImportExcel_Click()
  On Error GoTo ControlError

  Dim db As String
  
  db = GetDBName

  If db = "" Then Exit Sub

  If Not m_SQLServer.ImportExcel(db) Then Exit Sub

  info "Importación terminada con éxito"

  ' TODO: Reload de tablas

  GoTo ExitProc
ControlError:
  MngError Err, "popTblImportExcel_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTblNew_Click()
  On Error GoTo ControlError

  Dim Script As String
  Dim File As String
  
  File = FileGetValidPath(App.Path) & c_path_template & c_path_template_tbl & "Create Table Basic Template.tql"
  
  If Not FileReadFullFile(File, Script, False, cd) Then Exit Sub

  m_SQLServer.EditScript GetDBName(), Script

  GoTo ExitProc
ControlError:
  MngError Err, "popTblNew_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTriggerDelete_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim tg As String
  
  If Not AskDelete(" el trigger ") Then Exit Sub
  
  If Not GetDbAndObj(db, tg) Then Exit Sub
  If Not m_SQLServer.DeleteTrigger(db, lv.SelectedItem.SubItems(1), tg) Then Exit Sub
  
  If tv.SelectedItem Is Nothing Then Exit Sub
  
  If IsTriggers(tv.SelectedItem.Tag) Then
    tv.SelectedItem.Tag = SetUnLoaded(tv.SelectedItem.Tag)
    loadTriggersAux tv.SelectedItem, False
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "popTriggerDelete_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function AskDelete(ByVal Who As String) As Boolean
  Dim msg As String
  If lv.SelectedItem Is Nothing Then Exit Function
  msg = "¿Confirma que desea eliminar" & Who & lv.SelectedItem.Text & "?"
  
  AskDelete = Ask(msg)
End Function

Private Sub popTriggerEdit_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim tg As String
  
  If Not GetDbAndObj(db, tg) Then Exit Sub
  m_SQLServer.EditTrigger db, lv.SelectedItem.SubItems(1), tg

  GoTo ExitProc
ControlError:
  MngError Err, "popTriggerEdit_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTriggerNew_Click()
  On Error GoTo ControlError

  Dim Script As String
  Dim File As String
  
  File = FileGetValidPath(App.Path) & c_path_template & c_path_template_tr & "Create Trigger Basic Template.tql"
  
  If Not FileReadFullFile(File, Script, False, cd) Then Exit Sub

  m_SQLServer.EditScript GetDBName(), Script
  
  GoTo ExitProc
ControlError:
  MngError Err, "popTriggerNew_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popViewDelete_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim vw As String
  
  If Not AskDelete(" la vista ") Then Exit Sub
  
  If Not GetDbAndObj(db, vw) Then Exit Sub
  If Not m_SQLServer.DeleteView(db, vw) Then Exit Sub
  
  m_SQLServer.GetViews db, m_DataBases, True

  If tv.SelectedItem Is Nothing Then Exit Sub
  
  If IsView(tv.SelectedItem.Tag) Then
    ShowViews m_DataBases(db), False
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "popViewDelete_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popViewEdit_Click()
  On Error GoTo ControlError
  Dim db As String
  Dim vw As String
  
  If Not GetDbAndObj(db, vw) Then Exit Sub
  
  m_SQLServer.EditView db, vw

  GoTo ExitProc
ControlError:
  MngError Err, "popViewEdit_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTaskDelete_Click()
  On Error GoTo ControlError

  If lv.SelectedItem Is Nothing Then Exit Sub

  If Not Ask("Confirma que desea borrar la tarea " & lv.SelectedItem.Text) Then Exit Sub

  m_SQLServer.DeleteTask lv.SelectedItem.Text
  ShowJobs True
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsRestore_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTaskEdit_Click()
  On Error GoTo ControlError

  If lv.SelectedItem Is Nothing Then Exit Sub

  m_SQLServer.EditTask lv.SelectedItem.Text
  ShowJobs True
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsRestore_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTaskNewTask_Click()
  On Error GoTo ControlError

  If Not m_SQLServer.CreateTask() Then Exit Sub
  Set m_Jobs = m_SQLServer.ListTasks()
  ShowJobs True
  
  GoTo ExitProc
ControlError:
  MngError Err, "popTaskNewTask_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popTblOpen_Click()
  On Error GoTo ControlError
  
  Dim db As String
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  If lv.SelectedItem Is Nothing Then Exit Sub
  
  Dim f As New fEditTbl
  
  f.Table = lv.SelectedItem.Text
  
  With m_SQLServer.Conn.Server
    f.Server = .Name
    f.User = .Login
    f.UseNTSecurity = .LoginSecure
    f.Password = .Password
  End With
  
  With tv.SelectedItem
    If IsDatabase(.Tag) Then
      db = .Text
    Else
      db = .Parent.Text
    End If
  End With
  
  f.Database = db
  
  f.Show
  
  GoTo ExitProc
ControlError:
  MngError Err, "popTblOpen_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popViewNew_Click()
  On Error GoTo ControlError

  Dim Script As String
  Dim File As String
  
  File = FileGetValidPath(App.Path) & c_path_template & c_path_template_vw & "Create View Basic Template.tql"
  
  If Not FileReadFullFile(File, Script, False, cd) Then Exit Sub

  m_SQLServer.EditScript GetDBName(), Script
  
  GoTo ExitProc
ControlError:
  MngError Err, "popViewNew_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub popViewOpen_Click()
  popTblOpen_Click
End Sub

Private Sub tbTools_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error GoTo ControlError
  
  Select Case Button.key
    Case c_ktlb_open_cn
      mnuFileOpenConection_Click
    Case c_ktlb_edit_script
      mnuToolsEditSQL_Click
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "tbTools_ButtonClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tv_Expand(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError
  
  If IsDatabase(Node.Tag) Then LoadDataBaseAux Node
  
  GoTo ExitProc
ControlError:
  MngError Err, "tv_NodeClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tv_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error GoTo ControlError

  If Button = vbRightButton Then
    ShowPopMenu
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "tv_MouseUp", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tv_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError
  
  If m_OldNode = Node.Index Then Exit Sub
  
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  m_OldNode = Node.Index
  
  lv.ListItems.Clear
  lv.ColumnHeaders.Clear
  
  ShowObjects Node.Tag, Node, False
  
  GoTo ExitProc
ControlError:
  MngError Err, "tv_NodeClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'-------------------------------------------------
' Login
'-------------------------------------------------
Private Sub m_Login_Connect(Cancel As Boolean)
  sbMsg "Conectando ..."
  Cancel = Not m_SQLServer.OpenConnection(m_Login.cbServer.Text, m_Login.txUser.Text, m_Login.txPassword.Text, m_Login.opNt.Value)
  If Not Cancel Then
    With m_SQLServer.Conn
      Me.Caption = "SQLAdmin - Server [" & .ServerName & "] - User [" & .UserName & "]"
    End With
  End If
  sbMsg ""
End Sub

'-------------------------------------------------
' Menus
'-------------------------------------------------
Private Sub mnuFileExit_Click()
  On Error GoTo ControlError

  Unload Me
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuFileExit_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuFileOpenConection_Click()
  On Error GoTo ControlError

  Dim f As fLogin
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  Set f = New fLogin
  
  Set m_Login = f
  
  f.Show vbModal
  
  
  If f.Ok Then
    LoadSQLObjects
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "mnuFileOpenConection_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
  Set m_Login = Nothing
  sbMsg ""
End Sub

Private Sub mnuHelpAbout_Click()
  On Error GoTo ControlError
  
  fAbout.Show

  GoTo ExitProc
ControlError:
  MngError Err, "mnuHelpAbout_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuToolsBackup_Click()
  On Error GoTo ControlError

  Dim db As String
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait

  If ActiveControl Is tv Then
    If IsDatabase(tv.SelectedItem.Tag) Then
      db = tv.SelectedItem.Text
    End If
  End If
  
  Dim File As String
  
  File = FileGetValidPath(m_SQLServer.Conn.Server.Registry.SQLDataRoot) & "Backup\" & db & ".bak"

  m_SQLServer.ShowBackup db, False, File
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsBackup_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function IsDatabaseFolder(ByVal Tag As String) As Boolean
  IsDatabaseFolder = Val(GetInfoString_(Tag, c_k_dbf, 0))
End Function

Private Function IsLocksPerObj(ByVal Tag As String) As Boolean
  IsLocksPerObj = Val(GetInfoString_(Tag, c_k_locko, 0))
End Function

Private Function IsLocksPerId(ByVal Tag As String) As Boolean
  IsLocksPerId = Val(GetInfoString_(Tag, c_k_lockp, 0))
End Function

Private Function IsProcess(ByVal Tag As String) As Boolean
  IsProcess = Val(GetInfoString_(Tag, c_k_process, 0))
End Function

Private Function IsLog(ByVal Tag As String) As Boolean
  IsLog = Val(GetInfoString_(Tag, c_k_log, 0))
End Function

Private Function IsTriggers(ByVal Tag As String) As Boolean
  IsTriggers = Val(GetInfoString_(Tag, c_k_trg, 0))
End Function

Private Function IsDatabase(ByVal Tag As String) As Boolean
  IsDatabase = Val(GetInfoString_(Tag, c_k_db, 0))
End Function

Private Sub mnuToolsEditSQL_Click()
  On Error GoTo ControlError
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait

  m_SQLServer.EditScript
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsEditSQL_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuToolsNewDataBase_Click()
  On Error GoTo ControlError
  
  Dim dbName As String
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
  
  If Not m_SQLServer.CreateDataBaseWithWizard(dbName) Then Exit Sub
    
  LoadSQLObjects
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuToolsNewDataBase_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'-------------------------------------------------
' Objetos
'-------------------------------------------------
Private Sub CreateObjects()
  On Error GoTo ControlError
  
  Set m_SQLServer = New cSQLServer
  Set m_DataBases = New Collection
  
  GoTo ExitProc
ControlError:
  MngError Err, "CreateObjects", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub DestroyObjects()
  On Error GoTo ControlError
  
  Set m_SQLServer = Nothing
  Set m_Jobs = Nothing
  Set m_DataBases = Nothing
  Set m_Login = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "DestroyObjects", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'---------------------------------------------------------------------------------------------------------
' Progreso y Mensajes en StatusBar
'---------------------------------------------------------------------------------------------------------

Private Sub ShowProgress(ByVal Percent As Single)
  UpdateStatus picProgress, Percent
End Sub

Private Sub sbMsg(ByVal msg As String)
  On Error Resume Next
  sbEdit.Panels(c_panel_message).Text = msg
End Sub

'-------------------------------------------------
' Resizing and splitter
'-------------------------------------------------
Private Sub Form_Resize()
  On Error Resume Next
  SizeControls
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

Private Sub FormatStatusBar()
  Dim Panel As Panel
  sbEdit.Panels.Clear
  Set Panel = sbEdit.Panels.Add(, c_panel_message)
  Panel.Style = sbrText
  Panel.AutoSize = sbrSpring
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

Private Sub picSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
  With picSplitter
    picBar.Move .Left, .Top, .Width \ 2, .Height - 20
  End With
  picBar.Visible = True
  m_moving = True
End Sub

Private Sub picSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
  Dim sglPos As Single
  
  If m_moving Then
    sglPos = x + picSplitter.Left
    If sglPos < sglSplitLimit Then
      picBar.Left = sglSplitLimit
    ElseIf sglPos > Width - sglSplitLimit Then
      picBar.Left = Width - sglSplitLimit
    Else
      picBar.Left = sglPos
    End If
  End If
End Sub

Private Sub picSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  SizeControls
  picBar.Visible = False
  m_moving = False
End Sub
  
Private Sub SizeControls()
  Dim i As Integer
  Dim offTop      As Integer
  Dim offBottom   As Integer
  Dim iHeigth     As Integer
  
  On Error GoTo ControlError
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  If WindowState = vbMinimized Then Exit Sub
  
  If picBar.Left > ScaleWidth Then
    picBar.Left = ScaleWidth - 50
  End If
  
  offTop = picTlb.Height
  offBottom = sbEdit.Height
  If picProgress.Visible Then
    offBottom = offBottom + picProgress.Height
  End If
  
  iHeigth = ScaleHeight - offTop - offBottom
  
  picSplitter.Left = picBar.Left
  picSplitter.Height = iHeigth
  picSplitter.Top = offTop
  picBar.Height = iHeigth
  picBar.Top = offTop
  tv.Move 0, offTop, picSplitter.Left, iHeigth
  lv.Move picSplitter.Left + picSplitter.Width, offTop, ScaleWidth - picSplitter.Left + picSplitter.Width - 110, iHeigth
  
  tbTools.Left = 0
  tbTools.Width = picTlb.ScaleWidth
  
  Me.Refresh
  DoEvents
  
ControlError:
End Sub

Private Sub LoadSizeAndPos()
  Width = GetMainWindow(c_K_WMainWidth, Width)
  If Width < 2000 Then Width = 2000
  Height = GetMainWindow(c_K_WMainHeight, Height)
  If Height < 2000 Then Height = 2000
  WindowState = GetMainWindow(c_K_WMainState, WindowState)
  If WindowState = vbMinimized Then WindowState = FormWindowStateConstants.vbNormal
  Left = GetMainWindow(c_K_WMainLeft, Left)
  Top = GetMainWindow(c_K_WMainTop, Top)
  
  If Left - 2000 > Screen.Width Then Left = Screen.Width - 2000
  If Top - 2000 > Screen.Height Then Left = Screen.Height - 2000
  
  picBar.Left = GetMainWindow(c_K_WMainSplitter, picBar.Left)
  DoEvents
  SizeControls
End Sub

Private Sub SaveSizeAndPos()
  If WindowState = FormWindowStateConstants.vbNormal Then
    SaveMainWindow c_K_WMainWidth, Width
    SaveMainWindow c_K_WMainHeight, Height
    SaveMainWindow c_K_WMainLeft, Left
    SaveMainWindow c_K_WMainTop, Top
  End If
  SaveMainWindow c_K_WMainState, WindowState
  SaveMainWindow c_K_WMainSplitter, picBar.Left
End Sub

Private Sub LoadToolBar()
  tbTools.Style = tbrFlat
  tbTools.BorderStyle = ccNone
  tbTools.Appearance = ccFlat
  Set tbTools.ImageList = ilToolBar
  With tbTools.Buttons
    .Clear
    .Add , , , tbrSeparator
    .Add , c_ktlb_open_cn, , , c_img_tlb_open_cn
    .Add , c_ktlb_edit_script, , , c_img_tlb_edit
  End With
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  CSKernelClient2.AppName = APP_NAME
  
  LoadSizeAndPos
  picSplitter.ZOrder
  SizeControls
  HideProgressBar
  FormatStatusBar
  
  CreateObjects

  LoadToolBar
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  DestroyObjects
  SaveSizeAndPos
  CloseApp
 
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub CloseApp()
  Dim f As Form
  
  For Each f In Forms
    If Not f Is Me Then
      Unload f
    End If
  Next
End Sub

Private Sub pRunScriptFile()
  On Error GoTo ControlError

  Dim File   As CSKernelFile.cFile
  Dim db     As String

  Dim signature As String
  #If PREPROC_CROWSOFT Then
    signature = c_LoginSignature
  #Else
    If Not GetInput(signature, "Indique la semilla de encriptacion") Then Exit Sub
  #End If

  Set File = New CSKernelFile.cFile
  File.Init "popSpCreateScript", C_Module, Me.cd
  
  File.Filter = "SQL Files|*.sql"
  
  If Not File.FOpen("sp.sql", csRead, False, False, csShared, True, True) Then Exit Sub
  
  db = GetDBName()
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  Dim Script     As String
  
  m_bCancel = False
  
  While Not File.IsEOF
  
    DoEvents: DoEvents: DoEvents: DoEvents
  
    If Not File.FRead(Script, False) Then Exit Sub
    Script = Encrypt.Decrypt(Script, signature)
    pExecuteScript Script, db
    
    If m_bCancel Then
      MsgWarning "Proceso cancelado por el usuario"
      Exit Sub
    End If
  Wend
  
  MsgInfo "Proceso terminado con éxito"

  GoTo ExitProc
ControlError:
  MngError Err, "pRunScriptFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pExecuteScript(ByVal Script As String, ByVal dbName As String) As Boolean
  pExecuteScript = m_SQLServer.SQLScript.ExecuteBatchWithResultAndMessage(Script, dbName)
End Function

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
