VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fBackupProgress 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Progreso..."
   ClientHeight    =   2775
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4545
   Icon            =   "fBackupProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2775
   ScaleWidth      =   4545
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   1710
      TabIndex        =   5
      Top             =   2385
      Width           =   1275
   End
   Begin MSComctlLib.ProgressBar prgbProgress 
      Height          =   285
      Left            =   105
      TabIndex        =   2
      Top             =   1935
      Width           =   4350
      _ExtentX        =   7673
      _ExtentY        =   503
      _Version        =   393216
      Appearance      =   0
      Scrolling       =   1
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   435
      Left            =   60
      Top             =   1860
      Width           =   4455
   End
   Begin VB.Label lbServer 
      Alignment       =   2  'Center
      BackColor       =   &H80000010&
      Caption         =   "Medea"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   225
      Left            =   885
      TabIndex        =   4
      Top             =   1260
      Width           =   2925
   End
   Begin VB.Label Label3 
      Caption         =   "En el servidor :"
      Height          =   285
      Left            =   45
      TabIndex        =   3
      Top             =   1035
      Width           =   1140
   End
   Begin VB.Label lbDataBase 
      Alignment       =   2  'Center
      BackColor       =   &H80000010&
      Caption         =   "Cairo"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   225
      Left            =   900
      TabIndex        =   1
      Top             =   450
      Width           =   2925
   End
   Begin VB.Label lbAction 
      Caption         =   "Recuperando el backup de la base :"
      Height          =   330
      Left            =   90
      TabIndex        =   0
      Top             =   135
      Width           =   2670
   End
End
Attribute VB_Name = "fBackupProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fBackupProgress
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
Private Const C_Module = "fBackupProgress"
' estructuras
' variables privadas
Private m_Backup As cBackup
Private m_Action            As csBackupAction
Private m_IsForInstall      As Boolean
' eventos
Public Event Cancel()
' propiedadades publicas
Public Property Set Backup(ByRef rhs As cBackup)
  Set m_Backup = rhs
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
Private Sub cmdCancel_Click()
  On Error GoTo ControlError

  If Ask("Desea cancelar el proceso") Then RaiseEvent Cancel
  
  Hide
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdCancel_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  DoEvents
  Select Case m_Action
    Case csBackupAction.csBakActionBackup
      If m_Backup.BackupStep2() Then
        DoEvents
        If Not m_IsForInstall Then
          info "El backup se realizo con éxito"
        End If
      End If
    Case csBackupAction.csBakActionRestore
      If m_Backup.RestoreStep2() Then
        DoEvents
        If Not m_IsForInstall Then
          info "El restore se realizo con éxito"
        End If
      End If
  End Select
  Me.Hide
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  prgbProgress.Min = 0
  prgbProgress.Max = 100
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
    cmdCancel_Click
  End If
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

