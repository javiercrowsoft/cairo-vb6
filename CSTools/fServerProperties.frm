VERSION 5.00
Begin VB.Form fServerProperties 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Propiedades del servidor"
   ClientHeight    =   3225
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "fServerProperties.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3225
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txOldPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1320
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1590
      Width           =   2565
   End
   Begin VB.TextBox txPassword2 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1320
      PasswordChar    =   "*"
      TabIndex        =   4
      Top             =   2310
      Width           =   2565
   End
   Begin VB.TextBox txPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1320
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   1950
      Width           =   2565
   End
   Begin VB.OptionButton opNTSecurity 
      Caption         =   "Seguirdad de Windows"
      Height          =   315
      Left            =   510
      TabIndex        =   0
      Top             =   450
      Width           =   3705
   End
   Begin VB.OptionButton opSqlSecurity 
      Caption         =   "Seguirdad de Windows y SQL"
      Height          =   315
      Left            =   510
      TabIndex        =   1
      Top             =   840
      Width           =   3705
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   3330
      TabIndex        =   6
      Top             =   2850
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   1845
      TabIndex        =   5
      Top             =   2850
      Width           =   1275
   End
   Begin VB.Label Label5 
      Caption         =   "Vieja clave:"
      Height          =   255
      Left            =   240
      TabIndex        =   11
      Top             =   1620
      Width           =   2385
   End
   Begin VB.Label Label4 
      Caption         =   "Confirmación:"
      Height          =   255
      Left            =   240
      TabIndex        =   10
      Top             =   2340
      Width           =   2385
   End
   Begin VB.Label Label3 
      Caption         =   "Nueva clave:"
      Height          =   255
      Left            =   240
      TabIndex        =   9
      Top             =   1980
      Width           =   2385
   End
   Begin VB.Label Label2 
      Caption         =   "Clave de SA"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1200
      Width           =   2385
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000010&
      X1              =   -90
      X2              =   5220
      Y1              =   2670
      Y2              =   2670
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000014&
      X1              =   -90
      X2              =   5220
      Y1              =   2685
      Y2              =   2685
   End
   Begin VB.Label Label1 
      Caption         =   "Seguridad"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   2385
   End
End
Attribute VB_Name = "fServerProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
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
Private Const C_Module = "cWindow"

' estructuras
' variables privadas
Private m_Connection  As cConnection
' eventos
' propiedadades publicas
' propiedadades friend
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOk_Click()
  If Not pSave() Then Exit Sub
  Unload Me
End Sub

Private Function pSave() As Boolean
  On Error GoTo ControlError
  
  If txPassword.Text <> txPassword2.Text Then
    info "La nueva clave y su confirmación no coinciden"
    Exit Function
  End If
  
  Dim oldSecurityMode  As Boolean
  
  oldSecurityMode = m_Connection.Server.IntegratedSecurity.SecurityMode
  
  m_Connection.Server.Logins("SA").SetPassword txOldPassword.Text, txPassword.Text
  m_Connection.Server.IntegratedSecurity.SecurityMode = IIf(opNTSecurity.Value, SQLDMOSecurity_Integrated, SQLDMOSecurity_Mixed)
  
  If oldSecurityMode <> m_Connection.Server.IntegratedSecurity.SecurityMode Then
    If Ask("Para que los cambios tomen efecto es necesario detener y luego arrancar el servicio. ¿Desea hacerlo ahora?") Then
      m_Connection.Server.Stop
      m_Connection.Server.DisConnect
      m_Connection.Server.Start True, m_Connection.Server.Name, m_Connection.Server.Login, m_Connection.Server.Password
    End If
  End If
  
  pSave = True
  GoTo ExitProc
ControlError:
  MngError Err, "pSave ", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

   If m_Connection.Server.IntegratedSecurity.SecurityMode = SQLDMOSecurity_Integrated Then
    opNTSecurity.Value = True
  Else
    opSqlSecurity.Value = True
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  Set m_Connection = Nothing
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

