VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fTaskCommandBackup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Tarea de backup"
   ClientHeight    =   8865
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7500
   Icon            =   "fTaskCommandBackup.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8865
   ScaleWidth      =   7500
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txZips 
      Height          =   315
      Left            =   6120
      TabIndex        =   42
      Top             =   1380
      Width           =   615
   End
   Begin VB.TextBox txFtpPort 
      Height          =   315
      Left            =   6660
      TabIndex        =   35
      Text            =   "21"
      Top             =   3240
      Width           =   435
   End
   Begin VB.TextBox txFtpPwd 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   5040
      PasswordChar    =   "*"
      TabIndex        =   34
      Top             =   3240
      Width           =   1575
   End
   Begin VB.TextBox txFtpUser 
      Height          =   315
      Left            =   3420
      TabIndex        =   33
      Text            =   "anonymous"
      Top             =   3240
      Width           =   1575
   End
   Begin VB.TextBox txFtpAddress 
      Height          =   315
      Left            =   60
      TabIndex        =   32
      Top             =   3240
      Width           =   3315
   End
   Begin VB.CommandButton cmdSaveAs 
      Caption         =   "G&uardar Como"
      Height          =   315
      Left            =   120
      TabIndex        =   16
      Top             =   8400
      Width           =   1575
   End
   Begin VB.TextBox txName 
      Height          =   315
      Left            =   1800
      TabIndex        =   0
      Top             =   1020
      Width           =   4935
   End
   Begin VB.TextBox txFile 
      Height          =   315
      Left            =   1800
      TabIndex        =   2
      Top             =   1740
      Width           =   4935
   End
   Begin VB.TextBox txDescrip 
      Height          =   615
      Left            =   1800
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   2100
      Width           =   4935
   End
   Begin VB.CommandButton cmdOpenFile 
      Caption         =   "..."
      Height          =   315
      Left            =   6840
      TabIndex        =   3
      Top             =   1740
      Width           =   375
   End
   Begin VB.TextBox txCode 
      Height          =   315
      Left            =   1800
      TabIndex        =   1
      Top             =   1380
      Width           =   1695
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Guardar"
      Height          =   315
      Left            =   4140
      TabIndex        =   17
      Top             =   8400
      Width           =   1575
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cerrar"
      Height          =   315
      Left            =   5820
      TabIndex        =   18
      Top             =   8400
      Width           =   1575
   End
   Begin VB.Frame Frame2 
      Caption         =   "Archivos"
      Height          =   2490
      Left            =   90
      TabIndex        =   21
      Top             =   5850
      Width           =   7335
      Begin VB.TextBox txServerFolder 
         Height          =   330
         Left            =   120
         TabIndex        =   40
         Top             =   2010
         Width           =   6600
      End
      Begin VB.CommandButton cmdServerFolder 
         Caption         =   "..."
         Height          =   330
         Left            =   6750
         TabIndex        =   39
         Top             =   2010
         Width           =   435
      End
      Begin VB.PictureBox Picture2 
         BorderStyle     =   0  'None
         Height          =   1455
         Left            =   60
         ScaleHeight     =   1455
         ScaleWidth      =   7155
         TabIndex        =   23
         Top             =   240
         Width           =   7155
         Begin VB.CommandButton cmdFindFile 
            Caption         =   "..."
            Height          =   330
            Left            =   6690
            TabIndex        =   12
            Top             =   330
            Width           =   435
         End
         Begin VB.TextBox txFileData 
            Height          =   330
            Left            =   60
            TabIndex        =   11
            Top             =   330
            Width           =   6600
         End
         Begin VB.CommandButton cmdFileLog 
            Caption         =   "..."
            Height          =   330
            Left            =   6690
            TabIndex        =   15
            Top             =   1050
            Width           =   435
         End
         Begin VB.TextBox txFileLog 
            Height          =   330
            Left            =   60
            TabIndex        =   14
            Top             =   1050
            Width           =   6600
         End
         Begin VB.CheckBox chkDataBaseFileDefault 
            Caption         =   "Path por defecto"
            Height          =   240
            Left            =   2220
            TabIndex        =   10
            Top             =   60
            Width           =   2940
         End
         Begin VB.CheckBox chkLofFileDefault 
            Caption         =   "Path por defecto"
            Height          =   240
            Left            =   2220
            TabIndex        =   13
            Top             =   780
            Width           =   2940
         End
         Begin VB.Label Label2 
            Caption         =   "Base de datos :"
            Height          =   195
            Left            =   60
            TabIndex        =   25
            Top             =   60
            Width           =   1410
         End
         Begin VB.Label Label3 
            Caption         =   "Log de transacciones :"
            Height          =   195
            Left            =   60
            TabIndex        =   24
            Top             =   780
            Width           =   1815
         End
      End
      Begin VB.Label Label11 
         Caption         =   "Carpeta en el servidor :"
         Height          =   195
         Left            =   120
         TabIndex        =   41
         Top             =   1740
         Width           =   1815
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Tipo"
      Height          =   1140
      Left            =   90
      TabIndex        =   20
      Top             =   4545
      Width           =   7335
      Begin VB.PictureBox Picture1 
         BorderStyle     =   0  'None
         Height          =   675
         Left            =   540
         ScaleHeight     =   675
         ScaleWidth      =   4635
         TabIndex        =   22
         Top             =   360
         Width           =   4635
         Begin VB.CheckBox chkInitLog 
            Caption         =   "Inicializar el Log"
            Height          =   240
            Left            =   1875
            TabIndex        =   9
            Top             =   30
            Width           =   1680
         End
         Begin VB.OptionButton opDataBase 
            Caption         =   "Base de datos"
            Height          =   330
            Left            =   0
            TabIndex        =   7
            Top             =   0
            Width           =   2175
         End
         Begin VB.OptionButton opLog 
            Caption         =   "Log de transacciones"
            Height          =   330
            Left            =   0
            TabIndex        =   8
            Top             =   360
            Width           =   2220
         End
      End
   End
   Begin VB.ComboBox cbDataBases 
      Height          =   315
      Left            =   1320
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   3780
      Width           =   6015
   End
   Begin VB.CheckBox chkOverWrite 
      Alignment       =   1  'Right Justify
      Caption         =   "Sobre escribir :"
      Height          =   240
      Left            =   90
      TabIndex        =   6
      Top             =   4185
      Width           =   1410
   End
   Begin MSComDlg.CommonDialog dlg 
      Left            =   6900
      Top             =   2160
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList ilDir 
      Left            =   6900
      Top             =   1080
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTaskCommandBackup.frx":058A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTaskCommandBackup.frx":0B26
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTaskCommandBackup.frx":10C2
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Label Label12 
      Caption         =   "Cantidad de Zips:"
      Height          =   255
      Left            =   4740
      TabIndex        =   43
      Top             =   1440
      Width           =   1335
   End
   Begin VB.Label Label10 
      Caption         =   "Puerto"
      Height          =   255
      Left            =   6660
      TabIndex        =   38
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Label Label9 
      Caption         =   "Clave"
      Height          =   255
      Left            =   5040
      TabIndex        =   37
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Label Label8 
      Caption         =   "Usuario"
      Height          =   255
      Left            =   3480
      TabIndex        =   36
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Label Label7 
      Caption         =   "Dirección FTP"
      Height          =   255
      Left            =   60
      TabIndex        =   31
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   11000
      Y1              =   2820
      Y2              =   2820
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   11000
      Y1              =   2835
      Y2              =   2835
   End
   Begin VB.Image Image1 
      Height          =   720
      Left            =   360
      Picture         =   "fTaskCommandBackup.frx":121C
      Top             =   120
      Width           =   720
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "Configuración de Tareas de Backup de SQL Server"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   1800
      TabIndex        =   30
      Top             =   120
      UseMnemonic     =   0   'False
      Width           =   5115
   End
   Begin VB.Label lb 
      Caption         =   "Titulo:"
      Height          =   255
      Left            =   120
      TabIndex        =   29
      Top             =   1080
      Width           =   735
   End
   Begin VB.Label Label5 
      Caption         =   "Descripción:"
      Height          =   255
      Left            =   120
      TabIndex        =   28
      Top             =   2160
      Width           =   1095
   End
   Begin VB.Label Label4 
      Caption         =   "Nombre del Archivo:"
      Height          =   255
      Left            =   120
      TabIndex        =   27
      Top             =   1800
      Width           =   1695
   End
   Begin VB.Label lbCode 
      Caption         =   "Código:"
      Height          =   255
      Left            =   120
      TabIndex        =   26
      Top             =   1440
      Width           =   735
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   11000
      Y1              =   3675
      Y2              =   3675
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   11000
      Y1              =   3660
      Y2              =   3660
   End
   Begin VB.Label Label1 
      Caption         =   "Base de datos :"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   3795
      Width           =   1140
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   0
      Top             =   0
      Width           =   7485
   End
