VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form fNewDatabaseFromScript 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Nueva base de datos desde script"
   ClientHeight    =   3450
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6510
   Icon            =   "fNewDatabaseFromScript.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3450
   ScaleWidth      =   6510
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   330
      Left            =   3915
      TabIndex        =   9
      Top             =   3060
      Width           =   1185
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   330
      Left            =   5220
      TabIndex        =   8
      Top             =   3060
      Width           =   1185
   End
   Begin VB.TextBox txFile 
      Height          =   285
      Left            =   180
      TabIndex        =   5
      Top             =   2385
      Width           =   5685
   End
   Begin VB.CommandButton cmdFindFileScript 
      Caption         =   "..."
      Height          =   285
      Left            =   5985
      TabIndex        =   4
      Top             =   2385
      Width           =   375
   End
   Begin VB.TextBox txFiledb 
      Height          =   285
      Left            =   180
      TabIndex        =   3
      Top             =   1575
      Width           =   5685
   End
   Begin VB.CommandButton cmdFindFileScriptdb 
      Caption         =   "..."
      Height          =   285
      Left            =   5985
      TabIndex        =   2
      Top             =   1575
      Width           =   375
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   6500
      Y1              =   2895
      Y2              =   2895
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   6500
      Y1              =   2880
      Y2              =   2880
   End
   Begin VB.Label lbDescrip 
      BackColor       =   &H80000005&
      Caption         =   $"fNewDatabaseFromScript.frx":000C
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   645
      Left            =   360
      TabIndex        =   6
      Top             =   225
      Width           =   6045
   End
   Begin VB.Label Label2 
      Caption         =   "Definicion de los comandos :"
      Height          =   240
      Left            =   180
      TabIndex        =   1
      Top             =   2025
      Width           =   2400
   End
   Begin VB.Label Label1 
      Caption         =   "Definicion de la base de datos :"
      Height          =   240
      Left            =   180
      TabIndex        =   0
      Top             =   1215
      Width           =   2400
   End
   Begin VB.Label lbDescripBack 
      BackColor       =   &H80000005&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1005
      Left            =   0
      TabIndex        =   7
      Top             =   0
      Width           =   6675
   End
End
Attribute VB_Name = "fNewDatabaseFromScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fNewDatabaseFromScript
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fNewDatabaseFromScript"
' estructuras
' variables privadas
Private m_Ok                            As Boolean

' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

Public Property Let Ok(ByVal rhs As Boolean)
   m_Ok = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Me.Hide
End Sub

#If PREPROC_INSTALL = 0 Then

Private Sub cmdFindFileScriptdb_Click()
  On Error GoTo ControlError
  
  Dim File As String
  Dim Cancel As Boolean
  
  File = txFiledb.Text
  
  FindFile cd, File, Cancel, c_str_defDb
  
  If Cancel Then Exit Sub
  
  txFiledb.Text = File
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFileScriptdb_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdFindFileScript_Click()
  On Error GoTo ControlError
  
  Dim File As String
  Dim Cancel As Boolean
  
  File = txFile.Text
  
  FindFile cd, File, Cancel, c_str_defCommand
  
  If Cancel Then Exit Sub
  
  txFile.Text = File
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFileScript_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

#End If

' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  m_Ok = False
  CenterForm Me
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    cmdCancel_Click
    Cancel = True
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

