VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fMain 
   Caption         =   "CrowSoft Update"
   ClientHeight    =   6165
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   8865
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6165
   ScaleWidth      =   8865
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame frFolder 
      Height          =   2445
      Left            =   1305
      TabIndex        =   12
      Top             =   900
      Width           =   7305
      Begin VB.TextBox txBackupFolder 
         Height          =   330
         Left            =   1890
         TabIndex        =   29
         Top             =   1800
         Width           =   4875
      End
      Begin VB.CommandButton cmdOpenBackupFolder 
         Caption         =   "..."
         Height          =   330
         Left            =   6795
         TabIndex        =   28
         Top             =   1800
         Width           =   330
      End
      Begin VB.CommandButton cmdOpenTempFolder 
         Caption         =   "..."
         Height          =   330
         Left            =   6795
         TabIndex        =   21
         Top             =   1305
         Width           =   330
      End
      Begin VB.CommandButton cmdOpenCsrFolder 
         Caption         =   "..."
         Height          =   330
         Left            =   6795
         TabIndex        =   20
         Top             =   810
         Width           =   330
      End
      Begin VB.CommandButton cmdOpenInstallFolder 
         Caption         =   "..."
         Height          =   330
         Left            =   6795
         TabIndex        =   19
         Top             =   270
         Width           =   330
      End
      Begin VB.TextBox txTempFolder 
         Height          =   330
         Left            =   1890
         TabIndex        =   18
         Top             =   1305
         Width           =   4875
      End
      Begin VB.TextBox txCsrFolder 
         Height          =   330
         Left            =   1890
         TabIndex        =   16
         Top             =   810
         Width           =   4875
      End
      Begin VB.TextBox txInstallFolder 
         Height          =   330
         Left            =   1890
         TabIndex        =   15
         Top             =   270
         Width           =   4875
      End
      Begin VB.Label Label4 
         Caption         =   "Carpeta de Backup: "
         Height          =   375
         Left            =   135
         TabIndex        =   30
         Top             =   1845
         Width           =   1995
      End
      Begin VB.Label Label3 
         Caption         =   "Carpeta de Temp: "
         Height          =   375
         Left            =   135
         TabIndex        =   17
         Top             =   1350
         Width           =   1995
      End
      Begin VB.Label Label2 
         Caption         =   "Carpeta de Reportes: "
         Height          =   375
         Left            =   135
         TabIndex        =   14
         Top             =   855
         Width           =   1995
      End
      Begin VB.Label Label1 
         Caption         =   "Carpeta de Instalación: "
         Height          =   375
         Left            =   135
         TabIndex        =   13
         Top             =   315
         Width           =   1995
      End
   End
   Begin VB.Frame frProgress 
      Height          =   4155
      Left            =   855
      TabIndex        =   22
      Top             =   360
      Width           =   7530
      Begin VB.PictureBox picProgress 
         Appearance      =   0  'Flat
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   3705
         Left            =   90
         ScaleHeight     =   3705
         ScaleWidth      =   7350
         TabIndex        =   23
         Top             =   180
         Width           =   7350
         Begin VB.PictureBox picStatus 
            AutoRedraw      =   -1  'True
            BackColor       =   &H00FFFFFF&
            BorderStyle     =   0  'None
            ClipControls    =   0   'False
            FillColor       =   &H0080C0FF&
            Height          =   330
            Left            =   105
            ScaleHeight     =   330
            ScaleWidth      =   7080
            TabIndex        =   25
            TabStop         =   0   'False
            Top             =   1305
            Width           =   7080
         End
         Begin VB.ListBox lsFiles 
            Appearance      =   0  'Flat
            BackColor       =   &H8000000F&
            Height          =   1785
            Left            =   45
            TabIndex        =   24
            Top             =   1845
            Width           =   7215
         End
         Begin VB.Label lbProcess 
            BackStyle       =   0  'Transparent
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
            Left            =   60
            TabIndex        =   27
            Top             =   420
            Width           =   7170
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
            Left            =   60
            TabIndex        =   26
            Top             =   90
            Width           =   2820
         End
         Begin VB.Shape Shape5 
            BorderColor     =   &H80000010&
            Height          =   435
            Left            =   45
            Top             =   1245
            Width           =   7200
         End
      End
   End
   Begin VB.PictureBox picTop 
      Align           =   1  'Align Top
      BackColor       =   &H8000000C&
      BorderStyle     =   0  'None
      Height          =   615
      Left            =   0
      ScaleHeight     =   615
      ScaleWidth      =   8865
      TabIndex        =   9
      TabStop         =   0   'False
      Top             =   0
      Width           =   8865
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
         ForeColor       =   &H00FFFFFF&
         Height          =   195
         Left            =   150
         TabIndex        =   10
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
      Top             =   3000
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
      TabIndex        =   7
      TabStop         =   0   'False
      Top             =   2400
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
      TabIndex        =   8
      TabStop         =   0   'False
      Top             =   2625
      Width           =   5115
   End
   Begin RichTextLib.RichTextBox rtxInfo 
      Height          =   840
      Left            =   225
      TabIndex        =   6
      Top             =   2625
      Width           =   3390
      _ExtentX        =   5980
      _ExtentY        =   1482
      _Version        =   393217
      Enabled         =   -1  'True
      TextRTF         =   $"fMain.frx":1042
   End
   Begin MSComctlLib.ListView lvInfo 
      Height          =   1965
      Left            =   225
      TabIndex        =   5
      Top             =   375
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
   Begin VB.PictureBox picBottom 
      Align           =   2  'Align Bottom
      BackColor       =   &H8000000C&
      BorderStyle     =   0  'None
      Height          =   690
      Left            =   0
      ScaleHeight     =   690
      ScaleWidth      =   8865
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   5235
      Width           =   8865
      Begin VB.CommandButton cmdUnMarkAll 
         Caption         =   "Desmarcar Todos"
         Height          =   315
         Left            =   1785
         TabIndex        =   32
         Top             =   225
         Visible         =   0   'False
         Width           =   1500
      End
      Begin VB.CommandButton cmdMarkAll 
         Caption         =   "Marcar Todos"
         Height          =   315
         Left            =   180
         TabIndex        =   31
         Top             =   225
         Visible         =   0   'False
         Width           =   1500
      End
      Begin VB.PictureBox picButtons 
         BackColor       =   &H8000000C&
         BorderStyle     =   0  'None
         Height          =   400
         Left            =   3750
         ScaleHeight     =   405
         ScaleWidth      =   3765
         TabIndex        =   1
         Top             =   225
         Width           =   3765
         Begin VB.CommandButton cmdCancel 
            Caption         =   "&Cancelar"
            Height          =   315
            Left            =   2550
            TabIndex        =   4
            Top             =   0
            Width           =   1140
         End
         Begin VB.CommandButton cmdBack 
            Caption         =   "< &Atras"
            Height          =   315
            Left            =   0
            TabIndex        =   3
            Top             =   0
            Width           =   1140
         End
         Begin VB.CommandButton cmdNext 
            Caption         =   "&Siguiente >"
            Height          =   315
            Left            =   1200
            TabIndex        =   2
            Top             =   0
            Width           =   1140
         End
      End
   End
   Begin MSComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   240
      Left            =   0
      TabIndex        =   11
      Top             =   5925
      Width           =   8865
      _ExtentX        =   15637
      _ExtentY        =   423
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Abrir..."
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Herramientas"
      Begin VB.Menu mnuViewConnections 
         Caption         =   "&Ver Clientes Conectados..."
      End
      Begin VB.Menu mnuToolsSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsConfig 
         Caption         =   "&Configuracion..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuHelpIndex 
         Caption         =   "&Indice..."
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&Acerca de CSUpdate..."
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
Private WithEvents m_Unzip     As cUnzip
Attribute m_Unzip.VB_VarHelpID = -1
Private WithEvents m_UnzipCSAI As cUnzip
Attribute m_UnzipCSAI.VB_VarHelpID = -1
Private WithEvents m_Client   As cTCPIPClient
Attribute m_Client.VB_VarHelpID = -1

Private m_BackupFileFolder As String
Private m_BackupDbFolder   As String

Private m_step As Integer

Private m_bHideSplitter As Boolean

Private m_vDataBases()  As t_Database
Private m_vInformes()   As t_Informe_lst

Private m_ConnectedTo   As String

Private m_bCancel       As Boolean

' eventos
' propiedadades publicas
Public Property Let ConnectedTo(ByVal rhs As String)
  m_ConnectedTo = rhs
  SetCaption ""
End Property

Public Property Get Client() As cTCPIPClient
   Set Client = m_Client
End Property

Public Property Set Client(ByRef rhs As cTCPIPClient)
   Set m_Client = rhs
End Property

Public Property Let iStep(ByVal rhs As Integer)
  m_step = rhs
End Property

Public Property Get iStep() As Integer
  iStep = m_step
End Property

Public Property Let Operation(ByVal rhs As String)
   sbrMain.Panels(c_sbrOperation).Text = rhs & "..."
End Property

' funciones publicas
Public Sub SetCaption(ByVal msg As String)
  Me.Caption = App.Title & " " & m_ConnectedTo & " - " & msg
End Sub

Public Function ShowMsgTop(ByVal msg As String, _
                           Optional ByVal bRed As Boolean)
  With fMain.lbTopTitle
    .Caption = msg
    If bRed Then
      .ForeColor = &H80FF&
    Else
      .ForeColor = vbWhite
    End If
  End With
End Function

Public Function NextStep() As Boolean
  SetStep m_step + 1
  If Not ShowStep(m_step) Then
    m_step = m_step - 1
  End If
  NextStep = True
End Function

Public Function PrevStep() As Boolean
  SetStep m_step - 1
  If Not ShowStep(m_step) Then
    m_step = m_step + 1
  End If
  PrevStep = True
End Function

Public Sub SetStep(ByVal iStep As Integer)
  
  If m_step < c_step_show_setup_info Then
    m_step = c_step_show_setup_info
  End If
  
  If m_step > c_step_show_databases Then
    m_step = c_step_show_databases
  End If
  
  m_step = iStep