End
Attribute VB_Name = "fTaskCommandBackup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fTaskCommandBackup
' 25-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fTaskCommandBackup"

' estructuras
' variables privadas
Private m_CmdBackup   As cSQLTaskCommandBackup

Private m_Changed     As Boolean

Private WithEvents m_fSQLLogin As fSQLLogin
Attribute m_fSQLLogin.VB_VarHelpID = -1

' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Edit(ByVal SQLServerTaskFile As String) As Boolean
  
  Dim Server        As String
  Dim User          As String
  Dim Password      As String
  Dim SecurityType  As csSQLSecurityType
  
  Set m_CmdBackup = New cSQLTaskCommandBackup

  If SQLServerTaskFile <> vbNullString Then
    
    If Not m_CmdBackup.Load(SQLServerTaskFile, False) Then
      Exit Function
    End If
    
    If Not m_CmdBackup.Connect(m_CmdBackup.Server, _
                               m_CmdBackup.User, _
                               m_CmdBackup.Pwd, _
                               m_CmdBackup.SecurityType, _
                               False) Then
    
      Server = m_CmdBackup.Server
      User = m_CmdBackup.DataBase
      Password = m_CmdBackup.Pwd
      SecurityType = m_CmdBackup.SecurityType
      
      Load fSQLLogin
      fSQLLogin.SetLogin Server, User, Password, SecurityType
    
      If Not pLogin() Then Exit Function
    
    End If
    
    With Me
      .txName.Text = m_CmdBackup.Name
      SelectItemByText .cbDataBases, m_CmdBackup.DataBase
      .txCode.Text = m_CmdBackup.Code
      .txFile.Text = m_CmdBackup.File
      .txDescrip.Text = m_CmdBackup.Descrip
      
      .txFtpAddress.Text = m_CmdBackup.FtpAddress
      .txFtpUser.Text = m_CmdBackup.FtpUser
      .txFtpPwd.Text = m_CmdBackup.FtpPwd
      .txFtpPort.Text = m_CmdBackup.FtpPort
      
    End With
  
  Else
    
    If Not pLogin() Then Exit Function
  
  End If
      
  m_Changed = False

  fTaskCommandBackup.Show vbModal

