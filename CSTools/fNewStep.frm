VERSION 5.00
Begin VB.Form fNewStep 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Nuevo paso"
   ClientHeight    =   2010
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3900
   Icon            =   "fNewStep.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2010
   ScaleWidth      =   3900
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   2565
      TabIndex        =   4
      Top             =   1575
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Siguiente"
      Height          =   330
      Left            =   1080
      TabIndex        =   3
      Top             =   1575
      Width           =   1275
   End
   Begin VB.OptionButton opScript 
      Caption         =   "Comando SQL o del sistema operativo"
      Height          =   375
      Left            =   315
      TabIndex        =   1
      Top             =   945
      Width           =   3390
   End
   Begin VB.OptionButton opBackup 
      Caption         =   "Tarea de backup de base de datos"
      Height          =   375
      Left            =   315
      TabIndex        =   0
      Top             =   450
      Width           =   3300
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   5310
      Y1              =   1440
      Y2              =   1440
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   5310
      Y1              =   1455
      Y2              =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "¿Que desea hacer?"
      Height          =   285
      Left            =   45
      TabIndex        =   2
      Top             =   90
      Width           =   2805
   End
End
Attribute VB_Name = "fNewStep"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fNewStep
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSchedule"

' estructuras
' variables privadas
Private m_Ok            As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  On Error GoTo ControlError

  m_Ok = False
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdCancel_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError
  
  m_Ok = True
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancel_Click
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_QueryUnload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  opBackup.Value = True
  m_Ok = False
  FormCenter Me
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
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