End Sub

Public Function ShowStep(ByVal iStep As Integer) As Boolean
  On Error GoTo ControlError
  
  Dim mousew As cMouseWait
  Set mousew = New cMouseWait
  
  Select Case iStep
  
    Case c_step_init
  
      lvInfo.ListItems.Clear
      lvInfo.ColumnHeaders.Clear
      lvInfo.Sorted = False
      
      frFolder.Visible = False
      frProgress.Visible = False
      
      cmdBack.Enabled = False
      cmdNext.Enabled = False
      cmdCancel.Enabled = False
      cmdMarkAll.Visible = False
      cmdUnMarkAll.Visible = False
      
      pHideSplitter
  
    Case c_step_show_setup_info
    
      frFolder.Visible = False
      frProgress.Visible = False
    
      ShowSetupIni
      
      cmdBack.Enabled = False
      cmdNext.Enabled = True
      cmdCancel.Enabled = False
      cmdMarkAll.Visible = False
      cmdUnMarkAll.Visible = False
      
      pShowSplitter
    
    Case c_step_show_databases
      
      frFolder.Visible = False
      frProgress.Visible = False
    
      fMain.lbTopTitle.Caption = "Seleccione las bases que se actualizarán"
    
      Operation = "Cargando las bases"
      SetGrDataBases lvInfo
      ShowDataBases lvInfo, m_vDataBases

      cmdBack.Enabled = True
      cmdNext.Enabled = True
      cmdCancel.Enabled = False
      cmdMarkAll.Visible = True
      cmdUnMarkAll.Visible = True
      
      pHideSplitter
      
    Case c_step_backup_databases
      
      If Not pValidateDb() Then Exit Function
      
      fMain.lbTopTitle.Caption = "Seleccione las bases que deben resguardarse (Backup)"

      frFolder.Visible = False
      frProgress.Visible = False
    
      SetGrDataBases lvInfo
      ShowDataBases2 lvInfo, m_vDataBases

      cmdBack.Enabled = True
      cmdNext.Enabled = True
      cmdCancel.Enabled = False
      cmdMarkAll.Visible = True
      cmdUnMarkAll.Visible = True
      
      pHideSplitter
    
    Case c_step_show_folders
      
      fMain.lbTopTitle.Caption = "Indique las carpetas a utilizar por la actualización"
      
      frProgress.Visible = False
      frFolder.Visible = True
      frFolder.ZOrder
      
      cmdBack.Enabled = True
      cmdNext.Enabled = True
      cmdCancel.Enabled = False
      cmdMarkAll.Visible = False
      cmdUnMarkAll.Visible = False
      
    Case c_step_show_inf
            
      fMain.lbTopTitle.Caption = "Procesando el paquete de actualización"
            
      frProgress.Visible = False
      frFolder.Visible = False
      
      cmdBack.Enabled = True
      
      If pShowInf() Then
        If lvInfo.ListItems.Count Then
          fMain.lbTopTitle.Caption = "Seleccione los informes a actualizar"
          cmdNext.Enabled = True
        Else
          NextStep
        End If
      Else
        cmdNext.Enabled = False
      End If
      
      cmdCancel.Enabled = False
    
    Case c_step_unzip_files
    
      fMain.lbTopTitle.Caption = "Descompactando el paquete de actualización"
    
      frFolder.Visible = False
      frProgress.Visible = True
      frProgress.ZOrder
      
      cmdBack.Enabled = False
      cmdNext.Enabled = False
      cmdCancel.Enabled = True
      cmdMarkAll.Visible = False
      cmdUnMarkAll.Visible = False
      
      If pUnzipFiles() Then
    
        NextStep
    
      Else
        cmdBack.Enabled = True
        cmdNext.Enabled = False
        cmdCancel.Enabled = False
    
      End If
    
    Case c_step_backup_db
    
      fMain.lbTopTitle.Caption = "Resguardando las bases de datos"
    
      pSetBackupFileFolder
    
      If pBackupDB() Then
      
        NextStep
      
      Else
      
        SetStep c_step_show_folders
        ShowStep m_step
      
      End If
    
    Case c_step_copy_files
    
      fMain.lbTopTitle.Caption = "Copiando los archivos"
    
      frFolder.Visible = False
      frProgress.Visible = True
      frProgress.ZOrder
      
      If pCopyFiles() Then
        
        If pDeleteClienteIni() Then
        
          NextStep
        End If
        
      Else
      
        SetStep c_step_show_folders
        ShowStep m_step
      
      End If
      
    Case c_step_exec_scripts
    
      fMain.lbTopTitle.Caption = "Actualizando los scripts"
    
      frFolder.Visible = False
      frProgress.Visible = True
      frProgress.ZOrder
      
      If pExecuteScripts() Then
      
        NextStep
        
      Else
      
        SetStep c_step_show_folders
        ShowStep m_step
      
      End If
    
    Case c_step_update_inf
    
      fMain.lbTopTitle.Caption = "Actualizando los informes"
    
      frFolder.Visible = False
      frProgress.Visible = True
      frProgress.ZOrder
      
      If pUpdateInf() Then
      
        NextStep
        
      Else
      
        SetStep c_step_show_folders
        ShowStep m_step
      
      End If
    
    Case c_step_finish
    
      fMain.lbTopTitle.Caption = "Actualización completada"
    
      MsgInfo "La actualización se completo con exito"
      
      SetStep c_step_init
      ShowStep c_step_init
    
  End Select
  
  ShowStep = True

  GoTo ExitProc
ControlError:
  MngError Err, "ShowStep", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Operation = ""
End Function

' funciones privadas

Private Function pValidateDb() As Boolean
  If UBound(m_vDataBases) = 0 Then
    MsgWarning "Debe seleccionar al menos una base de datos"
    Exit Function
  End If
  pValidateDb = True
End Function

Private Sub cmdBack_Click()
  On Error GoTo ControlError
  
  PrevStep

  GoTo ExitProc
ControlError:
  MngError Err, "PrevStep", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdNext_Click()
  On Error GoTo ControlError
  
  NextStep

  GoTo ExitProc
ControlError:
  MngError Err, "NextStep", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  On Error GoTo ControlError
  
  pCancel

  GoTo ExitProc
ControlError:
  MngError Err, "pCancel", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOpenBackupFolder_Click()
  pGetFolder txBackupFolder
End Sub

Private Sub cmdOpenCsrFolder_Click()
  pGetFolder txCsrFolder
End Sub

Private Sub cmdOpenInstallFolder_Click()
  pGetFolder txInstallFolder
End Sub

Private Sub cmdOpenTempFolder_Click()
  pGetFolder txTempFolder
End Sub

Private Function pGetFolder(ByRef txCtrl As Control)
  On Error GoTo ControlError

  Dim fld As cFolder
  Dim sFld As String

  Set fld = New cFolder
  sFld = fld.SeleccionarDirectorio(Me)
  If sFld <> "" Then txCtrl.Text = sFld
  
ExitSuccess:
  Exit Function
ControlError:
  MngError Err, "pGetFolder", C_Module
  Resume ExitSuccess
End Function

Private Sub cmdMarkAll_Click()
  Dim Item As ListItem
  For Each Item In lvInfo.ListItems
    Item.Checked = True
    lvInfo_ItemCheck Item
  Next
End Sub

Private Sub cmdUnMarkAll_Click()
  Dim Item As ListItem
  For Each Item In lvInfo.ListItems
    Item.Checked = False
    lvInfo_ItemCheck Item
  Next
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError
  
  Dim Top As Single
  
  LoadForm Me, Me.name
  
  Top = picTop.Height + 10
  
  fMain.ShowMsgTop "Abra un archivo de Actualización para procesar ..."
  
  pInitForm

  picSplitter.Left = 0
  
  With lvInfo
    .View = lvwReport
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .HideSelection = False
    .Left = 0
    .Top = Top
  End With
  
  With frFolder
    .Top = Top
    .Left = 0
  End With
  
  With frProgress
    .Top = Top
    .Left = 0
  End With
  
  txTempFolder.Text = ValidPath(Environ$("TEMP")) & "CSA"
  txCsrFolder.Text = IniGet2(c_sec_csr, c_key_csrpath, "", ValidPath(App.Path) & c_cairo_ini)
  txInstallFolder.Text = App.Path
  txBackupFolder.Text = ValidPath(App.Path) & "Backup"
  
  rtxInfo.Left = 0
  picSplitterBar.Left = 0
  picSplitterBar.Top = (Me.ScaleHeight - Top - picBottom.Height) * 0.75
  
  Set m_Unzip = New cUnzip
  Set m_UnzipCSAI = New cUnzip
  
  ReDim m_vDataBases(0)
  ReDim m_vInformes(0)
  
  ShowStep c_step_init
  
  Exit Sub
ControlError:
  MngError Err, "Form_Load", C_Module
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim Height As Single
  
  DoEvents
  
  Height = Me.ScaleHeight _
           - picBottom.Height _
           - sbrMain.Height
  
  picSplitterBar.Width = Me.ScaleWidth
  shTop.Width = ScaleWidth - shTop.Left * 2
  
  picButtons.Left = Me.ScaleWidth - picButtons.Width
  
  lvInfo.Width = Me.ScaleWidth
  frFolder.Width = Me.ScaleWidth
  frProgress.Width = Me.ScaleWidth
  
  picProgress.Left = (Me.ScaleWidth - picProgress.Width) * 0.5
  
  If m_bHideSplitter Then
    
    Height = Me.ScaleHeight - picBottom.Height - sbrMain.Height
    
    lvInfo.Height = Height - lvInfo.Top
    frFolder.Height = Height - lvInfo.Top
    frProgress.Height = Height - lvInfo.Top
    picProgress.Top = (frProgress.Height - picProgress.Height) * 0.5
    
  Else
  
    lvInfo.Height = picSplitterBar.Top - lvInfo.Top
    rtxInfo.Width = Me.ScaleWidth
    rtxInfo.Height = Height - picSplitterBar.Top - picSplitterBar.Height
    rtxInfo.Top = picSplitterBar.Top + picSplitterBar.Height
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  UnloadForm Me, Me.name
  
  Set m_Unzip = Nothing
  Set m_UnzipCSAI = Nothing
  
  CloseApp
  
  Exit Sub
