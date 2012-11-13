VERSION 5.00
Begin VB.Form fTaskCommandBackup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Tarea de backup"
   ClientHeight    =   5175
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5745
   Icon            =   "fTaskCommandBackup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5175
   ScaleWidth      =   5745
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txName 
      Height          =   300
      Left            =   1125
      TabIndex        =   1
      Top             =   135
      Width           =   4335
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   4410
      TabIndex        =   8
      Top             =   4770
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   2925
      TabIndex        =   7
      Top             =   4770
      Width           =   1275
   End
   Begin VB.Frame Frame2 
      Caption         =   "Archivos"
      Height          =   1770
      Left            =   90
      TabIndex        =   6
      Top             =   2790
      Width           =   5595
      Begin VB.PictureBox Picture2 
         BorderStyle     =   0  'None
         Height          =   1455
         Left            =   60
         ScaleHeight     =   1455
         ScaleWidth      =   5475
         TabIndex        =   13
         Top             =   240
         Width           =   5475
         Begin VB.CommandButton cmdFindFile 
            Caption         =   "..."
            Height          =   330
            Left            =   5010
            TabIndex        =   19
            Top             =   330
            Width           =   375
         End
         Begin VB.TextBox txFile 
            Height          =   330
            Left            =   60
            TabIndex        =   18
            Top             =   330
            Width           =   4920
         End
         Begin VB.CommandButton cmdFileLog 
            Caption         =   "..."
            Height          =   330
            Left            =   5010
            TabIndex        =   17
            Top             =   1050
            Width           =   375
         End
         Begin VB.TextBox txFileLog 
            Height          =   330
            Left            =   60
            TabIndex        =   16
            Top             =   1050
            Width           =   4920
         End
         Begin VB.CheckBox chkDataBaseFileDefault 
            Caption         =   "Path por defecto"
            Height          =   240
            Left            =   2220
            TabIndex        =   15
            Top             =   60
            Width           =   2940
         End
         Begin VB.CheckBox chkLofFileDefault 
            Caption         =   "Path por defecto"
            Height          =   240
            Left            =   2220
            TabIndex        =   14
            Top             =   780
            Width           =   2940
         End
         Begin VB.Label Label2 
            Caption         =   "Base de datos :"
            Height          =   195
            Left            =   60
            TabIndex        =   21
            Top             =   60
            Width           =   1410
         End
         Begin VB.Label Label3 
            Caption         =   "Log de transacciones :"
            Height          =   195
            Left            =   60
            TabIndex        =   20
            Top             =   780
            Width           =   1815
         End
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Tipo"
      Height          =   1140
      Left            =   90
      TabIndex        =   5
      Top             =   1485
      Width           =   5595
      Begin VB.PictureBox Picture1 
         BorderStyle     =   0  'None
         Height          =   675
         Left            =   540
         ScaleHeight     =   675
         ScaleWidth      =   4635
         TabIndex        =   9
         Top             =   360
         Width           =   4635
         Begin VB.CheckBox chkInitLog 
            Caption         =   "Inicializar el Log"
            Height          =   240
            Left            =   1875
            TabIndex        =   12
            Top             =   30
            Width           =   1680
         End
         Begin VB.OptionButton opDataBase 
            Caption         =   "Base de datos"
            Height          =   330
            Left            =   0
            TabIndex        =   11
            Top             =   0
            Width           =   2175
         End
         Begin VB.OptionButton opLog 
            Caption         =   "Log de transacciones"
            Height          =   330
            Left            =   0
            TabIndex        =   10
            Top             =   360
            Width           =   2220
         End
      End
   End
   Begin VB.ComboBox cbDataBases 
      Height          =   315
      Left            =   1320
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   720
      Width           =   4035
   End
   Begin VB.CheckBox chkOverWrite 
      Alignment       =   1  'Right Justify
      Caption         =   "Sobre escribir :"
      Height          =   240
      Left            =   90
      TabIndex        =   2
      Top             =   1125
      Width           =   1410
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   6000
      Y1              =   555
      Y2              =   555
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   6000
      Y1              =   540
      Y2              =   540
   End
   Begin VB.Label Label6 
      Caption         =   "Nombre :"
      Height          =   330
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   825
   End
   Begin VB.Label Label1 
      Caption         =   "Base de datos :"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   735
      Width           =   1140
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
Private m_CmdBackup         As cSQLTaskCommandBackup
Private m_SQLServer         As cSQLServer
Private m_Ok                As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Set SQLServer(ByRef rhs As cSQLServer)
  Set m_SQLServer = rhs
End Property

Public Property Set CmdBackup(ByRef rhs As cSQLTaskCommandBackup)
  Set m_CmdBackup = rhs
End Property

