VERSION 5.00
Begin VB.Form fConfig 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Configuracion"
   ClientHeight    =   1995
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5550
   Icon            =   "fConfig.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1995
   ScaleWidth      =   5550
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox tnPort 
      Height          =   330
      Left            =   1935
      TabIndex        =   1
      Top             =   720
      Width           =   1140
   End
   Begin VB.TextBox txServer 
      Height          =   330
      Left            =   1935
      TabIndex        =   0
      Top             =   315
      Width           =   2805
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   330
      Left            =   2835
      TabIndex        =   2
      Top             =   1530
      Width           =   1185
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   4095
      TabIndex        =   3
      Top             =   1530
      Width           =   1185
   End
   Begin VB.Image Image1 
      Height          =   675
      Left            =   240
      Picture         =   "fConfig.frx":058A
      Top             =   360
      Width           =   675
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000016&
      X1              =   -195
      X2              =   10005
      Y1              =   1380
      Y2              =   1380
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Port :"
      Height          =   240
      Left            =   1170
      TabIndex        =   5
      Top             =   720
      Width           =   645
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Server :"
      Height          =   240
      Left            =   1170
      TabIndex        =   4
      Top             =   360
      Width           =   645
   End
End
Attribute VB_Name = "fConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fConfig
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fConfig"
' estructuras
' variables privadas
Private m_ok                            As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
   Ok = m_ok
End Property

Public Property Let Ok(ByVal rhs As Boolean)
   m_ok = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  m_ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  Dim Server As String
  Dim Port   As Integer
  
  SaveConfig
  
  Server = IniGet(c_K_Server, "")
  Port = Val(IniGet(c_k_Port, ""))
  
  If Server = "" Then
    MsgError "Debe indicar un servidor en el archivo " & c_MainIniFile
    Exit Sub
  ElseIf Port = 0 Then
    MsgError "Debe indicar un port en el archivo " & c_MainIniFile
    Exit Sub
  End If
  
  m_ok = True
  Me.Hide
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  LoadForm Me, Me.name
  m_ok = False

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  UnloadForm Me, Me.name
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    m_ok = False
    Me.Hide
    Cancel = True
  End If
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyEscape Then
    m_ok = False
    Me.Hide
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