ControlError:
  MngError Err, "Form_Unload", C_Module
End Sub

Private Sub lvInfo_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
  If m_step = c_step_show_setup_info Then Exit Sub
  
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

Private Sub lvInfo_ItemCheck(ByVal Item As MSComctlLib.ListItem)
  On Error Resume Next
  
  Select Case m_step
    Case c_step_show_databases
      If Val(GetInfoString(Item.Tag, c_key_olderpkg)) Then
        Item.Checked = False
      Else
        LVSetDataBases lvInfo, m_vDataBases
      End If
    Case c_step_backup_databases
      m_vDataBases(Item.Index).bBackup = Item.Checked
    Case c_step_show_inf
      m_vInformes(Item.Index).selected = Item.Checked
  End Select
End Sub

Private Sub lvInfo_ItemClick(ByVal Item As MSComctlLib.ListItem)
  On Error Resume Next
  Select Case m_step
    Case c_step_show_setup_info
      ShowInfo Item
  End Select
End Sub

Private Sub mnuFileExit_Click()
  Unload Me
End Sub

Private Sub mnuFileOpen_Click()
  OpenCSAFile
End Sub

Private Sub mnuHelpAbout_Click()
  Load fSplash
  fSplash.IsSplash = False
  fSplash.Show vbModal
End Sub

Private Sub pCancel()
  If Ask("Confirma que desea cancelar", vbNo) Then
    m_bCancel = True
  End If
End Sub

Private Sub mnuToolsConfig_Click()
  EditConfig
End Sub

Private Sub mnuViewConnections_Click()
  fClients.Show
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

'------------------------------------------------------------
' UnZip Events
'
Private Sub m_Unzip_Cancel(ByVal msg As String, bCancel As Boolean)
   Debug.Print "Cancel:" & msg & "soso un hijo de puta"
End Sub

Private Sub m_UnzipCSAI_Cancel(ByVal msg As String, bCancel As Boolean)
   Debug.Print "Cancel:" & msg
End Sub

Private Sub m_UnzipCSAI_OverWritePrompt(ByVal sFIle As String, eResponse As EUZOverWriteResponse)

   Dim fO As New fOverwrite
   With fO
      .TheCaption = "Confirma que desea reemplazar la copia existente del archivo " & sFIle & "?"
      fO.Show vbModal, Me
      If fO.Response = vbYes Then
         If fO.ApplyToAll Then
            eResponse = euzOverwriteAllFiles
         Else
            eResponse = euzOverwriteThisFile
         End If
      ElseIf fO.Response = vbNo Then
         If fO.ApplyToAll Then
            eResponse = euzOverwriteNone
         Else
            eResponse = euzDoNotOverwrite
         End If
      Else
         ' Hmmm...
         eResponse = euzOverwriteNone
      End If
   End With
   
End Sub

Private Sub m_Unzip_OverWritePrompt(ByVal sFIle As String, eResponse As EUZOverWriteResponse)

   Dim fO As New fOverwrite
   With fO
      .TheCaption = "Confirma que desea reemplazar la copia existente del archivo " & sFIle & "?"
      fO.Show vbModal, Me
      If fO.Response = vbYes Then
         If fO.ApplyToAll Then
            eResponse = euzOverwriteAllFiles
         Else
            eResponse = euzOverwriteThisFile
         End If
      ElseIf fO.Response = vbNo Then
         If fO.ApplyToAll Then
            eResponse = euzOverwriteNone
         Else
            eResponse = euzDoNotOverwrite
         End If
      Else
         ' Hmmm...
         eResponse = euzOverwriteNone
      End If
   End With
   
End Sub

Private Sub m_Unzip_PasswordRequest(sPassword As String, bCancel As Boolean)
   Dim fP As New fPassword
   With fP
      .Show vbModal, Me
      If Not fP.Cancelled Then
         sPassword = fP.Password
      Else
         bCancel = True
      End If
   End With
End Sub

Private Sub m_UnzipCSAI_PasswordRequest(sPassword As String, bCancel As Boolean)
   Dim fP As New fPassword
   With fP
      .Show vbModal, Me
      If Not fP.Cancelled Then
         sPassword = fP.Password
      Else
         bCancel = True
      End If
   End With
End Sub

Private Sub m_Unzip_Progress(ByVal lCount As Long, ByVal msg As String)
   pAddMessage msg
End Sub

Private Sub m_UnzipCSAI_Progress(ByVal lCount As Long, ByVal msg As String)
   pAddMessage msg
End Sub

Private Sub pAddMessage(ByVal msg As String)

End Sub

Public Function OpenZipFile(ByVal FullFileName As String, _
                            Optional ByRef zip As cUnzip) As Boolean
   
   If zip Is Nothing Then Set zip = m_Unzip
   
   ' Get the file directory:
   zip.ZipFile = FullFileName
   zip.Directory
End Function

Public Sub UnSelectAllFile()
  Dim i As Integer
  For i = 1 To m_Unzip.FileCount
    m_Unzip.FileSelected(i) = False
  Next
End Sub

Public Function ExtractFile(ByVal File As String, _
                            ByVal FolderToExtract As String, _
                            Optional ByRef zip As cUnzip) As Boolean
  
  If zip Is Nothing Then Set zip = m_Unzip
  
  If File <> vbNullString Then
    If Not SelectFile(File, zip) Then
      Exit Function
    End If
  End If
  
  zip.OverwriteExisting = True
  zip.UnzipFolder = FolderToExtract
  
  ExtractFile = zip.Unzip()
End Function

Public Sub UnSelectAll(ByRef zip As cUnzip)
  pSelectAll False, zip
End Sub

Public Sub SelectAll(ByRef zip As cUnzip)
  pSelectAll True, zip
End Sub

Public Sub pSelectAll(ByVal bSelect As Boolean, _
                      ByRef zip As cUnzip)
  Dim i As Integer
  
  If zip Is Nothing Then Set zip = m_Unzip
  
  For i = 1 To zip.FileCount
    zip.FileSelected(i) = bSelect
  Next
End Sub

Public Sub UnSelectFile(ByVal File As String, _
                        ByRef zip As cUnzip)
  pSelectFile File, False, zip
End Sub

Public Function SelectFile(ByVal File As String, _
                           ByRef zip As cUnzip) As Boolean
  SelectFile = pSelectFile(File, True, zip)
End Function

Private Function pSelectFile(ByVal File As String, _
                             ByVal bSelect As Boolean, _
                             ByRef zip As cUnzip) As Boolean
  Dim i As Integer
  
  If zip Is Nothing Then Set zip = m_Unzip
  
  For i = 1 To zip.FileCount
    If zip.Filename(i) = File Then
      zip.FileSelected(i) = bSelect
      pSelectFile = True
      Exit For
    End If
  Next
End Function

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

Private Sub pShowSplitter(Optional ByVal bHide As Boolean = False)
  m_bHideSplitter = bHide
  picSplitterBar.Visible = Not m_bHideSplitter
  rtxInfo.Visible = Not m_bHideSplitter
  Form_Resize
End Sub

Private Sub pHideSplitter()
  pShowSplitter True
End Sub

Private Sub pSetBackupFileFolder()
  Dim folder As String
  Dim n      As Long
  
  Do
    
    n = n + 1
    
    m_BackupFileFolder = Format(date, "yyyy-mm-dd") & "-"
    
    folder = ValidPath(txBackupFolder.Text) & _
                m_BackupFileFolder & _
                Format(n, "000")
  
  Loop Until Not pExistsFolder(folder)
  
  pCreateFolder folder
  
  m_BackupDbFolder = folder
  m_BackupFileFolder = ValidPath(folder)
End Sub

Private Function pDeleteClienteIni() As Boolean
  Dim strError As String
  If Not pDeleteFile(ValidPath(App.Path) & "cliente.ini", strError) Then
    MsgWarning strError
    Exit Function
  End If
  pDeleteClienteIni = True
End Function

Private Function pCopyFiles() As Boolean
  Dim i           As Long
  Dim k           As Long
  Dim strPath     As String
  Dim filesToCopy As Long
  
  filesToCopy = UBound(g_SetupCfg.Files) + _
                UBound(g_SetupCfg.Reports)
  
  Me.lsFiles.Clear
  Me.lbProcess.Caption = ""
  UpdateStatus Me.picStatus, 0
  
  For i = 1 To UBound(g_SetupCfg.Files)

    With g_SetupCfg.Files(i)
    
      Select Case .FolderTarget
  
        ' Copy to Install
        ' $apppath
        Case c_macro_apppath
          strPath = txInstallFolder.Text
        
        ' Copy to Report
        ' $reportpath
        Case c_macro_reportpath
          strPath = txCsrFolder.Text
        
        Case c_macro_windowspath
          strPath = Environ$("windir")
          
        Case c_macro_programfilespath
          strPath = GetEspecialFolders(sfidPROGRAMS_FILES)
          
        Case c_macro_system32path
          strPath = Environ$("windir")
          If pExistsFolder(ValidPath(strPath) & _
                             "system32") Then
            strPath = ValidPath(strPath) & _
                        "system32"
          Else
            strPath = ValidPath(strPath) & _
                        "system"
          End If
          
        Case c_macro_desktoppath
          strPath = GetEspecialFolders(sfidDESKTOP)
          
        Case c_macro_qlaunchpath
          strPath = GetEspecialFolders(sfidAPPDATA) & "\Microsoft\Internet Explorer\Quick Launch"
          
        Case c_macro_startuppath
          strPath = GetEspecialFolders(sfidCOMMON_STARTUP)
          
        Case Else
          MsgWarning "Este archivo de actualizacion no es valido. La macro {" & .FolderTarget & "} no es valida."
          Exit Function
      End Select
    
      ' Para Depurar - Borrar al Compilar
      '
      ' strPath = txInstallFolder.Text
    
      Me.lbProcess.Caption = "Copiando " & .Filename
    
      If Not pCopyFilesAux(strPath, _
                           .Filename) Then
        Exit Function
      End If
      
      If m_bCancel Then Exit Function
      
      k = k + 1
      
      UpdateStatus Me.picStatus, DivideByCero(k, filesToCopy)
      Me.lsFiles.AddItem .Filename
      With Me.lsFiles
        .ListIndex = .NewIndex
      End With
    
    End With
  Next
  
  For i = 1 To UBound(g_SetupCfg.Reports)
  
    With g_SetupCfg.Reports(i)
  
      If LCase$(Right$(.Filename, 5)) <> ".csai" Then
  
        strPath = txCsrFolder.Text
  
        ' Para Depurar - Borrar al Compilar
        '
        'MsgBox "Se esta usando el directorio de testo de csupdate para copiar los reportes. Si este es un exe, esta mal compilado. Busquen este testo en el fuente, comentenlo y vuelvan a compilar", vbExclamation
        'strPath = txInstallFolder.Text
      
        Me.lbProcess.Caption = "Copiando " & .Filename
      
        If Not pCopyFilesAux(strPath, _
                             .Filename) Then
          Exit Function
        End If
  
      End If
      
      If m_bCancel Then Exit Function
  
      k = k + 1
  
      UpdateStatus Me.picStatus, DivideByCero(k, filesToCopy)
      Me.lsFiles.AddItem .Filename
      With Me.lsFiles
        .ListIndex = .NewIndex
      End With
    End With
  Next
  
  UpdateStatus Me.picStatus, 1, True
  
  pCopyFiles = True

