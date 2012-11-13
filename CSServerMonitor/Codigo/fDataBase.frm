VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fDataBase 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Empresa"
   ClientHeight    =   3795
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6330
   Icon            =   "fDataBase.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3795
   ScaleWidth      =   6330
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.OptionButton opNT 
      BackColor       =   &H00FFFFFF&
      Caption         =   "NT"
      Height          =   315
      Left            =   3720
      TabIndex        =   10
      Top             =   2220
      Width           =   975
   End
   Begin VB.OptionButton opSQL 
      BackColor       =   &H00FFFFFF&
      Caption         =   "SQL"
      Height          =   315
      Left            =   2340
      TabIndex        =   9
      Top             =   2220
      Value           =   -1  'True
      Width           =   1275
   End
   Begin CSButton.cButton cmdOk 
      Height          =   315
      Left            =   2355
      TabIndex        =   13
      Top             =   3360
      Width           =   1200
      _ExtentX        =   2117
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
      Left            =   3615
      TabIndex        =   14
      Top             =   3360
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
   Begin CSMaskEdit2.cMaskEdit txEmpresa 
      Height          =   315
      Left            =   2280
      TabIndex        =   1
      Top             =   180
      Width           =   3915
      _ExtentX        =   6906
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txServer 
      Height          =   315
      Left            =   2280
      TabIndex        =   3
      Top             =   720
      Width           =   3915
      _ExtentX        =   6906
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txDataBase 
      Height          =   315
      Left            =   2280
      TabIndex        =   5
      Top             =   1260
      Width           =   3915
      _ExtentX        =   6906
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txLogin 
      Height          =   315
      Left            =   2280
      TabIndex        =   7
      Top             =   1800
      Width           =   3915
      _ExtentX        =   6906
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txPassword 
      Height          =   315
      Left            =   2280
      TabIndex        =   12
      Top             =   2640
      Width           =   3915
      _ExtentX        =   6906
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
   Begin CSButton.cButton cmdApply 
      Height          =   315
      Left            =   5040
      TabIndex        =   15
      Top             =   3360
      Width           =   1200
      _ExtentX        =   2117
      _ExtentY        =   556
      Caption         =   "&Aplicar"
      Style           =   2
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
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "Tipo de seguridad :"
      Height          =   255
      Left            =   900
      TabIndex        =   8
      Top             =   2280
      Width           =   1605
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "Clave"
      Height          =   255
      Left            =   900
      TabIndex        =   11
      Top             =   2700
      Width           =   1605
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Login"
      Height          =   255
      Left            =   900
      TabIndex        =   6
      Top             =   1860
      Width           =   1605
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Base de Datos :"
      Height          =   255
      Left            =   900
      TabIndex        =   4
      Top             =   1320
      Width           =   1605
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Server :"
      Height          =   255
      Left            =   900
      TabIndex        =   2
      Top             =   780
      Width           =   1605
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8015
      Y1              =   3180
      Y2              =   3180
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Empresa :"
      Height          =   255
      Left            =   900
      TabIndex        =   0
      Top             =   240
      Width           =   1605
   End
   Begin VB.Image Image3 
      Height          =   480
      Left            =   195
      Picture         =   "fDataBase.frx":058A
      Top             =   195
      Width           =   480
   End
End
Attribute VB_Name = "fDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDataBase
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
Private Const C_Module = "fDataBase"
' estructuras
' variables privadas
Private m_id As Long
Private m_bChanged As Boolean

' eventos
' propiedadades publicas
Public Property Get Id() As Long
  Id = m_id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_id = rhs
End Property

Public Property Let Changed(ByVal rhs As Boolean)
  m_bChanged = rhs
  cmdApply.Enabled = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdApply_Click()
  Changed = Not pApplyChanges()
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub opNT_Click()
  txPassword.Enabled = False
End Sub

Private Sub opSQL_Click()
  txPassword.Enabled = True
End Sub

Private Sub cmdOk_Click()
  If m_bChanged Then
    If Not pApplyChanges() Then Exit Sub
  End If
  cmdCancel_Click
End Sub

Private Function pSaveEmpresas(ByRef dbDomain As cDataBase) As Boolean
  Dim db As cDataSource
  Set db = New cDataSource
  
  If Not db.OpenConnection(txServer.Text, _
                           txDataBase.Text, _
                           txLogin.Text, _
                           txPassword.Text, _
                           opNT.Value, "") Then Exit Function
  
  Dim rs      As Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select emp_id, emp_nombre from empresa"
  
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  Dim EmpIds As String
  
  While Not rs.EOF
  
    EmpIds = EmpIds & rs.Fields("emp_id").Value & ","
    sqlstmt = "sp_SysDomainUpdateEmpresa " & Id & "," _
                       & rs.Fields("emp_id").Value & "," _
                       & dbDomain.sqlString( _
                                Encrypt.Encript(rs.Fields("emp_nombre").Value, _
                                c_LoginSignature))
  
    If Not dbDomain.Execute(sqlstmt) Then Exit Function
    rs.MoveNext
  Wend
  
  If EmpIds <> "" Then
    
    sqlstmt = "sp_SysDomainDeleteEmpresaEx " & Id & "," _
                      & dbDomain.sqlString(RemoveLastColon(EmpIds))
                      
    If Not dbDomain.Execute(sqlstmt) Then Exit Function
  End If
  
  pSaveEmpresas = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSaveEmpresas", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pApplyChanges() As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim db      As cDataBase
  Dim rs      As Recordset
  Dim Encrypt As cEncrypt
  
  Set Encrypt = New cEncrypt
  
  Set db = GetDataBase
  sqlstmt = "sp_SysDomainUpdateDB " & vbCrLf
  sqlstmt = sqlstmt & Id & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(txEmpresa.Text, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(txServer.Text, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(txDataBase.Text, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(txLogin.Text, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & IIf(opSQL.Value, 0, 1) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(txPassword.Text, c_LoginSignature)) & vbCrLf
  
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then Id = rs.Fields(0).Value
  
  pApplyChanges = pSaveEmpresas(db)
  
  GoTo ExitProc
ControlError:
  MngError Err, "pApplyChanges", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  m_id = csNO_ID
  CSKernelClient2.LoadForm Me, Me.name
  opSQL_Click

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  CSKernelClient2.UnloadForm Me, Me.name
End Sub

Private Sub txDataBase_Change()
  Changed = True
End Sub

Private Sub txEmpresa_Change()
  Changed = True
End Sub

Private Sub txLogin_Change()
  Changed = True
End Sub

Private Sub txPassword_Change()
  Changed = True
End Sub

Private Sub txServer_Change()
  Changed = True
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
