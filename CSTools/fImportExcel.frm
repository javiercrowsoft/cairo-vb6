VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "Mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Begin VB.Form fImportExcel 
   Caption         =   "Importar desde Excel"
   ClientHeight    =   3390
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7530
   LinkTopic       =   "Form1"
   ScaleHeight     =   3390
   ScaleWidth      =   7530
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lsTables 
      Height          =   840
      Left            =   45
      TabIndex        =   8
      Top             =   675
      Width           =   4470
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   6075
      TabIndex        =   6
      Top             =   2925
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   4590
      TabIndex        =   5
      Top             =   2925
      Width           =   1275
   End
   Begin VB.TextBox txTable 
      Height          =   285
      Left            =   45
      TabIndex        =   3
      Top             =   2025
      Width           =   2310
   End
   Begin VB.TextBox txFile 
      Height          =   285
      Left            =   45
      TabIndex        =   1
      Top             =   360
      Width           =   6945
   End
   Begin VB.CommandButton cmdFindFile 
      Caption         =   "..."
      Height          =   285
      Left            =   7110
      TabIndex        =   0
      Top             =   360
      Width           =   375
   End
   Begin MSComctlLib.ProgressBar prgbProgress 
      Height          =   285
      Left            =   45
      TabIndex        =   7
      Top             =   2430
      Width           =   7440
      _ExtentX        =   13123
      _ExtentY        =   503
      _Version        =   393216
      BorderStyle     =   1
      Appearance      =   0
      Scrolling       =   1
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   3870
      Top             =   1710
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   7650
      Y1              =   2805
      Y2              =   2805
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   7650
      Y1              =   2790
      Y2              =   2790
   End
   Begin VB.Label Label1 
      Caption         =   "Tabla:"
      Height          =   240
      Left            =   45
      TabIndex        =   4
      Top             =   1755
      Width           =   1410
   End
   Begin VB.Label Label2 
      Caption         =   "Archivo:"
      Height          =   240
      Left            =   45
      TabIndex        =   2
      Top             =   90
      Width           =   1410
   End
End
Attribute VB_Name = "fImportExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fImportExcel
' 30-01-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fImportExcel"
' estructuras
' variables privadas
Private m_Ok            As Boolean

' eventos
Public Event FindFile(ByRef File As String, ByRef Cancel As Boolean)
Public Event ImportExcel(ByRef Success As Boolean)
Public Event OpenExcel(ByRef Success As Boolean)

' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Private Sub cmdCancel_Click()
  Me.Hide
  m_Ok = False
End Sub

' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdFindFile_Click()
  On Error GoTo ControlError
  
  Dim File As String
  Dim Cancel As Boolean
  
  File = txFile.Text
  
  RaiseEvent FindFile(File, Cancel)
  
  If Cancel Then Exit Sub
  
  txFile.Text = File
  
  Dim Success As Boolean
  RaiseEvent OpenExcel(Success)
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError
  
  Dim Success As Boolean
  
  RaiseEvent ImportExcel(Success)
  
  If Success Then
    m_Ok = True
    Me.Hide
  End If
  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Form_Load()
  m_Ok = False
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