Public Property Get CmdBackup() As cSQLTaskCommandBackup
  Set CmdBackup = m_CmdBackup
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub LoadDataBases()
  On Error GoTo ControlError
  
  Dim o As cListDataBaseInfo
  Dim coll As Collection
  
  Set coll = m_SQLServer.ListDataBases()
  
  cbDataBases.Clear
  
  For Each o In coll
    If LCase(o.Name) <> "master" Then cbDataBases.AddItem o.Name
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
  Path = FileGetPath(txFile.Text)
  If Path <> "" Then Path = FileGetValidPath(Path)
  txFile.Text = Path & cbDataBases.Text & "_dat"

  Path = FileGetPath(txFileLog.Text)
  If Path <> "" Then Path = FileGetValidPath(Path)
  txFileLog.Text = Path & cbDataBases.Text & "_log"
End Sub

Private Sub chkDataBaseFileDefault_Click()
  cmdFindFile.Enabled = chkDataBaseFileDefault.Value <> vbChecked
  txFile.Text = FileGetName(txFile.Text)
End Sub

Private Sub chkLofFileDefault_Click()
  cmdFileLog.Enabled = chkLofFileDefault.Value <> vbChecked
  txFileLog.Text = FileGetName(txFileLog.Text)
End Sub

Private Sub cmdFileLog_Click()
  On Error GoTo ControlError
  
  Dim File      As String
  Dim Database  As String
  
  Database = cbDataBases.Text & "_log.dat"
  
  File = m_CmdBackup.ShowFindFileBackup(Database, txFileLog.Text, Me.Caption)
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
  Dim Database  As String
  
  Database = cbDataBases.Text & "_db.dat"
  
  File = m_CmdBackup.ShowFindFileBackup(Database, txFile.Text, Me.Caption)
  If File <> "" Then txFile.Text = File

  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError

  Dim Init        As Boolean
  Dim OverWrite   As Boolean
  Dim Database    As String
  Dim FileDataBase As String
  Dim FileLog     As String
  Dim IsFull      As Boolean
  Dim LogDefaultPath        As Boolean
  Dim DataBaseDefaultPath   As Boolean
  
  Init = chkInitLog.Value = vbChecked
  OverWrite = chkOverWrite.Value = vbChecked
  Database = cbDataBases.Text
  FileDataBase = txFile.Text
  FileLog = txFileLog.Text
  IsFull = opDataBase.Value
  
  If FileDataBase = "" Then
    info "Debe indicar el nombre del archibo de backup para la base de datos"
    SetFocusControl txFile
    Exit Sub
  End If
  
  If FileLog = "" Then
    info "Debe indicar el nombre del archibo de backup para el log de transacciones"
    SetFocusControl txFileLog
    Exit Sub
  End If

  DataBaseDefaultPath = chkDataBaseFileDefault.Value = vbChecked
  LogDefaultPath = chkLofFileDefault.Value = vbChecked

  m_CmdBackup.Database = Database
  m_CmdBackup.InitLog = Init
  m_CmdBackup.IsFull = IsFull
  m_CmdBackup.IsLog = Not IsFull
  m_CmdBackup.FileDataBase = FileDataBase
  m_CmdBackup.FileLog = FileLog
  m_CmdBackup.OverWrite = OverWrite
  m_CmdBackup.LogUseDefaultPath = LogDefaultPath
  m_CmdBackup.DataBaseUseDefaultPath = DataBaseDefaultPath
  
  m_Ok = True
  
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  Me.Hide
End Sub

Private Sub opDataBase_Click()
  chkInitLog.Enabled = True
End Sub

Private Sub opLog_Click()
  chkInitLog.Enabled = False
End Sub

Private Sub ShowData()
  If m_CmdBackup.Database = "" Then Exit Sub
  txName.Text = m_CmdBackup.Name
  SelectItemByText cbDataBases, m_CmdBackup.Database
  txFile.Text = m_CmdBackup.FileDataBase
  txFileLog.Text = m_CmdBackup.FileLog
  chkDataBaseFileDefault.Value = IIf(m_CmdBackup.DataBaseUseDefaultPath, vbChecked, vbUnchecked)
  chkLofFileDefault.Value = IIf(m_CmdBackup.LogUseDefaultPath, vbChecked, vbUnchecked)
  chkInitLog.Value = IIf(m_CmdBackup.InitLog, vbChecked, vbUnchecked)
  chkOverWrite.Value = IIf(m_CmdBackup.OverWrite, vbChecked, vbUnchecked)
  opDataBase.Value = m_CmdBackup.IsLog = False
  opLog.Value = m_CmdBackup.IsLog = True
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
  If UnloadMode <> vbFormCode Then
    Cancel = True
    m_Ok = False
    Me.Hide
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  Set m_SQLServer = Nothing
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


