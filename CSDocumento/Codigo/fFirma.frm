VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.0#0"; "CSHelp2.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fFirma 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Firmar"
   ClientHeight    =   2250
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5550
   BeginProperty Font 
      Name            =   "Marlett"
      Size            =   12
      Charset         =   2
      Weight          =   500
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "fFirma.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2250
   ScaleWidth      =   5550
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMaskEdit txPassword 
      Height          =   315
      Left            =   1560
      TabIndex        =   6
      Top             =   1620
      Width           =   2475
      _ExtentX        =   4366
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
      ForeColor       =   0
      PasswordChar    =   "*"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSHelp2.cHelp hlUsuario 
      Height          =   315
      Left            =   1560
      TabIndex        =   5
      Top             =   1140
      Width           =   2475
      _ExtentX        =   4366
      _ExtentY        =   556
      BorderType      =   1
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
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   4140
      TabIndex        =   1
      Top             =   1620
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "Cancelar"
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
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   4140
      TabIndex        =   0
      Top             =   1140
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
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
   Begin VB.Image Image3 
      Height          =   480
      Left            =   210
      Picture         =   "fFirma.frx":058A
      Top             =   1545
      Width           =   480
   End
   Begin VB.Image Image5 
      Height          =   480
      Left            =   180
      Picture         =   "fFirma.frx":1254
      Top             =   1020
      Width           =   480
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "&Clave :"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   885
      TabIndex        =   4
      Top             =   1650
      Width           =   1005
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "&Usuario :"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   870
      TabIndex        =   3
      Top             =   1170
      Width           =   1005
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Ingrese la firma"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   840
      TabIndex        =   2
      Top             =   180
      Width           =   1965
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   180
      Picture         =   "fFirma.frx":1B1E
      Top             =   120
      Width           =   480
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   735
      Left            =   -420
      Top             =   0
      Width           =   6135
   End
End
Attribute VB_Name = "fFirma"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fFirma
' 16-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fFirma"
Private Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"
' estructuras
' variables privadas
Private m_Us_id                         As Long

' eventos
' propiedades publicas
Public Property Get Us_id() As Long
   Us_id = m_Us_id
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub SetFilter(ByVal Users As String)
  hlUsuario.Filter = "us_id in (" & Users & ")"
End Sub


' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  On Error GoTo ControlError

  m_Us_id = 0
  Unload Me

  GoTo ExitProc
ControlError:
  MngError Err, "cmdCancel_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Encrypt As cEncrypt
  
  Set Encrypt = New cEncrypt
  hlUsuario.Validate
  
  sqlstmt = "sp_usuarioValidate " & Val(hlUsuario.id) & "," & gDB.sqlString(Encrypt.Encript(txPassword.Text, c_LoginSignature)) & "," & CSOAPI2.EmpId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Val(gDB.ValField(rs.Fields, 0)) Then
    m_Us_id = hlUsuario.id
    Unload Me
  Else
    MsgWarning "Las credenciales no son validas."
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  hlUsuario.ButtonStyle = cHelpButtonSingle
  hlUsuario.Table = csUsuario
  CSKernelClient2.CenterForm Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
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