End Function
' funciones friend
' funciones privadas
Private Function pLogin() As Boolean

  Set m_fSQLLogin = fSQLLogin
  fSQLLogin.Show vbModal
  
  If Not fSQLLogin.Ok Then Exit Function
      
  m_CmdBackup.Server = fSQLLogin.cbServer.Text
  m_CmdBackup.User = fSQLLogin.txUser.Text
  m_CmdBackup.Pwd = fSQLLogin.txPassword.Text
  m_CmdBackup.SecurityType = IIf(fSQLLogin.opNt.Value, csTSNT, csTSSQL)

  pLogin = True
End Function

Private Sub LoadDataBases()
  On Error GoTo ControlError
  
  Dim i    As Long
  Dim coll As Collection
  
  Set coll = m_CmdBackup.Conn.ListDataBases()
  
  cbDataBases.Clear
  
  For i = 1 To coll.Count
    If LCase$(coll.Item(i)) <> "master" Then
      cbDataBases.AddItem coll.Item(i)
    End If
  Next
  
  cbDataBases.ListIndex = 0
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDataBases", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cbDataBases_Click()
  Dim Path As String
  Path = GetPath_(txFileData.Text)
  If Mid$(Path, 2, 1) <> ":" Then Path = vbNullString
  If Path <> "" Then Path = FileGetValidPath(Path)
  txFileData.Text = Path & cbDataBases.Text & "_dat.bak"

  Path = GetPath_(txFileLog.Text)
  If Mid$(Path, 2, 1) <> ":" Then Path = vbNullString
  If Path <> "" Then Path = FileGetValidPath(Path)
  txFileLog.Text = Path & cbDataBases.Text & "_log.bak"
