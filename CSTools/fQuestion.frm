VERSION 5.00
Begin VB.Form fQuestion 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form1"
   ClientHeight    =   1770
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5295
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1770
   ScaleWidth      =   5295
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&No"
      Height          =   330
      Left            =   3870
      TabIndex        =   3
      Top             =   1350
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Si"
      Height          =   330
      Left            =   2385
      TabIndex        =   2
      Top             =   1350
      Width           =   1275
   End
   Begin VB.CheckBox chkQuestionAgain 
      Caption         =   "Volver a mostrar este mensaje"
      Height          =   240
      Left            =   720
      TabIndex        =   1
      Top             =   810
      Width           =   2625
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   5310
      Y1              =   1215
      Y2              =   1215
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   5310
      Y1              =   1230
      Y2              =   1230
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fQuestion.frx":0000
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label1 
      Caption         =   "¿Desea cargar Intelisense para esta base de datos?"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Left            =   720
      TabIndex        =   0
      Top             =   225
      Width           =   4470
   End
End
Attribute VB_Name = "fQuestion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
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
Private Const C_Module = "cWindow"
' estructuras
' variables privadas
Private m_Ok                As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Me.Hide
End Sub

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  chkQuestionAgain.Value = vbChecked
  Me.Caption = "Intelisense"
  FormCenter Me
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancel_Click
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  SaveMainIniEdit c_K_EditQuestionAgain, chkQuestionAgain.Value = vbChecked
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