End Function

Private Function pCopyFilesAux(ByVal strPath As String, _
                               ByVal strFile As String) As Boolean
  
  Dim source        As String
  Dim destination   As String
  Dim Answer        As VbMsgBoxResult
  
  source = ValidPath(txTempFolder.Text) & strFile
  destination = ValidPath(strPath) & strFile
  
  Do
    
    If Not pCopyFile(source, destination) Then
      
      Answer = pAsk2("No se pudo copiar el archivo " & strFile & " en " _
                     & pGetPath(source) & " a " & pGetPath(destination) & _
                     ";;¿Desea intentar nuevamente?", vbYes)
      
      If Answer = vbNo Then
        
        Exit Function
      
      ElseIf Answer = vbIgnore Then
      
        pCopyFilesAux = True
        Exit Function
      End If
      
    Else
      Exit Do
    End If
  Loop
  
  pCopyFilesAux = True
End Function

'////////////////////////////////////////////////////////////////////////////

Private Function pCopyFile(ByVal FileSource As String, ByVal FileTo As String) As Boolean
  Dim strError As String
  Dim rslt     As csE_CopyFileError
  
  rslt = csETryAgain
  
  Do While rslt = csETryAgain
    
    DoEvents
    
    If Not pCopyFileAux(FileSource, FileTo, strError) Then

      rslt = pContinue(FileSource, strError)
      
      If rslt = csECancel Then Exit Function
    Else
      
      pSetAttribute FileTo
      Exit Do
    End If
  Loop
  
  pCopyFile = True
End Function

