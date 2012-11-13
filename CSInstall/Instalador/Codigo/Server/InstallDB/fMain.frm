VERSION 5.00
Begin VB.Form fMain 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Instalando Bases de Datos"
   ClientHeight    =   5700
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8835
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5700
   ScaleWidth      =   8835
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txNombreLargo 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   2760
      TabIndex        =   1
      Top             =   5190
      Width           =   4200
   End
   Begin VB.TextBox txEmpresa 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   2760
      TabIndex        =   0
      Top             =   4710
      Width           =   3000
   End
   Begin VB.Label Label2 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre Completo:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   600
      TabIndex        =   3
      Top             =   5160
      Width           =   1995
   End
   Begin VB.Label Label1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre Corto:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   600
      TabIndex        =   2
      Top             =   4740
      Width           =   1755
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   2700
      Top             =   5160
      Width           =   4275
   End
   Begin VB.Image Image2 
      Height          =   900
      Left            =   540
      Picture         =   "fMain.frx":08CA
      Top             =   3540
      Width           =   6750
   End
   Begin VB.Image cmdCancel 
      Height          =   330
      Left            =   7080
      Picture         =   "fMain.frx":34F3
      Top             =   5160
      Width           =   1635
   End
   Begin VB.Image cmdOk 
      Height          =   330
      Left            =   7080
      Picture         =   "fMain.frx":3D63
      Top             =   4680
      Width           =   1635
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   2700
      Top             =   4680
      Width           =   3075
   End
   Begin VB.Image Image1 
      Height          =   3150
      Left            =   120
      Picture         =   "fMain.frx":455D
      Top             =   180
      Width           =   8625
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fMain"

Private WithEvents m_Login     As fLogin
Attribute m_Login.VB_VarHelpID = -1
Private m_dbFolder             As String
Private m_backupFolder         As String
Private m_appFolder            As String
Private m_Ok                   As Boolean

Private m_ServerName           As String
Private m_UserName             As String
Private m_Password             As String
Private m_NTSecurity           As Boolean

Private Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"

' Objeto de conexión a SQL SERVER
Private WithEvents m_SQLServer As cSQLServer
Attribute m_SQLServer.VB_VarHelpID = -1

Public Property Let dbFolder(ByVal rhs As String)
  m_dbFolder = rhs
End Property

Public Property Let BackupFolder(ByVal rhs As String)
  m_backupFolder = rhs
End Property

Public Property Let AppFolder(ByVal rhs As String)
  m_appFolder = rhs
End Property

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Private Sub cmdOk_Click()
  On Error Resume Next
  
  If Trim(txEmpresa.Text) = "" Then
    MsgWarning "Debe indicar un nombre corto para su empresa"
    Exit Sub
  End If
  
  If Not pConnect Then Exit Sub
  
  If Not pCreateDataBase Then Exit Sub
  
  m_Ok = True
  
  Unload Me
End Sub

Private Sub cmdCancel_Click()
  UnloadForm
End Sub

Private Function UnloadForm() As Boolean
  If vbYes = MsgBox("Si cancela no se instalaran las bases de datos." & vbCrLf & vbCrLf & "¿Desea cancelar de todas formas?", vbYesNo + vbQuestion, "Instalación") Then
    Unload Me
  Else
    UnloadForm = True
  End If
End Function
'-------------------------------------------------
' Login
'-------------------------------------------------
Private Sub m_Login_Connect(Cancel As Boolean)
  If m_SQLServer.OpenConnectionEx(m_Login.txServer.Text, _
                                  m_Login.txUser.Text, _
                                  m_Login.txPassword.Text, _
                                  m_Login.opNt.Value) Then
    With m_Login
      m_ServerName = .txServer.Text
      m_UserName = .txUser.Text
      m_Password = .txPassword.Text
      m_NTSecurity = .opNt.Value
    End With
    Cancel = False
  Else
    Cancel = True
  End If
End Sub

