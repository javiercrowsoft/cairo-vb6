VERSION 5.00
Begin VB.Form fTask 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Tarea"
   ClientHeight    =   4890
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6660
   Icon            =   "fTask.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4890
   ScaleWidth      =   6660
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancelar"
      Height          =   330
      Left            =   5085
      TabIndex        =   7
      Top             =   540
      Width           =   1365
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Aceptar"
      Height          =   330
      Left            =   5085
      TabIndex        =   6
      Top             =   135
      Width           =   1365
   End
   Begin VB.Frame Frame2 
      Caption         =   "Programación"
      Height          =   1725
      Left            =   90
      TabIndex        =   5
      Top             =   3060
      Width           =   6450
      Begin VB.PictureBox Picture2 
         BorderStyle     =   0  'None
         Height          =   1395
         Left            =   60
         ScaleHeight     =   1395
         ScaleWidth      =   6255
         TabIndex        =   13
         Top             =   240
         Width           =   6255
         Begin VB.CommandButton cmdDeleteSchedule 
            Caption         =   "Eliminar"
            Height          =   330
            Left            =   4845
            TabIndex        =   17
            Top             =   870
            Width           =   1365
         End
         Begin VB.CommandButton cmdEditSchedule 
            Caption         =   "Modificar"
            Height          =   330
            Left            =   4845
            TabIndex        =   16
            Top             =   465
            Width           =   1365
         End
         Begin VB.CommandButton cmdAddSchedule 
            Caption         =   "Agregar"
            Height          =   330
            Left            =   4845
            TabIndex        =   15
            Top             =   60
            Width           =   1365
         End
         Begin VB.ListBox lsSchedule 
            Height          =   1230
            Left            =   120
            Sorted          =   -1  'True
            TabIndex        =   14
            Top             =   60
            Width           =   4650
         End
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Pasos"
      Height          =   1725
      Left            =   90
      TabIndex        =   4
      Top             =   1215
      Width           =   6450
      Begin VB.PictureBox Picture1 
         BorderStyle     =   0  'None
         Height          =   1395
         Left            =   60
         ScaleHeight     =   1395
         ScaleWidth      =   6315
         TabIndex        =   8
         Top             =   240
         Width           =   6315
         Begin VB.ListBox lsSteps 
            Height          =   1230
            Left            =   120
            Sorted          =   -1  'True
            TabIndex        =   12
            Top             =   60
            Width           =   4650
         End
         Begin VB.CommandButton cmdAddStep 
            Caption         =   "Agregar"
            Height          =   330
            Left            =   4845
            TabIndex        =   11
            Top             =   60
            Width           =   1365
         End
         Begin VB.CommandButton cmdEditStep 
            Caption         =   "Modificar"
            Height          =   330
            Left            =   4845
            TabIndex        =   10
            Top             =   465
            Width           =   1365
         End
         Begin VB.CommandButton cmdDeleteStep 
            Caption         =   "Eliminar"
            Height          =   330
            Left            =   4845
            TabIndex        =   9
            Top             =   870
            Width           =   1365
         End
      End
   End
   Begin VB.ComboBox cbCategory 
      Height          =   315
      Left            =   900
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   630
      Width           =   2910
   End
   Begin VB.TextBox txName 
      Height          =   330
      Left            =   900
      TabIndex        =   1
      Top             =   180
      Width           =   3975
   End
   Begin VB.Label Label2 
      Caption         =   "Categoria :"
      Height          =   285
      Left            =   90
      TabIndex        =   3
      Top             =   630
      Width           =   825
   End
   Begin VB.Label Label1 
      Caption         =   "Nombre :"
      Height          =   285
      Left            =   90
      TabIndex        =   0
      Top             =   180
      Width           =   690
   End
End
Attribute VB_Name = "fTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fTask
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
Private Const C_Module = "fTask"

' estructuras
' variables privadas
Private m_SQLServer         As cSQLServer
Private m_Ok                As Boolean
Private m_Task              As cSQLTask
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Set SQLServer(ByRef rhs As cSQLServer)
  On Error GoTo ControlError

  Set m_SQLServer = rhs
  Set m_Task.Conn = m_SQLServer.Conn

  GoTo ExitProc
ControlError:
  MngError Err, "SQLServer", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Property

Public Property Get Task() As cSQLTask
  Set Task = m_Task
End Property

Public Property Set Task(ByRef rhs As cSQLTask)
  Set m_Task = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function EditTaskScript() As Boolean
  On Error GoTo ControlError

  Dim stp As cISQLTaskStep
  
  For Each stp In m_Task.Steps
    If stp.Name = lsSteps.Text Then Exit For
  Next
  
  Dim f As Object
  
  If stp Is Nothing Then Exit Function
  
  If stp.CmdType = csSchTypeScript Then
    Set f = New fTaskCommandScript
    Set f.SQLServer = m_SQLServer
    Set f.CmdScript = stp
  Else
    Set f = New fTaskCommandBackup
    Set f.SQLServer = m_SQLServer
    Set f.CmdBackup = stp
  End If
    
  f.Show vbModal

  If Not f.Ok Then GoTo ExitProc
  
  LoadSteps

  EditTaskScript = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "EditTaskScript", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Function

