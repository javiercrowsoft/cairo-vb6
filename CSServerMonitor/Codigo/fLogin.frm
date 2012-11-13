VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fLogin 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Login"
   ClientHeight    =   3165
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4905
   Icon            =   "fLogin.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3165
   ScaleWidth      =   4905
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMaskEdit TxPassword 
      Height          =   315
      Left            =   1350
      TabIndex        =   0
      Top             =   1935
      Width           =   2805
      _ExtentX        =   4948
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      PasswordChar    =   "*"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdOk 
      Default         =   -1  'True
      Height          =   315
      Left            =   2295
      TabIndex        =   1
      Top             =   2745
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   556
      Caption         =   "&Aceptar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButton cmdCancel 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   3555
      TabIndex        =   2
      Top             =   2745
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   556
      Caption         =   "&Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   -60
      X2              =   10045
      Y1              =   2625
      Y2              =   2625
   End
   Begin VB.Image Image1 
      Height          =   1500
      Left            =   180
      Picture         =   "fLogin.frx":000C
      Top             =   180
      Width           =   3360
   End
   Begin VB.Image Image3 
      Height          =   360
      Left            =   585
      Picture         =   "fLogin.frx":2E82
      Top             =   1935
      Width           =   600
   End
End
Attribute VB_Name = "fLogin"
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
Private m_Password    As String
Private m_ok          As Boolean
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
End Sub

Private Sub cmdOk_Click()
  Dim ErrorMsg As String
  
  m_Password = txPassword.Text
  
  If Login(m_Password, ErrorMsg) Then
    Ok = True
    Me.Hide
  Else
    CSKernelClient2.MsgWarning ErrorMsg, "Login"
  End If
End Sub

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  CSKernelClient2.LoadForm Me, Me.name
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  CSKernelClient2.UnloadForm Me, Me.name
  
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