End Sub

Private Sub chkDataBaseFileDefault_Click()
  cmdFindFile.Enabled = chkDataBaseFileDefault.Value <> vbChecked
  txFileData.Text = GetFileName_(txFileData.Text)
End Sub

Private Sub chkLofFileDefault_Click()
  cmdFileLog.Enabled = chkLofFileDefault.Value <> vbChecked
  txFileLog.Text = GetFileName_(txFileLog.Text)
End Sub

Private Sub cmdFileLog_Click()
  On Error GoTo ControlError
  
  Dim File      As String
  Dim DataBase  As String
  
  DataBase = cbDataBases.Text & "_log.dat"
  
  File = m_CmdBackup.ShowFindFileBackup(DataBase, txFileLog.Text, Me.Caption)
  If File <> "" Then txFileLog.Text = File

  GoTo ExitProc
ControlError:
  MngError Err, "cmdFileLog_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdFindFile_Click()
  On Error GoTo ControlError
  
  Dim File      As String
  Dim DataBase  As String
  
  DataBase = cbDataBases.Text & "_db.dat"
  
  File = m_CmdBackup.ShowFindFileBackup(DataBase, txFileData.Text, Me.Caption)
  If File <> "" Then txFileData.Text = File

  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOpenFile_Click()

  With dlg
    .Filter = "Archivos de Backup de CrowSoft|*.cszip"
    .ShowOpen
    If .FileName <> vbNullString Then
      txFile.Text = .FileName
    End If
  End With
End Sub

Private Sub cmdSave_Click()
  pSave
End Sub

Private Sub cmdSaveAs_Click()
  Dim TaskName As String
  TaskName = InputBox("Ingrese el nombre", "Guardar Como", "Nueva Tarea")
  If LenB(TaskName) Then
    txCode.Text = TaskName
    pSave
  End If
  
End Sub

Private Sub cmdServerFolder_Click()
  On Error GoTo ControlError
  
  Dim File      As String
  
  With dlg
    .Filter = "Archivos de Backup de Base de datos|*.dat|Todos los archivos|*.*"
    .ShowOpen
    If .FileName <> vbNullString Then
      File = .FileName
    End If
  End With
  If File <> "" Then txServerFolder.Text = GetPath_(File)

  GoTo ExitProc
ControlError:
  MngError Err, "cmdServerFolder_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fSQLLogin_Connect(Cancel As Boolean)
  Cancel = Not m_CmdBackup.Connect(m_fSQLLogin.cbServer.Text, _
                                   m_fSQLLogin.txUser.Text, _
                                   m_fSQLLogin.txPassword.Text, _
                                   IIf(m_fSQLLogin.opNt.Value, _
                                          csSQLSecurityType.csTSNT, _
                                          csSQLSecurityType.csTSSQL) _
                                  , False)
End Sub

Private Sub opDataBase_Click()
  chkInitLog.Enabled = True
End Sub

Private Sub opLog_Click()
  chkInitLog.Enabled = False
End Sub

Private Sub ShowData()
  If m_CmdBackup.DataBase = "" Then Exit Sub
  txName.Text = m_CmdBackup.Name
  SelectItemByText cbDataBases, m_CmdBackup.DataBase
  txFileData.Text = m_CmdBackup.FileDataBase
  txFileLog.Text = m_CmdBackup.FileLog
  txServerFolder.Text = m_CmdBackup.ServerFolder
  txZips.Text = m_CmdBackup.ZipFiles
  chkDataBaseFileDefault.Value = IIf(m_CmdBackup.DataBaseUseDefaultPath, vbChecked, vbUnchecked)
  chkLofFileDefault.Value = IIf(m_CmdBackup.LogUseDefaultPath, vbChecked, vbUnchecked)
  chkInitLog.Value = IIf(m_CmdBackup.InitLog, vbChecked, vbUnchecked)
  chkOverWrite.Value = IIf(m_CmdBackup.OverWrite, vbChecked, vbUnchecked)
  opDataBase.Value = m_CmdBackup.IsLog = False
  opLog.Value = m_CmdBackup.IsLog = True