Private Sub Form_Load()
  On Error Resume Next
  
  Me.Left = (Screen.Width - Me.Width) * 0.1
  Me.Top = (Screen.Height - Me.Height) * 0.1

  Set m_SQLServer = New cSQLServer
  
  m_Ok = False
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  Set m_SQLServer = Nothing
End Sub

Private Function pConnect() As Boolean
  On Error GoTo ControlError
  Dim msg     As String
  Dim f       As fLogin
  Dim Mouse   As CSTools.cMouseWait
  
  Set Mouse = New CSTools.cMouseWait
  
  msg = "Si no se conecta con el servidor no podra completar el proceso de instalación.;;¿Confirma que desea cancelar?."
  
  Set f = New fLogin
  
  Set m_Login = f
  
  f.Show vbModal
  
  Do While Not f.Ok
  
    If Ask(msg, vbNo) Then
      
      Unload f
      Set m_Login = Nothing
      
      Unload Me
      Exit Function
    End If
    
    f.Show vbModal
  Loop
  
  pConnect = True

  GoTo ExitProc
ControlError:
  MngError Err, "pConnect", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
  Set m_Login = Nothing
End Function

Private Function pCreateDataBase() As Boolean
  On Error GoTo ControlError
  
  Dim Empresa   As String
  Dim Mouse     As CSTools.cMouseWait
  
  Dim dbDominio As String
  Dim dbDemo    As String
  Dim dbEmpresa As String
  
  Set Mouse = New CSTools.cMouseWait
  
  Empresa = Trim(txEmpresa.Text)
  Empresa = Replace(txEmpresa.Text, " ", "")
  
  dbEmpresa = "cairo" & Empresa
  dbDominio = "cairo_dominio"
  dbDemo = "cairoDemo"
  
  If Not CreateFolder(m_dbFolder) Then Exit Function
  
  m_SQLServer.IsForInstall = True
  
  If Not m_SQLServer.CreateDataBaseWithWizardEx(dbDominio, _
                                                m_dbFolder & "\cairo_dominio.mdf", _
                                                15, _
                                                m_dbFolder & "\cairo_dominio.log", 2) Then Exit Function
                                                
  If Not m_SQLServer.CreateDataBaseWithWizardEx(dbDemo, _
                                                m_dbFolder & "\cairoDemo.mdf", _
                                                15, _
                                                m_dbFolder & "\cairoDemo.log", 2) Then Exit Function
  
  If Not m_SQLServer.CreateDataBaseWithWizardEx(dbEmpresa, _
                                                m_dbFolder & "\cairo" & Empresa & ".mdf", _
                                                5, _
                                                m_dbFolder & "\cairo" & Empresa & ".log", 2) Then Exit Function
  
  If Not m_SQLServer.ShowRestore(dbDominio, _
                                 True, False, _
                                 m_backupFolder & "\cairo_dominio.bak" _
                                 ) Then Exit Function
                                    
  If Not m_SQLServer.ShowRestore(dbDemo, _
                                 True, False, _
                                 m_backupFolder & "\cairoDemo.bak" _
                                 ) Then Exit Function
                                    
  If Not m_SQLServer.ShowRestore(dbEmpresa, _
                                 True, False, _
                                 m_backupFolder & "\cairo.bak" _
                                 ) Then Exit Function
                                    
  
  If Not pUpdateDominio(txNombreLargo.Text, dbDominio, dbDemo, dbEmpresa) Then Exit Function
  
  If Not pSaveInis(dbDominio) Then Exit Function
  
  pCreateDataBase = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pCreateDataBase", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pUpdateDominio(ByVal NombreEmpresa As String, _
                                ByVal dbDominio As String, _
                                ByVal dbDemo As String, _
                                ByVal dbEmpresa As String) As Boolean
  On Error GoTo ControlError

  Dim db          As cDataSource
  Dim sqlstmt     As String
  
  Set db = New cDataSource
  If Not db.OpenConnection(m_ServerName, dbDominio, m_UserName, m_Password, m_NTSecurity) Then Exit Function

  sqlstmt = "Delete Empresa"
  If Not db.Execute(sqlstmt, "") Then Exit Function
  
  sqlstmt = "Delete BaseDatos"
  If Not db.Execute(sqlstmt, "") Then Exit Function

  If Not pUpdateDominioAux("Demo", dbDemo, db) Then Exit Function
  If Not pUpdateDominioAux(NombreEmpresa, dbEmpresa, db) Then Exit Function

  pUpdateDominio = True

  GoTo ExitProc
