VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fChangePassword 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Cambiar Contraseña"
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5310
   Icon            =   "fChangePassword.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2400
   ScaleWidth      =   5310
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txVerify 
      BorderStyle     =   0  'None
      Height          =   195
      IMEMode         =   3  'DISABLE
      Left            =   2100
      PasswordChar    =   "*"
      TabIndex        =   4
      Top             =   1260
      Width           =   3015
   End
   Begin VB.TextBox txNewPassword 
      BorderStyle     =   0  'None
      Height          =   195
      IMEMode         =   3  'DISABLE
      Left            =   2100
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   780
      Width           =   3015
   End
   Begin VB.TextBox txOldPwd 
      BorderStyle     =   0  'None
      Height          =   195
      IMEMode         =   3  'DISABLE
      Left            =   2100
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   300
      Width           =   3015
   End
   Begin CSButton.cButtonLigth cmdApply 
      Height          =   315
      Left            =   2580
      TabIndex        =   0
      Top             =   1980
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
      Caption         =   "&Aplicar"
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
      ForeColor       =   0
      BorderColor     =   8421504
   End
   Begin CSButton.cButtonLigth cmdClose 
      Height          =   315
      Left            =   3960
      TabIndex        =   1
      Top             =   1980
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   556
      Caption         =   "&Cerrar"
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
      ForeColor       =   0
      BorderColor     =   8421504
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   5340
      Y1              =   1800
      Y2              =   1800
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Confirmación"
      Height          =   315
      Left            =   840
      TabIndex        =   7
      Top             =   1260
      Width           =   1035
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Nueva Clave"
      Height          =   315
      Left            =   840
      TabIndex        =   6
      Top             =   780
      Width           =   1035
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Clave Actual"
      Height          =   315
      Left            =   840
      TabIndex        =   5
      Top             =   300
      Width           =   1035
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   120
      Picture         =   "fChangePassword.frx":058A
      Top             =   180
      Width           =   480
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H80000010&
      Height          =   315
      Left            =   2040
      Top             =   1200
      Width           =   3135
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000010&
      Height          =   315
      Left            =   2040
      Top             =   720
      Width           =   3135
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   315
      Left            =   2040
      Top             =   240
      Width           =   3135
   End
End
Attribute VB_Name = "fChangePassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fChangePassword
' 18-06-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fChangePassword"

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdApply_Click()
  On Error GoTo ControlError
  
  Dim Encrypt As CSEncrypt.cEncrypt
  Set Encrypt = New CSEncrypt.cEncrypt

  If LCase(txOldPwd.Text) <> LCase(User.Password) Then
    MsgWarning "La clave es incorrecta"
    Exit Sub
  End If
  
  If LCase(txNewPassword.Text) <> LCase(txVerify.Text) Then
    MsgWarning "La nueva clave y su confirmación no coinciden"
    Exit Sub
  End If
  
  If User.ChangePassword(txNewPassword.Text) Then
    MsgInfo "La clave se cambio con éxito"
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "cmdApply_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdClose_Click()
  Unload Me
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  CSKernelClient2.LoadForm Me, Me.Caption

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  CSKernelClient2.UnloadForm Me, Me.Caption

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