End Sub

Private Function pSave() As Boolean
  
  If Not Validate() Then Exit Function
  
  CollectData
  
  If m_CmdBackup.Save Then
    m_Changed = False
    pSave = True
  End If
End Function

Private Function Validate() As Boolean
  
  If txName.Text = "" Then
    Info "Debe indicar un nombre para la tarea"
    SetFocusControl txName
    Exit Function
  End If
  
  If txFile.Text = "" Then
    Info "Debe indicar el nombre del archivo de backup que sera generado por la tarea"
    SetFocusControl txFile
    Exit Function
  End If
  
  If txCode.Text = "" Then
    Info "Debe indicar un codigo para la tarea"
    SetFocusControl txCode
    Exit Function
  End If
  
  If txFileData.Text = "" Then
    Info "Debe indicar el nombre del archivo de backup para la base de datos"
    SetFocusControl txFileData
    Exit Function
  End If
  
  If txFileLog.Text = "" Then
    Info "Debe indicar el nombre del archivo de backup para el log de transacciones"
    SetFocusControl txFileLog
    Exit Function
  End If
  
  Validate = True
End Function

Private Sub CollectData()

  Dim Init          As Boolean
  Dim OverWrite     As Boolean
  Dim DataBase      As String
  Dim FileDataBase  As String
  Dim FileLog       As String
  Dim ServerFolder  As String
  Dim ZipFiles      As Long
  Dim IsFull        As Boolean
  Dim LogDefaultPath        As Boolean
  Dim DataBaseDefaultPath   As Boolean
  
  Init = chkInitLog.Value = vbChecked
  OverWrite = chkOverWrite.Value = vbChecked
  DataBase = cbDataBases.Text
  FileDataBase = txFileData.Text
  FileLog = txFileLog.Text
  ServerFolder = txServerFolder.Text
  ZipFiles = Val(txZips.Text)
  IsFull = opDataBase.Value

  DataBaseDefaultPath = chkDataBaseFileDefault.Value = vbChecked
  LogDefaultPath = chkLofFileDefault.Value = vbChecked

  m_CmdBackup.Name = txName.Text
  m_CmdBackup.File = txFile.Text
  m_CmdBackup.Descrip = txDescrip.Text
  m_CmdBackup.Code = txCode.Text

  m_CmdBackup.FtpAddress = txFtpAddress.Text
  m_CmdBackup.FtpUser = txFtpUser.Text
  m_CmdBackup.FtpPwd = txFtpPwd.Text
  m_CmdBackup.FtpPort = Val(txFtpPort.Text)
  
  m_CmdBackup.DataBase = DataBase
  m_CmdBackup.InitLog = Init
  m_CmdBackup.IsFull = IsFull
  m_CmdBackup.IsLog = Not IsFull
  m_CmdBackup.FileDataBase = FileDataBase
  m_CmdBackup.FileLog = FileLog
  m_CmdBackup.ServerFolder = ServerFolder
  m_CmdBackup.OverWrite = OverWrite
  m_CmdBackup.LogUseDefaultPath = LogDefaultPath
  m_CmdBackup.DataBaseUseDefaultPath = DataBaseDefaultPath
    
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
    
  opDataBase.Value = True
  chkInitLog.Value = vbChecked
  chkOverWrite.Value = vbChecked
  
  LoadDataBases
  ShowData
  
  FormCenter Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Dim Rslt As VbMsgBoxResult
  
  If m_Changed Then
    Rslt = MsgBox("Desea guardar los cambios?", vbQuestion + vbYesNoCancel)
    If Rslt = vbCancel Then
      Cancel = True
    ElseIf Rslt = vbYes Then
      If Not pSave Then
        Cancel = True
      End If
    End If
  End If

End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  Set m_CmdBackup = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