Private Function pCopyFileAux(ByVal FileSource As String, ByVal FileTo As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not pBackupFile(FileTo) Then Exit Function
  If Not pDeleteFile(FileTo, strError) Then Exit Function
  
  FileCopy FileSource, FileTo
  
  strError = Err.Description
  
  pCopyFileAux = Err.Number = 0
End Function

Private Function pBackupFile(ByVal File As String) As Boolean
  On Error GoTo ControlError
  
  If File <> pGetBKFolderFile() & _
                      GetFileName(File) Then
                      
    If FileExists(File) Then
  
      If Not pCopyFile(File, _
                       pGetBKFolderFile() & _
                          GetFileName(File)) Then
        Exit Function
      End If
    End If
  End If
  
  pBackupFile = True
  Exit Function
  
ControlError:
  MngError Err, "pBackupFile", C_Module, ""
End Function

Private Function pGetBKFolderFile() As String
  pGetBKFolderFile = m_BackupFileFolder
End Function

Private Function pDeleteFile(ByVal File As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If FileExists(File) Then
    SetAttr File, vbNormal
    Kill File
  End If
  
  strError = Err.Description

  pDeleteFile = Err.Number = 0
End Function

Private Function pGetPath(ByVal folder As String) As String
  Dim i As Long
  
  For i = Len(folder) To 1 Step -1
    If Mid(folder, i, 1) = "\" Then
      If i > 1 Then pGetPath = Mid(folder, 1, i - 1)
      Exit Function
    End If
  Next
End Function

Private Function pAsk2(ByVal Question As String, _
                       ByVal default As VbMsgBoxResult) As VbMsgBoxResult
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseDefault
  
  Dim fAsk2 As fAsk2
  Set fAsk2 = New fAsk2
  fAsk2.cmdIgnore.default = default = vbIgnore
  fAsk2.cmdNo.default = default = vbNo
  fAsk2.cmdYes.default = default = vbYes
  fAsk2.lbQuestion = Replace(Question, ";", vbCrLf)
  fAsk2.Show vbModal
  pAsk2 = fAsk2.Answer
  Unload fAsk2
End Function

Private Function pContinue(ByVal File As String, ByVal strError As String) As csE_CopyFileError
  Dim rslt As VbMsgBoxResult
  Dim msg  As String
  
  msg = "Ha ocurrido un error copiando el archivo '" & File & "'." & vbCrLf & vbCrLf
  msg = msg & "Error: " & strError & vbCrLf & vbCrLf
  rslt = MsgBox(msg, vbAbortRetryIgnore)
  
  Select Case rslt
    Case vbIgnore
      pContinue = csEIgnore
    Case vbRetry
      pContinue = csETryAgain
    Case vbAbort
      pContinue = csECancel
  End Select
End Function

Private Sub pSetAttribute(ByVal File As String)
  SetAttr File, vbNormal
End Sub

Private Function pUnzipFiles() As Boolean
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseSet vbArrowHourglass
  
  Dim msg As String
  Dim i   As Long
  
  m_bCancel = False
  
  msg = "Descompactando el archivo " & g_SetupCfg.CSA_File
  
  Me.ShowMsgTop msg
  Me.Operation = msg
  
  Me.lsFiles.Clear
  Me.lbProcess.Caption = ""
  UpdateStatus Me.picStatus, 0
  
  Me.OpenZipFile g_SetupCfg.CSA_File
  
  If Not pCreateFolder(txTempFolder.Text) Then Exit Function
  
  If Not pClearFolder(txTempFolder.Text) Then Exit Function
  
  If m_Unzip.FileCount > 0 Then

    ' Display it in the ListView:
    For i = 1 To m_Unzip.FileCount
    
      DoEvents
    
      msg = "Descompactando " & m_Unzip.Filename(i) & "..."
    
      Me.lbProcess.Caption = msg
      With Me.lsFiles
        .AddItem msg
        .ListIndex = .NewIndex
      End With
    
      Me.UnSelectAll m_Unzip
      Me.ExtractFile m_Unzip.Filename(i), _
                     txTempFolder.Text
                     
      UpdateStatus Me.picStatus, DivideByCero(i, m_Unzip.FileCount)
      
      If m_bCancel Then Exit Function
    
    Next i
   
    UpdateStatus Me.picStatus, 1, True
   
  End If

  pUnzipFiles = True
  
End Function

Private Function pCreateFolder(ByVal folder As String) As Boolean
  On Error GoTo ControlError
  
  Dim strError As String
  
  If Not pExistsFolder(folder) Then
    If Not pCreateFolderAux(folder, strError) Then
      MsgBox "No se ha podido crear la carpeta '" & folder & "'." & vbCrLf & vbCrLf & "Error: " & strError, vbCritical + vbOKOnly
      Exit Function
    End If
  End If
  
  pCreateFolder = True
  Exit Function
  
ControlError:
  MngError Err, "pCreateFolder", C_Module, ""
End Function

Private Function pExistsFolder(ByVal folder As String) As Boolean
  On Error Resume Next
  Dim rslt As String
  rslt = Dir(folder, vbDirectory)
  If rslt <> "" Then
    If Not GetAttr(folder) And vbDirectory Then
      rslt = ""
    End If
  End If
  pExistsFolder = rslt <> ""
End Function

Private Function pCreateFolderAux(ByVal folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not pExistsFolder(folder) Then
    If Not pCreateFolderAux(pGetPath(folder)) Then Exit Function
    If Not pCreateFolderAux2(folder, strError) Then Exit Function
  End If
  
  strError = Err.Description
  pCreateFolderAux = Err.Number = 0
End Function

Private Function pCreateFolderAux2(ByVal folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  MkDir folder
  
  strError = Err.Description
  
  pCreateFolderAux2 = Err.Number = 0
End Function

Private Function pClearFolder(ByVal folder As String) As Boolean
  On Error GoTo ControlError
  
  Dim strFile     As String
  Dim strError    As String
  
  If pExistsFolder(folder) Then
    
    strFile = Dir(ValidPath(folder) & "*.*")
    While strFile <> vbNullString
      
      If Not pDeleteFile(ValidPath(folder) & strFile, strError) Then
        MsgError "No se ha podido vaciar la carpeta '" & folder & "'." & vbCrLf & vbCrLf & "Error: " & strError
        Exit Function
      Else
        strFile = Dir(ValidPath(folder) & "*.*")
      End If
    Wend
  End If
  
  pClearFolder = True
  Exit Function
  
ControlError:
  MngError Err, "pClearFolder ", C_Module, ""
End Function

Private Function pBackupDB() As Boolean
  Dim i       As Long
  Dim server  As cSqlDMOServer
  
  If Not pCreateFolder(txBackupFolder.Text) Then
    Exit Function
  End If
  
  For i = 1 To UBound(m_vDataBases)
    With m_vDataBases(i)
      If .bBackup Then
        
        Set server = New cSqlDMOServer
        If Not server.Login(.server, _
                            .User, _
                            .Pwd, _
                            .UseNT) Then
          Exit Function
        End If
        
        If Not server.Backup(.DataBase, _
                             pGetBKFolderFile()) Then
          Exit Function
        End If
         
      End If
    End With
  Next
  
  pBackupDB = True
End Function

Private Function pShowInf() As Boolean
  Dim i         As Integer
  Dim vCSAI()   As String
  
  UnSelectAll m_Unzip
  ReDim vCSAI(0)
  
  For i = 1 To m_Unzip.FileCount
    If LCase$(Right$(m_Unzip.Filename(i), 5)) = ".csai" Then
      m_Unzip.FileSelected(i) = True
      ReDim Preserve vCSAI(UBound(vCSAI) + 1)
      vCSAI(UBound(vCSAI)) = m_Unzip.Filename(i)
    End If
  Next
  
  ExtractFile "", _
              txTempFolder.Text
  
  ReDim m_vInformes(0)
  
  For i = 1 To UBound(vCSAI)
  
    OpenZipFile ValidPath(txTempFolder.Text) & vCSAI(i), _
                m_UnzipCSAI
  
    UnSelectAll m_UnzipCSAI
    ExtractFile c_setup_inf_lst, _
                txTempFolder.Text, _
                m_UnzipCSAI
    
    pLoadInfFromLst vCSAI(i)
  Next
  
  With lvInfo
    .ListItems.Clear
    .Sorted = False
    With .ColumnHeaders
      .Clear
      .Add , , "Codigo", 2000
      .Add , , "Titulo", 5500
      .Add , , "Archivo csai", 2000
    End With
  
    With .ListItems
      For i = 1 To UBound(m_vInformes)
        With .Add(, , m_vInformes(i).inf_codigo)
          .SubItems(1) = m_vInformes(i).inf_nombre
          .SubItems(2) = m_vInformes(i).csai_file
        End With
      Next
    End With
    Me.cmdMarkAll.Visible = True
    Me.cmdUnMarkAll.Visible = True
    .ZOrder
  End With
  
  pShowInf = True
  
End Function

Private Function pLoadInfFromLst(ByVal csai_file As String) As Boolean
  Dim informe   As t_Informe_lst
  Dim iFile     As Long
  Dim strInf    As String
  Dim vInf      As Variant
  Dim bFound    As Boolean
  Dim i         As Integer
  
  iFile = FreeFile
  Open ValidPath(txTempFolder.Text) & c_setup_inf_lst For Input As #iFile
  
  While Not EOF(iFile)
    Line Input #iFile, strInf
    
    vInf = Split(strInf, "|")
    
    informe.csai_file = csai_file
    informe.inf_codigo = vInf(0)
    informe.inf_nombre = vInf(1)
    
    For i = 1 To UBound(m_vInformes)
      If m_vInformes(i).inf_codigo = informe.inf_codigo Then
        m_vInformes(i) = informe
        bFound = True
        Exit For
      End If
    Next
    
    If Not bFound Then
      ReDim Preserve m_vInformes(UBound(m_vInformes) + 1)
      m_vInformes(UBound(m_vInformes)) = informe
    End If
  Wend
  
  Close iFile
  
End Function

Private Function pUpdateInf() As Boolean
  On Error GoTo ControlError
  
  Dim i       As Long
  Dim j       As Long
  Dim db      As cDataBase
  Dim strDB   As String
  Dim k       As Long
  Dim n       As Long
  
  Set db = New cDataBase
  
  UpdateStatus picStatus, 0
  
  n = UBound(m_vDataBases) * UBound(m_vInformes)
  
  For j = 1 To UBound(m_vDataBases)
  
    With m_vDataBases(j)
      If Not db.OpenConnection(.server, _
                               .DataBase, _
                               .User, _
                               .Pwd, _
                               .UseNT) Then Exit Function
      strDB = .server & "-" & .DataBase
    End With
  
    For i = 1 To UBound(m_vInformes)
      
      If m_vInformes(i).selected Then
      
        lbProcess.Caption = strDB & " - " & _
                            m_vInformes(i).inf_codigo
        
        If Not pUpdateInfAux(m_vInformes(i), _
                             db) Then Exit Function
        
        With lsFiles
          .AddItem strDB & " - " & m_vInformes(i).inf_codigo
          .ListIndex = .NewIndex
        End With
        
        DoEvents
        
        If m_bCancel Then Exit Function
            
      End If
      
      k = k + 1
      UpdateStatus picStatus, DivideByCero(k, n)
      
    Next
    
    db.CloseConnection
    
  Next
  
  UpdateStatus picStatus, 1, True
  
  pUpdateInf = True
  Exit Function
  
ControlError:
  MngError Err, "pUpdateInf", C_Module, ""
End Function

Private Function pUpdateInfAux(ByRef informe As t_Informe_lst, _
                               ByRef db As cDataBase) As Boolean
                               
  If Not pUnzipAndUpdateInf(informe, db) Then Exit Function
                               
  pUpdateInfAux = True
End Function

Private Function pUnzipAndUpdateInf(ByRef informe As t_Informe_lst, _
                                    ByRef db As cDataBase) As Boolean
                               
  OpenZipFile ValidPath(txTempFolder.Text) & informe.csai_file, _
              m_UnzipCSAI
  
  If Not pUnzipAndUpdateInfFile(informe.inf_codigo & ".ado") Then Exit Function
  If Not pUnzipAndUpdateInfFile(informe.inf_codigo & "_P.ado") Then Exit Function
  If Not pUnzipAndUpdateInfFile(informe.inf_codigo & "_G.ado") Then Exit Function
  If Not pUnzipAndUpdateInfFile(informe.inf_codigo & "_H.ado") Then Exit Function
  If Not pUnzipAndUpdateInfFile(informe.inf_codigo & "_O.ado") Then Exit Function
  If Not pUnzipAndUpdateInfFile(informe.inf_codigo & "_S.ado") Then Exit Function
                               
  Dim inf_script As String
  Dim inf_csr    As String
  
  Dim rs As ADODB.Recordset
  
  Set rs = New ADODB.Recordset
  rs.Open ValidPath(txTempFolder.Text) & informe.inf_codigo & ".ado"
  
  If Not rs.EOF Then
    With rs.fields
      
      inf_script = .Item("inf_storedprocedure") & ".sql"
      inf_csr = .Item("inf_reporte")
                                  
      If Not pUnzipAndUpdateInfFile(inf_script) Then Exit Function
      
      If LenB(inf_csr) Then
        If Not pUnzipAndUpdateInfFile(inf_csr) Then Exit Function
      End If
    End With
  End If
  
  If Not pUpdateInfAux2(rs, db) Then Exit Function
  If Not pExecuteInfScript(inf_script, db) Then Exit Function
  
  If LenB(inf_csr) Then
    If Not pCopyFile(ValidPath(txTempFolder.Text) & inf_csr, _
                     ValidPath(txCsrFolder.Text) & inf_csr) Then Exit Function
  End If
  
  pUnzipAndUpdateInf = True
End Function

Private Function pExecuteInfScript(ByVal inf_script As String, _
                                   ByRef db As cDataBase) As Boolean

  Dim sqlstmt     As String
  Dim iFile       As Long
  Dim scriptLen   As Long
  
  iFile = FreeFile
  
  Open ValidPath(txTempFolder.Text) & inf_script For Input As #iFile
  
  scriptLen = FileLen(ValidPath(txTempFolder.Text) & inf_script)
  
  If scriptLen Then
    
    sqlstmt = Input$(LOF(iFile), iFile)
        
    Close iFile
    
    If Not db.ExecuteBatch(sqlstmt, "") Then Exit Function
  
  Else
      
    Close iFile

  End If
  
  pExecuteInfScript = True
End Function

Private Function pUpdateInfAux2(ByRef rs As ADODB.Recordset, _
                                ByRef db As cDataBase) As Boolean
  Dim inf_id    As Long
  Dim bUpdate   As Boolean
  
  ' Actualizo Informe
  '
  If Not pUpdateInforme(rs, _
                           db, _
                           inf_id, _
                           bUpdate) Then Exit Function
  
  ' Actualizo InformeParametro
  '
  If Not pUpdateInfParametro(rs, _
                             db, _
                             inf_id, _
                             bUpdate) Then Exit Function
  
  ' Actualizo InformeGroups
  '
  If Not pUpdateInfGroups(rs, _
                          db, _
                          inf_id, _
                          bUpdate) Then Exit Function
  
  ' Actualizo InformeHiperlinks
  '
  If Not pUpdateInfHiperlinks(rs, _
                              db, _
                              inf_id, _
                              bUpdate) Then Exit Function
  
  ' Actualizo InformeOrders
  '
  If Not pUpdateInfOrders(rs, _
                          db, _
                          inf_id, _
                          bUpdate) Then Exit Function
  
  ' Actualizo InformeSumaries
  '
  If Not pUpdateInfSumaries(rs, _
                            db, _
                            inf_id, _
                            bUpdate) Then Exit Function

  pUpdateInfAux2 = True
End Function

Private Function pUpdateInforme(ByRef rsInf As ADODB.Recordset, _
                                ByRef db As cDataBase, _
                                ByRef inf_id As Long, _
                                ByRef bUpdate As Boolean) As Boolean
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim inf_codigo  As String
  
  inf_codigo = db.sqlString(rsInf.fields.Item("inf_codigo").Value)
  
  sqlstmt = "select inf_id from Informe where inf_codigo = " & inf_codigo

  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    inf_id = db.ValField(rs.fields, "inf_id")
  End If
  
  bUpdate = inf_id
  
  ' Update
  '
  If bUpdate Then
  
    With rsInf.fields
      sqlstmt = "update Informe set " & _
                    " inf_nombre = " & db.sqlString(.Item("inf_nombre")) & _
                    ", inf_descrip = " & db.sqlString(.Item("inf_descrip")) & _
                    ", inf_storedprocedure = " & db.sqlString(.Item("inf_storedprocedure")) & _
                    ", inf_reporte = " & db.sqlString(.Item("inf_reporte")) & _
                    ", inf_presentaciondefault = " & db.sqlString(.Item("inf_presentaciondefault")) & _
                    ", inf_modulo = " & db.sqlString(.Item("inf_modulo")) & _
                    ", inf_tipo = " & db.sqlString(.Item("inf_tipo")) & _
                    ", inf_propietario = " & db.sqlString(.Item("inf_propietario")) & _
                    ", inf_colocultas = " & db.sqlString(.Item("inf_colocultas")) & _
                    ", inf_checkbox = " & db.sqlString(.Item("inf_checkbox")) & _
                    ", inf_totalesgrales = " & db.sqlString(.Item("inf_totalesgrales")) & _
                    ", inf_connstr = " & db.sqlString(.Item("inf_connstr")) & _
                    ", modifico = 1" & _
                " where inf_id = " & inf_id
    End With
    
    If Not db.Execute(sqlstmt, "") Then Exit Function
  
  ' Insert
  '
  Else
    With rsInf.fields
      sqlstmt = "declare @inf_id int " & _
                "exec sp_dbgetnewid 'Informe', 'inf_id', @inf_id out, 0 " & _
                "insert Informe (inf_id,inf_nombre,inf_codigo,inf_descrip,inf_storedprocedure," & _
                                "inf_reporte,inf_presentaciondefault,inf_modulo,inf_tipo," & _
                                "inf_propietario,inf_colocultas,inf_checkbox," & _
                                "inf_totalesgrales,inf_connstr,modifico,activo) " & _
                         "values(@inf_id, " & _
                                 db.sqlString(.Item("inf_nombre")) & ", " & _
                                 db.sqlString(.Item("inf_codigo")) & ", " & _
                                 db.sqlString(.Item("inf_descrip")) & ", " & _
                                 db.sqlString(.Item("inf_storedprocedure")) & ", " & _
                                 db.sqlString(.Item("inf_reporte")) & ", " & _
                                 db.sqlNumber(.Item("inf_presentaciondefault")) & ", " & _
                                 db.sqlString(.Item("inf_modulo")) & ", " & _
                                 db.sqlNumber(.Item("inf_tipo")) & ", " & _
                                 db.sqlNumber(.Item("inf_propietario")) & ", " & _
                                 db.sqlNumber(.Item("inf_colocultas")) & ", " & _
                                 db.sqlString(.Item("inf_checkbox")) & ", " & _
                                 db.sqlNumber(.Item("inf_totalesgrales")) & ", " & _
                                 db.sqlString(.Item("inf_connstr")) & ",1,1" & _
                                ")"
    End With
    
    If Not db.Execute(sqlstmt, "") Then Exit Function
  
    sqlstmt = "select inf_id, inf_codigo, inf_nombre, inf_modulo " & _
              "from Informe where inf_codigo = " & inf_codigo
  
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    inf_id = db.ValField(rs.fields, "inf_id")
    
    If Not pSavePrestacion(rs.fields.Item("inf_id").Value, _
                           rs.fields.Item("inf_codigo").Value, _
                           rs.fields.Item("inf_nombre").Value, _
                           rs.fields.Item("inf_modulo").Value, _
                           db) Then Exit Function
  
  End If
  
  pUpdateInforme = True
End Function

Private Function pSavePrestacion(ByVal inf_id As Long, _
                                 ByVal Codigo As String, _
                                 ByVal Nombre As String, _
                                 ByVal Modulo As String, _
                                 ByRef db As cDataBase) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim min     As Long
  Dim max     As Long
  Dim PreId   As Long
  
  If PreId = 0 Then
  
    'DC_CSC_CON_0010'
    Select Case UCase(Mid(Codigo, 1, 2))
      Case "DC"
        min = 10000000
        max = 10999999
      Case "DT"
        min = 11000000
        max = 11999999
      Case "IT"
        min = 12000000
        max = 12999999
      Case "CL"
        min = 13000000
        max = 13999999
      Case "IC"
        min = 14000000
        max = 14999999
    End Select
    
    sqlstmt = "SP_DBGetNewId2 'Prestacion', 'pre_id', " & min & ", " & max & ", 0"
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  
    If rs.EOF Then Exit Function
    
    PreId = rs.fields(0).Value
    
    sqlstmt = "insert Prestacion (pre_id, pre_nombre,pre_grupo,pre_grupo1,activo)"
    sqlstmt = sqlstmt & " values(" & PreId & "," & db.sqlString(Nombre) & ",'Informes',"
    sqlstmt = sqlstmt & db.sqlString(Modulo) & ",1)"
    
    If Not db.Execute(sqlstmt, "") Then Exit Function
    
    sqlstmt = "update Informe set pre_id = " & PreId & _
              " where inf_id = " & inf_id
    
    If Not db.Execute(sqlstmt, "") Then Exit Function
    
  Else
    
    sqlstmt = "Update Prestacion set "
    sqlstmt = sqlstmt & "pre_nombre = " & db.sqlString(Nombre) & "," & vbCrLf
    sqlstmt = sqlstmt & "pre_grupo  = 'Informes'," & vbCrLf
    sqlstmt = sqlstmt & "pre_grupo1 = " & db.sqlString(Modulo) & "," & vbCrLf
    sqlstmt = sqlstmt & "activo = 1" & vbCrLf
    sqlstmt = sqlstmt & " where pre_id = " & PreId
    
    If Not db.Execute(sqlstmt, "") Then Exit Function
    
  End If
  
  pSavePrestacion = True
End Function

Private Function pUpdateInfParametro(ByRef rsInf As ADODB.Recordset, _
                                     ByRef db As cDataBase, _
                                     ByRef inf_id As Long, _
                                     ByRef bUpdate As Boolean) As Boolean
  ' Cargo todos los parametros
  '
  Dim sqlstmt     As String
  Dim sqlwhere    As String
  Dim rs          As ADODB.Recordset
  Dim rsP         As ADODB.Recordset
  Dim strNotDel   As String
  Dim infp_id     As Long
  
  Dim file_param   As String
  
  file_param = ValidPath(txTempFolder.Text) & _
                rsInf.fields("inf_codigo").Value & "_P.ado"
                
  If FileExists(file_param) Then
  
    sqlstmt = "select infp_id, infp_nombre, infp_tipo " & _
              "from InformeParametro where inf_id = " & inf_id
              
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    Set rsP = New ADODB.Recordset
    rsP.Open file_param
    
    While Not rsP.EOF
    
      infp_id = 0
    
      ' Busco entre los parametros existentes
      ' cada uno de los parametros del informe
      ' contenido en el paquete
      '
      If Not (rs.EOF And rs.BOF) Then
        rs.MoveFirst
        
        Do While Not rs.EOF
          
          With rs.fields
            
            ' El parametro debe tener el mismo nombre
            ' y el mismo tipo. El orden no importa
            '
            If LCase$(.Item("infp_nombre").Value) _
                   = LCase$(rsP.fields.Item("infp_nombre").Value) And _
               .Item("infp_tipo").Value = rsP.fields.Item("infp_tipo").Value Then
               
               strNotDel = strNotDel & .Item("infp_id").Value & ","
               
               infp_id = .Item("infp_id").Value
               Exit Do
               
            End If
          End With
          
          rs.MoveNext
        Loop
      End If
      
      ' Update
      '
      If infp_id Then
    
        ' Actualizo los parametros encontrados
        '
        With rsP.fields
          sqlstmt = "update InformeParametro set " & _
                        " infp_nombre = " & db.sqlString(.Item("infp_nombre")) & _
                        ", infp_orden = " & db.sqlNumber(.Item("infp_orden")) & _
                        ", infp_tipo = " & db.sqlNumber(.Item("infp_tipo")) & _
                        ", infp_default = " & db.sqlString(.Item("infp_default")) & _
                        ", infp_visible = " & db.sqlNumber(.Item("infp_visible")) & _
                        ", infp_sqlstmt = " & db.sqlString(.Item("infp_sqlstmt")) & _
                        ", inf_id = " & inf_id & _
                        ", tbl_id = " & IIf(IsNull(.Item("tbl_id")), "Null", .Item("tbl_id")) & _
                        ", modifico = 1" & _
                    " where infp_id = " & infp_id
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
      
      ' Insert
      '
      Else
        
        ' Inserto los nuevos parametros
        '
        With rsP.fields
          
          infp_id = pGetNewId("InformeParametro", "infp_id", db)
          If infp_id = csNO_ID Then Exit Function
          
          sqlstmt = "insert into InformeParametro (infp_id,infp_nombre,infp_orden,infp_tipo," & _
                             "infp_default,infp_visible,infp_sqlstmt,inf_id,tbl_id,modifico) " & _
                          "values(" & infp_id & "," & _
                                db.sqlString(.Item("infp_nombre")) & ", " & _
                                db.sqlNumber(.Item("infp_orden")) & ", " & _
                                db.sqlNumber(.Item("infp_tipo")) & ", " & _
                                db.sqlString(.Item("infp_default")) & ", " & _
                                db.sqlNumber(.Item("infp_visible")) & ", " & _
                                db.sqlString(.Item("infp_sqlstmt")) & ", " & _
                                inf_id & ", " & _
                                IIf(IsNull(.Item("tbl_id")), "Null", .Item("tbl_id")) & ",1 " & _
                               ")"
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
        
        strNotDel = strNotDel & infp_id & ","
        
      End If
      
      rsP.MoveNext
    Wend
  End If
  
  If strNotDel = "" Then
    strNotDel = "0" ' Para que no falle el delete
  End If
  
  If bUpdate Then
  
    ' Borro todos los parametros que no
    ' estan en la nueva version del informe
    '
    sqlstmt = "delete ReporteParametro "
    sqlwhere = "where infp_id in " & _
                   "(select infp_id from InformeParametro where inf_id = " & inf_id & _
                      " and infp_id not in (" & RemoveLastColon(strNotDel) & "))"
  
    If Not db.Execute(sqlstmt & sqlwhere, "") Then Exit Function
    
    sqlstmt = "delete InformeParametro "
    
    If Not db.Execute(sqlstmt & sqlwhere, "") Then Exit Function
  End If
  
  pUpdateInfParametro = True
End Function

Private Function pUpdateInfGroups(ByRef rsInf As ADODB.Recordset, _
                                  ByRef db As cDataBase, _
                                  ByRef inf_id As Long, _
                                  ByRef bUpdate As Boolean) As Boolean
  ' Cargo todos los grupos
  '
  Dim sqlstmt     As String
  Dim sqlwhere    As String
  Dim rs          As ADODB.Recordset
  Dim rsG         As ADODB.Recordset
  Dim strNotDel   As String
  Dim winfg_id    As Long
  
  Dim file_group   As String
  
  file_group = ValidPath(txTempFolder.Text) & _
                 rsInf.fields("inf_codigo").Value & "_G.ado"
                
  If FileExists(file_group) Then
  
    sqlstmt = "select winfg_id, winfg_nombre " & _
              "from InformeGroups where inf_id = " & inf_id
              
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    Set rsG = New ADODB.Recordset
    rsG.Open file_group
    
    While Not rsG.EOF
    
      winfg_id = 0
    
      ' Busco entre los grupos existentes
      ' cada uno de los grupos del informe
      ' contenido en el paquete
      '
      If Not (rs.EOF And rs.BOF) Then
        rs.MoveFirst
        
        Do While Not rs.EOF
          
          With rs.fields
            
            ' El grupo debe tener el mismo nombre
            ' y el mismo tipo.
            '
            If LCase$(.Item("winfg_nombre").Value) _
                   = LCase$(rsG.fields.Item("winfg_nombre").Value) Then
               
               strNotDel = strNotDel & .Item("winfg_id").Value & ","
               
               winfg_id = .Item("winfg_id").Value
               Exit Do
               
            End If
          End With
          
          rs.MoveNext
        Loop
      End If
      
      ' Update
      '
      If winfg_id Then
    
        ' Actualizo los grupos encontrados
        '
        With rsG.fields
          sqlstmt = "update InformeGroups set " & _
                        " winfg_nombre = " & db.sqlString(.Item("winfg_nombre")) & _
                        ", winfg_pordefecto = " & db.sqlNumber(.Item("winfg_pordefecto")) & _
                        ", inf_id = " & inf_id & _
                        ", modifico = 1" & _
                    " where winfg_id = " & winfg_id
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
      
      ' Insert
      '
      Else
        
        ' Inserto los nuevos grupos
        '
        With rsG.fields
          
          winfg_id = pGetNewId("InformeGroups", "winfg_id", db)
          If winfg_id = csNO_ID Then Exit Function
          
          sqlstmt = "insert into InformeGroups (winfg_id,winfg_nombre,winfg_pordefecto," & _
                             "inf_id,modifico) " & _
                          "values(" & winfg_id & "," & _
                                db.sqlString(.Item("winfg_nombre")) & ", " & _
                                db.sqlNumber(.Item("winfg_pordefecto")) & ", " & _
                                inf_id & ", 1 " & _
                               ")"
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
        
        strNotDel = strNotDel & winfg_id & ","
        
      End If
      
      rsG.MoveNext
    Wend
  End If
  
  If strNotDel = "" Then
    strNotDel = "0" ' Para que no falle el delete
  End If
  
  If bUpdate Then
    ' Borro todos los grupos que no
    ' estan en la nueva version del informe
    '
    sqlstmt = "delete InformeGroups "
    sqlwhere = "where winfg_id in " & _
                   "(select winfg_id from InformeGroups where inf_id = " & inf_id & _
                      " and winfg_id not in (" & RemoveLastColon(strNotDel) & "))"
    
    If Not db.Execute(sqlstmt & sqlwhere, "") Then Exit Function
  End If
  
  pUpdateInfGroups = True
End Function

Private Function pUpdateInfHiperlinks(ByRef rsInf As ADODB.Recordset, _
                                      ByRef db As cDataBase, _
                                      ByRef inf_id As Long, _
                                      ByRef bUpdate As Boolean) As Boolean
  ' Cargo todos los Hiperlinks
  '
  Dim sqlstmt     As String
  Dim sqlwhere    As String
  Dim rs          As ADODB.Recordset
  Dim rsH         As ADODB.Recordset
  Dim strNotDel   As String
  Dim winfh_id    As Long
  
  Dim file_hiperlink   As String
  
  file_hiperlink = ValidPath(txTempFolder.Text) & _
                    rsInf.fields("inf_codigo").Value & "_H.ado"
                
  If FileExists(file_hiperlink) Then
  
    sqlstmt = "select winfh_id, winfh_nombre, winfh_columna " & _
              "from InformeHiperlinks where inf_id = " & inf_id
              
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    Set rsH = New ADODB.Recordset
    rsH.Open file_hiperlink
    
    While Not rsH.EOF
    
      winfh_id = 0
    
      ' Busco entre los Hiperlinks existentes
      ' cada uno de los Hiperlinks del informe
      ' contenido en el paquete
      '
      If Not (rs.EOF And rs.BOF) Then
        rs.MoveFirst
        
        Do While Not rs.EOF
          
          With rs.fields
            
            ' El parametro debe tener el mismo nombre
            ' y el mismo tipo.
            '
            If LCase$(.Item("winfh_nombre").Value) _
                   = LCase$(rsH.fields.Item("winfh_nombre").Value) Then
               
               strNotDel = strNotDel & .Item("winfh_id").Value & ","
               
               winfh_id = .Item("winfh_id").Value
               Exit Do
               
            End If
          End With
          
          rs.MoveNext
        Loop
      End If
      
      ' Update
      '
      If winfh_id Then
    
        ' Actualizo los Hiperlinks encontrados
        '
        With rsH.fields
          sqlstmt = "update InformeHiperlinks set " & _
                        " winfh_nombre = " & db.sqlString(.Item("winfh_nombre")) & _
                        ", winfh_columna = " & db.sqlString(.Item("winfh_columna")) & _
                        ", winfh_url = " & db.sqlString(.Item("winfh_url")) & _
                        ", inf_id = " & inf_id & _
                        ", modifico = 1" & _
                    " where winfh_id = " & winfh_id
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
      
      ' Insert
      '
      Else
        
        ' Inserto los nuevos Hiperlinks
        '
        With rsH.fields
          
          winfh_id = pGetNewId("InformeHiperlinks", "winfh_id", db)
          If winfh_id = csNO_ID Then Exit Function
                    
          sqlstmt = "insert into InformeHiperlinks (winfh_id,winfh_nombre,winfh_columna,winfh_url," & _
                             "inf_id,modifico) " & _
                          "values(" & winfh_id & "," & _
                                db.sqlString(.Item("winfh_nombre")) & ", " & _
                                db.sqlString(.Item("winfh_columna")) & ", " & _
                                db.sqlString(.Item("winfh_url")) & ", " & _
                                inf_id & ", 1 " & _
                               ")"
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
        
        strNotDel = strNotDel & winfh_id & ","
        
      End If
      
      rsH.MoveNext
    Wend
  End If
  
  If strNotDel = "" Then
    strNotDel = "0" ' Para que no falle el delete
  End If
  
  If bUpdate Then
    ' Borro todos los Hiperlinks que no
    ' estan en la nueva version del informe
    '
    sqlstmt = "delete InformeHiperlinks "
    sqlwhere = "where winfh_id in " & _
                   "(select winfh_id from InformeHiperlinks where inf_id = " & inf_id & _
                      " and winfh_id not in (" & RemoveLastColon(strNotDel) & "))"
  
    If Not db.Execute(sqlstmt & sqlwhere, "") Then Exit Function
  End If
  
  pUpdateInfHiperlinks = True
End Function

Private Function pUpdateInfOrders(ByRef rsInf As ADODB.Recordset, _
                                  ByRef db As cDataBase, _
                                  ByRef inf_id As Long, _
                                  ByRef bUpdate As Boolean) As Boolean
  ' Cargo todos los orders
  '
  Dim sqlstmt     As String
  Dim sqlwhere    As String
  Dim rs          As ADODB.Recordset
  Dim rsO         As ADODB.Recordset
  Dim strNotDel   As String
  Dim winfo_id    As Long
  
  Dim file_orders  As String
  
  file_orders = ValidPath(txTempFolder.Text) & _
                  rsInf.fields("inf_codigo").Value & "_O.ado"
                
  If FileExists(file_orders) Then
  
    sqlstmt = "select winfo_id, winfo_nombre " & _
              "from InformeOrders where inf_id = " & inf_id
              
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    Set rsO = New ADODB.Recordset
    rsO.Open file_orders
    
    While Not rsO.EOF
    
      winfo_id = 0
    
      ' Busco entre los orders existentes
      ' cada uno de los orders del informe
      ' contenido en el paquete
      '
      If Not (rs.EOF And rs.BOF) Then
        rs.MoveFirst
        
        Do While Not rs.EOF
          
          With rs.fields
            
            ' El grupo debe tener el mismo nombre
            ' y el mismo tipo.
            '
            If LCase$(.Item("winfo_nombre").Value) _
                   = LCase$(rsO.fields.Item("winfo_nombre").Value) Then
               
               strNotDel = strNotDel & .Item("winfo_id").Value & ","
               
               winfo_id = .Item("winfo_id").Value
               Exit Do
               
            End If
          End With
          
          rs.MoveNext
        Loop
      End If
      
      ' Update
      '
      If winfo_id Then
    
        ' Actualizo los orders encontrados
        '
        With rsO.fields
          sqlstmt = "update InformeOrders set " & _
                        " winfo_nombre = " & db.sqlString(.Item("winfo_nombre")) & _
                        ", inf_id = " & inf_id & _
                        ", modifico = 1" & _
                    " where winfo_id = " & winfo_id
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
        
      ' Insert
      '
      Else
        
        ' Inserto los nuevos orders
        '
        With rsO.fields
          
          winfo_id = pGetNewId("InformeOrders", "winfo_id", db)
          If winfo_id = csNO_ID Then Exit Function
                    
          sqlstmt = "insert into InformeOrders (winfo_id,winfo_nombre," & _
                             "inf_id,modifico) " & _
                          "values(" & winfo_id & "," & _
                                db.sqlString(.Item("winfo_nombre")) & ", " & _
                                inf_id & ", 1 " & _
                               ")"
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
        
        strNotDel = strNotDel & winfo_id & ","
        
      End If
      
      rsO.MoveNext
    Wend
  End If
  
  If strNotDel = "" Then
    strNotDel = "0" ' Para que no falle el delete
  End If
  
  If bUpdate Then
    ' Borro todos los orders que no
    ' estan en la nueva version del informe
    '
    sqlstmt = "delete InformeOrders "
    sqlwhere = "where winfo_id in " & _
                   "(select winfo_id from InformeOrders where inf_id = " & inf_id & _
                      " and winfo_id not in (" & RemoveLastColon(strNotDel) & "))"
    
    If Not db.Execute(sqlstmt & sqlwhere, "") Then Exit Function
  End If
  
  pUpdateInfOrders = True
End Function

Private Function pUpdateInfSumaries(ByRef rsInf As ADODB.Recordset, _
                                    ByRef db As cDataBase, _
                                    ByRef inf_id As Long, _
                                    ByRef bUpdate As Boolean) As Boolean
  ' Cargo todos los grupos
  '
  Dim sqlstmt     As String
  Dim sqlwhere    As String
  Dim rs          As ADODB.Recordset
  Dim rsS         As ADODB.Recordset
  Dim strNotDel   As String
  Dim winfs_id    As Long
  
  Dim file_sumaries   As String
  
  file_sumaries = ValidPath(txTempFolder.Text) & _
                    rsInf.fields("inf_codigo").Value & "_S.ado"
                
  If FileExists(file_sumaries) Then
  
    sqlstmt = "select winfs_id, winfs_nombre " & _
              "from InformeSumaries where inf_id = " & inf_id
              
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    Set rsS = New ADODB.Recordset
    rsS.Open file_sumaries
    
    While Not rsS.EOF
    
      winfs_id = 0
    
      ' Busco entre los grupos existentes
      ' cada uno de los grupos del informe
      ' contenido en el paquete
      '
      If Not (rs.EOF And rs.BOF) Then
        rs.MoveFirst
        
        Do While Not rs.EOF
          
          With rs.fields
            
            ' El grupo debe tener el mismo nombre
            ' y el mismo tipo.
            '
            If LCase$(.Item("winfs_nombre").Value) _
                   = LCase$(rsS.fields.Item("winfs_nombre").Value) Then
               
               strNotDel = strNotDel & .Item("winfs_id").Value & ","
               
               winfs_id = .Item("winfs_id").Value
               Exit Do
               
            End If
          End With
          
          rs.MoveNext
        Loop
      End If
      
      ' Update
      '
      If winfs_id Then
    
        ' Actualizo los grupos encontrados
        '
        With rsS.fields
          sqlstmt = "update InformeSumaries set " & _
                        " winfs_nombre = " & db.sqlString(.Item("winfs_nombre")) & _
                        ", winfs_operacion = " & db.sqlString(.Item("winfs_operacion")) & _
                        ", inf_id = " & inf_id & _
                        ", modifico = 1" & _
                    " where winfs_id = " & winfs_id
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
      
      ' Insert
      '
      Else
        
        ' Inserto los nuevos grupos
        '
        With rsS.fields

          winfs_id = pGetNewId("InformeSumaries", "winfs_id", db)
          If winfs_id = csNO_ID Then Exit Function
                    
          sqlstmt = "insert into InformeSumaries (winfs_id,winfs_nombre,winfs_operacion," & _
                             "inf_id,modifico) " & _
                          "values(" & winfs_id & "," & _
                                db.sqlString(.Item("winfs_nombre")) & ", " & _
                                db.sqlString(.Item("winfs_operacion")) & ", " & _
                                inf_id & ", 1 " & _
                               ")"
        End With
        
        If Not db.Execute(sqlstmt, "") Then Exit Function
        
        strNotDel = strNotDel & winfs_id & ","
        
      End If
      
      rsS.MoveNext
    Wend
  End If
  
  If strNotDel = "" Then
    strNotDel = "0" ' Para que no falle el delete
  End If
  
  If bUpdate Then
    ' Borro todos los grupos que no
    ' estan en la nueva version del informe
    '
    sqlstmt = "delete InformeSumaries "
    sqlwhere = "where winfs_id in " & _
                   "(select winfs_id from InformeSumaries where inf_id = " & inf_id & _
                      " and winfs_id not in (" & RemoveLastColon(strNotDel) & "))"
    
    If Not db.Execute(sqlstmt & sqlwhere, "") Then Exit Function
  End If
  
  pUpdateInfSumaries = True
End Function

Private Function pUnzipAndUpdateInfFile(ByRef File As String) As Boolean
  Dim i As Long

  UnSelectAll m_UnzipCSAI

  With m_UnzipCSAI
    For i = 1 To .FileCount
      If .Filename(i) = File Then
        
        ExtractFile File, _
                    txTempFolder.Text, _
                    m_UnzipCSAI
      
      End If
    Next
  End With
  
  pUnzipAndUpdateInfFile = True
  
End Function

Private Function pExecuteScripts()
  On Error GoTo ControlError
  
  Dim i       As Long
  Dim j       As Long
  Dim db      As cDataBase
  Dim strDB   As String
  Dim k       As Long
  Dim n       As Long
  
  Set db = New cDataBase
  
  UpdateStatus picStatus, 0
  
  n = UBound(m_vDataBases) * UBound(g_SetupCfg.Scripts)
  
  For j = 1 To UBound(m_vDataBases)
  
    With m_vDataBases(j)
      If Not db.OpenConnection(.server, _
                               .DataBase, _
                               .User, _
                               .Pwd, _
                               .UseNT) Then Exit Function
      strDB = .server & "-" & .DataBase
    End With
  
    For i = 1 To UBound(g_SetupCfg.Scripts)
      
      With g_SetupCfg.Scripts(i)
      
        lbProcess.Caption = strDB & " - " & _
                            .name
        
        If Not pExecuteScriptsAux(.Filename, _
                                  db) Then Exit Function
        
        With lsFiles
          .AddItem strDB & " - " & g_SetupCfg.Scripts(i).name
          .ListIndex = .NewIndex
        End With
        
        DoEvents
        
        If m_bCancel Then Exit Function
            
      End With
      
      k = k + 1
      UpdateStatus picStatus, DivideByCero(k, n)
      
    Next
    
    db.CloseConnection
    
  Next
  
  UpdateStatus picStatus, 1, True
  
  pExecuteScripts = True
  Exit Function
  
ControlError:
  MngError Err, "pExecuteScripts", C_Module, ""
End Function

Private Function pExecuteScriptsAux(ByVal inf_script As String, _
                                    ByRef db As cDataBase) As Boolean

  Dim sqlstmt     As String
  Dim iFile       As Long
  Dim scriptLen   As Long
  
  iFile = FreeFile
  
  Open ValidPath(txTempFolder.Text) & inf_script For Input As #iFile
  
  scriptLen = FileLen(ValidPath(txTempFolder.Text) & inf_script)
  
  If scriptLen Then
    
    sqlstmt = Input$(LOF(iFile), iFile)
        
    Close iFile
    
    If Not db.ExecuteBatch(sqlstmt, "") Then Exit Function
  
  Else
      
    Close iFile

  End If
  
  pExecuteScriptsAux = True
End Function

Private Function pGetNewId(ByVal Table As String, _
                           ByVal Field As String, _
                           ByRef db As cDataBase) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "exec sp_dbgetnewid '" & Table & "', '" & Field & "', 0, 1 "
  
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  
  pGetNewId = rs.fields.Item(0).Value
  
End Function

'////////////////////////////////////////////
'
' Parametros para Environ$
'
  '    ALLUSERSPROFILE=C:\Documents and Settings\All Users
  '    APPDATA=C:\Documents and Settings\lafeverc\Application Data
  '    CommonProgramFiles=C:\Program Files\Common Files
  '    COMPUTERNAME = lafeverc
  '    ComSpec=C:\WINDOWS\system32\cmd.exe
  '    HOMEDRIVE = c:
  '    HOMEPATH=\Documents and Settings\lafeverc
  '    INCLUDE=D:\Program Files\Microsoft Visual Studio .NET\FrameworkSDK\includeLIB=D:\Program Files\Microsoft Visual Studio .NET\FrameworkSDK\LibLOGONSERVER=\\CG1BDC-7VH2H11
  '    NUMBER_OF_PROCESSORS = 1
  '    OS = Windows_NT
  '    Path=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\Program Files\Microsoft SQL Server\80\Tools\BINN;C:\Program Files\Common Files\Adaptec Shared\System
  '    PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH
  '    PROCESSOR_ARCHITECTURE = x86
  '    PROCESSOR_IDENTIFIER=x86 Family 6 Model 11 Stepping 1, GenuineIntel
  '    PROCESSOR_LEVEL = 6
  '    PROCESSOR_REVISION=0b01
  '    ProgramFiles=C:\Program Files
  '    SESSIONNAME = Console
  '    SystemDrive = c:
  '    SystemRoot=C:\WINDOWS
  '    TEMP=C:\DOCUME~1\lafeverc\LOCALS~1\Temp
  '    TMP=C:\DOCUME~1\lafeverc\LOCALS~1\Temp
  '    ULTRAMON_LANGDIR=C:\Program Files\UltraMon\Resources\en
  '    USERDOMAIN = CG1
  '    UserName = lafeverc
  '    USERPROFILE=C:\Documents and Settings\lafeverc
  '    VSCOMNTOOLS = "D:\Program Files\Microsoft Visual Studio .NET\Common7\Tools\"
  '    windir=C:\WINDOWS
