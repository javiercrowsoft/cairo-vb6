VERSION 5.00
Begin VB.Form fLogin2 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Login"
   ClientHeight    =   4800
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5295
   Icon            =   "fLogin2.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4800
   ScaleWidth      =   5295
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkNTSecurity 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00FFFFFF&
      Caption         =   "Seguridad por NT"
      Height          =   240
      Left            =   270
      TabIndex        =   4
      Top             =   3645
      Width           =   1725
   End
   Begin VB.TextBox txPassword 
      Height          =   330
      IMEMode         =   3  'DISABLE
      Left            =   1395
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   3180
      Width           =   2805
   End
   Begin VB.TextBox txUser 
      Height          =   330
      IMEMode         =   3  'DISABLE
      Left            =   1395
      TabIndex        =   2
      Top             =   2760
      Width           =   2805
   End
   Begin VB.TextBox txDatabase 
      Height          =   330
      IMEMode         =   3  'DISABLE
      Left            =   1395
      TabIndex        =   1
      Top             =   2340
      Width           =   2805
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   3510
      TabIndex        =   6
      Top             =   4290
      Width           =   1185
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   330
      Left            =   2250
      TabIndex        =   5
      Top             =   4290
      Width           =   1185
   End
   Begin VB.TextBox txServer 
      Height          =   330
      IMEMode         =   3  'DISABLE
      Left            =   1395
      TabIndex        =   0
      Top             =   1935
      Width           =   2805
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Clave"
      Height          =   255
      Left            =   300
      TabIndex        =   10
      Top             =   3225
      Width           =   975
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Usuario"
      Height          =   255
      Left            =   300
      TabIndex        =   9
      Top             =   2805
      Width           =   975
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Base"
      Height          =   255
      Left            =   300
      TabIndex        =   8
      Top             =   2385
      Width           =   975
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Servidor"
      Height          =   255
      Left            =   300
      TabIndex        =   7
      Top             =   1980
      Width           =   975
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000016&
      X1              =   -60
      X2              =   10045
      Y1              =   4170
      Y2              =   4170
   End
   Begin VB.Image Image1 
      Height          =   1500
      Left            =   180
      Picture         =   "fLogin2.frx":000C
      Top             =   180
      Width           =   3360
   End
End
Attribute VB_Name = "fLogin2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fLogin
' 29-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fLogin"

' estructuras
' variables privadas
Private m_ok          As Boolean
Private m_bDone       As Boolean
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

' funciones privadas
Private Sub cmdCancel_Click()
  Ok = False
  Me.Hide
  m_bDone = False
End Sub

Private Sub cmdOk_Click()
  Dim ErrorMsg As String
  
  Ok = True
  Me.Hide
  m_bDone = False
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  If m_bDone Then Exit Sub
  m_bDone = True
  txPassword.SetFocus
End Sub

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  txDatabase.Text = "cairo_dominio"
  txServer.Text = IniGet(c_K_Server, "")
  txUser.Text = "sa"
  chkNTSecurity.Value = vbUnchecked

  LoadForm Me, Me.name
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  UnloadForm Me, Me.name
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
