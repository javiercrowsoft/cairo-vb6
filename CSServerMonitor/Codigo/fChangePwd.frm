VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fChangePwd 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Cambiar Clave"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4500
   Icon            =   "fChangePwd.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   4500
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMaskEdit txConfirm 
      Height          =   315
      Left            =   1680
      TabIndex        =   5
      Top             =   1200
      Width           =   2655
      _ExtentX        =   4683
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
      Left            =   1860
      TabIndex        =   6
      Top             =   1860
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
      Left            =   3180
      TabIndex        =   7
      Top             =   1860
      Width           =   1140
      _ExtentX        =   2011
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
   End
   Begin CSMaskEdit2.cMaskEdit txNewPassword 
      Height          =   315
      Left            =   1680
      TabIndex        =   3
      Top             =   720
      Width           =   2655
      _ExtentX        =   4683
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
   Begin CSMaskEdit2.cMaskEdit txPassword 
      Height          =   315
      Left            =   1680
      TabIndex        =   1
      Top             =   240
      Width           =   2655
      _ExtentX        =   4683
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
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -10
      X2              =   5000
      Y1              =   1680
      Y2              =   1680
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "&Nueva :"
      Height          =   255
      Left            =   840
      TabIndex        =   2
      Top             =   780
      Width           =   645
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Clave :"
      Height          =   255
      Left            =   840
      TabIndex        =   0
      Top             =   300
      Width           =   645
   End
   Begin VB.Image Image3 
      Height          =   480
      Left            =   120
      Picture         =   "fChangePwd.frx":058A
      Top             =   255
      Width           =   480
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "&Confirma :"
      Height          =   255
      Left            =   855
      TabIndex        =   4
      Top             =   1260
      Width           =   765
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      Height          =   2475
      Left            =   -60
      Top             =   -60
      Width           =   5415
   End
End
Attribute VB_Name = "fChangePwd"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fChangePwd
' 27-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fChangePwd"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas

' funciones privadas
Private Sub cmdCancel_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError
  
  Dim ErrorMsg As String
  
  If Login(txPassword.Text, ErrorMsg) Then
    If txNewPassword.Text <> txConfirm.Text Then
      CSKernelClient2.MsgWarning "La nueva clave no coincide con su confirmación", "Cambiar Clave"
    Else
      pSavePassword
    End If
  Else
    CSKernelClient2.MsgWarning ErrorMsg, "Cambiar Clave"
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones friend
' funciones privadas
Private Sub pSavePassword()
  Dim sqlstmt   As String
  Dim db        As cDataBase
  Dim Connstr   As String
  Dim ErrorMsg  As String
  Dim Encrypt   As cEncrypt
  
  If Not GetConnstrToDomain(Connstr, ErrorMsg) Then
    CSKernelClient2.MsgWarning ErrorMsg, "Cambiar Clave"
  Else
    Set db = New cDataBase
    Set Encrypt = New cEncrypt
    
    If Not db.InitDB(, , , , Connstr) Then Exit Sub
    sqlstmt = "sp_SysDomainUpdatePwd " & db.sqlString(Encrypt.Encript(txNewPassword.Text, c_LoginSignature))
    
    If Not db.Execute(sqlstmt) Then Exit Sub
    
    MsgInfo "La clave se cambio con exito"
  End If
End Sub

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
