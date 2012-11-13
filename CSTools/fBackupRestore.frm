VERSION 5.00
Begin VB.Form fBackupRestore 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   5415
   Icon            =   "fBackupRestore.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   5415
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkRestoreInNewDataBase 
      Alignment       =   1  'Right Justify
      Caption         =   "Recuperar en una nueva base de datos :"
      Height          =   240
      Left            =   1980
      TabIndex        =   8
      Top             =   540
      Width           =   3345
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   2610
      TabIndex        =   7
      Top             =   1890
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   4095
      TabIndex        =   6
      Top             =   1890
      Width           =   1275
   End
   Begin VB.CommandButton cmdFindFile 
      Caption         =   "..."
      Height          =   330
      Left            =   5040
      TabIndex        =   4
      Top             =   1215
      Width           =   375
   End
   Begin VB.TextBox txFile 
      Height          =   330
      Left            =   90
      TabIndex        =   3
      Top             =   1215
      Width           =   4920
   End
   Begin VB.CheckBox chkOverWrite 
      Alignment       =   1  'Right Justify
      Caption         =   "Sobre escribir :"
      Height          =   240
      Left            =   90
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.ComboBox cbDataBases 
      Height          =   315
      Left            =   1320
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   135
      Width           =   4035
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   45
      X2              =   5355
      Y1              =   1720
      Y2              =   1720
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   45
      X2              =   5355
      Y1              =   1710
      Y2              =   1710
   End
   Begin VB.Label Label2 
      Caption         =   "Archivo :"
      Height          =   255
      Left            =   135
      TabIndex        =   5
      Top             =   900
      Width           =   1140
   End
   Begin VB.Label Label1 
      Caption         =   "Base de datos :"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   150
      Width           =   1140
   End
End
Attribute VB_Name = "fBackupRestore"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fBackupRestore
' 16-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fBackupRestore"
' estructuras
' variables privadas
Private WithEvents m_Backup As cBackup
Attribute m_Backup.VB_VarHelpID = -1
Private WithEvents m_fProgress As fBackupProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_cancel            As Boolean
Private m_SQLServer         As cSQLServer
Private m_Ok                As Boolean
Private m_Action            As csBackupAction
Private m_Active            As Boolean
Private m_IsForInstall      As Boolean
' eventos
' propiedadades publicas
Public Property Set SQLServer(ByRef rhs As cSQLServer)
  Set m_SQLServer = rhs
  Set m_Backup = rhs.Backup
End Property

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property
Public Property Let Ok(ByVal rhs As Boolean)
  m_Ok = rhs
End Property

Public Property Let Action(ByRef rhs As csBackupAction)
  m_Action = rhs
End Property

Public Property Let IsForInstall(ByVal rhs As Boolean)
  m_IsForInstall = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

Private Sub cbDataBases_Click()
  On Error GoTo ControlError

  If Not m_Active Then Exit Sub

  If txFile.Text <> "" Then
  
    txFile.Text = FileGetValidPath(FileGetPath(txFile.Text)) & cbDataBases.Text & ".bak"
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "cbDataBases_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Activate()
  On Error GoTo ControlError
  If Not m_Active Then
    m_Active = True
    If m_IsForInstall Then
      m_fProgress.IsForInstall = True
      cmdOk_Click
    End If
  End If
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Activate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Backup_Initialize()
  On Error GoTo ControlError

  m_cancel = False
  With m_fProgress
    .prgbProgress.Value = 0
    Set .Backup = m_Backup
    .Action = m_Action
    .lbDataBase.Caption = m_Backup.Database
    .lbServer.Caption = m_Backup.Server
    If m_Action = csBakActionBackup Then
      .lbAction.Caption = "Haciendo un backup de la base"
    Else
      .lbAction.Caption = "Recuperando la base"
    End If
    .Show vbModal
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "m_Backup_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_fProgress.Backup = Nothing
End Sub

Private Sub m_Backup_BackupPercentComplete(ByVal Message As String, ByVal Percent As Long, Cancel As Boolean)
  On Error GoTo ControlError

  Cancel = m_cancel
  
  m_fProgress.prgbProgress.Value = Percent
  DoEvents

  GoTo ExitProc
ControlError:
  MngError Err, "m_Backup_BackupPercentComplete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Backup_RestorePercentComplete(ByVal Message As String, ByVal Percent As Long, Cancel As Boolean)
  On Error GoTo ControlError

  Cancel = m_cancel
  
  m_fProgress.prgbProgress.Value = Percent

  GoTo ExitProc
ControlError:
  MngError Err, "m_Backup_RestorePercentComplete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Backup_Finalize()
  On Error GoTo ControlError

  m_Ok = Not m_cancel

  GoTo ExitProc
ControlError:
  MngError Err, "m_Backup_Finalize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload m_fProgress
End Sub

Private Sub m_fProgress_Cancel()
  m_cancel = True
End Sub

Private Sub cmdFindFile_Click()
  On Error GoTo ControlError
  
  Dim File      As String
  Dim Database  As String
  
  If chkRestoreInNewDataBase.Value = vbUnchecked Then Database = cbDataBases.Text
  
  File = m_Backup.ShowFindFileBackup(Database, txFile.Text, Me.Caption)
  If File <> "" Then txFile.Text = File

  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub chkRestoreInNewDataBase_Click()
  If chkRestoreInNewDataBase.Value = vbChecked Then
    cbDataBases.Enabled = False
    chkOverWrite.Enabled = False
  Else
    cbDataBases.Enabled = True
    chkOverWrite.Enabled = True
  End If
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError

  Dim Init        As Boolean
  Dim OverWrite   As Boolean
  Dim Database    As String
  Dim File        As String
  
  Init = chkOverWrite.Value = vbChecked
  OverWrite = chkOverWrite.Value = vbChecked
  Database = cbDataBases.Text
  File = txFile.Text

  Select Case m_Action
    Case csBackupAction.csBakActionBackup
      If Not m_SQLServer.Backup.BackupStep1(Init, Database, File) Then Exit Sub
    Case csBackupAction.csBakActionRestore
      If Not m_SQLServer.Backup.RestoreStep1(Database, File, OverWrite) Then Exit Sub
  End Select
  
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
  m_Ok = False
  Me.Hide
End Sub

Private Sub LoadDataBases()
  On Error GoTo ControlError
  
  Dim o As cListDataBaseInfo
  Dim coll As Collection
  
  Set coll = m_SQLServer.ListDataBases()
  
  cbDataBases.Clear
  
  For Each o In coll
    If LCase(o.Name) <> "master" Then cbDataBases.AddItem o.Name
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDataBases", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Set m_fProgress = New fBackupProgress
  
  LoadDataBases
  
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
  
  Set m_Backup = Nothing
  Set m_fProgress = Nothing
  Set m_SQLServer = Nothing
  m_Active = False
  
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
