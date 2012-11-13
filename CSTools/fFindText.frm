VERSION 5.00
Begin VB.Form fFindText 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Buscar"
   ClientHeight    =   2235
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6240
   Icon            =   "fFindText.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2235
   ScaleWidth      =   6240
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdReplaceAll 
      Caption         =   "&ReemplazarTodas"
      Height          =   330
      Left            =   4545
      TabIndex        =   11
      Top             =   1800
      Width           =   1590
   End
   Begin VB.CheckBox chkMatchCase 
      Caption         =   "Coincidir Mayusculas/Minusculas"
      Height          =   285
      Left            =   1170
      TabIndex        =   8
      Top             =   1800
      Width           =   2985
   End
   Begin VB.CheckBox chkSearchWholeWord 
      Caption         =   "Buscar palabras completas"
      Height          =   285
      Left            =   1170
      TabIndex        =   7
      Top             =   1395
      Width           =   2985
   End
   Begin VB.ComboBox cbDirection 
      Height          =   315
      Left            =   1170
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   945
      Width           =   1680
   End
   Begin VB.CommandButton cmdReplace 
      Caption         =   "&Reemplazar..."
      Height          =   330
      Left            =   4545
      TabIndex        =   4
      Top             =   1350
      Width           =   1590
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   4545
      TabIndex        =   3
      Top             =   585
      Width           =   1590
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "&Buscar siguiente"
      Default         =   -1  'True
      Height          =   330
      Left            =   4545
      TabIndex        =   2
      Top             =   135
      Width           =   1590
   End
   Begin VB.ComboBox cbToSearch 
      Height          =   315
      Left            =   1170
      TabIndex        =   0
      Top             =   135
      Width           =   3210
   End
   Begin VB.ComboBox cbToReplaceWith 
      Height          =   315
      Left            =   1170
      TabIndex        =   9
      Top             =   540
      Visible         =   0   'False
      Width           =   3210
   End
   Begin VB.Label lbDirection 
      Caption         =   "Dirección :"
      Height          =   285
      Left            =   135
      TabIndex        =   5
      Top             =   945
      Width           =   960
   End
   Begin VB.Label Label1 
      Caption         =   "Que buscar :"
      Height          =   285
      Left            =   135
      TabIndex        =   1
      Top             =   135
      Width           =   960
   End
   Begin VB.Label lbToReplaceWith 
      Caption         =   "Reemplazar :"
      Height          =   285
      Left            =   135
      TabIndex        =   10
      Top             =   540
      Visible         =   0   'False
      Width           =   960
   End
End
Attribute VB_Name = "fFindText"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fFindText
' 20-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fFindText"
' estructuras
' variables privadas
Private m_ReplaceActivated      As Boolean

Private m_Command               As csFindReplace
Private m_direction             As csFindReplaceDirection

' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub ShowReplace(ByVal Visible As Boolean)
  Dim state As Boolean
  
  If Visible Then
    cmdReplace.Caption = "Reemplazar"
    state = True
  Else
    cmdReplace.Caption = "Reemplazar..."
    state = False
  End If
  
  m_ReplaceActivated = state
  cbToReplaceWith.Visible = state
  lbToReplaceWith.Visible = state
  cmdReplaceAll.Visible = state
End Sub

' funciones friend
' funciones privadas
Private Sub cmdReplace_Click()
  On Error Resume Next
  
  If Not m_ReplaceActivated Then
    ShowReplace True
  Else
    
  End If
End Sub

Private Sub cmdReplaceAll_Click()
  m_Command = csfrReplaceAll
  Hide
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error Resume Next
  If UnloadMode <> vbFormCode Then
    Cancel = True
    Hide
  End If
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

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