Private Function CreateTaskScript() As Boolean
  On Error GoTo ControlError

  Dim f As fTaskCommandScript
  Set f = New fTaskCommandScript
  
  Set f.SQLServer = m_SQLServer
  Set f.CmdScript = New cSQLTaskCommandScript
  
  f.CmdScript.Name = "Paso_" & m_Task.Steps.Count
    
  f.Show vbModal

  If Not f.Ok Then GoTo ExitProc
  
  m_Task.Steps.Add f.CmdScript
  
  LoadSteps

  CreateTaskScript = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "CreateTaskScript", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Function

Private Function CreateTaskBackup() As Boolean
  On Error GoTo ControlError

  Dim f As fTaskCommandBackup
  Set f = New fTaskCommandBackup
  
  Set f.SQLServer = m_SQLServer
  Set f.CmdBackup = New cSQLTaskCommandBackup
  Set f.CmdBackup.Conn = m_SQLServer.Conn
  
  f.CmdBackup.Name = "Paso_" & m_Task.Steps.Count
  
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc

  m_Task.Steps.Add f.CmdBackup
  
  LoadSteps
  
  CreateTaskBackup = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "CreateTaskBackup", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Function

Private Sub cmdAddSchedule_Click()
  On Error GoTo ControlError
  
  Dim f As fSchedule
  Set f = New fSchedule
  
  Set f.Schedule = New cSQLTaskSchedule
  
  f.Schedule.Name = "Programacion_" & m_Task.Schedules.Count
  
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc
  
  m_Task.Schedules.Add f.Schedule
  
  LoadSchedules
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdAddStep_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Sub

Private Sub cmdAddStep_Click()
  On Error GoTo ControlError
  
  Dim f As fNewStep
  Set f = New fNewStep
  
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc
  
  If f.opBackup.Value Then
    CreateTaskBackup
  Else
    CreateTaskScript
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdAddStep_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Sub

Private Sub cmdDeleteSchedule_Click()
  On Error GoTo ControlError

  Dim Id As Long
  Dim Name As String
  Dim sch  As cSQLTaskSchedule
  Dim i    As Integer
  
  Name = lsSchedule.Text
  
  For Each sch In m_Task.Schedules
    i = i + 1
    If sch.Name = Name Then
      Id = i
      Exit For
    End If
  Next
  
  If Id = 0 Then Exit Sub
  
  m_Task.Schedules.Remove Id
  
  lsSchedule.RemoveItem lsSchedule.ListIndex

  GoTo ExitProc
ControlError:
  MngError Err, "cmdDeleteSchedule_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdDeleteStep_Click()
  On Error GoTo ControlError

  Dim Id As Long
  Dim Name As String
  Dim stp  As cISQLTaskStep
  Dim i    As Integer
  
  Name = lsSteps.Text
  
  For Each stp In m_Task.Steps
    i = i + 1
    If stp.Name = Name Then
      Id = i
      Exit For
    End If
  Next
  
  If Id = 0 Then Exit Sub
  
  m_Task.Steps.Remove Id

  lsSteps.RemoveItem lsSteps.ListIndex

  GoTo ExitProc
ControlError:
  MngError Err, "cmdDeleteStep_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdEditSchedule_Click()
  On Error GoTo ControlError
  
  Dim sch As cSQLTaskSchedule
  Dim f As fSchedule
  Set f = New fSchedule
  
  For Each sch In m_Task.Schedules
    If sch.Name = lsSchedule.Text Then Exit For
  Next
  
  If sch Is Nothing Then Exit Sub
  
  Set f.Schedule = sch
  
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc
  
  LoadSchedules
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdEditSchedule_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Sub

Private Sub cmdEditStep_Click()
  On Error GoTo ControlError
  
  EditTaskScript
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdEditStep_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError

  If txName.Text = "" Then
    info "Debe indicar un nombre"
    SetFocusControl txName
    Exit Sub
  End If
  
  If lsSteps.ListCount = 0 Then
    info "Debe definir al menos una programacion"
    Exit Sub
  End If
  
  If lsSchedule.ListCount = 0 Then
    info "Debe definir al menos una programacion"
    Exit Sub
  End If

  m_Ok = True
  
  m_Task.Name = txName.Text
  m_Task.Category = cbCategory.Text
  
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

Private Sub LoadSteps()
  On Error GoTo ControlError

  Dim c As cISQLTaskStep
  
  lsSteps.Clear
  
  For Each c In m_Task.Steps
    AddItemToList lsSteps, c.Name
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "LoadSteps", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub LoadSchedules()
  On Error GoTo ControlError

  Dim c As cSQLTaskSchedule
  
  lsSchedule.Clear
  
  For Each c In m_Task.Schedules
    AddItemToList lsSchedule, c.Name
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "LoadSchedules", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub ShowData()
  txName.Text = m_Task.Name
  
  If SelectItemByText(cbCategory, m_Task.Category) = -1 Then
    AddItemToList cbCategory, m_Task.Category
    SelectItemByText cbCategory, m_Task.Category
  End If
  
  LoadSteps
  LoadSchedules
End Sub

' construccion - destruccion
Private Sub Form_Initialize()
  On Error GoTo ControlError

  Set m_Task = New cSQLTask
  
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError
  
  m_Ok = False
  
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
  Set m_Task = Nothing
  
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