ControlError:
  MngError Err, "pUpdateDominio", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pUpdateDominioAux(ByVal NombreEmpresa As String, _
                                   ByVal dbName As String, _
                                   ByRef db As cDataSource) As Boolean
  Dim Encrypt     As cEncrypt
  Dim sqlstmt     As String
  
  Set Encrypt = New cEncrypt
  
  sqlstmt = "sp_SysDomainUpdateDB " & vbCrLf
  sqlstmt = sqlstmt & 0 & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(NombreEmpresa, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(m_ServerName, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(dbName, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(m_UserName, c_LoginSignature)) & "," & vbCrLf
  sqlstmt = sqlstmt & IIf(m_NTSecurity, 1, 0) & "," & vbCrLf
  sqlstmt = sqlstmt & db.sqlString(Encrypt.Encript(m_Password, c_LoginSignature)) & vbCrLf
  
  Dim rs As ADODB.Recordset
  
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function

  If Not rs.EOF Then
  
    pUpdateDominioAux = pSaveEmpresas(db, _
                                      rs.Fields.Item(0).Value, _
                                      dbName)
                                      
    'sqlstmt = "sp_SysDomainUpdateEmpresa " & rs.Fields.Item(0).Value & "," _
                                           & "0," _
                                           & db.sqlString(Encrypt.Encript(NombreEmpresa, _
                                                                          c_LoginSignature))
  End If
  
  'If Not db.Execute(sqlstmt, "") Then Exit Function

  pUpdateDominioAux = True
End Function

Private Function pSaveEmpresas(ByRef dbDomain As cDataSource, _
                               ByVal Id As Long, _
                               ByVal dbName As String) As Boolean
  Dim db As cDataSource
  Set db = New cDataSource
  
  If Not db.OpenConnection(m_ServerName, _
                           dbName, _
                           m_UserName, _
                           m_Password, _
                           IIf(m_NTSecurity, 1, 0), "") Then Exit Function
  
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
  
    If Not dbDomain.Execute(sqlstmt, "") Then Exit Function
    rs.MoveNext
  Wend
  
  pSaveEmpresas = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSaveEmpresas", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSaveInis(ByVal dbDominio As String) As Boolean
  On Error GoTo ControlError
  
  ' Cairo.ini
  SaveIniValue "DESKTOP-CONFIG", "DESKTOP_PATH_INICIO_RPT", m_appFolder, m_appFolder & "\Cairo.ini"
  SaveIniValue "RPT-CONFIG", "RPT_PATH_REPORTES", m_appFolder & "\Reportes", m_appFolder & "\Cairo.ini"
  
  ' CSLogin.ini
  SaveIniValue "CONFIG", "Server", m_ServerName, m_appFolder & "\CSLogin.ini"
  
  ' CSServer.ini
  SaveIniValue "CONFIG", "Server", m_ServerName, m_appFolder & "\CSServer.ini"
  SaveIniValue "CONFIG", "DataBase", dbDominio, m_appFolder & "\CSServer.ini"
  SaveIniValue "CONFIG", "User", m_UserName, m_appFolder & "\CSServer.ini"
  SaveIniValue "CONFIG", "Password", m_Password, m_appFolder & "\CSServer.ini"
  SaveIniValue "CONFIG", "TrustedConnection", IIf(m_NTSecurity, 1, 0), m_appFolder & "\CSServer.ini"
  
  ' CSAdmin.ini
  SaveIniValue "CONFIG", "Server", GetComputerName(), m_appFolder & "\CSAdmin.ini"
  
  pSaveInis = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSaveInis", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
